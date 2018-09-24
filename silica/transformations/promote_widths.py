import ast
from ..width import get_width


class PromoteWidths(ast.NodeTransformer):
    def __init__(self, width_table, type_table):
        self.width_table = width_table
        self.type_table = type_table

    def check_valid(self, int_length, expected_length):
        if int_length > expected_length:
            raise TypeError("Cannot promote integer with greated width than other operand")

    def make(self, value, width, type_):
        return ast.parse(f"{type_}({value}, {width})").body[0].value

    def get_type(self, node):
        if isinstance(node, ast.Name):
            return self.type_table[node.id]
        elif isinstance(node, ast.Subscript):
            if isinstance(node.value, ast.Name):
                type_ = self.type_table[node.value.id]
                if type_ == "uint" and isinstance(node.slice, ast.Index):
                    return 1
                else:
                    raise NotImplementedError()
        raise NotImplementedError(node)

    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        if isinstance(node.value, ast.Num):
            width = get_width(node.targets[0], self.width_table)
            self.check_valid(node.value.n.bit_length(), width)
            node.value = self.make(node.value.n, width, self.get_type(node.targets[0]))
        elif isinstance(node.value, ast.NameConstant):
            width = get_width(node.targets[0], self.width_table)
            node.value = ast.parse(f"bit({node.value.value})").body[0].value
        return node

    def visit_AugAssign(self, node):
        node.value = self.visit(node.value)
        if isinstance(node.value, ast.Num):
            width = get_width(node.target, self.width_table)
            self.check_valid(node.value.n.bit_length(), width)
            node.value = self.make(node.value.n, width, self.get_type(node.target))
        return node

    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.left, ast.Num):
            right_width = get_width(node.right, self.width_table)
            self.check_valid(node.left.n.bit_length(), right_width)
            node.left = self.make(node.left.n, right_width, self.get_type(node.right))
        elif isinstance(node.right, ast.Num):
            left_width = get_width(node.left, self.width_table)
            self.check_valid(node.right.n.bit_length(), left_width)
            node.right = self.make(node.right.n, left_width, self.get_type(node.left))
        return node

    def visit_Compare(self, node):
        node.left = self.visit(node.left)
        node.comparators = [self.visit(x) for x in node.comparators]
        if not isinstance(node.left, ast.Num):
            left_width = get_width(node.left, self.width_table)
            type_ = self.get_type(node.left)
            for i in range(len(node.comparators)):
                if isinstance(node.comparators[i], ast.Num):
                    self.check_valid(node.comparators[i].n.bit_length(), left_width)
                    node.comparators[i] = self.make(node.comparators[i].n, left_width, type_)
        else:
            for comparator in node.comparators:
                if not isinstance(comparator, ast.Num):
                    width = get_width(comparator, self.width_table)
                    type_ = self.get_type(comparator)
            else:
                assert False, "Constant fold should have folded this expression {ast.dump(node)}"
            self.check_valid(node.left.n.bit_length(), width)
            node.left = self.make(node.left.n, width, type_)
            for i in range(len(node.comparators)):
                if isinstance(node.comparators[i], ast.Num):
                    self.check_valid(node.comparators[i].n.bit_length(), width)
                    node.comparators[i] = self.make(node.comparators[i].n, width, type_)
        return node

