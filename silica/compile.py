import ast
import astor
import inspect
import magma as m
import magma
import os
import sys

import silica
from silica.coroutine import Coroutine
from silica.cfg import ControlFlowGraph, BasicBlock, HeadBlock
from silica.cfg.control_flow_graph import render_paths_between_yields, build_state_info, render_fsm, get_constant
from silica.ast_utils import get_ast
from silica.liveness import liveness_analysis
from silica.transformations import specialize_constants, replace_symbols, \
    constant_fold, desugar_for_loops, specialize_evals, inline_yield_from_functions
from silica.visitors import collect_names
from silica.verilog import compile_state as verilog_compile_state
from .verilog import get_width_str
from .width import get_width
from .memory import MemoryType



def replace_assign_to_bits(statement, load_symbol_map, store_symbol_map):
    class Transformer(ast.NodeTransformer):
        def visit_Assign(self, node):
            if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
                target = replace_symbols(node.targets[0], store_symbol_map, ast.Load)
                return ast.parse(f"{astor.to_source(target).rstrip()} = {astor.to_source(node.value).rstrip()}").body[0]
            return node

        def run(self, statement):
            return self.visit(statement)
    return Transformer().run(statement)

def specialize_arguments(tree, coroutine):
    arg_map = {}
    for arg, value in zip(tree.args.args, coroutine.args):
        arg_map[arg.arg] = value
    if len(coroutine.args) < len(tree.args.args):
        for index, arg in enumerate(tree.args.args[len(coroutine.args):]):
            if arg.arg in coroutine.kwargs:
                value = coroutine.kwargs[arg.arg]
            else:
                value = tree.args.defaults[index + len(coroutine.args) - (len(tree.args.args) - len(tree.args.defaults))]
            if isinstance(value, ast.Num) or isinstance(value, ast.NameConstant) and value.value in [True, False]:
                arg_map[arg.arg] = value
            else:
                raise NotImplementedError(ast.dump(arg))


    return specialize_constants(tree, arg_map)


class TypeChecker(ast.NodeVisitor):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def check(self, tree):
        self.visit(tree)
        return self.width_table

    def visit_Assign(self, node):
        if isinstance(node.value, ast.Yield):
            return  # width specified at compile time
        if len(node.targets) == 1:
            if isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and node.value.func.id == "coroutine_create":
                pass
            elif isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Attribute) and node.value.func.attr == "send":
                pass
            elif isinstance(node.targets[0], ast.Name):
                if node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = get_width(node.value, self.width_table)
                elif self.width_table[node.targets[0].id] != get_width(node.value, self.width_table):
                    raise TypeError(f"Trying to assign {ast.dump(node.value)} with width {get_width(node.value, self.width_table)} to {node.targets[0].id} with width {self.width_table[node.targets[0].id]}")
            elif isinstance(node.targets[0], ast.Tuple):
                if not all(isinstance(target, ast.Name) for target in node.targets[0].elts):
                    raise SyntaxError(f"Can only assign to variables {ast.dump(node)}")
                widths = get_width(node.value, self.width_table)
                if not isinstance(widths, tuple) or len(widths) != len(node.targets[0].elts):
                    raise TypeError(f"Trying to unpack {len(node.targets.elts)} but got {len(widths)} - {ast.dump(node)} ")
                for target, width in zip(node.targets[0].elts, widths):
                    self.width_table[target.id] = width
            elif isinstance(node.targets[0], ast.Subscript):
                if not get_width(node.targets[0], self.width_table) == get_width(node.value, self.width_table):
                    raise TypeError(f"Mismatched widths {get_width(node.targets[0], self.width_table)} != {get_width(node.value, self.width_table)} : {astor.to_source(node).rstrip()}")
            else:
                raise NotImplementedError(ast.dump(node))
        else:
            raise NotImplementedError(ast.dump(node))


class CollectInitialWidthsAndTypes(ast.NodeVisitor):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def visit_Assign(self, node):
        if len(node.targets) == 1:
            if isinstance(node.targets[0], ast.Name):
                if isinstance(node.value, ast.Yield):
                    pass  # width specified at compile time
                elif isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and node.value.func.id == "coroutine_create":
                    pass
                elif isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Attribute) and node.value.func.attr == "send":
                    pass
                elif node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = get_width(node.value, self.width_table)
                    if isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and \
                       node.value.func.id in {"bits", "uint"}:
                        self.type_table[node.targets[0].id] = node.value.func.id
                    elif isinstance(node.value, ast.NameConstant) and node.value.value in [True, False]:
                        self.type_table[node.targets[0].id] = "bit"


