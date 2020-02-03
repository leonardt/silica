import copy
import astor
import ast
from .width import get_width
import veriloggen as vg
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator
from functools import *
from .ast_utils import *
import magma
from .visitors.collect_stores import collect_stores
from .cfg.types import HeadBlock, BasicBlock, Branch, Yield
from .memory import MemoryType
from .cfg.util import find_branch_join
from .transformations.replace_symbols import replace_symbols


def filter_duplicates(body):
    filtered = []
    seen = set()
    for stmt in body:
        stmt_str = astor.to_source(stmt)
        if stmt_str in seen:
            continue
        seen.add(stmt_str)
        filtered.append(stmt)
        if isinstance(stmt, ast.If):
            stmt.body = filter_duplicates(stmt.body)
            stmt.orelse = filter_duplicates(stmt.orelse)
    return filtered


def merge_ifs(block):
    new_block = []
    cond_map = {}
    for stmt in block:
        if isinstance(stmt, ast.If):
            if stmt.orig_node not in cond_map:
                cond_map[stmt.orig_node] = stmt
                new_block.append(stmt)
            else:
                for sub_stmt in stmt.body:
                    if stmt.is_true:
                        if sub_stmt not in cond_map[stmt.orig_node].body:
                            cond_map[stmt.orig_node].body.append(sub_stmt)
                    else:
                        if sub_stmt not in cond_map[stmt.orig_node].orelse:
                            cond_map[stmt.orig_node].orelse.append(sub_stmt)
        else:
            new_block.append(stmt)
    for stmt in block:
        if isinstance(stmt, ast.If):
            stmt.body = merge_ifs(stmt.body)
            stmt.orelse = merge_ifs(stmt.orelse)
    return new_block


def replace_references_to_registers(stmt, registers, is_reset, outputs):
    replace_map = {}
    for key in registers:
        if key in outputs:
            stmt = replace_symbols(stmt, {key: ast.Name(key + "_prev")},
                                   ctx=ast.Load)
        elif not is_reset:
            stmt = replace_symbols(stmt, {key: ast.Name(key + "_next")})
    return stmt



