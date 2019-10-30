"""
Silica's Control Flow Graph (CFG)

TODO: We need an explicit HeadBlock object?

"""
import tempfile
from copy import deepcopy, copy

import ast
import astor
import magma
import constraint

import silica
from silica.transformations import specialize_constants, replace_symbols, constant_fold
from silica.visitors import collect_names, collect_stores, collect_loads
from silica.cfg.types import BasicBlock, Yield, Branch, HeadBlock, State
from silica.cfg.ssa import SSAReplacer, convert_to_ssa, parse_expr
from .liveness import liveness_analysis
from .util import find_branch_join
from ..memory import MemoryType
import silica.ast_utils as ast_utils

def get_constant(node):
    if isinstance(node, ast.Num):
        return node.n
    elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
         node.func.id in {"bits", "uint", "bit"}:
        return get_constant(node.args[0])
    elif isinstance(node, ast.NameConstant):
        return int(node.value)


def parse_arguments(arguments):
    """
    arguments : a list of ast.arg nodes each annotated with a magma In or Out type

    return    : a tuple (inputs, outputs), where inputs and outputs sets of
                strings containing the input and output arguments respectively
    """
    outputs = set()
    inputs = set()
    for arg in arguments:
        _type = eval(astor.to_source(arg.annotation), globals(), magma.__dict__)()
        if _type.isoutput():
            outputs.add(arg.arg)
        else:
            assert _type.isinput()
            inputs.add(arg.arg)
    return inputs, outputs


def add_edge(source, sink, label=""):
    """
    Add an edge between source and sink with label
    """
    source.add_outgoing_edge(sink, label)
    sink.add_incoming_edge(source, label)


def add_true_edge(source, sink):
    """
    Add an edge form source to sink with label="T" and set the ``true_edge``
    attribute on source
    """
    assert isinstance(source, Branch)
    source.add_outgoing_edge(sink, "T")
    source.true_edge = sink
    sink.add_incoming_edge(source, "T")


def add_false_edge(source, sink):
    """
    Add an edge from source to sink with label="F" and set the ``false_edge``
    attribute on source
    """
    assert isinstance(source, Branch)
    source.add_outgoing_edge(sink, "F")
    source.false_edge = sink
    sink.add_incoming_edge(source, "F")


class IOCollector(ast.NodeVisitor):
    def __init__(self):
        self.inputs = None
        self.outputs = None

    def visit_Expr(self, node):
        if isinstance(node.value, ast.Yield):
            if isinstance(node.value.value, ast.Tuple):
                outputs = [value.id for value in node.value.value.elts]
                if self.outputs is None:
                    self.outputs = outputs
                else:
                    assert self.outputs == outputs

    def run(self, tree):
        self.visit(tree)
        return self.inputs, self.outputs


def get_io(tree):
    return IOCollector().run(tree)


def get_stores_on_branch(curr_block, join_block, var_counter):
    stores = set()
    while curr_block != join_block:
        if isinstance(curr_block, BasicBlock):
            for statement in curr_block.statements:
                stores |= collect_names(statement, ast.Store)
            curr_block = curr_block.outgoing_edge[0]
        elif isinstance(curr_block, Yield):
            stores |= collect_names(curr_block.value, ast.Store)
            curr_block = curr_block.outgoing_edge[0]
        elif isinstance(curr_block, Branch):
            inner_join_block = find_branch_join(curr_block)
            stores |= get_stores_on_branch(curr_block.true_edge, inner_join_block, var_counter)
            stores |= get_stores_on_branch(curr_block.false_edge, inner_join_block, var_counter)
            # insert_phi_node(curr_block, inner_join_block, var_counter)
            curr_block = inner_join_block
    return stores


def update_var(var, curr_var, curr_block, join_block, var_counter):
    while curr_block != join_block:
        if isinstance(curr_block, BasicBlock):
            for statement in curr_block.statements:
                if var in collect_names(statement, ast.Store):
                    if var not in var_counter:
                        var_counter[var] = -1
                    var_counter[var] += 1
                    curr_var = f"{var}_{var_counter[var]}"
                    replace_symbols(statement, {var: ast.Name(curr_var, ast.Store())}, ast.Store)
                elif var in collect_names(statement, ast.Load):
                    replace_symbols(statement, {var: ast.Name(curr_var, ast.Load())}, ast.Load)
            curr_block = curr_block.outgoing_edge[0]
        elif isinstance(curr_block, Yield):
            replace_symbols(curr_block.value, {var: ast.Name(curr_var, ast.Load())})
            curr_block = curr_block.outgoing_edge[0]
        elif isinstance(curr_block, Branch):
            if var in collect_names(curr_block.cond, ast.Load):
                replace_symbols(curr_block.cond, {var: ast.Name(curr_var, ast.Load())}, ast.Load)
            inner_join_block = find_branch_join(curr_block)
            update_var(var, var, curr_block.true_edge, inner_join_block, var_counter)
            update_var(var, var, curr_block.false_edge, inner_join_block, var_counter)
            # if getattr(curr_block, "phi_inserted", False):
            #     insert_phi_node(curr_block, inner_join_block, var_counter)
            curr_block = inner_join_block


