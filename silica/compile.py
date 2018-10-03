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
from silica.ast_utils import *
from silica.liveness import liveness_analysis
from silica.transformations import specialize_constants, replace_symbols, \
    constant_fold, desugar_for_loops, specialize_evals, inline_yield_from_functions
from silica.visitors import collect_names
import silica.verilog as verilog
from .verilog import get_width_str
from .width import get_width
from .memory import MemoryType
from silica.transformations.specialize_arguments import specialize_arguments
from silica.type_check import TypeChecker
from silica.analysis import CollectInitialWidthsAndTypes
from silica.transformations.promote_widths import PromoteWidths
from silica.transformations.desugar_for_loops import propagate_types, aaaaaaaaaaaaaaaaaaaaaaaaaaaaa

import veriloggen as vg

def specialize_list_comps(tree, globals, locals):
    locals.update(silica.operators)
    class ListCompSpecializer(ast.NodeTransformer):
        def visit_ListComp(self, node):
            result = eval(astor.to_source(node), globals, locals)
            result = ", ".join(repr(x) for x in result)
            return ast.parse(f"[{result}]").body[0].value

        def visit_Call(self, node):
            if is_name(node.func) and node.func.id == "list":
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


def make_io_string(inputs, outputs, width_table):
    io_strings = []
    for output in outputs:
        width = width_table[output]
        if width is None:
            io_strings.append(f"output {output}")
        else:
            io_strings.append(f"output [{width_table[output] - 1}:0] {output}")

    if inputs:
        for input_, type_ in inputs.items():
            if isinstance(type_, m.BitKind):
                io_strings.append(f"input {input_}")
            elif isinstance(type_, m.ArrayKind) and isinstance(type_.T, m.BitKind):
                io_strings.append(f"input [{len(type_)-1}:0] {input_}")
            else:
                raise NotImplementedError(type_)
    return ", ".join(io_strings)


def compile(coroutine, file_name=None, mux_strategy="one-hot", output='verilog', strategy="by_statement"):
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
    constant_fold(tree)
    specialize_list_comps(tree, func_globals, func_locals)
    tree, list_lens = propagate_types(tree)
    tree, loopvars = desugar_for_loops(tree, list_lens)

    print_ast(tree)

    width_table = {}
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            width_table[input_] = get_input_width(type_)

    for name,width in loopvars:
        width_table[name] = width

    constant_fold(tree)
    type_table = {}

    for name,_ in loopvars:
        type_table[name] = 'uint'

    CollectInitialWidthsAndTypes(width_table, type_table).visit(tree)
    PromoteWidths(width_table, type_table).visit(tree)
    # TODO: >>> NEW PASS SHOULD GO HERE <<<
    tree, loopvars = aaaaaaaaaaaaaaaaaaaaaaaaaaaaa(tree, width_table, func_locals, func_globals)

    for name,width in loopvars.items():
        width_table[name] = width

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
    io_string = make_io_string(coroutine._inputs, outputs, width_table)
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
                if is_call(statement.value) and is_name(statement.value.func) and statement.value.func.id == "coroutine_create":
                    sub_coroutine = eval(astor.to_source(statement.value.args[0]), func_globals, func_locals)
                    raise NotImplementedError()
                    verilog_source += verilog_compile(sub_coroutine(), func_globals, func_locals)
                    statement.value.func = ast.Name(sub_coroutine._name, ast.Load())
                    statement.value.args = []
                    sub_coroutines.append((statement, sub_coroutine))
                else:
                    if is_name(statement.value) and statement.value.id in initial_values:
                        initial_values[statement.targets[0].id] = initial_values[statement.value.id]
                    else:
                        initial_values[statement.targets[0].id] = get_constant(statement.value)
        initial_basic_block |= isinstance(node, BasicBlock)
    if not initial_basic_block:
        num_states -= 1
        num_yields -= 1
        states = states[1:]
        # for state in states:
        #     state.start_yield_id -= 1
        #     state.end_yield_id -= 1
    num_states = len(states)
    if has_ce:
        raise NotImplementedError("add ce to module decl")

    print(cfg)
    print(initial_values)
    print(initial_basic_block)
    print(num_states)
    print(num_yields)
    print(states)
    print(registers)
    print(width_table)
    print(strategy)

    verilog_source += f"""
module {module_name} ({io_string}, input CLK);
"""
    # def make_io_string(inputs, outputs, width_table):
    # io_strings = []

    # if inputs:
    #     for input_, type_ in inputs.items():
    #         if isinstance(type_, m.BitKind):
    #             io_strings.append(f"input {input_}")
    #         elif isinstance(type_, m.ArrayKind) and isinstance(type_.T, m.BitKind):
    #             io_strings.append(f"input [{len(type_)-1}:0] {input_}")
    #         else:
    #             raise NotImplementedError(type_)
    # return ", ".join(io_strings)

    m = vg.Module(module_name)
    for i,t in coroutine._inputs.items():
        a = m.Input(i, 5, 4)
        print(inspect.getmembers(a))
        print(i,t)
    for o in outputs:
        m.Output(o, width_table.get(o, 1))
        print(o)
    print(io_string)
    print(m.to_verilog())

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
    # render_paths_between_yields(cfg.paths)
    always_source, temp_var_source = verilog.compile_states(states, cfg.curr_yield_id == 1, width_table, strategy)
    verilog_source += temp_var_source + always_source
    verilog_source += "\n    end\nendmodule"
    verilog_source = verilog_source.replace("True", "1")
    verilog_source = verilog_source.replace("False", "0")
    # cfg.render()
    with open(file_name, "w") as f:
        f.write(verilog_source)
    return m.DefineFromVerilog(verilog_source, type_map={"CLK": m.In(m.Clock)})[-1]
