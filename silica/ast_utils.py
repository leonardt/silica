import ast
import astor
import inspect
import textwrap
import magma


def print_ast(tree):  # pragma: no cover
    print(astor.to_source(tree))

def to_source(tree):
    return astor.to_source(tree).rstrip()

def get_ast(obj):
    indented_program_txt = inspect.getsource(obj)
    program_txt = textwrap.dedent(indented_program_txt)
    return ast.parse(program_txt)
    # return astor.code_to_ast(obj)


# TODO: would be cool to metaprogram these is_* funcs
def is_call(node):
    return isinstance(node, ast.Call)


def is_name(node):
    return isinstance(node, ast.Name)


def is_subscript(node):
    return isinstance(node, ast.Subscript)


def get_call_func(node):
    if is_name(node.func):
        return node.func.id
    # Should handle nested expressions/alternate types
    raise NotImplementedError(type(node.value.func))  # pragma: no cover


def get_outputs_from_func(tree):
    """
    Given the ast of a mantle function defined like

    .. code-block:: python

        @circuit
        def func(a : In(Bit), b : Out(Array(Bit))):
            a = b

    returns a list of (name, width) tuples for each output
    """
    outputs = []
    for arg in tree.args.args:
        name = arg.arg
        _type = eval(astor.to_source(arg.annotation), globals(), magma.__dict__)()
        if _type.isoutput():
            if isinstance(_type, magma.ArrayType):
                width = _type.N
            elif isinstance(_type, magma.BitType):
                width = 1
            else:
                raise NotImplementedError(type(_type))
            outputs.append((name, width))
    return outputs