class PromoteWidths(ast.NodeTransformer):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def check_valid(self, int_length, expected_length):
        if int_length > expected_length:
            raise TypeError("Cannot promote integer with greated width than other operand")

    def make(self, value, width, type_):
        return ast.parse(f"{type_}({value}, {width})").body[0].value

    def get_type(self, node):
        if isinstance(node, ast.Name):
            return self.type_table[node.id]
        elif isinstance(node, ast.Subscript):
            if isinstance(node.value, ast.Name):
                type_ = self.type_table[node.value.id]
                if type_ == "uint" and isinstance(node.slice, ast.Index):
                    return 1
                else:
                    raise NotImplementedError()
        raise NotImplementedError(node)

    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        if isinstance(node.value, ast.Num):
            width = get_width(node.targets[0], self.width_table)
            self.check_valid(node.value.n.bit_length(), width)
            node.value = self.make(node.value.n, width, self.get_type(node.targets[0]))
        elif isinstance(node.value, ast.NameConstant):
            width = get_width(node.targets[0], self.width_table)
            node.value = ast.parse(f"bit({node.value.value})").body[0].value
        return node

    def visit_AugAssign(self, node):
        node.value = self.visit(node.value)
        if isinstance(node.value, ast.Num):
            width = get_width(node.target, self.width_table)
            self.check_valid(node.value.n.bit_length(), width)
            node.value = self.make(node.value.n, width, self.get_type(node.target))
        return node

    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.left, ast.Num):
            right_width = get_width(node.right, self.width_table)
            self.check_valid(node.left.n.bit_length(), right_width)
            node.left = self.make(node.left.n, right_width, self.get_type(node.right))
        elif isinstance(node.right, ast.Num):
            left_width = get_width(node.left, self.width_table)
            self.check_valid(node.right.n.bit_length(), left_width)
            node.right = self.make(node.right.n, left_width, self.get_type(node.left))
        return node

    def visit_Compare(self, node):
        node.left = self.visit(node.left)
        node.comparators = [self.visit(x) for x in node.comparators]
        if not isinstance(node.left, ast.Num):
            left_width = get_width(node.left, self.width_table)
            type_ = self.get_type(node.left)
            for i in range(len(node.comparators)):
                if isinstance(node.comparators[i], ast.Num):
                    self.check_valid(node.comparators[i].n.bit_length(), left_width)
                    node.comparators[i] = self.make(node.comparators[i].n, left_width, type_)
        else:
            for comparator in node.comparators:
                if not isinstance(comparator, ast.Num):
                    width = get_width(comparator, self.width_table)
                    type_ = self.get_type(comparator)
            else:
                assert False, "Constant fold should have folded this expression {ast.dump(node)}"
            self.check_valid(node.left.n.bit_length(), width)
            node.left = self.make(node.left.n, width, type_)
            for i in range(len(node.comparators)):
                if isinstance(node.comparators[i], ast.Num):
                    self.check_valid(node.comparators[i].n.bit_length(), width)
                    node.comparators[i] = self.make(node.comparators[i].n, width, type_)
        return node


class ListExprChecker(ast.NodeVisitor):
    def __init__(self):
        self.is_list_expr = True

    def visit_List(self, node):
        return

    def visit_Subscript(self, node):
        return

    def visit_Name(self, node):
        self.is_list_expr = False

    def run(self, expr):
        self.visit(expr)
        return self.is_list_expr


class Desugar(ast.NodeTransformer):
    def __init__(self, width_table):
        self.width_table = width_table

    def visit(self, node):
        node = super().visit(node)
        if hasattr(node, 'body'):
            new_body = []
            for child in node.body:
                if isinstance(child, list):
                    new_body.extend(child)
                else:
                    assert isinstance(child, ast.AST)
                    new_body.append(child)
            node.body = new_body
        return node

    def is_list_expr(self, node):
        if not len(node.targets) == 1 or not isinstance(node.targets[0], ast.Name) or \
           node.targets[0].id not in self.width_table or \
           not isinstance(self.width_table[node.targets[0].id], tuple):
               return False
        # Check leaf nodes are list literals or slices
        return ListExprChecker().run(node.value)

    # def visit_Assign(self, node):
    #     if self.is_list_expr(node):
    #         raise NotImplementedError()
    #     return super().generic_visit(node)

    def visit_Call(self, node):
        # Skip wire calls because they are not silica code
        if isinstance(node.func, ast.Name) and node.func.id in {"wire"}:
            return node
        return super().generic_visit(node)

    def visit_AugAssign(self, node):
        target = astor.to_source(node.target).rstrip()
        value  = astor.to_source(node.value).rstrip()
        return self.visit(ast.parse(f"{target} = {target} + {value}").body[0].value)

    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.op, ast.Add):
            op = "add"
        elif isinstance(node.op, ast.Sub):
            op = "sub"
        elif isinstance(node.op, ast.BitXor):
            op = "xor"
        elif isinstance(node.op, ast.BitAnd):
            op = "and_"
        elif isinstance(node.op, ast.Lt):
            op = "lt"
        elif isinstance(node.op, ast.LtE):
            op = "le"
        else:
            raise NotImplementedError(node.op)
        return ast.parse(f"{op}({astor.to_source(node.left).rstrip()}, {astor.to_source(node.right).rstrip()})").body[0].value


    def visit_UnaryOp(self, node):
        if isinstance(node.op, ast.Not):
            op = "not_"
        elif isinstance(node.op, ast.USub):
            op = "neg"
        else:
            raise NotImplementedError(node.op)
        return ast.parse(f"{op}({astor.to_source(node.operand).rstrip()})").body[0].value

    def visit_BoolOp(self, node):
        node.values = [self.visit(value) for value in node.values]
        if isinstance(node.op, ast.And):
            op = "and_"
        else:
            raise NotImplementedError(node.op)
        args = ", ".join(astor.to_source(value) for value in node.values)
        return ast.parse(f"{op}({args})").body[0].value

    def visit_Compare(self, node):
        node.left = self.visit(node.left)
        node.comparators = [self.visit(x) for x in node.comparators]
        if all(isinstance(op, ast.Eq) for op in node.ops):
            args = ", ".join([astor.to_source(node.left).rstrip()] +
                [astor.to_source(x).rstrip() for x in node.comparators])
            return ast.parse(f"eq({args})").body[0].value
        elif all(isinstance(op, ast.NotEq) for op in node.ops):
            args = ", ".join([astor.to_source(node.left).rstrip()] +
                [astor.to_source(x).rstrip() for x in node.comparators])
            return ast.parse(f"not_(eq({args}))").body[0].value
        if len(node.ops) == 1:
            left = astor.to_source(node.left).rstrip()
            right = astor.to_source(node.comparators[0]).rstrip()
            if isinstance(node.ops[0], ast.Lt):
                return ast.parse(f"lt({left}, {right})").body[0].value
            elif isinstance(node.ops[0], ast.Gt):
                return ast.parse(f"gt({left}, {right})").body[0].value
            # elif isinstance(node.ops[0], ast.And):
            #     return ast.parse(f"and_({left}, {right})").body[0].value
        return node


