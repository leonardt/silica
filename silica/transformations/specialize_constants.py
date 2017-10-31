import ast
import astor

class InlineConstants(ast.NodeTransformer):
    def __init__(self, constants):
        super().__init__()
        self.constants = constants

    def visit_Name(self, node):
        if node.id in self.constants:
            return ast.Num(self.constants[node.id])
        return node



def specialize_constants(tree, constants):
    tree = InlineConstants(constants).visit(tree)
    return tree

