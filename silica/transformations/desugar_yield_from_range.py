import ast

class YieldFromRangeDesugarer(ast.NodeTransformer):
    def __init__(self):
        super().__init__()
        self.loopvars = set()

    unique_id = -1
    def gen_loopvar(self, width):
        YieldFromRangeDesugarer.unique_id += 1
        loopvar = "____x{}".format(YieldFromRangeDesugarer.unique_id)
        self.loopvars.add((loopvar, width))
        return loopvar

    def visit_Expr(self, node):
        if isinstance(node.value, ast.YieldFrom) and isinstance(node.value.value, ast.Call) \
           and node.value.value.func.id == "range":
            node = node.value
            width = node.value.args[-1].n.bit_length()
            loopvar = self.gen_loopvar(width)
            return ast.For(ast.Name(loopvar, ast.Load()),
                           node.value,
                           [ast.Expr(ast.Yield(None))], None)
        node.value = self.visit(node.value)
        return node

def desugar_yield_from_range(tree):
    visitor = YieldFromRangeDesugarer()
    visitor.visit(tree)
    return tree, visitor.loopvars