class Context:
    def __init__(self, name, sub_coroutines=[]):
        self.module = vg.Module(name)
        self.sub_coroutines = sub_coroutines

    def declare_ports(self, inputs, outputs):
        if outputs:
            for o,n in outputs.items():
                if n > 1:
                    self.module.Output(o, n)
                else:
                    self.module.Output(o)
        if inputs:
            for i,n in inputs.items():
                if n > 1:
                    self.module.Input(i, n)
                else:
                    self.module.Input(i)

    def declare_wire(self, name, width=None, height=None):
        self.module.Wire(name, width, height)

    def declare_reg(self, name, width=None, height=None):
        self.module.Reg(name, width, height)

    def assign(self, lhs, rhs, blk=1):
        # return vg.Subst(lhs, rhs, not self.is_reg(lhs))
        return vg.Subst(lhs, rhs, blk)

    def initial(self, body=[]):
        return self.module.Initial(body)

    def get_by_name(self, name):
        if name in self.module.get_vars():
            return self.module.get_vars()[name]
        elif name in self.module.get_ports():
            return self.module.get_ports()[name]

        raise KeyError(f"`{name}` is not a valid port or variable.")

    def is_reg(self, obj):
        return isinstance(obj, vg.core.vtypes.Reg)

    def translate_assign(self, target, value, blk=1):
        return vg.Subst(
            self.translate(target),
            value,
            blk
        )


    # TODO: should reorder the switch into more sensible ordering
    # TODO: should split this up into a few translate functions that translate certain classes of inputs
    def translate(self, stmt):
        if isinstance(stmt, bool):
            return vg.Int(1 if stmt else 0)
        elif is_add(stmt):
            return vg.Add
        elif is_floor_div(stmt):
            return vg.Div
        elif is_mult(stmt):
            return vg.Mul
        elif isinstance(stmt, ast.Mod):
            return vg.Mod
        elif is_or(stmt):
            return vg.Or
        elif is_r_shift(stmt):
            return vg.Srl
        elif is_l_shift(stmt):
            return vg.Sll
        elif is_bool_op(stmt):
            result = self.translate(stmt.op)(
                self.translate(stmt.values[0]),
                self.translate(stmt.values[1])
            )
            for value in stmt.values[2:]:
                result = self.translate(stmt.op)(result, self.translate(value))
            return result
        elif is_bin_op(stmt):
            if is_list(stmt.left) or is_list(stmt.right):
                if is_add(stmt.op): # list concatenation
                    return vg.Cat(
                        self.translate(stmt.left),
                        self.translate(stmt.right)
                    )
                elif is_mult(stmt.op): # list replication
                    var = self.translate(stmt.left) if is_list(stmt.left) else self.translate(stmt.right)
                    times = self.translate(stmt.right) if is_list(stmt.left) else self.translate(stmt.left)
                    return vg.Repeat(var, times)

            return self.translate(stmt.op)(
                self.translate(stmt.left),
                self.translate(stmt.right)
            )
        elif is_bit_and(stmt):
            return vg.And
        elif is_bit_xor(stmt):
            return vg.Xor
        elif is_bit_or(stmt):
            return vg.Or
        elif is_compare(stmt):
            curr = self.translate(stmt.ops[0])(
                self.translate(stmt.left),
                self.translate(stmt.comparators[0])
            )
            for op, comp in zip(stmt.ops[1:], stmt.comparators[1:]):
                curr = self.translate(op)(curr, self.translate(comp))
            return curr
        elif is_eq(stmt):
            return vg.Eq
        elif is_if(stmt):
            body = [self.translate(stmt) for stmt in stmt.body]
            if_ = vg.If(
                self.translate(stmt.test),
            )(body)
            if stmt.orelse:
                if_.Else(
                    [self.translate(stmt) for stmt in stmt.orelse]
                )
            return if_
        elif is_if_exp(stmt):
            return vg.Cond(
                self.translate(stmt.test),
                self.translate(stmt.body),
                self.translate(stmt.orelse)
            )
        elif is_invert(stmt):
            return vg.Unot
        elif is_list(stmt):
            return vg.Cat(*[self.translate(elt) for elt in stmt.elts])
        elif is_lt(stmt):
            return vg.LessThan
        elif is_gt(stmt):
            return vg.GreaterThan
        elif is_gt_e(stmt):
            return vg.GreaterEq
        elif is_name(stmt):
            return self.get_by_name(stmt.id)
        elif is_name_constant(stmt):
            # TODO: distinguish between int, bool, etc.
            return self.translate(stmt.value)
        elif is_not_eq(stmt):
            return vg.NotEq
        elif is_num(stmt):
            return vg.Int(stmt.n)
        elif is_sub(stmt):
            return vg.Sub
        elif is_u_sub(stmt):
            return vg.Uminus
        elif is_subscript(stmt):
            if is_index(stmt.slice):
                return vg.Pointer(
                    self.translate(stmt.value),
                    self.translate(stmt.slice.value)
                )
            elif is_slice(stmt.slice):
                return vg.Slice(
                    self.translate(stmt.value),
                    vg.Sub(self.translate(stmt.slice.upper), vg.Int(1)),
                    self.translate(stmt.slice.lower)
                )
        elif is_tuple(stmt):
            return vg.Cat(*[self.translate(elt) for elt in stmt.elts])
        elif is_unary_op(stmt):
            return self.translate(stmt.op)(self.translate(stmt.operand))
        elif isinstance(stmt, ast.Assign) and is_call(stmt.value) and is_attribute(stmt.value.func) and stmt.value.func.attr == "send":
            coroutine = stmt.value.func.value.id
            subs = []
            inputs = []
            outputs = []
            for key, value in self.sub_coroutines[coroutine].IO.ports.items():
                if key == "CLK":
                    continue
                if value.isinput():
                    inputs.append(key)
                elif value.isoutput():
                    outputs.append(key)
            outputs.sort()
            args = stmt.value.args
            if isinstance(args[0], ast.Tuple) and len(args) == 1:
                args = args[0].elts
            for key, arg in zip(inputs, args):
                subs.append(vg.Subst(self.get_by_name("_si_" + coroutine + "_" + key), self.translate(arg), 1))
            if isinstance(stmt.targets[0], ast.Tuple):
                targets = stmt.targets[0].elts
            else:
                targets = stmt.targets
            for key, arg in zip(outputs, targets):
                subs.append(vg.Subst(self.get_by_name(arg.id), self.get_by_name("_si_" + coroutine + "_" + key), 1))
            return subs
        elif isinstance(stmt, ast.Expr) and is_call(stmt.value) and is_attribute(stmt.value.func) and stmt.value.func.attr == "send":
            coroutine = stmt.value.func.value.id
            subs = []
            inputs = []
            for key, value in self.sub_coroutines[coroutine].IO.ports.items():
                if key == "CLK":
                    continue
                if value.isinput():
                    inputs.append(key)
            for key, arg in zip(inputs, stmt.value.args):
                subs.append(vg.Subst(self.get_by_name("_si_" + coroutine + "_" + key), self.get_by_name(arg.id), 1))
            return subs
        elif is_attribute(stmt):
            coroutine = stmt.value.id
            return self.get_by_name("_si_" + coroutine + "_" + stmt.attr)
        elif is_assign(stmt) and is_call(stmt.value) and is_name(stmt.value.func) and stmt.value.func.id == "phi":
            conds = [self.translate(x) for x in stmt.value.args[0].elts]
            values = [self.translate(x) for x in stmt.value.args[1].elts]
            block = vg.If(conds[0])(
                self.translate_assign(stmt.targets[0], values[0])
            )
            for cond, value in zip(conds[1:-1], values[1:-1]):
                block.Elif(cond)(
                    self.translate_assign(stmt.targets[0], value)
                )
            block.Else(
                self.translate_assign(stmt.targets[0], values[-1])
            )
            return block
        elif is_assign(stmt):
            # blk = not self.is_reg(target)
            return self.translate_assign(stmt.targets[0], self.translate(stmt.value))
        elif isinstance(stmt, ast.Expr) and is_call(stmt.value) and is_name(stmt.value.func) and stmt.value.func.id == "print":
            # Skip print statements for now, maybe translate to display?
            return
        elif isinstance(stmt, ast.Str):
            return vg.EmbeddedCode(stmt.s)
        raise NotImplementedError(ast.dump(stmt))

    def to_verilog(self):
        return self.module.to_verilog()


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

