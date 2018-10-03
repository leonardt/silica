import astor
import ast
from .width import get_width
from .ast_utils import *
from functools import *
from veriloggen import *

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

class ExpandLists(ast.NodeTransformer):
    # TODO: probably should take in width_table in __init__ like TempVarPromoter
    def visit_Assign(self, node):
        if is_list(node.value):
            name = node.targets[0].id
            targets = [ast.Subscript(ast.Name(name, ast.Load()), ast.Index(ast.Num(x)), ast.Store()) for x in range(len(node.value.elts))]
            targets = [ast.Tuple(targets)]
            values = ast.Tuple(node.value.elts, ast.Load())
            return ast.Assign(targets, values)
        return node

class ListToVerilog(ast.NodeTransformer):
    def visit_List(self, node):
        print(ast.dump(node))
        node = ast.Set(node.elts)
        return node

class TupleAssignToVerilog(ast.NodeTransformer):
    def visit_Assign(self, node):
        if is_tuple(node.targets[0]):
            body = [ast.Assign([node.targets[0].elts[n]], node.value.elts[n])
                    for n in range(len(node.value.elts))]
            return ast.Module(body)
        return node

def process_statement(stmt):
    RemoveMagmaFuncs().visit(stmt)
    SwapSlices().visit(stmt)
    stmt = ExpandLists().visit(stmt)
    stmt = TupleAssignToVerilog().visit(stmt)
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


def compile_state_by_path(state, index, _tab, one_state, width_table):
    offset = ""
    verilog_source = ""
    if state.conds or not one_state:
        offset = tab
        cond = ""
        if state.conds:
            cond += " & ".join(astor.to_source(process_statement(cond)).rstrip() for cond in state.conds)
        if not one_state:
            if cond:
                cond += " & "
            cond += f"(yield_state == {state.start_yield_id})"
        if index == 0:
            if_str = "if"
        else:
            if_str = "else if"
        verilog_source += f"\n{_tab}{if_str} ({cond}) begin"
    # temp_var_promoter = TempVarPromoter(width_table)
    for statement in state.statements:
        statement = process_statement(statement)
        # temp_var_promoter.visit(statement)
        verilog_source += f"\n{_tab + offset}" + astor.to_source(statement).rstrip().replace(" = ", " = ") + ";"
    temp_var_source = ""
    # for width, assign in temp_var_promoter.assigns:
    #     width_str = get_width_str(width)
    #     temp_var_source += f"    wire {width_str}" + astor.to_source(assign).rstrip() + ";\n"
    if not one_state:
        verilog_source += f"\n{_tab + offset}yield_state = {state.end_yield_id};"
    if state.conds or not one_state:
        verilog_source += f"\n{_tab}end"
    return verilog_source, temp_var_source


def compile_statements(states, _tab, one_state, width_table, statements):
    offset = ""
    verilog_source = ""
    # temp_var_promoter = TempVarPromoter(width_table)
    for statement in statements:
        conds = []
        contained = [state for state in states if statement in state.statements]
        if contained != states:
            for state in states:
                if statement in state.statements:
                    if state.conds or not one_state:
                        offset = tab
                        these_conds = []
                        if state.conds:
                            these_conds.extend(astor.to_source(process_statement(cond)).rstrip() for cond in state.conds)
                        if not one_state:
                            these_conds.append(f"(yield_state == {state.start_yield_id})")
                        conds.append(" & ".join(these_conds))
            cond = " | ".join(conds)
            verilog_source += f"\n{_tab}if ({cond}) begin"
            statement = process_statement(statement)
            verilog_source += f"\n{_tab + offset}" + astor.to_source(statement).rstrip() + ";"
            verilog_source += f"\n{_tab}end"
        else:
            statement = process_statement(statement)
            verilog_source += f"\n{_tab}" + astor.to_source(statement).rstrip() + ";"
    temp_var_source = ""
    return verilog_source, temp_var_source


def compile_states(states, one_state, width_table, strategy="by_statement"):
    seq = TmpSeq(m, CLK)
    always_source = """\
    always @(posedge CLK) begin\
"""
    tab = "    "
    temp_var_source = ""
    if strategy == "by_path":
        for i, state in enumerate(states):
            always_inside, temp_vars = compile_state_by_path(state, i, tab * 3, one_state, width_table)
            always_source += always_inside
            temp_var_source += temp_vars
    elif strategy == "by_statement":
        statements = []
        for i, state in enumerate(states):
            for statement in state.statements:
                if statement not in statements:
                    statements.append(statement)
                else:
                    # Move it to the back
                    statements.remove(statement)
                    statements.append(statement)
        always_inside, temp_vars = compile_statements(states, tab * 3, one_state, width_table, statements)
        always_source += always_inside
        temp_var_source += temp_vars
        if not one_state:
            for i, state in enumerate(states):
                _tab = tab * 3
                offset = tab
                # cond = reduce(Land, (process_statement(cond) for cond in state.conds), (yield_state == {state.start_yield_id}))
                cond = ""
                if state.conds:
                    cond += " & ".join(astor.to_source(process_statement(cond)).rstrip() for cond in state.conds)

                if cond:
                    cond += " & "
                cond += f"(yield_state == {state.start_yield_id})"

                if i == 0:
                    # seqif = seq.If(cond)
                    if_str = "if"
                else:
                    # seqif = seq.Elif(cond)
                    if_str = "else if"
                always_source += f"\n{_tab}{if_str} ({cond}) begin"
                # seqif(yield_state = state.end_yield_id)
                always_source += f"\n{_tab + offset}yield_state = {state.end_yield_id};"
                always_source += f"\n{_tab}end"
    else:
        raise NotImplementedError(strategy)
    return always_source, temp_var_source