def specialize_list_comps(tree, globals, locals):
    locals.update(silica.operators)
    class ListCompSpecializer(ast.NodeTransformer):
        def visit_ListComp(self, node):
            result = eval(astor.to_source(node), globals, locals)
            result = ", ".join(repr(x) for x in result)
            return ast.parse(f"[{result}]").body[0].value

        def visit_Call(self, node):
            if isinstance(node.func, ast.Name) and node.func.id == "list":
                result = eval(astor.to_source(node), globals, locals)
                result = ", ".join(repr(x) for x in result)
                return ast.parse(f"[{result}]").body[0].value
            return node


            result = eval(astor.to_source(node), globals, locals)
            result = ", ".join(repr(x) for x in result)
            return ast.parse(f"[{result}]").body[0].value
    ListCompSpecializer().visit(tree)


def get_input_width(type_):
    if type_ is magma.Bit:
        return None
    elif isinstance(type_, magma.ArrayKind):
        if isinstance(type_.T, magma.ArrayKind):
            elem_width = get_input_width(type_.T)
            if isinstance(elem_width, tuple):
                return (type_.N, ) + elem_width
            else:
                return (type_.N, elem_width)
        else:
            return type_.N
    else:
        raise NotImplementedError(type_)



class ArrayReplacer(ast.NodeTransformer):
    def __init__(self, array, state):
        self.array = array
        self.state = state
        self.stored = False
        self.raddr = None
        self.waddr = None
        self.wdata = None

    def visit_Call(self, node):
        # Skip wire calls because they are not silica code
        if isinstance(node.func, ast.Name) and node.func.id in {"wire"}:
            return node
        elif isinstance(node.func, ast.Attribute) and node.func.attr in {"append"}:
            return node
        if isinstance(node.func, ast.Name) and node.func.id in {"__silica_skip"}:
            return node.args[0]
        return super().generic_visit(node)

    def visit_Subscript(self, node):
        if isinstance(node.value, ast.Name) and self.array in node.value.id:
            if isinstance(node.ctx, ast.Load):
                if isinstance(node.slice, ast.Index):
                    if isinstance(node.slice.value, ast.Num) or \
                       isinstance(node.slice.value, ast.Call) and \
                       node.slice.value.func.id in {"uint"}:
                        if "_tmp" in node.value.id:
                            return ast.parse(f"{astor.to_source(node).rstrip()}").body[0].value
                        else:
                            return ast.parse(f"{astor.to_source(node).rstrip()}.O").body[0].value
                    else:
                        self.raddr = astor.to_source(node.slice).rstrip(0)
                    # else:
                    #     if "_tmp" in node.value.id:
                    #         return ast.parse(f"mux([x for x in {astor.to_source(node.value).rstrip()}], {astor.to_source(node.slice).rstrip()})").body[0].value
                    #     else:
                    #         return ast.parse(f"mux([x.O for x in {astor.to_source(node.value).rstrip()}], {astor.to_source(node.slice).rstrip()})").body[0].value
        return node

    def visit_Assign(self, node):
        if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript) and \
                                      isinstance(node.targets[0].value, ast.Name) and \
                                      node.targets[0].value.id == self.array:
            if isinstance(node.targets[0].slice.value, ast.Num):
                return node
            self.waddr = astor.to_source(node.targets[0].slice.value).rstrip()
            self.wdata = astor.to_source(node.value).rstrip()
            return ast.parse("None")
            target = replace_symbols(node.targets[0], {self.array: ast.parse(f"{self.array}_next_{self.state}_tmp").body[0].value})
            target = astor.to_source(target).rstrip()
            value = astor.to_source(node.value).rstrip()
            self.stored = True
            return ast.parse(f"{target} = {value}")
        elif isinstance(node.value, ast.Subscript) and \
             isinstance(node.value.value, ast.Name) and \
             node.value.value.id == self.array:
            if isinstance(node.value.slice.value, ast.Num):
                return ast.parse(f"{astor.to_source(node).rstrip()}.O")
            self.raddr = astor.to_source(node.value.slice).rstrip()
            node.value = ast.parse(f"{self.array}.rdata").body[0].value
            return node
        return super().generic_visit(node)


    def run(self, tree):
        tree = self.visit(tree)
        return tree, self.stored, self.raddr, self.waddr, self.wdata


def replace_arrays(tree, array, state):
    return ArrayReplacer(array, state).run(tree)


def replace_memory(tree, memory, state):
    class MemoryReplacer(ast.NodeTransformer):
        def __init__(self):
            self.raddr = self.waddr = self.wdata = None

        def visit_Assign(self, node):
            if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript) and \
                                          isinstance(node.targets[0].value, ast.Name) and \
                                          node.targets[0].value.id == memory:
                self.waddr = astor.to_source(node.targets[0].slice.value).rstrip()
                self.wdata = astor.to_source(node.value).rstrip()
                return ast.parse("None")
            elif isinstance(node.value, ast.Subscript) and \
                 isinstance(node.value.value, ast.Name) and \
                 node.value.value.id == memory:
                self.raddr = astor.to_source(node.value.slice).rstrip()
                node.value = ast.parse(f"{memory}.rdata").body[0].value
                return node
            return super().generic_visit(node)

        def run(self, tree):
            tree = self.visit(tree)
            return tree, self.raddr, self.waddr, self.wdata
    return MemoryReplacer().run(tree)

class CollectStoredArrays(ast.NodeVisitor):
    def __init__(self):
        self.inside_assign_target = False
        self.stored = set()

    def run(self, node):
        self.visit(node)
        return self.stored

    def visit_Subscript(self, node):
        if self.inside_assign_target and isinstance(node.value, ast.Name):
            self.stored.add(node.value.id)

    def visit_Assign(self, node):
        self.inside_assign_target = True
        for target in node.targets:
            self.visit(target)
        self.inside_assign_target = False


