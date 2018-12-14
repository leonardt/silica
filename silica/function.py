import types
import magma as m
import silica.verilog as verilog
import inspect
from silica.visitors import collect_stores
from silica.analysis import CollectInitialWidthsAndTypes
from silica.type_check import to_type_str
from silica.width import get_io_width
import ast
import veriloggen as vg


class ReturnReplacer(ast.NodeTransformer):
    def visit_Return(self, node):
        if isinstance(node.value, ast.Tuple):
            raise NotImplementedError()
        return ast.Assign([ast.Name("O", ast.Store())], node.value)


def function(fn : types.FunctionType):
    """ TODO: Do implicit conversion of Python types to BitVector """
    return fn


def compile_function(fn : types.FunctionType, file_name : str):
    stack = inspect.stack()
    func_locals = stack[1].frame.f_locals
    func_globals = stack[1].frame.f_globals
    tree = m.ast_utils.get_func_ast(fn)
    ctx = verilog.Context(tree.name)
    width_table = {}
    type_table = {}

    def get_len(t):
        try:
            return len(t)
        except Exception:
            return 1


    inputs = inspect.getfullargspec(fn).annotations
    for input_, type_ in inputs.items():
        type_table[input_] = to_type_str(type_)
        width_table[input_] = get_io_width(type_)

    inputs = { i : get_len(t) for i,t in inputs.items() }
    output = inspect.signature(fn).return_annotation
    assert not isinstance(output, tuple), "Not implemented"
    type_table["O"] = to_type_str(output)
    width_table["O"] = get_io_width(output)
    outputs = { "O" : get_len(output) }

    CollectInitialWidthsAndTypes(width_table, type_table, func_locals, func_globals).visit(tree)

    ctx.declare_ports(inputs, outputs)

    stores = collect_stores(tree)
    for store in stores:
        ctx.declare_wire(store, width_table[store])

    tree = ReturnReplacer().visit(tree)

    ctx.module.Always(vg.SensitiveAll())([ctx.translate(s) for s in tree.body])

    with open(file_name, "w") as f:
        f.write(ctx.to_verilog())
