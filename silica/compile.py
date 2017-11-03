import ast
import astor
import inspect
import magma

import silica
from silica.coroutine import Coroutine
from silica.cfg import ControlFlowGraph 
from silica.cfg.control_flow_graph import render_paths_between_yields, build_state_info, render_fsm
from silica.ast_utils import get_ast
from silica.liveness import liveness_analysis
from silica.transformations import specialize_constants, replace_symbols, constant_fold, desugar_for_loops
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


def get_width(node, width_table):
    if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"bits", "uint", "BitVector"}:
        assert isinstance(node.args[1], ast.Num), "We should know all widths at compile time"
        return node.args[1].n
    elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"zext"}:
        assert isinstance(node.args[1], ast.Num), "We should know all widths at compile time"
        return get_width(node.args[0], width_table) + node.args[1].n
    elif isinstance(node, ast.Name):
        if node.id not in width_table:
            raise Exception(f"Trying to get width of variable that hasn't been previously added to the width_table: {node.id} (width_table={width_table})")
        return width_table[node.id]
    elif isinstance(node, ast.Call):
        if isinstance(node.func, ast.Name):
            widths = [get_width(arg, width_table) for arg in node.args]
            if node.func.id in {"add", "xor"}:
                if not all(widths[0] == x for x in widths):
                    raise TypeError(f"Calling {node.func.id} with different length types")
                width = widths[0]
                if node.func.id == "add":
                    for keyword in node.keywords:
                        if keyword.arg == "cout" and isinstance(keyword.value, ast.NameConstant) and keyword.value.value == True:
                            width = (width, None)
                return width
            elif node.func.id == "eq":
                if not all(widths[0] == x for x in widths):
                    raise TypeError("Calling eq with different length types")
                return None
            else:
                raise NotImplementedError(ast.dump(node))
        else:
            raise NotImplementedError(ast.dump(node))
    elif isinstance(node, ast.BinOp):
        left_width = get_width(node.left, width_table)
        right_width = get_width(node.right, width_table)
        if left_width != right_width:
            raise TypeError(f"Binary operation with mismatched widths {ast.dump(node)}")
        return left_width
    elif isinstance(node, ast.Compare):
        # TODO: Check widths of operands
        return None
    elif isinstance(node, ast.NameConstant) and node.value in [True, False]:
        return None
    elif isinstance(node, ast.List):
        widths = [get_width(arg, width_table) for arg in node.elts]
        assert all(widths[0] == width for width in widths) 
        return (len(node.elts), widths[0])
    elif isinstance(node, ast.Subscript):
        if isinstance(node.slice, ast.Index):
            width = get_width(node.value, width_table)
            if isinstance(width, tuple):
                return width[1]
            return width
    raise NotImplementedError(ast.dump(node))


class TypeChecker(ast.NodeVisitor):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def check(self, tree):
        self.visit(tree)
        return self.width_table

    def visit_Assign(self, node):
        if len(node.targets) == 1:
            if isinstance(node.targets[0], ast.Name):
                if isinstance(node.value, ast.Yield):
                    pass  # width specified at compile time
                elif node.targets[0].id not in self.width_table:
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
                elif node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = get_width(node.value, self.width_table)
                    if isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and \
                       node.value.func.id in {"bits", "uint"}:
                        self.type_table[node.targets[0].id] = node.value.func.id


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
        raise NotImplementedError(node)

    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        if isinstance(node.value, ast.Num):
            width = get_width(node.targets[0], self.width_table)
            self.check_valid(node.value.n.bit_length(), width)
            node.value = self.make(node.value.n, width, self.get_type(node.targets[0]))
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


class Desugar(ast.NodeTransformer):
    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.op, ast.Add):
            op = "add"
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

    # def visit_BoolOp(self, node):
    #     node.values = [self.visit(value) for value in node.values]
    #     if isinstance(node.op, ast.And):
    #         op = "and_"
    #     else:
    #         raise NotImplementedError(node.op)
    #     args = ", ".join(astor.to_source(value) for value in node.values)
    #     return ast.parse(f"{op}({args})").body[0].value

    def visit_Compare(self, node):
        node.left = self.visit(node.left)
        node.comparators = [self.visit(x) for x in node.comparators]
        if all(isinstance(op, ast.Eq) for op in node.ops):
            args = ", ".join([astor.to_source(node.left).rstrip()] + 
                [astor.to_source(x).rstrip() for x in node.comparators])
            return ast.parse(f"eq({args})").body[0].value
        if len(node.ops) == 1:
            left = astor.to_source(node.left).rstrip()
            right = astor.to_source(node.comparators[0]).rstrip()
            if isinstance(node.ops[0], ast.Lt):
                return ast.parse(f"lt({left}, {right})").body[0].value
            # elif isinstance(node.ops[0], ast.And):
            #     return ast.parse(f"and_({left}, {right})").body[0].value
        return node