class DesugarArrays(ast.NodeTransformer):
    def __init__(self):
        self.unique_decoder_id = -1

    def run(self, node):
        self.visit(node)

    def visit_Assign(self, node):
        self.unique_decoder_id += 1
        if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
            array = astor.to_source(node.targets[0].value).rstrip()
            write_address = node.targets[0].slice
            if isinstance(write_address, ast.Index):
                if isinstance(write_address.value, ast.Num):
                    return node
                return ast.parse("None")
                return ast.parse(f"""
__silica_decoder_{self.unique_decoder_id} = decoder({astor.to_source(write_address).rstrip()})
for i in range(len({array})):
    # {array}_CE[i].append(__silica_decoder_{self.unique_decoder_id}[i])
    {array}[i] = DefineSilicaMux(2, len({array}[i]))()({array}[i], {astor.to_source(node.value).rstrip()}, bits([not_(__silica_decoder_{self.unique_decoder_id}[i]), __silica_decoder_{self.unique_decoder_id}[i]]))
""").body
            else:
                raise NotImplementedError(ast.dump(node))
        return super().generic_visit(node)

def magma_compile(coroutine, func_globals, func_locals):
    # TODO: Simplify clock enables wired up to 1
    has_ce = coroutine.has_ce
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    func_locals.update(coroutine._defn_locals)
    specialize_arguments(tree, coroutine)
    specialize_constants(tree, coroutine._defn_locals)
    constant_fold(tree)
    specialize_list_comps(tree, func_globals, func_locals)
    desugar_for_loops(tree)
    width_table = {}
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            width_table[input_] = get_input_width(type_)

    constant_fold(tree)
    type_table = {}
    CollectInitialWidthsAndTypes(width_table, type_table).visit(tree)
    PromoteWidths(width_table, type_table).visit(tree)
    Desugar(width_table).visit(tree)
    type_table = {}
    TypeChecker(width_table, type_table).check(tree)
    # DesugarArrays().run(tree)
    cfg = ControlFlowGraph(tree)
    liveness_analysis(cfg)
    # cfg.render()
    # render_paths_between_yields(cfg.paths)
    # render_fsm(cfg.states)
    registers = set()
    outputs = tuple()
    for path in cfg.paths:
        registers |= path[0].live_ins  # Union
        outputs += (collect_names(path[-1].value, ctx=ast.Load), )
    assert all(outputs[1] == output for output in outputs[1:]), "Yield statements must all have the same outputs except for the first"
    outputs = outputs[1]
    io_strings = []
    for output in outputs:
        width = width_table[output]
        if width is None:
            io_strings.append(f"\"{output}\", Out(Bit)")
        else:
            io_strings.append(f"\"{output}\", Out(Bits({width_table[output]}))")

    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            io_strings.append(f"\"{input_}\", In({type_})")
    io_string = ", ".join(io_strings)
    states = cfg.states
    num_yields = cfg.curr_yield_id
    num_states = len(states)
    register_initial_values = {}
    initial_basic_block = False
    sub_coroutines = []
    # cfg.render()
    magma_source = ""
    for node in cfg.paths[0][:-1]:
        if isinstance(node, HeadBlock):
            for statement in node:
                if isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Name) and statement.value.func.id == "coroutine_create":
                    sub_coroutine = eval(astor.to_source(statement.value.args[0]), func_globals, func_locals)
                    magma_source += magma_compile(sub_coroutine(), func_globals, func_locals)
                    statement.value.func = ast.Name(sub_coroutine._name, ast.Load())
                    statement.value.args = []
                    sub_coroutines.append((statement, sub_coroutine))
                else:
                    register_initial_values[statement.targets[0].id] = get_constant(statement.value)
        initial_basic_block |= isinstance(node, BasicBlock)
    if not initial_basic_block:
        num_states -= 1
        num_yields -= 1
        states = states[1:]
    # CE = f"VCC"
    # if has_ce:
        # CE = f"{tree.name}.CE"
    if False:
        new_states = []
        for state in states:
            for new_state in new_states:
                if "\n".join(astor.to_source(statement) for statement in state.statements) == \
                   "\n".join(astor.to_source(statement) for statement in new_state.statements):
                       new_state.start_yield_ids.append(state.start_yield_id)
                       break
            else:
                new_states.append(state)
        states = new_states
    num_states = len(states)
    for i, state in enumerate(states):
        new_statements = []
        for statement in state.statements:
            if isinstance(statement, ast.Assign) and isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Attribute) and statement.value.func.attr == "send":
                if len(statement.targets) == 1:
                    target = statement.targets[0].id
                    sub_coroutine = statement.value.func.value
                    for j, arg in enumerate(statement.value.args[0].elts):
                        new_statements.append(ast.parse(f"wire({astor.to_source(sub_coroutine).rstrip()}_inputs_{j}.I{i}, {astor.to_source(arg).rstrip()})"))
                    statement.value = ast.Attribute(sub_coroutine, target, ast.Load)
                else:
                    raise NotImplementedError()
            new_statements.append(statement)
        state.statements = new_statements
    magma_source += f"""
{tree.name} = DefineCircuit("{tree.name}", {io_string}, *ClockInterface(has_ce={has_ce}))
"""
    if has_ce:
        magma_source += f"CE = {tree.name}.CE\n"
