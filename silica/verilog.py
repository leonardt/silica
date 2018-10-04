import astor
import ast
from .width import get_width
import veriloggen as vg
from functools import *
from .ast_utils import *

def get_width_str(width):
    return f"[{width-1}:0] " if width is not None else ""


class SwapSlices(ast.NodeTransformer):
    def visit_Subscript(self, node):
        node.slice = self.visit(node.slice)
        if isinstance(node.slice, ast.Slice):
            if node.slice.lower is None and isinstance(node.slice.upper, ast.Num):
                if node.slice.step is not None:
                    raise NotImplementedError()
                node.slice.lower = ast.Num(node.slice.upper.n - 1)
                node.slice.upper = ast.Num(0)
        return node


class RemoveMagmaFuncs(ast.NodeTransformer):
    def visit_Call(self, node):
        if isinstance(node.func, ast.Name) and node.func.id in ['bits', 'uint', 'bit']:
            return node.args[0]
        return node


def process_statement(stmt):
    RemoveMagmaFuncs().visit(stmt)
    SwapSlices().visit(stmt)
    return stmt

class TempVarPromoter(ast.NodeTransformer):
    __unique_id = 0

    def __init__(self, width_table):
        self.assigns = []
        self.var_map = {}
        self.width_table = width_table

    def visit_Assign(self, node):
        temp_var_str = f"temp_var_{TempVarPromoter.__unique_id}"
        TempVarPromoter.__unique_id += 1
        node.value = self.visit(node.value)
        self.var_map[astor.to_source(node.targets[0]).rstrip()] = temp_var_str
        self.assigns.append((get_width(node.targets[0], self.width_table),
                             ast.Assign([ast.Name(temp_var_str, ast.Store())],
                                        node.value)))
        node.value = ast.Name(temp_var_str, ast.Load())
        return node

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load) and node.id in self.var_map:
            node.id = self.var_map[node.id]
        return node

    def visit_Subscript(self, node):
        if isinstance(node.ctx, ast.Load) and astor.to_source(node).rstrip() in self.var_map:
            return ast.Name(self.var_map[astor.to_source(node).rstrip()], ast.Load())
        return node





tab = "    "


def get_by_name(module, name):
    return module.get_ports().get(name, module.get_vars().get(name))

# TODO: these translate functions should be merged
# TODO: the only reason translate takes in a module is to do the name lookup. should figure out how to not need to pass in module.
def translate_slice(module, slice, target):
    if is_index(slice):
        return vg.Pointer(target, translate_value(module, slice.value))
    elif is_slice(slice):
        return vg.Slice(target, translate_value(module, slice.lower), translate_value(module, slice.upper))

    raise NotImplementedError(slice)

# TODO: should reorder the switch into more sensible ordering
# TODO: should split this up into a few translate functions that translate certain classes of inputs
def translate_value(module, value):
    if isinstance(value, bool):
        return vg.Int(1 if value else 0)
    elif is_add(value):
        return vg.Add
    elif is_assign(value):
        return vg.Subst(translate_value(module, value.targets[0]), translate_value(module, value.value), 1)
    elif is_bin_op(value):
        return translate_value(module, value.op)(translate_value(module, value.left), translate_value(module, value.right))
    elif is_bit_and(value):
        return vg.And
    elif is_bit_xor(value):
        return vg.Xor
    elif is_compare(value):
        assert(len(value.ops) == len(value.comparators) == 1)
        return translate_value(module, value.ops[0])(translate_value(module, value.left), translate_value(module, value.comparators[0]))
    elif is_eq(value):
        return vg.Eq
    elif is_if_exp(value):
        return vg.Cond(
            translate_value(module, value.test),
            translate_value(module, value.body),
            translate_value(module, value.orelse)
        )
    elif is_invert(value):
        return vg.Unot
    elif is_lt(value):
        return vg.LessThan
    elif is_name(value):
        return get_by_name(module, value.id)
    elif is_name_constant(value):
        # TODO: distinguish between int, bool, etc.
        return translate_value(module, value.value)
    elif is_not_eq(value):
        return vg.NotEq
    elif is_num(value):
        return vg.Int(value.n)
    elif is_sub(value):
        return vg.Sub
    elif is_subscript(value):
        return translate_slice(module, value.slice, translate_value(module, value.value))
    elif is_unary_op(value):
        return translate_value(module, value.op)(translate_value(module, value.operand))

    raise NotImplementedError(value)