class RemoveFuncs(ast.NodeTransformer):
    def visit_Call(self, node):
        node.args = [self.visit(arg) for arg in node.args]
        if isinstance(node.func, ast.Name) and node.func.id in ['bits', 'uint',
                                                                'bit']:
            return self.visit(node.args[0])
        return node

class ExpandLists(ast.NodeTransformer):
    # TODO: probably should take in width_table in __init__ like TempVarPromoter
    def visit_Assign(self, node):
        if is_list(node.value):
            name = node.targets[0].id
            targets = [ast.Subscript(ast.Name(name, ast.Load()), ast.Index(ast.Num(x)), ast.Store()) for x in range(len(node.value.elts))]
            targets = [ast.Tuple(targets, ast.Store())]
            values = ast.Tuple(node.value.elts, ast.Load())
            return ast.Assign(targets, values)
        return node

class ListToVerilog(ast.NodeTransformer):
    def visit_List(self, node):
        node = ast.Set(node.elts)
        return node

# TODO: this is a hack because it needs to return a list of expanded tuple assignments, might be able to use ast.Module instead with the body
class TupleAssignToVerilog(ast.NodeTransformer):
    def visit_Assign(self, node):
        # skip sub coroutine invocations, handled by translate
        if is_call(node.value) and is_attribute(node.value.func) and node.value.func.attr == "send":
            return node
        if is_tuple(node.targets[0]):
            body = [ast.Assign([node.targets[0].elts[n]], node.value.elts[n])
                    for n in range(len(node.value.elts))]
            return ast.If(ast.NameConstant(True), body, [])
        return node