def insert_phi_node(block, join_block, var_counter):
    block.phi_inserted = True
    true_stores = get_stores_on_branch(block.true_edge, join_block, var_counter)
    false_stores = get_stores_on_branch(block.false_edge, join_block, var_counter)
    for var in true_stores | false_stores:
        if var in true_stores:
            update_var(var, var, block.true_edge, join_block, var_counter)
            new_true_var = f"{var}_{var_counter[var]}"
        else:
            new_true_var = var
        if var in false_stores:
            update_var(var, var, block.false_edge, join_block, var_counter)
            new_false_var = f"{var}_{var_counter[var]}"
        else:
            new_false_var = var
        join_block.statements.insert(0, ast.parse(f"{var} = phi({new_true_var}, {new_false_var})"))


class ControlFlowGraph:
    """
    Params:
        * ``tree`` - an instance of ``ast.FunctionDef``

    Fields:
        * ``self.curr_block`` - the current block used by the construction
          algorithm
    """
    def __init__(self, tree, width_table, func_locals, func_globals,
                 sub_coroutines, strategy):
        self.blocks = []
        self.curr_block = None
        self.curr_yield_id = 0
        self.local_vars = set()
        self.width_table = width_table
        self.func_locals = func_locals
        self.breaks = []
        self.continues = []

        # inputs, outputs = parse_arguments(tree.args.args)
        inputs, outputs = get_io(tree)
        self.build(tree)
        # for var in self.replacer.id_counter:
        #     width = self.width_table[var]
        #     for i in range(self.replacer.id_counter[var] + 1):
        #         self.width_table[f"{var}_{i}"] = width
        self.bypass_conds()
        # replacer = SSAReplacer()
        # var_counter = {}
        # for block in self.blocks:
            # if isinstance(block, (HeadBlock, BasicBlock)):
            #     replacer.process_block(block)
            #if isinstance(block, Branch):
            #    join_block = find_branch_join(block)
            #    insert_phi_node(block, join_block, var_counter)
            # elif isinstance(block, Yield):
            #     replacer.visit(block.value)
        try:
            self.paths_between_yields = self.paths = self.collect_paths_between_yields()
        except RecursionError as error:
            # Most likely infinite loop in CFG, TODO: should catch this with an analysis phase
            self.render()
            raise error
        self.adjust_yield_ids()
        self.sub_coroutines = sub_coroutines
        # for node in self.paths[0][:-1]:
        #     if isinstance(node, HeadBlock):
        #         for statement in node:
        #             if ast_utils.is_call(statement.value) and ast_utils.is_name(statement.value.func) and statement.value.func.id == "coroutine_create":
        #                 self.sub_coroutines.append(statement.targets[0].id)
        # self.paths = promote_live_variables(self.paths)
        liveness_analysis(self)
        # render_paths_between_yields(self.paths)
        if strategy == "by_statement":
            self.ssa_var_to_curr_id_map = convert_to_ssa(self)
        # self.render()
        self.states, self.state_vars = build_state_info(self.paths, outputs, inputs)


        # self.registers = set()
        # for path in self.paths:
        #     for block in path:
        #         if isinstance(block, (HeadBlock, Yield)):
        #             loads = self.collect_loads_before_yield(block.outgoing_edge[0], set())
        #             for load in loads:
        #                 if load in block.live_ins and "_si_tmp_val_" not in load:
        #                     prefix = "_".join(load.split("_")[:-1])
        #                     self.registers.add(prefix)
        #                     block.loads[load] = prefix

        # for path in self.paths:
        #     for block in path:
        #         if isinstance(block, Yield):
        #             stores = set()
        #             for edge, _ in block.incoming_edges:
        #                 stores |= self.collect_stores_after_yield(edge, set())
        #             for store in stores:
        #                 prefix = "_".join(store.split("_")[:-1])
        #                 for path2 in self.paths:
        #                     for block2 in path2:
        #                         if isinstance(block2, Yield):
        #                             if prefix in block2.loads.values():
        #                                 store_id = -1
        #                                 for store in stores:
        #                                     try:
        #                                         if prefix in store and "_si_tmp_val_" not in store:
        #                                             store_id = max(int(store.split("_")[-1]), store_id)
        #                                     except ValueError:
        #                                         pass
        #                                 if store_id < 0:
        #                                     store_id = 0
        #                                 block.stores[prefix + "_" + str(store_id)] = prefix
        #                                 break

        # self.render()
        # render_fsm(self.states)
        # exit()

    def build(self, func_def):
        """
        Called by ``__init__`` to actually construct the CFG
        TODO: Should self.local_vars logic be in here?
        """
        assert isinstance(func_def, ast.FunctionDef)
        self.head_block = HeadBlock()
        self.head_block.yield_id = -1
        self.blocks.append(self.head_block)
        self.curr_block = self.head_block
        # self.curr_block = self.gen_new_block()
        # add_edge(self.head_block, self.curr_block)

        # for statement in self.initial_statements:
        #     if isinstance(statement, ast.Assign) and isinstance(statement.value, ast.Call) and \
        #        isinstance(statement.value.func, ast.Name) and statement.value.func.id == "Register":
        #         assert isinstance(statement.targets[0], ast.Name) and len(statement.targets) == 1
        #         self.local_vars.add((statement.targets[0].id, statement.value.args[0].n))
        #     else:
        #         raise NotImplementedError()
        # assert isinstance(func_def.body[-1], ast.While), "FSMs should end with a ``while True:``"
        self.replacer = SSAReplacer(self.width_table)
        for statement in func_def.body:
            self.process_stmt(statement)
        # self.process_stmt(func_def.body[-1])
        self.consolidate_empty_blocks()
        self.remove_if_trues()


    def find_paths(self, block, initial_block, conds=[]):
        """
        Given a block, recursively build paths to yields
        """
        if isinstance(block, Yield):
            if isinstance(block.value, ast.Yield) and block.value.value is None or \
               isinstance(block.value, ast.Assign) and block.value.value.value is None:
                initial_block.initial_yield = block
                return [path for path in self.find_paths(block.outgoing_edge[0], initial_block, conds)]
            else:
                return [[(block)]]
        elif isinstance(block, BasicBlock):
            return [[(block)] + path for path in self.find_paths(block.outgoing_edge[0], initial_block, conds)]
        elif isinstance(block, Branch):
            true_paths = []
            false_paths = []
            for value, paths, edge in [(True, true_paths, block.true_edge),
                                       (False, false_paths, block.false_edge)]:
                _conds = conds[:] + [(block.cond, value)]
                problem = constraint.Problem()
                variables = {}
                constraints = []
                # print("===========")
                seen = set()
                for cond, result in _conds:
                    args = collect_names(cond)
                    for special_func in ["uint", "bit", "bits"]:
                        if special_func in args:
                            args.remove(special_func)
                    for arg in args:
                        if arg in seen:
                            continue
                        seen.add(arg)
                        width = self.width_table[arg]
                        if width is None:
                            width = 1
                        problem.addVariable(arg, range(0, 1 << width))
                        if arg not in variables:
                            variables[arg] = []
                        variables[arg].append(arg)

                        class Wrapper(ast.NodeTransformer):
                            def __init__(self):
                                super().__init__()

                            def visit_Name(self, node):
                                if node.id == arg:
                                    return parse_expr(f"uint({node.id}, {width})")
                                return node

                        cond = Wrapper().visit(deepcopy(cond))
                    _constraint = f"lambda {', '.join(args)}: ({astor.to_source(cond).rstrip()}) == BitVector[1]({result})"
                    # print(_constraint)
                    problem.addConstraint(
                        eval(_constraint, self.func_locals),
                        tuple(args))
                for same in variables.values():
                    if len(same) > 1:
                        _constraint = f"lambda {', '.join(same)}: { ' == '.join(same) }"
                        # print(_constraint)
                        problem.addConstraint(
                            eval(_constraint, self.func_locals),
                            tuple(same))
                # print(problem.getSolution(), value, edge)
                # print("===========")
                if problem.getSolution():
                    # print(edge)
                    paths += [[(block)] + path for path in
                              self.find_paths(edge, initial_block, _conds)]
            # for path in true_paths:
            #     path[0].true_edge = path[1]
            # for path in false_paths:
            #     path[0].false_edge = path[1]
            return true_paths + false_paths
        else:
            raise NotImplementedError(type(block))

    def adjust_yield_ids(self):
        if hasattr(self.head_block, "initial_yield"):
            seen = set()
            for block in self.blocks:
                if isinstance(block, Yield) and block not in seen:
                    block.yield_id -= 1
                    seen.add(block)
            self.curr_yield_id -= 1


    def collect_paths_between_yields(self):
        """
        For each block, if it's a Yield (or HeadBlock): TODO: HeadBlock is confusing
            Add a path for each path returned from calling ``self.find_paths`` on
            the outgoing edge
        """
        paths = []
        for block in self.blocks:
            if isinstance(block, (Yield, HeadBlock)):
                # if isinstance(block, Yield) and block.is_initial_yield:
                #        continue  # Skip initial yield
                paths.extend([block] + path for path in self.find_paths(block.outgoing_edge[0], block, []))
        for path in paths:
            for i in range(len(path) - 1):
                path[i].next = path[i + 1]
            path[-1].next = None
            path[-1].terminal = True
            path[0].terminal = False
        # render_paths_between_yields(paths)
        return paths

    def bypass_conds(self):
        """
        Bypass any conditions that evaluate to ``True``.
        Initially used for the ``if True:`` branch node emitted by
        the top-level ``while True:`` found in FSM definitions.
        """
        for block in self.get_basic_blocks_followed_by_branches():
            constants = collect_constant_assigns(block.statements)
            branch = block.outgoing_edge[0]
            cond = deepcopy(branch.cond)
            cond = specialize_constants(cond, constants)
            try:
                if eval(astor.to_source(cond), silica.operators):
                    # FIXME: Interface violation, need a remove method from blocks
                    branch.true_edge.incoming_edges.add((block, ""))
                    block.outgoing_edges = {(branch.true_edge, "")}
                else:
                    branch.false_edge.incoming_edges.add((block, ""))
                    block.outgoing_edges = {(branch.false_edge, "")}
                branch.incoming_edges.remove((block, ""))
            except NameError as e:
                # print(e)
                pass


    def gen_new_block(self):
        """
        Instantiates a new ``BasicBlock``, appends it to ``self.blocks``, and
        returns it.
        """
        block = BasicBlock()
        self.blocks.append(block)
        return block

    def add_new_block(self):
        """
        Generate a new ``BasicBlock`` via ``self.gen_new_block`` in the CFG and
        add an edge from the ``self.curr_block`` to this new block.

        Sets ``self.curr_block`` to this new ``Basicblock``
        """
        old_block = self.curr_block
        self.curr_block = self.gen_new_block()
        add_edge(old_block, self.curr_block)

    def add_new_yield(self, value, output_map={}, array_stores_to_process=[]):
        """
        Adds a new ``Yield`` block to the CFG and connects ``self.curr_block``
        to it.

        Then adds a new ``BasicBlock`` to the CFG via ``add_new_block`` and
        adds an edge from the new ``Yield`` block to this new ``BasicBlock``.
        """
        old_block = self.curr_block
        self.curr_block = Yield(value, output_map, array_stores_to_process)
        add_edge(old_block, self.curr_block)
        self.blocks.append(self.curr_block)
        # We need unique ids for each yield in the current cfg
        self.curr_block.yield_id = self.curr_yield_id
        self.curr_yield_id += 1

        self.add_new_block()

    def add_new_branch(self, if_node):
        """
        Adds a new ``Branch`` node with the if_node ``if_node`` to the CFG and
        connects the current block to it

        Generates a new ``BasicBlock`` corresponding to the True edge of the
        branch and sets ``self.curr_block`` to this new block.

        Returns the new Branch node so that the calling code can later on add a
        false edge if necessary
        """
        old_block = self.curr_block
        # First we create an explicit branch node
        self.curr_block = Branch(if_node)
        self.blocks.append(self.curr_block)
        add_edge(old_block, self.curr_block)
        branch = self.curr_block
        # Then we add a basic block for the true edge
        self.curr_block = self.gen_new_block()
        add_true_edge(branch, self.curr_block)
        # Note we add the block for the false edge later
        # TODO: This is confusing, can we make it simpler?
        return branch

    def process_branch(self, stmt):
        # orig_array_stores = copy(self.replacer.array_stores)
        # orig_index_map = copy(self.replacer.index_map)
        # Emit new blocks for the branching instruction
        # self.replacer.visit(stmt.test)
        branch = self.add_new_branch(stmt)
        orig_bb = self.curr_block
        # true_stores = set()
        # for sub_stmt in stmt.body:
        #     true_stores |= collect_stores(sub_stmt)
        # phi_vars = {}
        # for var in true_stores:
        #     if var in self.replacer.id_counter:
        #         phi_vars[var] = [None, None]
        # stmt.body holds the True path for both If and While nodes
        # orig_id_counter = copy(self.replacer.id_counter)
        for sub_stmt in stmt.body:
            self.process_stmt(sub_stmt)
        # true_id_counter = copy(self.replacer.id_counter)
        # for var in true_stores:
        #     if var in self.replacer.id_counter and var in phi_vars:
        #         phi_vars[var][0] = f"{var}_{self.replacer.id_counter[var]}"
        if isinstance(stmt, ast.While):
            # for base_var, (true_var, false_var) in phi_vars.items():
            #     if not (isinstance(stmt.test, ast.NameConstant) and stmt.test.value == True):
            #         self.replacer.id_counter[base_var] += 1
            #         if false_var is None:
            #             false_var = f"{base_var}_{self.replacer.id_counter[base_var]}"
            #             self.replacer.id_counter[base_var] += 1

            #         next_var = f"{base_var}_{self.replacer.id_counter[base_var]}"
            #         self.curr_block.statements.append(
            #             # ast.parse(f"{orig_var} = phi({true_var}, {orig_var}, cond={astor.to_source(stmt.test)})").body[0])
            #             ast.parse(f"{next_var} = phi({true_var} if {astor.to_source(stmt.test).rstrip()} else {false_var})").body[0])
            # seen = set()
            # for (name, index), (value, orig_value) in self.replacer.array_stores.items():
            #     index_hash = "_".join(ast.dump(i) for i in index)
            #     count = self.replacer.index_map[index_hash]
            #     if not (name, index) in orig_array_stores or \
            #             orig_index_map[index_hash] < count:
            #         if (name, index, value, count) in self.replacer.array_store_processed:
            #             continue
            #         # if name not in seen:
            #         #     seen.add(name)
            #         #     width = self.width_table[name]
            #         #     if isinstance(width, MemoryType):
            #         #         for i in range(width.height):
            #         #             self.curr_block.append(ast.parse(f"{name}[{i}] = {orig_value}[{i}]").body[0])
            #         #     else:
            #         #         self.curr_block.append(ast.parse(f"{name} = {orig_value}").body[0])
            #         self.replacer.array_store_processed.add((name, index, value, count))
            #         index_str = ""
            #         for i in index:
            #             index_str = f"[{astor.to_source(i).rstrip()}]" + index_str
            #         true_var = name + f"_si_tmp_val_{value}_i{count}"
            #         self.curr_block.statements.append(ast.parse(f"{name}{index_str} = {true_var}").body[0])
            # Exit the current basic block by looping back to the branch
            # node
            add_edge(self.curr_block, branch)
            # Generate a new basic block and set the false edge of the
            # branch to the new basic block (exiting the loop)
            self.curr_block = self.gen_new_block()
            add_false_edge(branch, self.curr_block)
            for break_ in self.breaks:
                add_edge(break_, self.curr_block)
            self.breaks = []
            for continue_ in self.continues:
                add_edge(continue_, branch)
            self.continues = []
        elif isinstance(stmt, (ast.If,)):
            end_then_block = self.curr_block
            # true_counts = {}
            # for (name, index), (value, orig_value) in self.replacer.array_stores.items():
            #     index_hash = "_".join(ast.dump(i) for i in index)
            #     count = self.replacer.index_map[index_hash]
            #     true_counts[name, index] = count
            if stmt.orelse:
                # false_stores = set()
                # for sub_stmt in stmt.orelse:
                #     false_stores |= collect_stores(sub_stmt)
                #     # false_stores |= collect_names(sub_stmt, ast.Store)
                self.curr_block = self.gen_new_block()
                add_false_edge(branch, self.curr_block)
                # load_store_offset = {}
                # for var, value in true_id_counter.items():
                #     if var in orig_id_counter:
                #         diff = value - orig_id_counter[var]
                #         if diff:
                #             load_store_offset[var] = diff
                # self.replacer.load_store_offset = load_store_offset
                for sub_stmt in stmt.orelse:
                    self.process_stmt(sub_stmt)
                # false_id_counter = self.replacer.id_counter
                # for var, diff in load_store_offset.items():
                #     if var in false_stores:
                #         self.replacer.id_counter[var] += diff
                #         self.width_table[f"{var}_{self.replacer.id_counter[var]}"] = self.width_table[var]
                # self.replacer.load_store_offset = {}
                # for var in false_stores:
                #     if var in self.replacer.id_counter and var in phi_vars:
                #         phi_vars[var][1] = f"{var}_{self.replacer.id_counter[var]}"
                end_else_block = self.curr_block
            # seen = set()
            # for (name, index), (value, orig_value) in self.replacer.array_stores.items():
            #     index_hash = "_".join(ast.dump(i) for i in index)
            #     count = self.replacer.index_map[index_hash]
            #     if not (name, index) in orig_array_stores or \
            #             orig_index_map[index_hash] < count:
            #         if (name, index, value, count) in self.replacer.array_store_processed:
            #             continue
            #         # if name not in seen:
            #         #     seen.add(name)
            #         #     width = self.width_table[name]
            #         #     if isinstance(width, MemoryType):
            #         #         for i in range(width.height):
            #         #             self.curr_block.append(ast.parse(f"{name}[{i}] = {orig_value}[{i}]").body[0])
            #         #     else:
            #         #         self.curr_block.append(ast.parse(f"{name} = {orig_value}").body[0])
            #         self.replacer.array_store_processed.add((name, index, value, count))
            #         index_str = ""
            #         for i in index:
            #             index_str = f"[{astor.to_source(i).rstrip()}]" + index_str
            #         true_var = name + f"_si_tmp_val_{value}_i{count}"
            #         self.curr_block.statements.append(ast.parse(f"{name}{index_str} = {true_var}").body[0])
            self.curr_block = self.gen_new_block()
            # for base_var, (true_var, false_var) in phi_vars.items():
            #     self.replacer.id_counter[base_var] += 1
            #     if false_var is None:
            #         false_var = f"{base_var}_{self.replacer.id_counter[base_var]}"
            #         self.replacer.id_counter[base_var] += 1
            #         self.width_table[false_var] = self.width_table[base_var]
            #     next_var = f"{base_var}_{self.replacer.id_counter[base_var]}"
            #     print(next_var)
            #     self.width_table[next_var] = self.width_table[base_var]
            #     width = self.width_table[base_var]
            #     if isinstance(width, MemoryType):
            #         for i in range(width.height):
            #             self.curr_block.append(
            #                 ast.parse(f"{next_var}[{i}] = phi({true_var}[{i}] if {astor.to_source(stmt.test).rstrip()} else {false_var}[{i}])").body[0]
            #             )
            #     else:
            #         self.curr_block.statements.append(
            #             ast.parse(f"{next_var} = phi({true_var} if {astor.to_source(stmt.test).rstrip()} else {false_var})").body[0])

            if end_then_block not in self.breaks + self.continues:
                add_edge(end_then_block, self.curr_block)
            if stmt.orelse:
                if end_else_block not in self.breaks + self.continues:
                    add_edge(end_else_block, self.curr_block)
            else:
                add_false_edge(branch, self.curr_block)

    def process_expr(self, stmt):
        if isinstance(stmt.value, ast.Yield):
            # replacer.visit(stmt.value)
            # if stmt.value is not None:
            #     output = stmt.value.value.id
            #     # self.curr_block.statements.append(ast.parse(f"{output} = {output}_{self.replacer.id_counter[output]}"))
            #     output_map = {output: f"{output}_{self.replacer.id_counter[output]}"}
            # self.add_new_yield(stmt.value, output_map)
            self.add_new_yield(stmt.value)
        elif isinstance(stmt.value, ast.Str):
            # Docstring, ignore
            pass
        else:  # pragma: no cover
            # self.replacer.visit(stmt)
            self.curr_block.add(stmt)
            # raise NotImplementedError(stmt.value)

    def process_assign(self, stmt):
        if isinstance(stmt.value, ast.Yield):
            # output_map = {}
            # if stmt.value.value is not None:
            #     if isinstance(stmt.value.value, ast.Name):
            #         output = stmt.value.value.id
            #         output_map[output] = f"{output}_{self.replacer.id_counter[output]}"
            #         # self.curr_block.statements.append(ast.parse(f"{output} = {output}_{self.replacer.id_counter[output]}"))
            #     elif isinstance(stmt.value.value, ast.Tuple):
            #         for element in stmt.value.value.elts:
            #             output = element.id
            #             # self.curr_block.statements.append(ast.parse(f"{output} = {output}_{self.replacer.id_counter[output]}"))
            #             output_map[output] = f"{output}_{self.replacer.id_counter[output]}"
            #     else:
            #         raise NotImplementedError(stmt.value.value)
            array_stores_to_process = []
            seen = set()
            for (name, index), (value, orig_value) in self.replacer.array_stores.items():
                index_hash = "_".join(ast.dump(i) for i in index)
                count = self.replacer.index_map[index_hash]
                if (name, index, value, count) in self.replacer.array_store_processed:
                    continue
                # if name not in seen:
                #     seen.add(name)
                #     width = self.width_table[name]
                #     if isinstance(width, MemoryType):
                #         for i in range(width.height):
                #             self.curr_block.append(ast.parse(f"{name}[{i}] = {orig_value}[{i}]").body[0])
                #     else:
                #         self.curr_block.append(ast.parse(f"{name} = {orig_value}").body[0])
                index_str = ""
                for i in index:
                    index_str = f"[{astor.to_source(i).rstrip()}]" + index_str
                self.replacer.array_store_processed.add((name, index, value, count))
                true_var = name + f"_si_tmp_val_{value}_i{count}"
                array_stores_to_process.append(
                    ast.parse(f"{name}{index_str} = {true_var}").body[0])
            self.add_new_yield(stmt) #, output_map)
            for var in self.replacer.id_counter:
                self.replacer.id_counter[var] += 1
                self.width_table[f"{var}_{self.replacer.id_counter[var]}"] = self.width_table[var]
        else:
            # self.replacer.visit(stmt)
            self.curr_block.add(stmt)

    def process_stmt(self, stmt):
        """
        Adds ``stmt`` to the CFG
        If stmt is a:
            * While or If - Adds a branch node, and basic blocks for the true and false edges
            * Yield - Adds a yield node
        Otherwise appends stmt to the current basic block
        """
        if isinstance(stmt, (ast.While, ast.If)):
            self.process_branch(stmt)
        elif isinstance(stmt, ast.Expr):
            self.process_expr(stmt)
        elif isinstance(stmt, ast.Assign):
            self.process_assign(stmt)
        elif isinstance(stmt, ast.Break):
            self.breaks.append(self.curr_block)
        elif isinstance(stmt, ast.Continue):
            self.continues.append(self.curr_block)
        else:
            # self.replacer.visit(stmt)
            # Append a normal statement to the current block
            self.curr_block.add(stmt)

    def remove_block(self, block, take_branch=None):
        """
        Removes ``block`` from the control flow graph and collapses incoming
        edges to outgoing edges.
        """
        for source, source_label in block.incoming_edges:
            source.outgoing_edges.remove((block, source_label))
        for sink, sink_label in block.outgoing_edges:
            sink.incoming_edges.remove((block, sink_label))
        for source, source_label in block.incoming_edges:
            if isinstance(source, Branch):
                if len(block.outgoing_edges) == 1:
                    sink, sink_label = list(block.outgoing_edges)[0]
                    add_edge(source, sink, source_label)
                    if source_label == "F":
                        source.false_edge = sink
                    elif source_label == "T":
                        source.true_edge = sink
                    else:  # pragma: no cover
                        assert False
                elif block.outgoing_edges:
                    assert isinstance(block, Branch), "Encountered non branch with more than one out edge"
                    assert take_branch, "Cannot remove branch without knowing which edge to take"
                    if take_branch is True:
                        sink = block.true_edge
                    else:
                        sink = block.false_edge
                    add_edge(source, sink, source_label)
                    if source_label == "F":
                        source.false_edge = sink
                    elif source_label == "T":
                        source.true_edge = sink
                    else:  # pragma: no cover
                        assert False
            else:
                if isinstance(block, Branch):
                    if take_branch is True:
                        sink = block.true_edge
                        add_edge(source, sink)
                    else:
                        sink = block.false_edge
                        add_edge(source, sink)
                else:
                    for sink, sink_label in block.outgoing_edges:
                        add_edge(source, sink, source_label)

    def consolidate_empty_blocks(self):
        """
        Remove any empty basic blocks
        """
        new_blocks = []
        for block in self.blocks:
            if isinstance(block, BasicBlock) and not block.statements:
                self.remove_block(block)
            else:
                new_blocks.append(block)
        self.blocks = new_blocks

    def remove_if_trues(self):
        """
        Remove any if true blocks
        """
        new_blocks = []
        for block in self.blocks:
            if isinstance(block, Branch) and (isinstance(block.cond, ast.NameConstant) \
                    and block.cond.value is True):
                self.remove_block(block, take_branch=True)
            else:
                new_blocks.append(block)
        self.blocks = new_blocks

    def render(self):  # pragma: no cover
        """
        Render the control flow graph using graphviz
        """
        from graphviz import Digraph
        dot = Digraph(name="top")
        for block in self.blocks:
            if isinstance(block, Branch):
                label = "if " + astor.to_source(block.cond)
                dot.node(str(id(block)), label.rstrip(), {"shape": "invhouse"})
            elif isinstance(block, Yield):
                label = astor.to_source(block.value)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "oval"})
            elif isinstance(block, BasicBlock):
                label = "\n".join(astor.to_source(stmt).rstrip() for stmt in block.statements)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "box"})
            elif isinstance(block, HeadBlock):
                label = "Initial"
                dot.node(str(id(block)) + "_start", label.rstrip(), {"shape": "doublecircle"})
                label = "\n".join(astor.to_source(stmt).rstrip() for stmt in block.initial_statements)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "box"})
                dot.edge(str(id(block)) + "_start", str(id(block)))
            else:
                raise NotImplementedError(type(block))
        # for source, sink, label in self.edges:
            for sink, label in block.outgoing_edges:
                dot.edge(str(id(block)), str(id(sink)), label)


        file_name = tempfile.mktemp("gv")
        dot.render(file_name, view=True)
        # with open("cfg.dot", "w") as file:
        #     file.write(dot.source)
        # exit()

    def get_basic_blocks_followed_by_branches(self):
        """
        Returns all the ``BasicBlock`` s in the CFG that are followed by a
        ``Branch``
        """
        is_basicblock_followed_by_branch = \
            lambda block : isinstance(block, BasicBlock) and \
                           isinstance(block.outgoing_edge[0], Branch)
        return filter(is_basicblock_followed_by_branch, self.blocks)


    def collect_loads_before_yield(self, block, seen):
        if isinstance(block, Yield):
            return set()
        if block in seen:
            return set()
        seen.add(block)
        loads = set()
        if isinstance(block, BasicBlock):
            for stmt in block.statements:
                loads |= collect_loads(stmt)
        elif isinstance(block, Branch):
            loads |= collect_loads(block.cond)
        for edge, _ in block.outgoing_edges:
            loads |= self.collect_loads_before_yield(edge, seen)
        return loads


    def collect_stores_after_yield(self, block, seen):
        if isinstance(block, (Yield, HeadBlock)):
            return set()
        if block in seen:
            return set()
        seen.add(block)
        stores = set()
        if isinstance(block, BasicBlock):
            for stmt in block.statements:
                stores |= collect_stores(stmt)
        for edge, _ in block.incoming_edges:
            stores |= self.collect_stores_after_yield(edge, seen)
        return stores


