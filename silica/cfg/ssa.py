import ast
import astor

from collections import defaultdict
from silica.cfg.types import BasicBlock, Yield, Branch, HeadBlock, State


class SSAReplacer(ast.NodeTransformer):
    def __init__(self, width_table):
        self.width_table = width_table
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
            prev_name = name + f"_{self.id_counter[name] - store_offset}"
            name += f"_{self.id_counter[name] + store_offset}"
            index = self.get_index(node.targets[0])
            if (name, index) not in self.array_stores:
                self.array_stores[name, index] = (0, prev_name)
                num = 0
            else:
                val = self.array_stores[name, index]
                num = val[0] + 1
                self.array_stores[name, index] = (num, val[1])
            index_hash = "_".join(ast.dump(i) for i in index)
            if index_hash not in self.index_map:
                self.index_map[index_hash] = len(self.index_map)
            node.targets[0].value.id = f"{name}_si_tmp_val_{num}_i{self.index_map[index_hash]}"
            node.targets[0] = node.targets[0].value
            node.targets[0].ctx = ast.Store()
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
            self.width_table[f"{node.id}_{self.id_counter[node.id]}"] = self.width_table[node.id]
            return ast.Name(f"{node.id}_{self.id_counter[node.id] + store_offset}", ast.Store())


class Replacer(ast.NodeTransformer):
    def __init__(self, var_to_curr_id_map):
        super().__init__()
        self.var_to_curr_id_map = var_to_curr_id_map
        self.stores = set()


    def visit_Assign(self, node):
        node.value = self.visit(node.value)
        node.targets = [self.visit(target) for target in node.targets]
        return node

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Store):
            self.var_to_curr_id_map[node.id] += 1
        node.id += f"_{self.var_to_curr_id_map[node.id]}"
        return node


def convert_to_ssa(cfg):
    replacer = SSAReplacer(cfg.width_table)
    yield_to_paths_map = defaultdict(lambda: [])
    for path in cfg.paths:
        yield_to_paths_map[path[-1]].append(path)

    processed = set()
    var_to_curr_id_map = defaultdict(lambda: 0)
    for end_yield, paths in yield_to_paths_map.items():
        blocks_to_process = []
        for path in paths:
            if isinstance(path[0], HeadBlock):
                blocks_to_process.append(path[0])
            elif all(isinstance(edge, Yield) or edge in processed for edge, _ in path[1].incoming_edges):
                blocks_to_process.append(path[1])
        while blocks_to_process:
            block = blocks_to_process.pop(0)
            processed.add(block)
            print(block)
            print(block.incoming_edges)
            if isinstance(block, BasicBlock):
                block.print_statements()
            if len(block.incoming_edges) == 1:
                predecessor, _ = next(iter(block.incoming_edges))
                if isinstance(predecessor, Yield):
                    loads = []
                    for var in block.live_ins:
                        loads.append(ast.parse(f"{var}_{var_to_curr_id_map[var]} = {var}"))
                        var_to_curr_id_map[var] += 1
            replacer = Replacer(var_to_curr_id_map)
            if isinstance(block, BasicBlock):
                for statement in block.statements:
                    replacer.visit(statement)
                block.statements = loads + block.statements
            elif isinstance(block, Branch):
                block.cond = replacer.visit(block.cond)

            for successor, _ in block.outgoing_edges:
                if successor in processed:
                    continue
                if all(isinstance(edge, Yield) or edge in processed for edge, _ in successor.incoming_edges):
                    blocks_to_process.append(successor)




    cfg.render()
    exit()

