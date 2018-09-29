import ast
from .collect_names import collect_names


class AssignToSubscriptCollector(ast.NodeVisitor):
    def __init__(self):
        super().__init__()
        self.seen = set()

    def get_name(self, node):
        if isinstance(node, ast.Subscript):
            return self.get_name(node.value)
        elif isinstance(node, ast.Name):
            return node.id
        else:
            raise NotImplementedError("Found assign to subscript that isn't of the form name[x][y]...[z]")

    def visit_Assign(self, node):
        if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
            self.seen.add(self.get_name(node.targets[0]))

def collect_assign_to_subscript(tree):
    collector = AssignToSubscriptCollector()
    collector.visit(tree)
    return collector.seen

def collect_stores(tree):
    """
    Collects nodes of the form:
        ast.Name(x, ast.Store())
        ast.Subscript(ast.Subscript(...(ast.Name, ast.Load()), ...), ...)
            where the Subscript is a child in the targets of an ast.Assign node

    >>> collect_stores(ast.parse("x = y")) 
    {'x'}
    >>> collect_stores(ast.parse("x[0] = y")) 
    {'x'}
    >>> collect_stores(ast.parse("x[0][0] = y")) 
    {'x'}
    """
    assign_to_names = collect_names(tree, ast.Store)
    assign_to_subscript = collect_assign_to_subscript(tree)

    return assign_to_names | assign_to_subscript
