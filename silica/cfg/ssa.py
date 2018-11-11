"""
For each yield, find all paths from other yields that lead into it.

    For each path,
        Create a queue of blocks to process, where a block is in the queue only if
        all blocks leading into it have been processed, or the block leading into it
        is a Yield

        Initialize the queue with the blocks following the start yields (that
        is, the blocks following the yields that start a path ending in the
        current end yield).
            Note: there could be a block that immediately follows a yield, but
                  also has a path from another block, that may itself, come
                  from another yield. In this case, the block should only be
                  added to queue *after* the block leading into it has been
                  processed, so even though it's an immediate successor of a
                  yield, it may not go in the initial queue.

        For each block, if a variable is read, check its predecessor:
            If the predecessor is a yield, perform a load from any live
            variables coming into the path into a fresh temporary variable,
            e.g. `a_3 = a`.

            If the predecessor is a basic block, get the latest ssa values of
            assigned variables, use this to set the current state of the ssa
            variable replacer.

            If it has multiple predecessors, insert a phi node to select the
            correct predecessor.  The condition of the phi node (mux) are,
            select this value if the start yield was one of the yields starting
            a path leading into the predecssor and the result of branches match
            the edges along the path in the control flow graph from the start
            yields.

                for each predecessor:
                    conds = []
                    for each path leading into predecessor:
                        conds.append(yield_state == start_yield_id &
                                     (cond_1 == T) & (cond_2 == F) & ...)
                    take predecessor variables if reduce(|, conds)

        Once we reach the end yield, perform a store with the latest assigned
        temporary variables for each live out.
"""
import ast
import astor
import copy
from ..memory import MemoryType
import silica.ast_utils as ast_utils

from collections import defaultdict
from silica.cfg.types import BasicBlock, Yield, Branch, HeadBlock, State
from .util import find_branch_join


def parse_expr(expr):
    return ast.parse(expr).body[0].value



def parse_stmt(statement):
    return ast.parse(statement).body[0]


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
    def __init__(self, var_to_curr_id_map, stores, width_table, sub_coroutines):
        super().__init__()
        self.var_to_curr_id_map = var_to_curr_id_map
        self.stores = stores
        self.width_table = width_table
        self.array_stores = {}
        self.index_map = {}
        self.sub_coroutines = sub_coroutines

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
        if isinstance(node.targets[0], ast.Subscript):
            assert isinstance(node.targets[0].value, ast.Name)
            node.targets[0].slice = self.visit(node.targets[0].slice)
            orig_name = self.get_name(node.targets[0])
            width = self.width_table[orig_name]
            if isinstance(width, MemoryType):
                width = width.width
                node.value = self.visit(node.value)
                node.targets = [self.visit(target) for target in node.targets]
                return node
            else:
                width = None
            prev_name = orig_name + f"_{self.var_to_curr_id_map[orig_name]}"
            name = orig_name + f"_{self.var_to_curr_id_map[orig_name]}"
            index = self.get_index(node.targets[0])
            if (name, index) not in self.array_stores:
                self.array_stores[name, index] = (0, orig_name)
                num = 0
            else:
                val = self.array_stores[name, index]
                num = val[0] + 1
                self.array_stores[name, index] = (num, val[1])
            index_hash = "_".join(ast.dump(i) for i in index)
            if index_hash not in self.index_map:
                self.index_map[index_hash] = len(self.index_map)
            node.targets[0].value.id = f"{name}_si_tmp_val_{num}_i{self.index_map[index_hash]}"
            self.width_table[node.targets[0].value.id] = width
            node.targets[0] = node.targets[0].value
            node.targets[0].ctx = ast.Store()
        else:
            node.value = self.visit(node.value)
            node.targets = [self.visit(target) for target in node.targets]
        return node

    def visit_Call(self, node):
        if ast_utils.is_name(node.func) and node.func.id == "coroutine_create":
            return node
        else:
            super().generic_visit(node)
            return node

    def visit_Name(self, node):
        if node.id in ["uint", "bits", "bit", "memory", "coroutine_create"] + self.sub_coroutines:
            return node
        orig_id = node.id
        if isinstance(node.ctx, ast.Store):
            node.id += f"_{self.var_to_curr_id_map[node.id]}"
            self.var_to_curr_id_map[orig_id] += 1
            self.stores[orig_id] = node.id
            self.width_table[node.id] = self.width_table[orig_id]
        else:
            if node.id in self.stores:
                node.id = self.stores[node.id]
        return node