# CE = {CE}
    if num_states > 1:
        magma_source += f"""\
Buffer = DefineCircuit("__silica_Buffer{tree.name}", "I", In(Bits({num_states})), "O", Out(Bits({num_states})))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()

import types
def generate_fsm_mux(next, width, reg, path_state, output=False):
    if hasattr(width, "__len__"):  # Hack to check for tuple since magma overrides it
        filtered_next = []
        for curr, state in next:
            if curr[0] is None:
                assert all(not x for x in curr)
            else:
                filtered_next.append((curr, state))
        if len(filtered_next) == 2:
            muxs = [DefineMux(2, width[1])() for _ in range(width[0])]
            for mux, r in zip(muxs,reg):
                wire(mux.O, r.I)
        else:
            mux = DefineSilicaMux(len(filtered_next), width[1])()
            wire(mux.O, reg.I)
        CES = []
        for i, (input_, state) in enumerate(filtered_next):
            curr = list(filter(lambda x: x, curr))
            for j, input_ in enumerate(input_):
                if isinstance(input_, list):
                    input_ = bits(input_)
                wire(getattr(muxs[j], f"I{{i}}"), input_)
                if len(filtered_next) == 2:
                    if i == 0:
                        wire(muxs[j].S, path_state.O[state])
                else:
                    wire(muxs[j].S[i], path_state.O[state])
            CES.append(path_state.O[state])
        if len(CES) == 1:
            wire(CES[0], reg.CE)
        else:
            for i in range(len(reg)):
                wire(or_(*CES), reg[i].CE)
    else:
        mux = DefineSilicaMux(len(next), width)()
        if output:
            wire(mux.O, reg)
        else:
            wire(mux.O, reg.I)
        for i, (input_, state) in enumerate(next):
            if isinstance(input_, list):
                input_ = bits(input_)
            wire(getattr(mux, f"I{{i}}"), input_)
            wire(mux.S[state], path_state.O[state])
"""
        if num_yields > 0:
            magma_source += f"""\
__silica_yield_state = Register({num_yields}, init=1, has_ce={has_ce})
{wire(__silica_yield_state.CE, CE) if has_ce else ""}
wireclock({tree.name}, __silica_yield_state)
"""
            if all(state.end_yield_id == states[0].end_yield_id for state in states):
                magma_source += f"wire(bits(1 << {states[0].end_yield_id}, {num_yields}), __silica_yield_state.I)\n"
            else:
                yield_id_map = {}
                for i, state in enumerate(states):
                    for start_yield_id in state.start_yield_ids:
                        if start_yield_id not in yield_id_map:
                            yield_id_map[start_yield_id] = []
                        yield_id_map[start_yield_id].append(state.end_yield_id)
                if all(len(value) == 1 for value in yield_id_map.values()):
                    inverse_map = {}
                    for key, value in yield_id_map.items():
                        value = value[0]
                        if value not in inverse_map:
                            inverse_map[value] = []
                        inverse_map[value].append(key)
                    for end_yield_id in inverse_map:
                        starts = inverse_map[end_yield_id]
                        if len(starts) == 1:
                            magma_source += f"wire(__silica_yield_state.O[{starts[0]}], __silica_yield_state.I[{end_yield_id}])\n"
                        else:
                            args = ", ".join(f"__silica_yield_state.O[{id_}]" for id_ in starts)
                            cond = f"or_({args})"
                            magma_source += f"wire({cond}, __silica_yield_state.I[{end_yield_id}])\n"
                    for i in range(num_yields):
                        if i not in inverse_map:
                            magma_source += f"wire(0, __silica_yield_state.I[{i}])\n"

                else:
                    magma_source += f"__silica_yield_state_next = DefineSilicaMux({num_states}, {num_yields})()\n"
                    magma_source += f"wire(__silica_path_state.O, __silica_yield_state_next.S)\n"
                    magma_source += "wire(__silica_yield_state_next.O, __silica_yield_state.I)\n"
                    for i, state in enumerate(states):
                        end_yield_id = state.end_yield_id
                        if not initial_basic_block:
                            end_yield_id -= 1
                        if not all(state.end_yield_id == states[0].end_yield_id for state in states):
                            magma_source += f"wire(__silica_yield_state_next.I{i}, bits(1 << {end_yield_id}, {num_yields}))\n"
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            magma_source += f"{input_} = {tree.name}.{input_}\n"

    for statement, sub_coroutine in sub_coroutines:
        magma_source += astor.to_source(statement)
        name = statement.targets[0].id
        if num_states > 1:
            for i, (input_, type_) in enumerate(sub_coroutine._inputs.items()):
                magma_source += f"""\
{name}_inputs_{i} = DefineSilicaMux({num_states}, {get_input_width(type_)})()
wire({name}_inputs_{i}.O, {name}.{input_})
wire(__silica_path_state.O, {name}_inputs_{i}.S)
"""

    for register in registers:
        num_stores = 0
        for state in states:
            stores = set()
            for statement in state.statements:
                stores |= CollectStoredArrays().run(statement)
                stores |= collect_names(statement, ast.Store)
            if register in stores:
                num_stores += 1
        width = width_table[register]
        if width is None:
            init_string = ""
            if register in register_initial_values and register_initial_values[register] is not None:
                init_string = f", init={register_initial_values[register]}"
            magma_source += f"{register} = DFF(has_ce={has_ce}, name=\"{register}\"{init_string})\n"
            # magma_source += f"{register}_CE = [CE]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            magma_source += f"wireclock({tree.name}, {register})\n"
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                # magma_source += f"{register}_next = DefineSilicaMux({num_states}, {width})()\n"
                # magma_source += f"wire(__silica_path_state.O, {register}_next.S)\n"
                # magma_source += f"wire({register}_next.O, {register}.I)\n"
        elif isinstance(width, MemoryType):
            magma_source += f"{register} = DefineCoreirMem({width.height}, {width.width})()\n"
        elif isinstance(width, tuple):
            if len(width) > 2:
                raise NotImplementedError()
            magma_source += f"{register} = [Register({width[1]}, has_ce=True) for _ in range({width[0]})]\n"
            # magma_source += f"{register} = DefineCoreirMem({width[0]}, {width[1]})()\n"
            # magma_source += f"{register}_CE = [[CE] for _ in range({width[0]})]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                for i in range(num_states):
                    magma_source += f"{register}_next_{i}_tmp = [None for _ in range({width[0]})]\n"
                # magma_source += f"{register}_next = [DefineSilicaMux({num_states}, {width[1]})() for _ in range({width[0]})]\n"