def compile_statements(module, seq, states, _tab, one_state, width_table, statements):
    offset = ""
    verilog_source = ""
    # temp_var_promoter = TempVarPromoter(width_table)
    for statement in statements:
        conds = []
        yields = set()
        contained = [state for state in states if statement in state.statements]
        if contained != states:
            for state in states:
                if statement in state.statements:
                    if state.conds or not one_state:
                        offset = tab
                        these_conds = []
                        # if state.conds:
                        #     these_conds.extend(astor.to_source(process_statement(cond)).rstrip() for cond in state.conds)
                        # if not one_state:
                        #     these_conds.append(f"(yield_state == {state.start_yield_id})")
                        yields.add(state.start_yield_id)
                        # if these_conds:
                        #     conds.append(" & ".join(these_conds))
            if not one_state:
                conds = [module.get_vars()["yield_state"] == yield_id for yield_id in yields]
                conds_old = [f"(yield_state == {yield_id})" for yield_id in yields] # TODO: remove
            process_statement(statement)
            if conds:
                cond = reduce(vg.Lor, conds)
                seq.If(cond)(
                    vg.Subst(translate_value(module, statement.targets[0]), translate_value(module, statement.value), 1)
                )
                # TODO: remove
                cond_old = " | ".join(conds_old)
                verilog_source += f"\n{_tab}if ({cond_old}) begin"
                verilog_source += f"\n{_tab + offset}" + astor.to_source(statement).rstrip() + ";"
                verilog_source += f"\n{_tab}end"
            else:
                verilog_source += f"\n{_tab}" + astor.to_source(statement).rstrip() + ";"
                seq(
                    vg.Subst(translate_value(module, statement.targets[0]), translate_value(module, statement.value), 1)
                )
        else:
            process_statement(statement)
            verilog_source += f"\n{_tab}" + astor.to_source(statement).rstrip() + ";"
            seq(
                vg.Subst(translate_value(module, statement.targets[0]), translate_value(module, statement.value), 1)
            )
    temp_var_source = ""
    return verilog_source, temp_var_source


def compile_states(module, states, one_state, width_table, strategy="by_statement"):
    seq = vg.TmpSeq(module, module.get_ports()["CLK"])
    comb_body = []
    always_source = """\
    always @(posedge CLK) begin\
"""
    tab = "    "
    temp_var_source = ""
    if strategy == "by_statement":
        statements = []
        for state in states:
            index = len(statements)
            for statement in reversed(state.statements):
                if statement in statements:
                    index = statements.index(statement)
                else:
                    statements.insert(index, statement)
        always_inside, temp_vars = compile_statements(module, seq, states, tab * 3, one_state, width_table, statements)
        always_source += always_inside
        temp_var_source += temp_vars
        _tab = tab * 3
        if not one_state:
            for i, state in enumerate(states):
                offset = tab
                cond = ""
                conds = []
                if state.conds:
                    cond += " & ".join(astor.to_source(process_statement(cond)).rstrip() for cond in state.conds)
                    conds = [translate_value(module, process_statement(cond)) for cond in state.conds]
                if cond:
                    cond += " & "
                cond += f"(yield_state == {state.start_yield_id})"
                cond_new = reduce(vg.Land, conds, get_by_name(module, 'yield_state') == state.start_yield_id)
                if i == 0:
                    if_stmt = seq.If(cond_new)
                    if_str = "if"
                else:
                    if_stmt = seq.Elif(cond_new)
                    if_str = "else if"
                stmts = []
                stmts.append(get_by_name(module, 'yield_state')(state.end_yield_id))
                always_source += f"\n{_tab}{if_str} ({cond}) begin"
                always_source += f"\n{_tab + offset}yield_state = {state.end_yield_id};"
                output_stmts = []
                for output, var in state.path[-1].output_map.items():
                    output_stmts.append(vg.Subst(get_by_name(module, output),
                                                 get_by_name(module, var), 1))
                    always_source += f"\n{_tab + offset}{output} = {var};"
                for stmt in state.path[-1].array_stores_to_process:
                    always_source += f"\n{tab + offset}" + astor.to_source(process_statement(stmt)).rstrip() + ";"
                    stmts.append(translate_value(module, process_statement(stmt)))
                always_source += f"\n{_tab}end"
                if_stmt(stmts)
                comb_cond = reduce(vg.Land, conds, get_by_name(module, 'yield_state') == state.end_yield_id)
                if i == 0:
                    comb_body.append(vg.If(comb_cond)(output_stmts))
                else:
                    comb_body[-1] = comb_body[-1].Elif(comb_cond)(output_stmts)

        else:
            for output, var in states[0].path[-1].output_map.items():
                comb_body.append(vg.Subst(get_by_name(module, output),
                                          get_by_name(module, var), 1))
                # seq(
                #     get_by_name(module, output)(get_by_name(module, var))
                # )
                always_source += f"\n{_tab}{output} = {var};"
    else:
        raise NotImplementedError(strategy)
    module.Always(vg.SensitiveAll())(
        comb_body
    )

    # rewrite (a if cond else b) to cond ? a : b
    new_always_source = ""
    for line in always_source.split("\n"):
        if "if" in line and "else" in line and not "else if" in line:
            assign, rest = line.split(" = ")
            true, rest = rest.split("if")
            cond, false = rest.split("else")
            new_always_source += f"{assign} ={cond}? {true}:{false}" + "\n"
        else:
            new_always_source += line + "\n"

    return new_always_source, temp_var_source