def render_fsm(states):
    from graphviz import Digraph
    dot = Digraph(name="top")
    ids = set(state.start_yield_id for state in states)
    for _id in ids:
        dot.node(str(_id), "state {}".format(_id))
    for state in states:
        label = "Inputs: "
        label += "\n"
        label += "Outputs: "
        # Skip yield state assignment for now
        label += "\n".join(astor.to_source(statement).rstrip() for statement in state.statements[1:])
        dot.edge(str(state.start_yield_id), str(state.end_yield_id), label)
    file_name = tempfile.mktemp("gv")
    dot.render(file_name, view=True)


def render_paths_between_yields(paths):  # pragma: no cover
    """
    Render all the paths between yields using graphviz
    """
    from graphviz import Digraph
    dot = Digraph(name="top")
    for i, path in enumerate(paths):
        prev = None
        for block in path:
            if isinstance(block, Branch):
                label = "if " + astor.to_source(block.cond)
                dot.node(str(i) + str(id(block)), label.rstrip(), {"shape": "invhouse"})
            elif isinstance(block, Yield):
                label = "id: {}\n".format(block.yield_id)
                label += astor.to_source(block.value)
                label += "\nLive Ins  : " + str(block.live_ins)
                label += "\nLive Outs : " + str(block.live_outs)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                dot.node(str(i) + str(id(block)), label.rstrip(), {"shape": "oval"})
            elif isinstance(block, BasicBlock):
                label = "\n".join(astor.to_source(stmt) for stmt in block.statements)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                label += "\nLive Ins  : " + str(block.live_ins)
                label += "\nLive Outs : " + str(block.live_outs)
                dot.node(str(i) + str(id(block)), label.rstrip(), {"shape": "box"})
            elif isinstance(block, HeadBlock):
                label = "Initial"
                dot.node(str(i) + str(id(block)) + "_start", label.rstrip(), {"shape": "doublecircle"})
                label = "\n".join(astor.to_source(stmt).rstrip() for stmt in block.initial_statements)
                if hasattr(block, "initial_yield"):
                    label += "\n" + astor.to_source(block.initial_yield.value)
                label += "\nLive Ins  : " + str(block.live_ins)
                label += "\nLive Outs : " + str(block.live_outs)
                # label += "\nGen  : " + str(block.gen)
                # label += "\nKill : " + str(block.kill)
                dot.node(str(i) + str(id(block)), label.rstrip(), {"shape": "box"})
                dot.edge(str(i) + str(id(block)) + "_start", str(i) + str(id(block)))
            elif isinstance(block, State):
                label = "{}".format(astor.to_source(block.yield_state).rstrip())
                if block.conds:
                    label += " && "
                label += " && ".join(astor.to_source(cond) for cond in block.conds)
                label += "\n"
                label += "\n".join(astor.to_source(statement) for statement in block.statements)
                dot.node(str(i) + str(id(block)), label.rstrip(), {"shape": "doubleoctagon"})
            else:
                raise NotImplementedError(type(block))
            if prev is not None:
                if isinstance(prev, Branch):
                    if block is prev.false_edge:
                        label = "F"
                    else:
                        label = "T"
                else:
                    label = ""
                dot.edge(str(i) + str(id(prev)), str(i) + str(id(block)), label)
            prev = block

    file_name = tempfile.mktemp("gv")
    dot.render(file_name, view=True)