#                 magma_source += f"""\
# for __silica_i in range({width[0]}):
#     wire(__silica_path_state.O, {register}_next[__silica_i].S)\n
# """
#                 magma_source += f"""\
# for __silica_i in range({width[0]}):
#     wire({register}_next[__silica_i].O, {register}[__silica_i].I)
# """
#                 if num_states > 1:
#                     for i in range(num_states):
#                         magma_source += f"""\
# {register}_next_{i}_tmp = []
# for __silica_j in range({width[0]}):
#     {register}_next_{i}_tmp.append({register}[__silica_j].O)
# """
        else:
            magma_source += f"{register} = Register({width}, has_ce={has_ce})\n"
            # magma_source += f"{register}_CE = [CE]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            magma_source += f"wireclock({tree.name}, {register})\n"
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                # magma_source += f"{register}_next = DefineSilicaMux({num_states}, {width})()\n"
                # magma_source += f"wire(__silica_path_state.O, {register}_next.S)\n"
                # magma_source += f"wire({register}_next.O, {register}.I)\n"

    for output in outputs:
        width = width_table[output]
        orig = output
        if num_states > 1:
            magma_source += f"{output}_output = []\n"
            # magma_source += f"{output} = DefineSilicaMux({num_states}, {width})()\n"
            # magma_source += f"wire(__silica_path_state.O, {output}.S)\n"
            # magma_source += f"wire({output}.O, {tree.name}.{orig})\n"
    raddrs = {}
    waddrs = {}
    wdatas = {}
    wens = {}
    for i, state in enumerate(states):
        load_symbol_map = {}
        store_symbol_map = {}
        arrays = set()
        memories = set()
        for register in registers:
            if isinstance(width_table[register], tuple):
                arrays.add(register)
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
            elif isinstance(width_table[register], MemoryType):
                memories.add(register)
            else:
                load_symbol_map[register] = ast.parse(f"{register}.O").body[0].value
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
                if width_table[register] is None:
                    magma_source += f"{register}_next_{i}_tmp = {register}.O\n"
                else:
                    magma_source += f"{register}_next_{i}_tmp = [{register}.O[__silica_i] for __silica_i in range({width_table[register]})]\n"
        for output in outputs:
            if output not in registers:
                store_symbol_map[output] = ast.parse(f"{output}_{i}_tmp").body[0].value
        stores = set()
        for statement in state.statements:
            stores |= CollectStoredArrays().run(statement)
            stores |= collect_names(statement, ast.Store)
            for array in arrays:
                statement, stored, raddr, waddr, wdata = replace_arrays(statement, array, i)
                if stored:
                    stores.add(array)
            for memory in memories:
                statement, raddr, waddr, wdata = replace_memory(statement, memory, i)
                if raddr:
                    assert memory not in raddrs or raddrs[memory] == raddr
                    raddrs[memory] = raddr
                if waddr:
                    assert memory not in waddrs or waddrs[memory] == waddr, (waddr, memory, waddrs[memory])
                    waddrs[memory] = waddr
                    if memory not in wens:
                        wens[memory] = set()
                    wens[memory].add(i)
                if wdata:
                    assert memory not in wdatas or wdatas[memory] == wdata
                    wdatas[memory] = wdata
            statement = replace_assign_to_bits(statement, load_symbol_map, store_symbol_map)
            statement = replace_symbols(statement, load_symbol_map, ast.Load)
            statement = replace_symbols(statement, store_symbol_map, ast.Store)
            magma_source += astor.to_source(statement)
            for var in stores:
                if var in width_table and isinstance(width_table[var], MemoryType):
                    continue
                if var in registers:
                    load_symbol_map[var] = ast.parse(f"{var}_next_{i}_tmp").body[0].value
                elif var in outputs:
                    load_symbol_map[var] = ast.parse(f"{var}_{i}_tmp").body[0].value
        for register in registers:
            if isinstance(width_table[register], MemoryType):
                continue
            if num_states > 1:
                magma_source += f"""{register}_next.append(({register}_next_{i}_tmp, {i}))\n"""
            else:
                magma_source += f"""wire({register}_next_{i}_tmp, {register}.I)\n"""
