import ast
import astor


class EvalSpecializer(ast.NodeTransformer):
    def __init__(self, _locals, _globals):
        self._locals = _locals
        self._globals = _globals

    def visit_Call(self, node):
        if isinstance(node.func, ast.Name) and \
           node.func.id == "eval":
            result = eval(astor.to_source(node.args[0]).rstrip(), self._globals, self._locals)
            return ast.parse(str(result)).body[0].value
        node = super().generic_visit(node)
        return node


def specialize_evals(tree, _locals, _globals):
    return EvalSpecializer(_locals, _globals).visit(tree)
