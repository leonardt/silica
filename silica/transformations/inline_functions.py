import ast
import silica.ast_utils
from silica.transformations.replace_symbols import replace_symbols


class YieldFromFunctionInliner(ast.NodeTransformer):
    def __init__(self, _locals, _globals):
        self._locals = _locals
        self._globals = _globals

    def visit(self, node):
        """
        For nodes with a `body` attribute, we explicitly traverse them and
        flatten any lists that are returned. This allows visitors to return
        more than one node.
        """
        if hasattr(node, 'body'):
            new_body = []
            for statement in node.body:
                result = self.visit(statement)
                if isinstance(result, list):
                    new_body.extend(result)
                else:
                    new_body.append(result)
            node.body = new_body
            return node
        return super().visit(node)

    def visit_Expr(self, node):
        """
        If node.value is a YieldFrom that is inlined, it will return a list, so
        here we pass the list on so it can be flattened into the body of the
        parent node
        """
        node.value = self.visit(node.value)
        if isinstance(node.value, list):
            return node.value
        return node

    def visit_YieldFrom(self, node):
        if isinstance(node.value, ast.Call):
            func = node.value
            if not isinstance(func.func, ast.Name):
                raise NotImplementedError(ast.dump(func))
            func_obj = eval(func.func.id, self._globals, self._locals)
            if not getattr(func_obj, '__silica_inline', False):
                return node
            # `ast_utils.get_ast` returns a module so grab first statement in body
            func_def = silica.ast_utils.get_ast(func_obj).body[0]
            symbol_table = {}
            for arg, param in zip(func.args, func_def.args.args):
                symbol_table[param.arg] = arg
            func_def = replace_symbols(func_def, symbol_table)
            return func_def.body
        else:
            return node



def inline_yield_from_functions(tree, _locals, _globals):
    return YieldFromFunctionInliner(_locals, _globals).visit(tree)