#             if isinstance(width_table[register], tuple):
#                 if register in stores:
#                     magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     wire({register}_next_{i}_tmp[__silica_i], {register}_next[__silica_i].I{i})
# """
#                 else:
#                     magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     wire({register}[__silica_i].O, {register}_next[__silica_i].I{i})
# """
#             else:
#                 if width_table[register] is None:
#                     if num_states > 1:
#                         magma_source += f"wire({register}_next_{i}_tmp, {register}_next.I{i})\n"
#                     else:
#                         magma_source += f"wire({register}_next_{i}_tmp, {register}.I)\n"
#                 else:
#                     if num_states > 1:
#                         magma_source += f"""\
# wire(bits({register}_next_{i}_tmp), {register}_next.I{i})
# """
#                     else:
#                         magma_source += f"""\
# wire(bits({register}_next_{i}_tmp), {register}.I)
# """

        for output in outputs:
            if output not in registers:
                if num_states > 1:
                    # magma_source += f"wire({output}_{i}_tmp, {output}.I{i})\n"
                    magma_source += f"{output}_output.append(({output}_{i}_tmp, {i}))\n"
                else:
                    magma_source += f"wire({output}_{i}_tmp, {tree.name}.{output})\n"
            elif output in stores:
                # magma_source += f"wire({output}_next_{i}_tmp, {output}_output.I{i})\n"
                magma_source += f"{output}_output.append(({output}_next_{i}_tmp, {i}))\n"
            # else:
            #     # magma_source += f"wire({output}.O, {output}_output.I{i})\n"
            #     magma_source += f"{output}_output.append(({output}.O, {i}))\n"

        # curr = ast.parse(f"__silica_yield_state_next_{i}.O[{state.start_yield_id}]").body[0].value
        conds = []
        if num_yields > 0:
            for start_yield_id in state.start_yield_ids:
                if not initial_basic_block and num_yields > 0:
                    start_yield_id -= 1
                conds.append(ast.parse(f"__silica_yield_state.O[{start_yield_id}]").body[0].value)
        if len(conds) > 1:
            conds = [ast.Call(ast.Name("or_", ast.Load()), conds, [])]
        if state.conds:
            for cond in state.conds:
                cond = replace_symbols(cond, load_symbol_map, ast.Load)
                conds.append(cond)
        if not conds:
            cond = ast.parse("True")
        elif len(conds) > 1:
            cond = ast.Call(ast.Name("and_", ast.Load()), conds, [])
        else:
            cond = conds[0]
        if num_states > 1 :
            magma_source += f"wire(__silica_path_state.I[{i}], {astor.to_source(cond).rstrip()})\n"
    for array, raddr in raddrs.items():
        magma_source += f"wire({array}.raddr, {raddr}.O)\n"
    for array, waddr in waddrs.items():
        magma_source += f"wire({array}.waddr, {waddr}.O)\n"
    for array, wdata in wdatas.items():
        magma_source += f"wire({array}.wdata, {wdata})\n"
    for array, wens in wens.items():
        wens = ", ".join(f"__silica_path_state.O[{i}]" for i in wens)
        magma_source += f"wire({array}.wen, or_({wens}))\n"
    if num_states > 1:
        for register in registers:
            width = width_table[register]
            if not isinstance(width, MemoryType):
                magma_source += f"generate_fsm_mux({register}_next, {width}, {register}, __silica_path_state)\n"
        for output in outputs:
            width = width_table[output]
            magma_source += f"generate_fsm_mux({output}_output, {width}, {tree.name}.{output}, __silica_path_state, output=True)\n"

#     for register in registers:
#         if isinstance(width_table[register], tuple):
#             magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     if len({register}_CE[__silica_i]) == 1:
#         wire({register}_CE[__silica_i][0], {register}[__silica_i].CE)
#     else:
#         wire(and_(*{register}_CE[__silica_i]), {register}[__silica_i].CE)
# """
#         else:
#             magma_source += f"""\
# if len({register}_CE) == 1:
#     wire({register}_CE[0], {register}.CE)
# else:
#     wire(and_(*{register}_CE), {register}.CE)
# """
    magma_source += "EndDefine()"

    return magma_source

def compile_magma(coroutine, file_name, mux_strategy, output):
    stack = inspect.stack()
    func_locals = stack[2].frame.f_locals
    func_globals = stack[2].frame.f_globals
    magma_source = magma_compile(coroutine, func_globals, func_locals)
    magma_source = f"""\
from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator


@cache_definition
def DefineSilicaMux(height, width):
    if "{mux_strategy}" == "one-hot":
        if width is None:
            T = Bit
        else:
            T = Bits(width)
        inputs = []
        for i in range(height):
            inputs += [f"I{{i}}", In(T)]
        class OneHotMux(Circuit):
            name = "SilicaOneHotMux{{}}{{}}".format(height, width)
            IO = inputs + ["S", In(Bits(height)), "O", Out(T)]
            @classmethod
            def definition(io):
                or_ = Or(height, width)
                wire(io.O, or_.O)
                for i in range(height):
                    and_ = And(2, width)
                    wire(and_.I0, getattr(io, f"I{{i}}"))
                    if width is not None:
                        for j in range(width):
                            wire(and_.I1[j], io.S[i])
                    else:
                        wire(and_.I1, io.S[i])
                    wire(getattr(or_, f"I{{i}}"), and_.O)
        return OneHotMux
    else:
        raise NotImplementedError()

""" + magma_source
    if int(os.environ.get("SILICA_DEBUG_LEVEL", "0")) > 0:
        print("\n".join(f"{i + 1}: {line}" for i, line in enumerate(magma_source.splitlines())))
    if file_name is None:
        exec(magma_source, func_globals, func_locals)
        return eval(coroutine._name, func_globals, func_locals)
    else:
        if silica.config.compile_dir == 'callee_file_dir':
            (_, callee_file_name, _, _, _, _) = inspect.getouterframes(inspect.currentframe())[1]
            file_path = os.path.dirname(callee_file_name)
            file_name = os.path.join(file_path, file_name)

        with open(file_name, "w") as output_file:
            output_file.write(magma_source)
        base = os.path.basename(file_name)
        import importlib.util
        spec = importlib.util.spec_from_file_location(os.path.splitext(base)[0], file_name)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return getattr(module, coroutine._name)


