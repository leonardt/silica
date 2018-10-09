import astor
import ast
from .width import get_width
import veriloggen as vg
from functools import *
from .ast_utils import *
import magma
from .visitors.collect_stores import collect_stores
from .cfg.types import HeadBlock
from .memory import MemoryType

class Context:
    def __init__(self, name):
        self.module = vg.Module(name)

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

    def assign(self, lhs, rhs):
        return vg.Subst(lhs, rhs, not self.is_reg(lhs))

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

    # TODO: should reorder the switch into more sensible ordering
    # TODO: should split this up into a few translate functions that translate certain classes of inputs
    def translate(self, stmt):
        if isinstance(stmt, bool):
            return vg.Int(1 if stmt else 0)
        elif is_add(stmt):
            return vg.Add
        elif is_assign(stmt):
            target = self.translate(stmt.targets[0])
            return vg.Subst(
                target,
                self.translate(stmt.value),
                not self.is_reg(target)
            )
        elif is_bin_op(stmt):
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
            assert(len(stmt.ops) == len(stmt.comparators) == 1)
            return self.translate(stmt.ops[0])(
                self.translate(stmt.left),
                self.translate(stmt.comparators[0])
            )
        elif is_eq(stmt):
            return vg.Eq
        elif is_if_exp(stmt):
            return vg.Cond(
                self.translate(stmt.test),
                self.translate(stmt.body),
                self.translate(stmt.orelse)
            )
        elif is_invert(stmt):
            return vg.Unot
        elif is_lt(stmt):
            return vg.LessThan
        elif is_gt(stmt):
            return vg.GreaterThan
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
        elif is_subscript(stmt):
            if is_index(stmt.slice):
                return vg.Pointer(
                    self.translate(stmt.value),
                    self.translate(stmt.slice.value)
                )
            elif is_slice(stmt.slice):
                return vg.Slice(
                    self.translate(stmt.value),
                    self.translate(stmt.slice.lower),
                    self.translate(stmt.slice.upper)
                )
        elif is_unary_op(stmt):
            return self.translate(stmt.op)(self.translate(stmt.operand))

        raise NotImplementedError(stmt)

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
        if isinstance(node.func, ast.Name) and node.func.id in ['bits', 'uint',
                                                                'bit', 'phi']:
            return self.visit(node.args[0])
        return node

def process_statement(stmt):
    RemoveFuncs().visit(stmt)
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


def compile_statements(ctx, seq, comb_body, states, one_state, width_table,
                       registers, statements):
    module = ctx.module
    # temp_var_promoter = TempVarPromoter(width_table)
    for statement in statements:
        conds = []
        yields = set()
        contained = [state for state in states if statement in state.statements]
        stores = collect_stores(statement)
        has_reg = any(x in registers for x in stores)
        if contained != states:
            for state in states:
                if statement in state.statements:
                    if state.conds or not one_state:
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
            statement = process_statement(statement)
            if has_reg:
                stmt = vg.Subst(ctx.translate(statement.targets[0]), ctx.translate(statement.value), 1)

                if conds:
                    cond = reduce(vg.Lor, conds)
                    seq.If(cond)(
                        stmt
                    )
                else:
                    seq(stmt)
            else:
                comb_body.append(
                    vg.Subst(ctx.translate(statement.targets[0]), ctx.translate(statement.value), 1)
                )
        else:
            process_statement(statement)
            try:
                stmt = vg.Subst(ctx.translate(statement.targets[0]), ctx.translate(statement.value), 1)
            except Exception as e:
                ctx.module.Always(vg.SensitiveAll())(comb_body)
                print(ctx.module.to_verilog())
                raise e
            if has_reg:
                seq(stmt)
            else:
                comb_body.append(stmt)


def compile_states(ctx, states, one_state, width_table, registers,
                   strategy="by_statement"):
    module = ctx.module
    seq = vg.TmpSeq(module, module.get_ports()["CLK"])
    comb_body = []

    if strategy == "by_statement":
        seen = set()
        for i, state in enumerate(states):
            if isinstance(state.path[0], HeadBlock):
                continue
            if state.path[0] not in seen:
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
                for value, target in state.path[0].stores.items():
                    if (target, value) not in seen:
                        seen.add((target, value))
                        width = width_table[value]
                        if target in registers:
                            if not one_state:
                                cond = ctx.get_by_name('yield_state_next') == state.start_yield_id
                                if isinstance(width, MemoryType):
                                    if_body = []
                                    for i in range(width.height):
                                        if_body.append(ctx.assign(vg.Pointer(ctx.get_by_name(target), i),
                                                                  vg.Pointer(ctx.get_by_name(value), i)))
                                    seq.If(cond)(if_body)
                                else:
                                    seq.If(cond)(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value)))
                            else:
                                if isinstance(width, MemoryType):
                                    for i in range(width.height):
                                        seq(ctx.assign(vg.Pointer(ctx.get_by_name(target), i),
                                                       vg.Pointer(ctx.get_by_name(value), i)))
                                else:
                                    seq(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value)))
                        else:
                            if isinstance(width, MemoryType):
                                for i in range(width.height):
                                    comb_body.append(ctx.assign(
                                        vg.Pointer(ctx.get_by_name(target), i),
                                        vg.Pointer(ctx.get_by_name(value), i))
                                    )
                            else:
                                comb_body.append(ctx.assign(ctx.get_by_name(target), ctx.get_by_name(value)))
        statements = []
        for state in states:
            index = len(statements)
            for statement in reversed(state.statements):
                if statement in statements:
                    index = statements.index(statement)
                else:
                    statements.insert(index, statement)
        compile_statements(ctx, seq, comb_body, states, one_state, width_table, registers, statements)
        if not one_state:
            next_state = None
            for i, state in enumerate(states):
                conds = []
                if state.conds:
                    conds = [ctx.translate(process_statement(cond)) for cond in state.conds]
                cond = reduce(vg.Land, conds, ctx.get_by_name('yield_state') == state.start_yield_id)

                if i == 0:
                    if_stmt = seq.If(cond)
                else:
                    if_stmt = seq.Elif(cond)

                output_stmts = []
                for output, var in state.path[-1].output_map.items():
                    output_stmts.append(ctx.assign(ctx.get_by_name(output), ctx.get_by_name(var)))
                    output_stmts[-1].blk = 1

                stmts = []
                next_yield = ctx.assign(ctx.get_by_name('yield_state_next'), state.end_yield_id)
                if next_state is None:
                    next_state = vg.If(cond)(next_yield)
                else:
                    next_state.Elif(cond)(next_yield)
                for stmt in state.path[-1].array_stores_to_process:
                    stmts.append(ctx.translate(process_statement(stmt)))

                if_stmt(stmts)
                comb_cond = reduce(
                    vg.Land,
                    conds + [ctx.get_by_name('yield_state_next') == state.end_yield_id],
                    ctx.get_by_name('yield_state') == state.start_yield_id)
                if i == 0:
                    comb_body.append(vg.If(comb_cond)(output_stmts))
                else:
                    comb_body[-1] = comb_body[-1].Elif(comb_cond)(output_stmts)
            comb_body.insert(0, next_state)

        else:
            for output, var in states[0].path[-1].output_map.items():
                comb_body.append(vg.Subst(ctx.get_by_name(output),
                                          ctx.get_by_name(var), 1))
    else:
        raise NotImplementedError(strategy)

    ctx.module.Always(vg.SensitiveAll())(
        comb_body
    )
    if not one_state:
        seq(
            ctx.assign(ctx.get_by_name('yield_state'), ctx.get_by_name('yield_state_next'))
        )
