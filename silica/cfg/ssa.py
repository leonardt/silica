import ast
import astor


class SSAReplacer(ast.NodeTransformer):
    def __init__(self):
        self.id_counter = {}
        self.phi_vars = {}
        self.load_store_offset = {}
        self.seen = set()
        self.array_stores = {}
        self.index_map = {}
        self.array_store_processed = set()

    def increment_id(self, key):
        if key not in self.id_counter:
            self.id_counter[key] = 0
        else:
            self.id_counter[key] += 1

    def get_name(self, node):
        if isinstance(node, ast.Subscript):
            return self.get_name(node.value)
        elif isinstance(node, ast.Name):
            return node.id
        else:
            raise NotImplementedError("Found assign to subscript that isn't of the form name[x][y]...[z]")

    def get_index(self, node):
        if isinstance(node.slice, ast.Index):
            index = node.slice.value
        else:
            raise NotImplementedError(node.slice, type(node.slice))
        if isinstance(node.value, ast.Subscript):
            return (index, ) + self.get_index(node.value)
        return (index, )

    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        assert len(node.targets) == 1
        if isinstance(node.targets[0], ast.Subscript):
            assert isinstance(node.targets[0].value, ast.Name)
            node.targets[0].slice = self.visit(node.targets[0].slice)
            store_offset = self.load_store_offset.get(node.targets[0].value.id, 0)
            name = self.get_name(node.targets[0])
            name += f"_{self.id_counter[name]}"
            index = self.get_index(node.targets[0])
            if name not in self.array_stores:
                self.array_stores[name, index] = 0
            else:
                self.array_stores[name, index] += 1
            index_hash = "_".join(ast.dump(i) for i in index)
            if index_hash not in self.index_map:
                self.index_map[index_hash] = len(self.index_map)
            node.targets[0].value.id += f"_{self.id_counter[node.targets[0].value.id]}_{self.array_stores[name, index]}_i{self.index_map[index_hash]}"
            node.targets[0] = node.targets[0].value
            # self.increment_id(name)
            # if name not in self.seen:
            #     self.increment_id(name)
            #     self.seen.add(name)
            # node.targets[0].value.id += f"_{self.id_counter[name] + store_offset}"
        else:
            node.targets[0] = self.visit(node.targets[0])
        return node

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load):
            # phi_args = []
            # for block, _ in self.curr_block.incoming_edges:
            #     phi_args.append(ast.Name(f"{node.id}_{block.id_counter[node.id]}", ast.Load()))
            # if len(phi_args):
            #     return ast.Call(ast.Name("phi", ast.Load()), phi_args, [])
            if node.id in self.id_counter:
                load_offset = self.load_store_offset.get(node.id, 0)
                node.id += f"_{self.id_counter[node.id] - load_offset}"
            return node
        else:
            self.increment_id(node.id)
            # if node.id not in self.seen:
            #     self.increment_id(node.id)
            #     self.seen.add(node.id)
            store_offset = self.load_store_offset.get(node.id, 0)
            return ast.Name(f"{node.id}_{self.id_counter[node.id] + store_offset}", ast.Store)