def specialize_list_comps(tree, globals, locals):
    class ListCompSpecializer(ast.NodeTransformer):
        def visit_ListComp(self, node):
            result = eval(astor.to_source(node), globals, silica.operators)
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
    def __init__(self, array):
        self.array = array

    def visit_Subscript(self, node):
        if isinstance(node.value, ast.Name) and self.array in node.value.id:
            if isinstance(node.ctx, ast.Load):
                if isinstance(node.slice, ast.Index):
                    if isinstance(node.slice.value, ast.Num) or isinstance(node.slice.value, ast.Call) and node.slice.value.func.id in {"uint"}:
                        if "_tmp" in node.value.id:
                            return ast.parse(f"{astor.to_source(node).rstrip()}").body[0].value
                        else:
                            return ast.parse(f"{astor.to_source(node).rstrip()}.O").body[0].value
                    else:
                        if "_tmp" in node.value.id:
                            return ast.parse(f"mux([x for x in {astor.to_source(node.value).rstrip()}], {astor.to_source(node.slice).rstrip()})").body[0].value
                        else:
                            return ast.parse(f"mux([x.O for x in {astor.to_source(node.value).rstrip()}], {astor.to_source(node.slice).rstrip()})").body[0].value
            else:
                raise NotImplementedError()
        return node


def replace_arrays(tree, array):
    return ArrayReplacer(array).visit(tree)


