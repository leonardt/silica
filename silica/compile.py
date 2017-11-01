import ast
import astor

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
            arg_map[arg.arg] = value.n  # FIXME: Assumes arg is a number

    return specialize_constants(tree, arg_map)


class TypeChecker(ast.NodeVisitor):
    def __init__(self):
        self.width_table = {}

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
                        if keyword.arg == "with_cout" and isinstance(keyword.value, ast.NameConstant) and keyword.value.value == True:
                            width = (width, 1)
                    return width
            else:
                raise NotImplementedError(ast.dump(node))
        raise NotImplementedError(ast.dump(node))

    def visit_Assign(self, node):
        if len(node.targets) == 1:
            if isinstance(node.targets[0], ast.Name):
                if node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = self.get_width(node.value)
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
    width_table = TypeChecker().check(tree)
    cfg = ControlFlowGraph(tree)
    liveness_analysis(cfg.paths)
    # render_paths_between_yields(cfg.paths)
    # render_fsm(cfg.states)
    registers = set()
    outputs = tuple()
    for path in cfg.paths:
        registers |= path[0].live_ins  # Union
        outputs += (collect_names(path[-1].value), )
    assert all(outputs[0] == output for output in outputs), "Yield statements must all have the same outputs"
    output_string = ", ".join(f"\"{output}\", Out(Bits({width_table[output]}))" for output in outputs[0])
    states = cfg.states
    num_yields = cfg.curr_yield_id
    yield_width = (num_yields - 1).bit_length()
    magma_source = f"""\
from magma import *
import os
os.environ["MANTLE"] = "lattice"
from mantle import *

{tree.name} = DefineCircuit("{tree.name}", {output_string}, "CLK", In(Clock), "CE", In(Enable))
__silica_yield_state = Register({num_yields}, ce=True)
wireclock({tree.name}, __silica_yield_state)
"""

    for register in registers:
        magma_source += f"{register} = Register({width_table[register]}, ce=True)\n"
        magma_source += f"wireclock({tree.name}, {register})\n"
        magma_source += f"{register}_next = Or({len(cfg.paths)}, {width_table[register]})\n"
        for i, state in enumerate(states):
            magma_source += f"{register}_next_{i} = And(2, {width_table[register]})\n"
            magma_source += f"wire({register}_next_{i}.O, {register}_next.I[{i}])\n"
            for j in range(width_table[register]):
                magma_source += f"wire({register}_next_{i}.I0[{j}], __silica_state_{state.start_yield_id})\n"
    for i, path in enumerate(cfg.paths):
        load_symbol_map = {}
        store_symbol_map = {}
        for register in registers:
            load_symbol_map[register] = ast.parse(f"{register}.O").body[0].value
            store_symbol_map[register] = ast.parse(f"{register}_next_{i}.I[1]").body[0].value
        for block in path[1:-1]:
            for statement in block.statements:
                statement = replace_symbols(statement, load_symbol_map, ast.Load)
                statement = replace_symbols(statement, store_symbol_map, ast.Store)
                magma_source += astor.to_source(statement)

    print(magma_source)
    # cfg.render()
    raise NotImplementedError()