def collect_constant_assigns(statements):
    """
    Collect statements that assign a variable ``var`` to a constant value
    ``c``.

    Returns a dict ``{var : c for each constant assign in statements}``
    """
    constant_assigns = {}
    for stmt in statements:
        if isinstance(stmt, ast.Assign):
            constant = get_constant(stmt.value)
            if constant is not None:
                constant_assigns[stmt.targets[0].id] = constant
    return constant_assigns


def is_assign_to_name(statement):
    """Returns true if statement is of the form ``var = ...``"""
    return isinstance(statement, ast.Assign) and \
           len(statement.targets) == 1 and \
           isinstance(statement.targets[0], ast.Name)


def promote_live_variables(paths):
    """
    Currently silica has blocking assingment semantics. To encode this in the
    CFG, for each path between yields we store the value of writes to a
    variable and promote any subsequents reads of that variable to the written
    value (rather than the value during the previous clock cycle).
    """
    for path in paths:
        symbol_table = {}  # We build a new symbol table for each path
        for block in path:
            if isinstance(block, BasicBlock):
                new_statements = []
                for statement in block.statements:
                    # Replace any symbols currently in the symbol table
                    statement = replace_symbols(statement, symbol_table, ctx=ast.Load)
                    # Fold constants
                    statement = constant_fold(statement)
                    # Update symbol table if the statement is an assign
                    if is_assign_to_name(statement):
                        symbol_table[statement.targets[0].id] = statement.value
                    new_statements.append(statement)
                block.statements = new_statements
            elif isinstance(block, Branch):
                # For branches we just promote in the condition
                block.cond = replace_symbols(block.cond, symbol_table, ctx=ast.Load)
                block.cond = constant_fold(block.cond)
    return paths