def get_conds_up_to(path, predecessor, cfg):
    conds = set()
    for i, block in enumerate(path):
        if isinstance(block, Yield):
            continue
            if cfg.curr_yield_id > 1:
                conds.add(f"yield_state == {block.yield_id}")
        elif isinstance(block, HeadBlock):
            continue
            if cfg.curr_yield_id > 1:
                conds.add(f"yield_state == 0")
        elif isinstance(block, Branch):
            join_block = find_branch_join(block)
            if join_block in path and path.index(join_block) > i and path.index(join_block) < path.index(predecessor):
                continue
            cond = block.cond
            if path[i + 1] is block.false_edge:
                cond = ast.UnaryOp(ast.Invert(), cond)
            conds.add(astor.to_source(cond).rstrip())
        if block == predecessor:
            break

    if not conds:
        return "1"
    result = None
    for cond in conds:
        if result is None:
            result = cond
        else:
            result = f"({result}) & ({cond})"
    return result


def convert_to_ssa(cfg):
    yield_to_paths_map = defaultdict(lambda: [])
    for path in cfg.paths:
        yield_to_paths_map[path[-1]].append(path)

    processed = set()
    var_to_curr_id_map = defaultdict(lambda: 0)
    for end_yield, paths in yield_to_paths_map.items():
        blocks_to_process = []
        for path in paths:
            if isinstance(path[0], HeadBlock) and path[0] not in blocks_to_process:
                blocks_to_process.append(path[0])
            elif all(isinstance(edge, Yield) or edge in blocks_to_process for edge, _ in path[1].incoming_edges):
                if path[1] not in blocks_to_process:
                    blocks_to_process.append(path[1])
        while blocks_to_process:
            block = blocks_to_process.pop(0)
            if block in processed:
                continue
            processed.add(block)
            loads = []

            block._ssa_stores = {}
            phi_vars = set()
            if len(block.incoming_edges) == 1:
                predecessor, _ = next(iter(block.incoming_edges))
                if isinstance(predecessor, (HeadBlock, Yield)):
                    for var in block.live_ins:
                        if var in cfg.sub_coroutines:
                            continue
                        ssa_var = f"{var}_{var_to_curr_id_map[var]}"
                        var_to_curr_id_map[var] += 1
                        width = cfg.width_table[var]
                        cfg.width_table[ssa_var] = width
                        if isinstance(width, MemoryType):
                            continue
                            for i in range(width.height):
                                loads.append(parse_stmt(f"{ssa_var}[{i}] = {var}[{i}]"))
                        else:
                            loads.append(parse_stmt(f"{ssa_var} = {var}"))
                        block._ssa_stores[var] = ssa_var
                else:
                    for store, value in predecessor._ssa_stores.items():
                        if store not in block._ssa_stores:
                            block._ssa_stores[store] = value
            elif len(block.incoming_edges) > 1:
                for var in block.live_ins:
                    if var in cfg.sub_coroutines:
                        continue
                    to_mux = []
                    phi_values = []
                    phi_conds = []
                    for predecessor, _ in block.incoming_edges:
                        if var in predecessor.live_outs:
                            if isinstance(cfg.width_table[var], MemoryType):
                                continue
                            conds = set()
                            conds = {}
                            for path in cfg.paths:
                                if predecessor in path and block in path[1:] and path.index(predecessor) == path[1:].index(block):
                                    these_conds = get_conds_up_to(path, predecessor, cfg)
                                    if these_conds not in conds:
                                        conds[these_conds] = set()
                                    conds[these_conds].add(path[0].yield_id)
                            if not conds:
                                # not in valid path
                                continue
                            expanded_conds = []
                            for cond, yields in conds.items():
                                # If not in all yields
                                if len(yields) < cfg.curr_yield_id - 1:
                                    cond = cond + " & " + "(" + " | ".join(f"(yield_state == {i})" for i in yields) + ")"
                                expanded_conds.append(cond)
                            conds = [ast.parse(cond) for cond in expanded_conds]
                            if len(conds) > 1:
                                phi_conds.append(ast.BoolOp(ast.Or(), conds))
                            else:
                                phi_conds.extend(conds)
                            phi_vars.add(var)
                            if isinstance(predecessor, (HeadBlock, Yield)):
                                ssa_var = f"{var}_{var_to_curr_id_map[var]}"
                                var_to_curr_id_map[var] += 1
                                width = cfg.width_table[var]
                                if isinstance(width, MemoryType):
                                    continue
                                    for i in range(width.height):
                                        loads.append(parse_stmt(f"{ssa_var}[{i}] = {var}[{i}]"))
                                else:
                                    loads.append(parse_stmt(f"{ssa_var} = {var}"))
                                cfg.width_table[ssa_var] = width
                                block._ssa_stores[var] = ssa_var
                                phi_values.append(f"{ssa_var}")
                            else:
                                to_mux.append(predecessor)
                                phi_values.append(f"{predecessor._ssa_stores[var]}")

                    if not phi_conds:
                        continue
                    ssa_var = f"{var}_{var_to_curr_id_map[var]}"
                    var_to_curr_id_map[var] += 1
                    width = cfg.width_table[var]
                    if isinstance(width, MemoryType):
                        continue
                        for i in range(width.height):
                            _phi_values = [f"{val}[{i}]" for val in phi_values]
                            if all(x == phi_values[0] for x in phi_values):
                                loads.append(parse_stmt(f"{ssa_var}[{i}] = {phi_values[0]}[{i}]"))
                            else:
                                loads.append(parse_stmt(f"{ssa_var}[{i}] = phi([{', '.join(astor.to_source(cond).rstrip() for cond in phi_conds)}], [{', '.join(_phi_values)}])"))
                    else:
                        if all(x == phi_values[0] for x in phi_values):
                            loads.append(parse_stmt(f"{ssa_var} = {phi_values[0]}"))
                        else:
                            loads.append(parse_stmt(f"{ssa_var} = phi([{', '.join(astor.to_source(cond).rstrip() for cond in phi_conds)}], [{', '.join(phi_values)}])"))
                    block._ssa_stores[var] = ssa_var
                    cfg.width_table[ssa_var] = width
                    for predecessor, _ in block.incoming_edges:
                        if not isinstance(predecessor, (HeadBlock, Yield)):
                            for store, value in predecessor._ssa_stores.items():
                                if store not in block._ssa_stores:
                                    block._ssa_stores[store] = value

            replacer = Replacer(var_to_curr_id_map, block._ssa_stores, cfg.width_table, cfg.sub_coroutines)
            if isinstance(block, (BasicBlock, HeadBlock)):
                for statement in block.statements:
                    replacer.visit(statement)
                arrays_loaded = set()
                for (ssa_var, index), (value, var) in replacer.array_stores.items():
                    index_hash = "_".join(ast.dump(i) for i in index)
                    count = replacer.index_map[index_hash]
                    if ssa_var not in arrays_loaded:
                        width = cfg.width_table[var]
                        if isinstance(width, MemoryType):
                            continue
                            for i in range(width.height):
                                loads.append(parse_stmt(f"{ssa_var}[{i}] = {block._ssa_stores[var]}[{i}]"))
                        else:
                            loads.append(parse_stmt(f"{ssa_var} = {block._ssa_stores[var]}"))
                        arrays_loaded.add(ssa_var)
                        block._ssa_stores[var] = ssa_var
                        var_to_curr_id_map[var] += 1
                        cfg.width_table[ssa_var] = cfg.width_table[var]
                    index_str = ""
                    for i in index:
                        index_str = f"[{astor.to_source(i).rstrip()}]" + index_str
                    var = ssa_var + f"_si_tmp_val_{value}_i{count}"
                    block.statements.append(ast.parse(f"{ssa_var}{index_str} = {var}").body[0])
                block.statements = loads + block.statements
            elif isinstance(block, Branch):
                block.cond = replacer.visit(block.cond)

            if isinstance(block, (Yield, Branch)):
                if loads:
                    new_block = BasicBlock()
                    new_block.statements = loads
                    new_block.live_outs = copy.copy(block.live_outs)
                    new_block._ssa_stores = copy.copy(block._ssa_stores)
                    processed.add(new_block)
                    cfg.blocks.append(new_block)
                    for edge, label in block.incoming_edges:
                        edge.outgoing_edges.remove((block, label))
                        edge.outgoing_edges.add((new_block, label))
                        if isinstance(edge, Branch):
                            if edge.true_edge is block:
                                edge.true_edge = new_block
                            elif edge.false_edge is block:
                                edge.false_edge = new_block
                        new_block.incoming_edges.add((edge, label))
                    block.incoming_edges = {(new_block, "")}
                    new_block.outgoing_edges = {(block, "")}
                    for path in cfg.paths:
                        if block in path[1:]:
                            idx = path[1:].index(block)
                            path.insert(1 + idx, new_block)
                            assert path[1 + idx] == new_block
                            assert path[1 + idx + 1] == block
                if isinstance(block, Yield):
                    for var in block.live_ins:
                        if var in cfg.sub_coroutines:
                            continue
                        if isinstance(cfg.width_table[var], MemoryType):
                            continue
                        # new_block.statements.append(parse_stmt(f"{var} = {block._ssa_stores[var]}"))
                        block.stores[block._ssa_stores[var]] = var
            for successor, _ in block.outgoing_edges:
                if successor in processed or successor in blocks_to_process:
                    continue
                if all(isinstance(edge, Yield) or edge in processed for edge, _ in successor.incoming_edges):
                    blocks_to_process.append(successor)
    for block in cfg.blocks:
        assert block in processed, processed
    return var_to_curr_id_map
