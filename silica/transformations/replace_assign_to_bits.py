import ast
from silica.transformations.replace_symbols import replace_symbols


def replace_assign_to_bits(statement, load_symbol_map, store_symbol_map):
    class Transformer(ast.NodeTransformer):
        def visit_Assign(self, node):
            if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
                target = replace_symbols(node.targets[0], store_symbol_map, ast.Load)
                return ast.parse(f"{astor.to_source(target).rstrip()} = {astor.to_source(node.value).rstrip()}").body[0]
            return node

        def run(self, statement):
            return self.visit(statement)
    return Transformer().run(statement)