def process_statement(stmt):
    RemoveFuncs().visit(stmt)
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


def compile_statements(ctx, else_body, comb_body, states, one_state, width_table,
                       registers, statements):
    module = ctx.module
    # temp_var_promoter = TempVarPromoter(width_table)
    for statement in statements:
        conds = []
        yield_pairs = set()
        contained = [state for state in states if statement in state.statements]
        stores = collect_stores(statement)
        has_reg = any(x in registers for x in stores)
        if contained != states:
            for state in states:
                if statement in state.statements:
                    these_conds = []
                    if state.conds:
                        these_conds.extend(ctx.translate(process_statement(cond)) for cond in state.conds)
                    if not one_state:
                        these_conds.append(ctx.get_by_name('yield_state') == state.start_yield_id)
                        yield_pairs.add((state.start_yield_id, state.end_yield_id))
                    if these_conds:
                        if len(these_conds) > 1:
                            cond = reduce(vg.Land, these_conds[1:], these_conds[0])
                        else:
                            cond = these_conds[0]
                        conds.append(cond)
            if not one_state:
                ends = [end_yield_id for _, end_yield_id in yield_pairs]
                if all(x == ends[0] for x in ends):
                    conds = [module.get_vars()["yield_state_next"] == ends[0]]
                else:
                    conds = [(module.get_vars()["yield_state"] == start_yield_id) &
                             (module.get_vars()["yield_state_next"] == end_yield_id) for
                             start_yield_id, end_yield_id in yield_pairs]
            statement = process_statement(statement)
            if has_reg:
                stmt = vg.Subst(ctx.translate(statement.targets[0]), ctx.translate(statement.value), 1)

                if conds:
                    cond = reduce(vg.Lor, conds)
                    else_body.append(vg.If(cond)(
                        stmt
                    ))
                else:
                    else_body.append(stmt)
            else:
                # print(astor.to_source(statement))
                result = ctx.translate(statement)
                if result:
                    comb_body.append(result
                        # vg.Subst(ctx.translate(statement.targets[0]), ctx.translate(statement.value), 1)
                    )
        else:
            process_statement(statement)
            try:
                stmt = ctx.translate(statement)
            except Exception as e:
                ctx.module.Always(vg.SensitiveAll())(comb_body)
                print(ctx.module.to_verilog())
                raise e
            if stmt:
                if has_reg:
                    else_body.append(stmt)
                else:
                    comb_body.append(stmt)


