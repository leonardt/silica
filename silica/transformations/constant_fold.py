import ast
import astor


class ConstantFold(ast.NodeTransformer):
    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.left, ast.Num) and \
           isinstance(node.right, ast.Num):
            result = eval(astor.to_source(node))
            if result is True or result is False:
                return ast.NameConstant(result)
            return ast.Num(result)
        elif isinstance(node.op, ast.Mult) and \
             ((isinstance(node.left, ast.Num) and node.left.n == 0) or
              (isinstance(node.right, ast.Num) and node.right.n == 0)):
            return ast.Num(0)
        elif isinstance(node.op, ast.Add):
            if isinstance(node.left, ast.Num) and node.left.n == 0:
                return node.right
            elif isinstance(node.right, ast.Num) and node.right.n == 0:
                return node.left
        return node

def constant_fold(tree):
    return ConstantFold().visit(tree)