def compile(coroutine, file_name=None):
    if not isinstance(coroutine, Coroutine):
        raise ValueError("silica.compile expects a silica.Coroutine")
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    stack = inspect.stack()
    func_locals = stack[1].frame.f_locals  # FIXME: Should include the function scope
    func_globals = stack[1].frame.f_globals
    specialize_arguments(tree, coroutine)
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
    Desugar().visit(tree)
    type_table = {}
    TypeChecker(width_table, type_table).check(tree)
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
    num_states = len(states)
    state_width = (num_states - 1).bit_length()
    yield_width = (num_yields - 1).bit_length()
    magma_source = f"""\
from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

{tree.name} = DefineCircuit("{tree.name}", {io_string}, "CLK", In(Clock), "CE", In(Enable))
__silica_yield_state = Register({num_yields}, init=1) # , ce=True)
wireclock({tree.name}, __silica_yield_state)
__silica_yield_state_next = Or({len(cfg.paths)}, {num_yields})
wire(__silica_yield_state_next.O, __silica_yield_state.I)

Buffer = DefineCircuit("__silica_Buffer{tree.name}", "I", In(Bits({num_states})), "O", Out(Bits({num_states})))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
"""
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            magma_source += f"{input_} = {tree.name}.{input_}\n"
    # for i in range(num_states):
    #     magma_source += f"__silica_path_state_next_{i} = And(2, None)\n"
    #     magma_source += f"wire(__silica_path_state_next_{i}.O, __silica_path_state.I[{i}])\n"
        # for j in range(num_yields):
        #     magma_source += f"wire(__silica_path_state_next_{i}.I0[{j}], __silica_path_state.O[{state.start_yield_id}])\n"

    for i in range(num_states):
        magma_source += f"__silica_yield_state_next_{i} = And(2, {num_yields})\n"
        magma_source += f"wire(__silica_yield_state_next_{i}.O, __silica_yield_state_next.I{i})\n"
        for j in range(num_yields):
            magma_source += f"wire(__silica_yield_state_next_{i}.I0[{j}], __silica_path_state.O[{i}])\n"

    for register in registers:
        width = width_table[register]
        if width is None:
            magma_source += f"{register} = DFF() # , ce=True)\n"
            magma_source += f"wireclock({tree.name}, {register})\n"
            magma_source += f"{register}_next = Or({len(cfg.paths)}, {width})\n"
            magma_source += f"wire({register}_next.O, {register}.I)\n"
        elif isinstance(width, tuple):
            if len(width) > 2:
                raise NotImplementedError()
            magma_source += f"{register} = [Register({width[1]}) for _ in range({width[0]})]\n"
            magma_source += f"{register}_next = [Or({len(cfg.paths)}, {width[1]}) for _ in range({width[0]})]\n"
            magma_source += f"""\
for __silica_i in range({width[0]}):
    wire({register}_next[__silica_i].O, {register}[__silica_i].I)
"""
        else:
            magma_source += f"{register} = Register({width})\n"
            magma_source += f"wireclock({tree.name}, {register})\n"
            magma_source += f"{register}_next = Or({len(cfg.paths)}, {width})\n"
            magma_source += f"wire({register}_next.O, {register}.I)\n"
        for i, state in enumerate(states):
            if width is None:
                magma_source += f"{register}_next_{i} = And(2, {width})\n"
                magma_source += f"wire({register}_next_{i}.O, {register}_next.I{i})\n"
                magma_source += f"wire({register}_next_{i}.I0, __silica_path_state.O[{i}])\n"
            elif isinstance(width, tuple):
                if len(width) > 2:
                    raise NotImplementedError()
                magma_source += f"{register}_next_{i} = [And(2, {width[1]}) for _ in range({width[0]})]\n"
                magma_source += f"""\
for __silica_j in range({width[0]}):
    wire({register}_next_{i}[__silica_j].O, {register}_next[__silica_j].I{i})
    for __silica_k in range({width[1]}):
        wire({register}_next_{i}[__silica_j].I0[__silica_k], __silica_path_state.O[{i}])
"""
            else:
                magma_source += f"{register}_next_{i} = And(2, {width})\n"
                magma_source += f"wire({register}_next_{i}.O, {register}_next.I{i})\n"
                for j in range(width):
                    magma_source += f"wire({register}_next_{i}.I0[{j}], __silica_path_state.O[{i}])\n"

    for output in outputs:
        width = width_table[output]
        magma_source += f"{output} = Or({len(cfg.paths)}, {width})\n"
        magma_source += f"wire({output}.O, {tree.name}.{output})\n"
        for i, state in enumerate(states):
            magma_source += f"{output}_{i} = And(2, {width})\n"
            magma_source += f"wire({output}_{i}.O, {output}.I{i})\n"
            if width is None:
                magma_source += f"wire({output}_{i}.I0, __silica_path_state.O[{i}])\n"
            else:
                for j in range(width):
                    magma_source += f"wire({output}_{i}.I0[{j}], __silica_path_state.O[{i}])\n"
    for i, state in enumerate(cfg.states):
        load_symbol_map = {}
        store_symbol_map = {}
        arrays = set()
        for register in registers:
            if isinstance(width_table[register], tuple):
                arrays.add(register)
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
            else:
                load_symbol_map[register] = ast.parse(f"{register}.O").body[0].value
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
        for output in outputs:
            store_symbol_map[output] = ast.parse(f"{output}_{i}_tmp").body[0].value
        stores = set()
        for statement in state.statements:
            stores |= collect_names(statement, ast.Store)
            statement = replace_symbols(statement, load_symbol_map, ast.Load)
            statement = replace_symbols(statement, store_symbol_map, ast.Store)
            for array in arrays:
                statement = replace_arrays(statement, array)
            magma_source += astor.to_source(statement)
            for var in stores:
                if var in registers:
                    load_symbol_map[var] = ast.parse(f"{var}_next_{i}_tmp").body[0].value
                elif var in outputs:
                    load_symbol_map[var] = ast.parse(f"{var}_{i}_tmp").body[0].value
        magma_source += f"wire(__silica_yield_state_next_{i}.I1, bits({1 << state.end_yield_id}, {num_yields}))\n"
        for register in registers:
            if isinstance(width_table[register], tuple):
                if register in stores:
                    magma_source += f"""\
for __silica_i in range({width_table[register][0]}):
    wire({register}_next_{i}_tmp[__silica_i], {register}_next_{i}[__silica_i].I1)
"""
                else:
                    magma_source += f"""\
for __silica_i in range({width_table[register][0]}):
    wire({register}[__silica_i].O, {register}_next_{i}[__silica_i].I1)
"""
            else:
                if register in stores:
                    magma_source += f"wire({register}_next_{i}_tmp, {register}_next_{i}.I1)\n"
                else:
                    magma_source += f"wire({register}.O, {register}_next_{i}.I1)\n"
        for output in outputs:
            magma_source += f"wire({output}_{i}_tmp, {output}_{i}.I1)\n"

        # curr = ast.parse(f"__silica_yield_state_next_{i}.O[{state.start_yield_id}]").body[0].value
        conds = [ast.parse(f"__silica_yield_state.O[{state.start_yield_id}]").body[0].value]
        if state.conds:
            for cond in state.conds:
                cond = replace_symbols(cond, load_symbol_map, ast.Load)
                conds.append(cond)
            cond = ast.Call(ast.Name("and_", ast.Load()), conds, [])
        else:
            cond = conds[0]
        magma_source += f"wire(__silica_path_state.I[{i}], {astor.to_source(cond).rstrip()})\n"
    magma_source += "EndDefine()"

    print("\n".join(f"{i + 1}: {line}" for i, line in enumerate(magma_source.splitlines())))
    if file_name is None:
        exec(magma_source, func_globals, func_locals)
        return eval(tree.name, func_globals, func_locals)
    else:
        with open(file_name, "w") as output_file:
            output_file.write(magma_source)