def compile_states(ctx, states, one_state, width_table, registers, inputs,
                   sub_coroutines):
    module = ctx.module
    else_body = []
    comb_body = []
    for name, def_ in sub_coroutines.items():
        ports = []
        for key, type_ in def_.interface.ports.items():
            if key == "CLK":
                ports.append((key, ctx.get_by_name(f"CLK")))
            elif key == "RESET":
                ports.append((key, ctx.get_by_name(f"RESET")))
            elif key == "CE":
                ports.append((key, ctx.get_by_name(f"CE")))
            else:
                ports.append((key, ctx.get_by_name(f"_si_sub_co_{name}_{key}")))

        module.Instance(def_.name, name, ports=ports)

    seen = set()
    for i, state in enumerate(states):
        if isinstance(state.path[0], Yield) and state.path[0].yield_id < 0:
            continue
        for target, value in state.path[0].loads.items():
            if (target, value) not in seen:
                seen.add((target, value))
                width = width_table[value]
                if isinstance(width, MemoryType):
                    for i in range(width.height):
                        comb_body.append(
                            ctx.assign(vg.Pointer(ctx.get_by_name(target), i),
                                       vg.Pointer(ctx.get_by_name(value), i)))
                        comb_body[-1].blk = 1
                else:
                    comb_body.append(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value)))
                    comb_body[-1].blk = 1
    statements = []
    for state in states:
        index = len(statements)
        for statement in reversed(state.statements):
            if statement in statements:
                index = statements.index(statement)
            else:
                statements.insert(index, statement)
    compile_statements(ctx, else_body, comb_body, states, one_state, width_table, registers, statements)
    reset_body = []
    for i, state in enumerate(states):
        if isinstance(state.path[0], Yield) and state.path[0].yield_id < 0:
            continue
        is_reset = isinstance(state.path[0], HeadBlock)
        for value, target in state.path[-1].stores.items():
            if (target, value) not in seen:
                if not is_reset:
                    seen.add((target, value))
                    update_body = else_body
                else:
                    update_body = reset_body
                width = width_table[value]
                if not one_state:
                    # cond = ctx.get_by_name('yield_state_next') == state.start_yield_id
                    all_conds = {}
                    for _state in states:
                        if _state.path[-1] is not state.path[-1]:
                            continue
                        conds = [ctx.translate(process_statement(cond)) for cond in _state.conds]
                        if is_reset:
                            cond = reduce(vg.Land, conds) if conds else vg.Int(1)
                        else:
                            cond = reduce(vg.Land, conds, ctx.get_by_name('yield_state') == _state.start_yield_id)

                        all_conds[str(cond)] = cond
                    all_conds = list(all_conds.values())
                    cond = reduce(vg.Lor, all_conds)
                    if isinstance(width, MemoryType):
                        if_body = []
                        for i in range(width.height):
                            if_body.append(ctx.assign(vg.Pointer(ctx.get_by_name(target), i),
                                                      vg.Pointer(ctx.get_by_name(value), i),
                                                      blk=target not in registers))
                        if if_body:
                            if target in registers:
                                update_body.append(vg.If(cond)(if_body))
                            elif not is_reset:
                                comb_body.append(vg.If(cond)(if_body))
                    else:
                        if target in registers:
                            assign = ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value), blk=0)
                            update_body.append(vg.If(cond)(assign))
                        elif not is_reset:
                            comb_body.append(vg.If(cond)(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value))))
                else:
                    if isinstance(width, MemoryType):
                        for i in range(width.height):
                            if target in registers:
                                assign = \
                                    ctx.assign(vg.Pointer(ctx.get_by_name(target),
                                                          i),
                                               vg.Pointer(ctx.get_by_name(value),
                                                          i), blk=0)
                                update_body.append(assign)
                            elif not is_reset:
                                comb_body.append(ctx.assign(vg.Pointer(ctx.get_by_name(target), i),
                                                            vg.Pointer(ctx.get_by_name(value), i)))
                    else:
                        if target in registers:
                            assign = ctx.assign(ctx.get_by_name(target),
                                                ctx.get_by_name(value), blk=0)
                            update_body.append(assign)
                        elif not is_reset:
                            comb_body.append(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value)))
    if not one_state:
        started = False
        yields = set()
        for state in states:
            yields.add(state.path[0])
            yields.add(state.path[-1])
        next_yield_stmts = []
        next_state = None
        reset_next_state = None
        yields = list(yields)
        for yield_ in yields:
            is_reset = yield_.yield_id < 0
            if is_reset and isinstance(yield_, Yield):
                continue
            next_yield = ctx.assign(ctx.get_by_name('yield_state_next'), yield_.yield_id)
            all_conds = {}
            if not is_reset:
                for state in states:
                    if state.start_yield_id < 0:
                        continue
                    if state.end_yield_id == yield_.yield_id:
                        cond = ctx.get_by_name('yield_state') == state.start_yield_id
                        if state.conds:
                            conds = (ctx.translate(process_statement(cond)) for cond in state.conds)
                            cond = reduce(vg.Land, conds, cond)
                        all_conds[str(cond)] = cond
                if all_conds:
                    all_conds = list(all_conds.values())
                    if len(all_conds) > 1:
                        cond = reduce(vg.Lor, all_conds[1:], all_conds[0])
                    else:
                        cond = all_conds[0]
                    if next_state is None:
                        next_state = vg.If(cond)(next_yield)
                    elif yield_ == yields[-1]:
                        next_state.Else(next_yield)
                    else:
                        next_state.Elif(cond)(next_yield)
            else:
                reset_states = list(filter(lambda x: x.start_yield_id < 0, states))
                for state in reset_states:
                    next_yield = ctx.assign(ctx.get_by_name('yield_state'),
                                            state.end_yield_id, blk=0)
                    if state.conds:
                        conds = (ctx.translate(process_statement(cond)) for cond in state.conds)
                        cond = reduce(vg.Land, conds)
                        if reset_next_state is None:
                            reset_next_state = vg.If(cond)(next_yield)
                        elif state == reset_states[-1]:
                            reset_next_state = reset_next_state.Else(next_yield)
                        else:
                            reset_next_state.Elif(cond)(next_yield)
                    else:
                        reset_next_state = next_yield
        assert next_state is not None
        assert reset_next_state is not None
        comb_body.insert(0, next_state)
        for i, state in enumerate(states):
            conds = []
            if state.conds:
                conds = [ctx.translate(process_statement(cond)) for cond in state.conds]
            cond = reduce(vg.Land, conds, ctx.get_by_name('yield_state') == state.start_yield_id)


            output_stmts = []
            for output, var in state.path[-1].output_map.items():
                output_stmts.append(ctx.assign(ctx.get_by_name(output), ctx.get_by_name(var)))
                output_stmts[-1].blk = 1

            stmts = []
            for stmt in state.path[-1].array_stores_to_process:
                stmts.append(ctx.translate(process_statement(stmt)))

            if stmts:
                if not started:
                    if_stmt = vg.If(cond)
                    else_body.append(if_stmt)
                    started = True
                elif i == len(states) - 1:
                    if_stmt = if_stmt.Else()
                else:
                    if_stmt = if_stmt.Elif(cond)
                if_stmt(stmts)
            comb_cond = reduce(
                vg.Land,
                conds, #  + [ctx.get_by_name('yield_state_next') == state.end_yield_id],
                ctx.get_by_name('yield_state') == state.start_yield_id)
            if output_stmts:
                if not comb_body:
                    comb_body.append(vg.If(comb_cond)(output_stmts))
                elif i == len(states) - 1:
                    comb_body[-1] = comb_body[-1].Else(output_stmts)
                else:
                    comb_body[-1] = comb_body[-1].Elif(comb_cond)(output_stmts)

    else:
        for output, var in states[0].path[-1].output_map.items():
            comb_body.append(vg.Subst(ctx.get_by_name(output),
                                      ctx.get_by_name(var), 1))

    sensitivity_list = []
    for reg in registers:
        sensitivity_list.append(ctx.get_by_name(reg))
    for input_ in inputs:
        sensitivity_list.append(ctx.get_by_name(input_))
    if not one_state:
        sensitivity_list.append(ctx.get_by_name("yield_state"))
    # ctx.module.Always(*sensitivity_list)(
    #     comb_body
    # )
    for stmt in comb_body:
        ctx.module.Always(*sensitivity_list)(
            # comb_body
            stmt
        )
    if not one_state:
        else_body.append(
            ctx.assign(ctx.get_by_name('yield_state'), ctx.get_by_name('yield_state_next'), blk=0)
        )
        reset_body.insert(0, reset_next_state)
        # reset_body = [reset_next_state] + comb_body + reset_body
    ctx.module.Always(
        vg.Posedge(ctx.module.get_ports()["CLK"]),
        vg.Posedge(ctx.module.get_ports()["RESET"])
    )(
        vg.If(
            ctx.module.get_ports()["RESET"]
        )(
            reset_body
        )(
            else_body
        )
    )


