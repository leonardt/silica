import silica
import ast
import astor
import copy

class InlineConstants(ast.NodeTransformer):
    def __init__(self, constants):
        super().__init__()
        self.constants = constants

    def visit_Name(self, node):
        if node.id in self.constants:
            constant = self.constants[node.id]
            if isinstance(constant, ast.AST):
                return copy.deepcopy(constant)
            elif isinstance(constant, int):
                return ast.Num(constant)
            elif isinstance(constant, silica.BitVector):
                return ast.parse(f"bits({constant._value}, {constant.num_bits})").body[0].value
        return node



def specialize_constants(tree, constants):
    tree = InlineConstants(constants).visit(tree)
    return tree

