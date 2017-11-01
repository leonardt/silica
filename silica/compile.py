import ast
import astor
import inspect
import magma

from silica.coroutine import Coroutine
from silica.cfg import ControlFlowGraph 
from silica.cfg.control_flow_graph import render_paths_between_yields, build_state_info, render_fsm
from silica.ast_utils import get_ast
from silica.liveness import liveness_analysis
from silica.transformations import specialize_constants, replace_symbols
from silica.visitors import collect_names


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
    def __init__(self, width_table):
        self.width_table = width_table

    def check(self, tree):
        self.visit(tree)
        return self.width_table

    def get_width(self, node):
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
           node.func.id == "bits":
            assert isinstance(node.args[1], ast.Num), "We should know all widths at compile time"
            return node.args[1].n
        elif isinstance(node, ast.Name):
            if node.id not in self.width_table:
                raise Exception(f"Trying to get width of variable that hasn't been previously added to the width_table: {node.id} (width_table={self.width_table})")
            return self.width_table[node.id]
        elif isinstance(node, ast.Call):
            if isinstance(node.func, ast.Name):
                widths = [self.get_width(arg) for arg in node.args]
                if node.func.id == "add":
                    if not all(widths[0] == x for x in widths):
                        raise TypeError("Calling add with different length types")
                    width = widths[0]
                    for keyword in node.keywords:
                        if keyword.arg == "cout" and isinstance(keyword.value, ast.NameConstant) and keyword.value.value == True:
                            width = (width, None)
                    return width
                else:
                    raise NotImplementedError(ast.dump(node))
            else:
                raise NotImplementedError(ast.dump(node))
        elif isinstance(node, ast.BinOp):
            left_width = self.get_width(node.left)
            right_width = self.get_width(node.right)
            if left_width != right_width:
                raise TypeError(f"Binary operation with mismatched widths {ast.dump(node)}")
            return left_width
        elif isinstance(node, ast.NameConstant) and node.value in [True, False]:
            return None
        raise NotImplementedError(ast.dump(node))

    def visit_Assign(self, node):
        if len(node.targets) == 1:
            if isinstance(node.targets[0], ast.Name):
                if node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = self.get_width(node.value)
                elif isinstance(node.value, ast.Yield):
                    pass  # width specified at compile time
                elif self.width_table[node.targets[0].id] != self.get_width(node.value):
                    raise TypeError(f"Trying to assign {ast.dump(node.value)} with width {self.get_width(node.value)} to {node.targets[0].id} with width {self.width_table[node.targets[0].id]}")
            elif isinstance(node.targets[0], ast.Tuple):
                if not all(isinstance(target, ast.Name) for target in node.targets[0].elts):
                    raise SyntaxError(f"Can only assign to variables {ast.dump(node)}")
                widths = self.get_width(node.value)
                if not isinstance(widths, tuple) or len(widths) != len(node.targets[0].elts):
                    raise TypeError(f"Trying to unpack {len(node.targets.elts)} but got {len(widths)} - {ast.dump(node)} ")
                for target, width in zip(node.targets[0].elts, widths):
                    self.width_table[target.id] = width
            else:
                raise NotImplementedError(ast.dump(node))
        else:
            raise NotImplementedError(ast.dump(node))