def compile_by_path(ctx, paths, one_state, width_table, registers,
                    sub_coroutines, outputs, inputs,
                    strategy="by_statement", reset_type="posedge",
                    has_ce=False):

    for name, def_ in sub_coroutines.items():
        ports = []
        for key, type_ in def_.interface.ports.items():
            if key == "CLK":
                ports.append((key, ctx.get_by_name(f"CLK")))
            elif key == "RESET":
                ports.append((key, ctx.get_by_name(f"RESET")))
            else:
                ports.append((key, ctx.get_by_name(f"_si_sub_co_{name}_{key}")))

        ctx.module.Instance(def_.name, name, ports=ports)

    last_if = None
    first_if = None
    state_map = {}
    for i, path in enumerate(paths):
        if isinstance(path[0], Yield) and path[0].yield_id < 0:
            continue
        state = path[0].yield_id
        if state >= 0 and "state" in outputs:
            if isinstance(path[0].value.value.value, ast.Num):
                state = path[0].value.value.value.n
            else:
                assert isinstance(path[0].value.value.value, ast.Tuple)
                value = path[0].value.value.value.elts[0]
                if isinstance(value, ast.Num):
                    value = value.n
                elif isinstance(value, ast.Str):
                    value = value.s
                else:
                    raise NotImplementedError(value)
                state = value
        if state not in state_map:
            state_map[state] = []
        statements = []
        for n, block in reversed(list(enumerate(path))[1:]):
            if isinstance(block, HeadBlock):
                continue
            elif isinstance(block, BasicBlock):
                statements = [
                    replace_references_to_registers(
                        process_statement(copy.deepcopy(stmt)),
                        registers, isinstance(state, int) and state < 0,
                        outputs)
                    for stmt in block.statements
                ] + statements
            elif isinstance(block, Branch):
                cond = block.cond
                if path[n + 1] is block.false_edge:
                    cond = ast.UnaryOp(ast.Invert(), cond)
                statements = [ast.If(
                    replace_references_to_registers(
                        process_statement(copy.deepcopy(cond)), registers,
                        isinstance(state, int) and state < 0, outputs
                    ), statements, []
                )]
                statements[0].orig_node = block.orig_node
                statements[0].is_true = path[n + 1] is block.true_edge
            elif isinstance(block, Yield):
                if not one_state:
                    if "state" in outputs:
                        if isinstance(block.value.value.value, ast.Num):
                            next_state = block.value.value.value.n
                        else:
                            assert isinstance(block.value.value.value, ast.Tuple)
                            value = block.value.value.value.elts[0]
                            if isinstance(value, ast.Num):
                                value = value.n
                            elif isinstance(value, ast.Str):
                                value = "\"" + value.s + "\""
                            else:
                                raise NotImplementedError(value)
                            next_state = value
                        # if state >= 0:
                        #     statements.append(
                        #         ast.parse(f"yield_state_next = state_next").body[0])
                        # else:
                        #     statements.append(
                        #         ast.parse(f"yield_state = state").body[0])
                    else:
                        next_state = block.yield_id
                    if not isinstance(state, int) or state >= 0:
                        statements.append(
                            ast.parse(f"yield_state_next = {next_state}").body[0])
                    else:
                        statements.append(
                            ast.parse(f"yield_state = {next_state}").body[0])
            else:
                raise NotImplementedError(block)
        if isinstance(state, int) and state < 0:
            statements = [
                replace_references_to_registers(
                    process_statement(copy.deepcopy(stmt)), registers, state <
                    0, outputs) for stmt in path[0].statements
            ] + statements
        state_map[state].append(statements)

    last_if = None
    items = list(state_map.items())
    reset_body = []
    for state, statements in items:
        body = []
        for block in statements:
            for stmt in block:
                if stmt not in body:
                    body.append(stmt)
        body = merge_ifs(body)
        body = filter_duplicates(body)

        if state == -1:
            initialized = set()
            for stmt in body:
                if isinstance(stmt, ast.Assign):
                    if stmt.targets[0].id in registers or \
                            stmt.targets[0].id == "yield_state":
                        # HACK: Take first initialization value
                        if stmt.targets[0].id in initialized:
                            continue
                        initialized.add(stmt.targets[0].id)
                        target = stmt.targets[0]
                        if target.id in outputs:
                            target.id += "_prev"
                        reset_body.append(
                            ctx.translate_assign(target,
                                                 ctx.translate(stmt.value),
                                                 blk=0)
                        )
                else:
                    raise NotImplementedError(astor.to_source(stmt))
        else:
            body = [ctx.translate(stmt) for stmt in body]
            if not one_state:
                if_ = vg.If(
                    (ctx.module.get_vars()["yield_state"] == vg.EmbeddedNumeric(state))
                )(body)
                if last_if is not None:
                    if (state, statements) == items[-1]:
                        last_if.Else(body)
                    else:
                        last_if.Else([if_])
                else:
                    first_if = if_
                last_if = if_
            else:
                assert len(items) <= 2
    assert reset_body is not None
    if last_if is not None:
        body = [first_if]
    else:
        assert one_state
    for reg in registers:
        width = width_table[reg]
        if reg in outputs:
            target = reg
            value = reg + "_prev"
        else:
            target = reg + "_next"
            value = reg
        if isinstance(width, MemoryType):
            for i in range(width.height):
                body.insert(0, ctx.assign(
                    vg.Pointer(ctx.get_by_name(target), vg.Int(i)),
                    vg.Pointer(ctx.get_by_name(value), vg.Int(i))
                ))
        else:
            body.insert(0, ctx.assign(ctx.get_by_name(target),
                                      ctx.get_by_name(value)))
    sensitivity_list = []
    for reg in registers:
        sensitivity_list.append(ctx.get_by_name(reg))
    for input_ in inputs:
        sensitivity_list.append(ctx.get_by_name(input_))
    if not one_state:
        sensitivity_list.append(ctx.get_by_name("yield_state"))
    ctx.module.Always(*sensitivity_list)(
        body
    )
    else_body = []
    for reg in registers:
        if reg in outputs:
            target = reg + "_prev"
            value = reg
        else:
            target = reg
            value = reg + "_next"
        width = width_table[reg]
        if isinstance(width, MemoryType):
            for i in range(width.height):
                else_body.append(
                    ctx.assign(
                        vg.Pointer(ctx.get_by_name(target), vg.Int(i)),
                        vg.Pointer(ctx.get_by_name(value), vg.Int(i)),
                        blk=0
                    )
                )
        else:
            else_body.append(
                ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value),
                           blk=0)
            )
    if not one_state:
        else_body.append(
            ctx.assign(ctx.get_by_name('yield_state'),
                       ctx.get_by_name('yield_state_next'), blk=0)
        )
    if reset_type == "posedge":
        reset_event = vg.Posedge(ctx.module.get_ports()["RESET"])
        reset_cond = ctx.module.get_ports()["RESET"] 
    else:
        reset_event = vg.Negedge(ctx.module.get_ports()["RESET"])
        reset_cond = ~ctx.module.get_ports()["RESET"] 
    if has_ce:
        else_body = vg.If(ctx.module.get_ports()["CE"])(else_body)
    ctx.module.Always(
        vg.Posedge(ctx.module.get_ports()["CLK"]), reset_event
    )(
        vg.If(reset_cond)(
            reset_body
        )(
            else_body
        )
    )
    if "state" in outputs:
        ctx.module.Assign(ctx.assign(ctx.module.get_ports()["state"],
                                     ctx.get_by_name("yield_state")))
