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
from silica.transformations.specialize_arguments import specialize_arguments
from silica.type_check import TypeChecker
from silica.analysis import CollectInitialWidthsAndTypes
from silica.transformations.promote_widths import PromoteWidths


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
