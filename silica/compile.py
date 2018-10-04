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
import silica.ast_utils as ast_utils
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

import veriloggen as vg

def specialize_list_comps(tree, globals, locals):
    locals.update(silica.operators)
    class ListCompSpecializer(ast.NodeTransformer):
        def visit_ListComp(self, node):
            result = eval(astor.to_source(node), globals, locals)
            result = ", ".join(repr(x) for x in result)
            return ast.parse(f"[{result}]").body[0].value

        def visit_Call(self, node):
            if ast_utils.is_name(node.func) and node.func.id == "list":
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
    tree = ast_utils.get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    module_name = coroutine._name
    func_locals.update(coroutine._defn_locals)
    specialize_arguments(tree, coroutine)
    specialize_constants(tree, coroutine._defn_locals)
    specialize_evals(tree, func_globals, func_locals)
    inline_yield_from_functions(tree, func_globals, func_locals)
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
    for var in cfg.replacer.id_counter:
        width = width_table[var]
        for i in range(cfg.replacer.id_counter[var] + 1):
            width_table[f"{var}_{i}"] = width
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
                if ast_utils.is_call(statement.value) and ast_utils.is_name(statement.value.func) and statement.value.func.id == "coroutine_create":
                    sub_coroutine = eval(astor.to_source(statement.value.args[0]), func_globals, func_locals)
                    raise NotImplementedError()
                    verilog_source += verilog_compile(sub_coroutine(), func_globals, func_locals)
                    statement.value.func = ast.Name(sub_coroutine._name, ast.Load())
                    statement.value.args = []
                    sub_coroutines.append((statement, sub_coroutine))
                else:
                    if ast_utils.is_name(statement.value) and statement.value.id in initial_values:
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

    # declare module and ports
    module = vg.Module(module_name)
    for o in outputs:
        module.Output(o, width_table.get(o, 1))
    if coroutine._inputs:
        for i,t in coroutine._inputs.items():
            if isinstance(t, m.BitKind):
                module.Input(i)
            else:
                module.Input(i, t.N)
    module.Input("CLK")
    verilog_source += f"""
module {module_name} ({io_string}, input CLK);
"""

    # declare wires
    for var in cfg.replacer.id_counter:
        width = width_table[var]
        for i in range(cfg.replacer.id_counter[var] + 1):
            if f"{var}_{i}" not in registers:
                width_str = get_width_str(width)
                module.Wire(f"{var}_{i}", width)
                verilog_source += f"    wire {width_str} {var}_{i};\n"

    for (name, index), value in cfg.replacer.array_stores.items():
        width = width_table[name]
        if isinstance(width, MemoryType):
            width = width.width
        else:
            width = None
        if len(index) > 1: raise NotImplementedError()
        index_hash = "_".join(ast.dump(i) for i in index)
        count = cfg.replacer.index_map[index_hash]
        for i in range(count + 1):
            var = name + f"_{value}_i{count}"
            width_table[var] = width

    # declare regs
    for register in registers:
        width = width_table[register]
        if isinstance(width, MemoryType):
            module.Reg(register, width.width, width.height)
            width_str = get_width_str(width.width)
            verilog_source += f"    reg {width_str} {register} [0:{width.height - 1}];\n"
        else:
            module.Reg(register, width)
            width_str = get_width_str(width)
            verilog_source += f"    reg {width_str} {register};\n"

    init_strings = []
    init = module.Initial()
    for key, value in initial_values.items():
        if value is not None:
            init.add(
                verilog.get_by_name(module, key)(value)
            )
            init_strings.append(f"{key} = {value};")

    if cfg.curr_yield_id > 1:
        module.Reg("yield_state", (cfg.curr_yield_id - 1).bit_length(), initval=0)
        verilog_source += f"    reg [{(cfg.curr_yield_id - 1).bit_length() - 1}:0] yield_state;\n"
        init_strings.append(f"yield_state = 0;")

    # TODO: need to do this
    if initial_basic_block:
        for statement in states[0].statements:
            verilog.process_statement(statement)
            # temp_var_promoter.visit(statement)
            init_strings.append(astor.to_source(statement).rstrip() + ";")

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
    if initial_basic_block:
        states = states[1:]
    always_source, temp_var_source = verilog.compile_states(module, states, cfg.curr_yield_id == 1, width_table, strategy)
    verilog_source += temp_var_source + always_source
    verilog_source += "\n    end\nendmodule"
    verilog_source = verilog_source.replace("True", "1")
    verilog_source = verilog_source.replace("False", "0")
    # cfg.render()

    print(module.to_verilog())
    print(verilog_source)

    # with open(file_name, "w") as f:
    #     f.write(verilog_source)
    # return m.DefineFromVerilog(verilog_source, type_map={"CLK": m.In(m.Clock)})[-1]

    with open(file_name, "w") as f:
        f.write(module.to_verilog())
    return m.DefineFromVerilog(module.to_verilog(), type_map={"CLK": m.In(m.Clock)})[-1]