__unique_cond_id = -1
def build_state_info(paths, outputs, inputs):
    """
    Constructs a ``State`` object for each path in paths.

    Returns a 2 element tuple of:
        list of State objects
        set of state variable names
    """
    states = []
    state_vars = {"yield_state"}
    for path in paths:
        if isinstance(path[0], HeadBlock):
            start_yield_id = -1
        else:
            start_yield_id = path[0].yield_id
        end_yield_id = path[-1].yield_id
        state = State(start_yield_id, end_yield_id, path)
        for i in range(0, len(path)):
            block = path[i]
            if isinstance(block, Branch):
                global __unique_cond_id
                __unique_cond_id += 1
                cond = block.cond
                if path[i + 1] is block.false_edge:
                    # cond = ast.Call(ast.Name("not_", ast.Load()), [cond], [])
                    cond = ast.UnaryOp(ast.Invert(), cond)
                else:
                    assert path[i + 1] is block.true_edge
                names = collect_names(cond)
                for name in names:
                    if outputs and name not in outputs and \
                       inputs and name not in inputs:
                        state_vars.update(names)
                # state.statements.append(ast.parse(f"__silica_cond_{__unique_cond_id} = {astor.to_source(cond).rstrip()}").body[0])
                # state.conds.append(ast.parse(f"__silica_cond_{__unique_cond_id}").body[0].value)
                state.conds.append(cond)
                # join_block = find_branch_join(block)
                # skip_cond = True
                # for path_ in paths:
                #     if block in path_ and (join_block not in path_ or path_.index(join_block) < path_.index(block)):
                #         skip_cond = False
                # if not skip_cond:
                #     state.conds.append(cond)
            elif isinstance(block, BasicBlock):
                state.statements.extend(block.statements)
            elif isinstance(block, HeadBlock):
                pass
                # state.statements.extend(block.initial_statements)
        states.append(state)
    return states, state_vars

