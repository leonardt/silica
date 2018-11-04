import ast
from .width import get_width
import astor


class TypeChecker(ast.NodeVisitor):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def check(self, tree):
        self.visit(tree)
        return self.width_table

    def visit_Assign(self, node):
        if isinstance(node.value, ast.Yield):
            return  # width specified at compile time
        if len(node.targets) == 1:
            if isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and node.value.func.id == "coroutine_create":
                pass
            elif isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Attribute) and node.value.func.attr == "send":
                pass
            elif isinstance(node.targets[0], ast.Name):
                if node.targets[0].id not in self.width_table:
                    self.width_table[node.targets[0].id] = get_width(node.value, self.width_table)
                elif self.width_table[node.targets[0].id] != get_width(node.value, self.width_table):
                    raise TypeError(f"Trying to assign {ast.dump(node.value)} with width {get_width(node.value, self.width_table)} to {node.targets[0].id} with width {self.width_table[node.targets[0].id]}")
            elif isinstance(node.targets[0], ast.Tuple):
                if not all(isinstance(target, ast.Name) for target in node.targets[0].elts):
                    raise SyntaxError(f"Can only assign to variables {ast.dump(node)}")
                widths = get_width(node.value, self.width_table)
                if not isinstance(widths, tuple) or len(widths) != len(node.targets[0].elts):
                    raise TypeError(f"Trying to unpack {len(node.targets.elts)} but got {len(widths)} - {ast.dump(node)} ")
                for target, width in zip(node.targets[0].elts, widths):
                    self.width_table[target.id] = width
            elif isinstance(node.targets[0], ast.Subscript):
                if not get_width(node.targets[0], self.width_table) == get_width(node.value, self.width_table):
                    raise TypeError(f"Mismatched widths {get_width(node.targets[0], self.width_table)} != {get_width(node.value, self.width_table)} : {astor.to_source(node).rstrip()}")
            else:
                raise NotImplementedError(ast.dump(node))
        else:
            raise NotImplementedError(ast.dump(node))
