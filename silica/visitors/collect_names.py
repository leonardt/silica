import ast

class NameCollector(ast.NodeVisitor):
    def __init__(self, ctx):
        self.names = set()
        self.ctx = ctx

    def visit_Name(self, node):
        if self.ctx is None or isinstance(node.ctx, self.ctx):
            self.names.add(node.id)


def collect_names(tree, ctx=None):
    visitor = NameCollector(ctx)
    visitor.visit(tree)
    return visitor.names