def compile(coroutine, file_name=None, mux_strategy="one-hot", output='verilog'):
    if not isinstance(coroutine, Coroutine):
        raise ValueError("silica.compile expects a silica.Coroutine")

    stack = inspect.stack()
    func_locals = stack[1].frame.f_locals
    func_globals = stack[1].frame.f_globals

    has_ce = coroutine.has_ce
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    module_name = coroutine._name
    func_locals.update(coroutine._defn_locals)
    specialize_arguments(tree, coroutine)
    specialize_constants(tree, coroutine._defn_locals)
    specialize_evals(tree, func_globals, func_locals)
    inline_yield_from_functions(tree, func_globals, func_locals)
    print(astor.to_source(tree))
    constant_fold(tree)
    specialize_list_comps(tree, func_globals, func_locals)
    desugar_for_loops(tree)
    width_table = {}
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            width_table[input_] = get_input_width(type_)

    constant_fold(tree)
    type_table = {}
    CollectInitialWidthsAndTypes(width_table, type_table).visit(tree)
    PromoteWidths(width_table, type_table).visit(tree)
    # Desugar(width_table).visit(tree)
    type_table = {}
    TypeChecker(width_table, type_table).check(tree)
    # DesugarArrays().run(tree)
    cfg = ControlFlowGraph(tree)
    liveness_analysis(cfg)

    if output == 'magma':
        # NOTE: This is currently not maintained
        return compile_magma(coroutine, file_name, mux_strategy, output)

    registers = set()
    outputs = tuple()
    for path in cfg.paths:
        registers |= path[0].live_ins  # Union
        outputs += (collect_names(path[-1].value, ctx=ast.Load), )
    assert all(outputs[1] == output for output in outputs[1:]), "Yield statements must all have the same outputs except for the first"
    outputs = outputs[1]
    io_strings = []
    for output in outputs:
        width = width_table[output]
        if width is None:
            io_strings.append(f"output {output}")
        else:
            io_strings.append(f"output [{width_table[output] - 1}:0] {output}")

    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            if isinstance(type_, m.BitKind):
                io_strings.append(f"input {input_}")
            elif isinstance(type_, m.ArrayKind) and isinstance(type_.T, m.BitKind):
                io_strings.append(f"input [{len(type_)-1}:0] {input_}")
            else:
                raise NotImplementedError(type_)
    io_string = ", ".join(io_strings)
    states = cfg.states
    num_yields = cfg.curr_yield_id
    num_states = len(states)
    initial_values = {}
    initial_basic_block = False
    sub_coroutines = []
    # cfg.render()
    verilog_source = ""
    for node in cfg.paths[0][:-1]:
        if isinstance(node, HeadBlock):
            for statement in node:
                if isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Name) and statement.value.func.id == "coroutine_create":
                    sub_coroutine = eval(astor.to_source(statement.value.args[0]), func_globals, func_locals)
                    raise NotImplementedError()
                    verilog_source += verilog_compile(sub_coroutine(), func_globals, func_locals)
                    statement.value.func = ast.Name(sub_coroutine._name, ast.Load())
                    statement.value.args = []
                    sub_coroutines.append((statement, sub_coroutine))
                else:
                    if isinstance(statement.value, ast.Name) and statement.value.id in initial_values:
                        initial_values[statement.targets[0].id] = initial_values[statement.value.id]
                    else:
                        initial_values[statement.targets[0].id] = get_constant(statement.value)
        initial_basic_block |= isinstance(node, BasicBlock)
    if not initial_basic_block:
        num_states -= 1
        num_yields -= 1
        states = states[1:]
    # CE = f"VCC"
    # if has_ce:
        # CE = f"{tree.name}.CE"
    if False:
        new_states = []
        for state in states:
            for new_state in new_states:
                if "\n".join(astor.to_source(statement) for statement in state.statements) == \
                   "\n".join(astor.to_source(statement) for statement in new_state.statements):
                       new_state.start_yield_ids.append(state.start_yield_id)
                       break
            else:
                new_states.append(state)
        states = new_states
    num_states = len(states)
    for i, state in enumerate(states):
        new_statements = []
        for statement in state.statements:
            if isinstance(statement, ast.Assign) and isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Attribute) and statement.value.func.attr == "send":
                if len(statement.targets) == 1:
                    target = statement.targets[0].id
                    sub_coroutine = statement.value.func.value
                    for j, arg in enumerate(statement.value.args[0].elts):
                        new_statements.append(ast.parse(f"wire({astor.to_source(sub_coroutine).rstrip()}_inputs_{j}.I{i}, {astor.to_source(arg).rstrip()})"))
                    statement.value = ast.Attribute(sub_coroutine, target, ast.Load)
                else:
                    raise NotImplementedError()
            new_statements.append(statement)
        state.statements = new_statements
    if has_ce:
        raise NotImplementedError("add ce to module decl")
    verilog_source += f"""
module {module_name} ({io_string}, input CLK);
"""


    init_strings = []
    for register in registers:
        width = width_table[register]
        if isinstance(width, MemoryType):
            width_str = get_width_str(width.width)
            verilog_source += f"    reg {width_str} {register} [0:{width.height - 1}];\n"
        else:
            width_str = get_width_str(width)
            verilog_source += f"    reg {width_str} {register};\n"
    for key, value in initial_values.items():
        if value is not None:
            init_strings.append(f"{key} = {value};")


    if cfg.curr_yield_id > 1:
        verilog_source += f"    reg [{(cfg.curr_yield_id - 1).bit_length() - 1}:0] yield_state;\n"
        init_strings.append(f"yield_state = 0;")

    init_string = '\n        '.join(init_strings)
    verilog_source += f"""
    initial begin
        {init_string}
    end
"""


    raddrs = {}
    waddrs = {}
    wdatas = {}
    wens = {}
    always_source = """\
    always @(posedge CLK) begin\
"""
    tab = "    "
    temp_var_source = ""
    for i, state in enumerate(states):
        always_inside, temp_vars = verilog_compile_state(state, i, tab * 3, cfg.curr_yield_id == 1, width_table)
        always_source += always_inside
        temp_var_source += temp_vars
    verilog_source += temp_var_source + always_source
    verilog_source += "\n    end\nendmodule"
    with open(file_name, "w") as f:
        f.write(verilog_source)
    return m.DefineFromVerilog(verilog_source, type_map={"CLK": m.In(m.Clock)})[-1]
