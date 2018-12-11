import ast
import astor
import inspect
import re
import sys
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


# Automatically generate is_{} functions for classes in the ast module
module_obj = sys.modules[__name__]

_first_cap_re=re.compile(r'(.)([A-Z][a-z]+)')
_all_cap_re=re.compile(r'([a-z0-9])([A-Z])')
def to_snake_case(name):
    """ Converts name from CamelCase to snake_case

    https://stackoverflow.com/questions/1175208/elegant-python-function-to-convert-camelcase-to-snake-case
    """
    s1 = re.sub(_first_cap_re, r'\1_\2', name)
    return re.sub(_all_cap_re, r'\1_\2', s1).lower()

def is_generator(name):
    def f(node):
        return isinstance(node, getattr(ast, name))

    setattr(module_obj, "is_" + to_snake_case(name), f)

for x in (m[0] for m in inspect.getmembers(ast, inspect.isclass) if m[1].__module__ == '_ast'):
    is_generator(x)


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
