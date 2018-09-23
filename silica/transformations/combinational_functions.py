import ast


class CombinationalFunctionCompiler(ast.NodeTransformer):
    def __init__(self, _globals, _locals):
        self._globals = _globals
        self._locals = _locals

    def visit_Call(self, node):
        if isinstance(node.func, ast.Name) and node.func.id in self._globals \
                and getattr(self._globals[node.func.id],
                            "__silica_combinational", False):
            print(self._globals[node.func.id])
        return node


def compile_combinational_functions(tree, _globals, _locals):
    compiler = CombinationalFunctionCompiler(_globals, _locals)
    compiler.visit(tree)
    exit(1)