def compile(coroutine):
    if not isinstance(coroutine, Coroutine):
        raise ValueError("silica.compile expects a silica.Coroutine")
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    specialize_arguments(tree, coroutine)
    width_table = {}
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            if type_ is magma.Bit:
                width_table[input_] = None
            else:
                raise NotImplementedError(type_)
    TypeChecker(width_table).check(tree)
    cfg = ControlFlowGraph(tree)
    liveness_analysis(cfg.paths)
    # render_paths_between_yields(cfg.paths)
    # render_fsm(cfg.states)
    registers = set()
    outputs = tuple()
    for path in cfg.paths:
        registers |= path[0].live_ins  # Union
        outputs += (collect_names(path[-1].value, ctx=ast.Load), )
    assert all(outputs[0] == output for output in outputs), "Yield statements must all have the same outputs"
    outputs = outputs[0]
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
    yield_width = (num_yields - 1).bit_length()
    magma_source = f"""\
from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *

{tree.name} = DefineCircuit("{tree.name}", {io_string}, "CLK", In(Clock), "CE", In(Enable))
__silica_yield_state = Register({num_yields}, init=1) # , ce=True)
wireclock({tree.name}, __silica_yield_state)
__silica_yield_state_next = Or({len(cfg.paths)}, {num_yields})
wire(__silica_yield_state_next.O, __silica_yield_state.I)
"""
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            magma_source += f"{input_} = {tree.name}.{input_}\n"
    for i, state in enumerate(states):
        magma_source += f"__silica_yield_state_next_{i} = And(2, {num_yields})\n"
        magma_source += f"wire(__silica_yield_state_next_{i}.O, __silica_yield_state_next.I{i})\n"
        for j in range(num_yields):
            magma_source += f"wire(__silica_yield_state_next_{i}.I0[{j}], __silica_yield_state.O[{state.start_yield_id}])\n"

    for register in registers:
        width = width_table[register]
        if width is None:
            magma_source += f"{register} = DFF() # , ce=True)\n"
        else:
            magma_source += f"{register} = Register({width_table[register]}) # , ce=True)\n"
        magma_source += f"wireclock({tree.name}, {register})\n"
        magma_source += f"{register}_next = Or({len(cfg.paths)}, {width_table[register]})\n"
        magma_source += f"wire({register}_next.O, {register}.I)\n"
        for i, state in enumerate(states):
            magma_source += f"{register}_next_{i} = And(2, {width_table[register]})\n"
            magma_source += f"wire({register}_next_{i}.O, {register}_next.I{i})\n"
            if width is None:
                magma_source += f"wire({register}_next_{i}.I0, __silica_yield_state.O[{state.start_yield_id}])\n"
            else:
                for j in range(width_table[register]):
                    magma_source += f"wire({register}_next_{i}.I0[{j}], __silica_yield_state.O[{state.start_yield_id}])\n"
    for output in outputs:
        width = width_table[output]
        magma_source += f"{output} = Or({len(cfg.paths)}, {width})\n"
        magma_source += f"wire({output}.O, {tree.name}.{output})\n"
        for i, state in enumerate(states):
            magma_source += f"{output}_{i} = And(2, {width})\n"
            magma_source += f"wire({output}_{i}.O, {output}.I{i})\n"
            if width is None:
                magma_source += f"wire({output}_{i}.I0, __silica_yield_state.O[{state.start_yield_id}])\n"
            else:
                for j in range(width):
                    magma_source += f"wire({output}_{i}.I0[{j}], __silica_yield_state.O[{state.start_yield_id}])\n"
    for i, state in enumerate(cfg.states):
        load_symbol_map = {}
        store_symbol_map = {}
        for register in registers:
            load_symbol_map[register] = ast.parse(f"{register}.O").body[0].value
            store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
        for output in outputs:
            store_symbol_map[output] = ast.parse(f"{output}_{i}_tmp").body[0].value
        for statement in state.statements:
            statement = replace_symbols(statement, load_symbol_map, ast.Load)
            statement = replace_symbols(statement, store_symbol_map, ast.Store)
            magma_source += astor.to_source(statement)
        magma_source += f"wire(__silica_yield_state_next_{i}.I1, bits({1 << state.end_yield_id}, {num_yields}))\n"
        for register in registers:
            magma_source += f"wire({register}_next_{i}_tmp, {register}_next_{i}.I1)\n"
        for output in outputs:
            magma_source += f"wire({output}_{i}_tmp, {output}_{i}.I1)\n"
    magma_source += "EndDefine()"

    print("\n".join(f"{i + 1}: {line}" for i, line in enumerate(magma_source.splitlines())))
    stack = inspect.stack()
    func_locals = stack[1].frame.f_locals
    func_globals = stack[1].frame.f_globals
    exec(magma_source, func_globals, func_locals)
    return eval(tree.name, func_globals, func_locals)
