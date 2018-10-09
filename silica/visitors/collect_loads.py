import ast

class LoadCollector(ast.NodeVisitor):
    def __init__(self):
        super().__init__()
        self.names = set()

    def visit_Assign(self, node):
        # skip stores
        self.visit(node.value)

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load):
            self.names.add(node.id)


def collect_loads(tree):
    visitor = LoadCollector()
    visitor.visit(tree)
    return visitor.names
