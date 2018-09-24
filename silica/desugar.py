import ast


class ListExprChecker(ast.NodeVisitor):
    def __init__(self):
        self.is_list_expr = True

    def visit_List(self, node):
        return

    def visit_Subscript(self, node):
        return

    def visit_Name(self, node):
        self.is_list_expr = False

    def run(self, expr):
        self.visit(expr)
        return self.is_list_expr


class Desugar(ast.NodeTransformer):
    def __init__(self, width_table):
        self.width_table = width_table

    def visit(self, node):
        node = super().visit(node)
        if hasattr(node, 'body'):
            new_body = []
            for child in node.body:
                if isinstance(child, list):
                    new_body.extend(child)
                else:
                    assert isinstance(child, ast.AST)
                    new_body.append(child)
            node.body = new_body
        return node

    def is_list_expr(self, node):
        if not len(node.targets) == 1 or not isinstance(node.targets[0], ast.Name) or \
           node.targets[0].id not in self.width_table or \
           not isinstance(self.width_table[node.targets[0].id], tuple):
               return False
        # Check leaf nodes are list literals or slices
        return ListExprChecker().run(node.value)

    # def visit_Assign(self, node):
    #     if self.is_list_expr(node):
    #         raise NotImplementedError()
    #     return super().generic_visit(node)

    def visit_Call(self, node):
        # Skip wire calls because they are not silica code
        if isinstance(node.func, ast.Name) and node.func.id in {"wire"}:
            return node
        return super().generic_visit(node)

    def visit_AugAssign(self, node):
        target = astor.to_source(node.target).rstrip()
        value  = astor.to_source(node.value).rstrip()
        return self.visit(ast.parse(f"{target} = {target} + {value}").body[0].value)

    def visit_BinOp(self, node):
        node.left = self.visit(node.left)
        node.right = self.visit(node.right)
        if isinstance(node.op, ast.Add):
            op = "add"
        elif isinstance(node.op, ast.Sub):
            op = "sub"
        elif isinstance(node.op, ast.BitXor):
            op = "xor"
        elif isinstance(node.op, ast.BitAnd):
            op = "and_"
        elif isinstance(node.op, ast.Lt):
            op = "lt"
        elif isinstance(node.op, ast.LtE):
            op = "le"
        else:
            raise NotImplementedError(node.op)
        return ast.parse(f"{op}({astor.to_source(node.left).rstrip()}, {astor.to_source(node.right).rstrip()})").body[0].value


    def visit_UnaryOp(self, node):
        if isinstance(node.op, ast.Not):
            op = "not_"
        elif isinstance(node.op, ast.USub):
            op = "neg"
        else:
            raise NotImplementedError(node.op)
        return ast.parse(f"{op}({astor.to_source(node.operand).rstrip()})").body[0].value

    def visit_BoolOp(self, node):
        node.values = [self.visit(value) for value in node.values]
        if isinstance(node.op, ast.And):
            op = "and_"
        else:
            raise NotImplementedError(node.op)
        args = ", ".join(astor.to_source(value) for value in node.values)
        return ast.parse(f"{op}({args})").body[0].value

    def visit_Compare(self, node):
        node.left = self.visit(node.left)
        node.comparators = [self.visit(x) for x in node.comparators]
        if all(isinstance(op, ast.Eq) for op in node.ops):
            args = ", ".join([astor.to_source(node.left).rstrip()] +
                [astor.to_source(x).rstrip() for x in node.comparators])
            return ast.parse(f"eq({args})").body[0].value
        elif all(isinstance(op, ast.NotEq) for op in node.ops):
            args = ", ".join([astor.to_source(node.left).rstrip()] +
                [astor.to_source(x).rstrip() for x in node.comparators])
            return ast.parse(f"not_(eq({args}))").body[0].value
        if len(node.ops) == 1:
            left = astor.to_source(node.left).rstrip()
            right = astor.to_source(node.comparators[0]).rstrip()
            if isinstance(node.ops[0], ast.Lt):
                return ast.parse(f"lt({left}, {right})").body[0].value
            elif isinstance(node.ops[0], ast.Gt):
                return ast.parse(f"gt({left}, {right})").body[0].value
            # elif isinstance(node.ops[0], ast.And):
            #     return ast.parse(f"and_({left}, {right})").body[0].value
        return node


class DesugarArrays(ast.NodeTransformer):
    def __init__(self):
        self.unique_decoder_id = -1

    def run(self, node):
        self.visit(node)

    def visit_Assign(self, node):
        self.unique_decoder_id += 1
        if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
            array = astor.to_source(node.targets[0].value).rstrip()
            write_address = node.targets[0].slice
            if isinstance(write_address, ast.Index):
                if isinstance(write_address.value, ast.Num):
                    return node
                return ast.parse("None")
                return ast.parse(f"""
__silica_decoder_{self.unique_decoder_id} = decoder({astor.to_source(write_address).rstrip()})
for i in range(len({array})):
    # {array}_CE[i].append(__silica_decoder_{self.unique_decoder_id}[i])
    {array}[i] = DefineSilicaMux(2, len({array}[i]))()({array}[i], {astor.to_source(node.value).rstrip()}, bits([not_(__silica_decoder_{self.unique_decoder_id}[i]), __silica_decoder_{self.unique_decoder_id}[i]]))
""").body
            else:
                raise NotImplementedError(ast.dump(node))
        return super().generic_visit(node)
