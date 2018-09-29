import ast


class SSAReplacer(ast.NodeTransformer):
    def __init__(self):
        self.seen = {}
        self.phi_vars = {}
        self.stmts_seen = set()
        self.load_store_offset = {}

    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        assert len(node.targets) == 1
        if isinstance(node.targets[0], ast.Subscript):
            assert isinstance(node.targets[0].value, ast.Name)
            store_offset = self.load_store_offset.get(node.targets[0].value.id, 0)
            node.targets[0].value.id += f"_{self.seen[node.targets[0].value.id] + store_offset}"
        else:
            node.targets[0] = self.visit(node.targets[0])
        return node

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load):
            # phi_args = []
            # for block, _ in self.curr_block.incoming_edges:
            #     phi_args.append(ast.Name(f"{node.id}_{block.seen[node.id]}", ast.Load()))
            # if len(phi_args):
            #     return ast.Call(ast.Name("phi", ast.Load()), phi_args, [])
            if node.id in self.seen:
                load_offset = self.load_store_offset.get(node.id, 0)
                node.id += f"_{self.seen[node.id] - load_offset}"
            return node
        else:
            if node.id not in self.seen:
                self.seen[node.id] = 0
            else:
                self.seen[node.id] += 1
            store_offset = self.load_store_offset.get(node.id, 0)
            return ast.Name(f"{node.id}_{self.seen[node.id] + store_offset}", ast.Store)

    def process_block(self, block):
        self.curr_block = block
        for statement in block:
            self.visit(statement)
        block.seen = copy(self.seen)
