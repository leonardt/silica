"""
Silica's Control Flow Graph (CFG)

TODO: We need an explicit HeadBlock object?
"""
import tempfile
from copy import deepcopy

import ast
import astor
import magma

from silica.transformations import specialize_constants, replace_symbols, constant_fold
from silica.visitors import collect_names
from silica.cfg.types import BasicBlock, Yield, Branch, HeadBlock, State


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


class ControlFlowGraph:
    """
    Params:
        * ``tree`` - an instance of ``ast.FunctionDef``

    Fields:
        * ``self.curr_block`` - the current block used by the construction
          algorithm
    """
    def __init__(self, tree):
        self.blocks = []
        self.curr_block = None
        self.curr_yield_id = 1
        self.local_vars = set()

        # inputs, outputs = parse_arguments(tree.args.args)
        inputs, outputs = get_io(tree)
        self.build(tree)
        self.bypass_conds()
        try:
            self.paths = self.collect_paths_between_yields()
        except RecursionError as error:
            # Most likely infinite loop in CFG, TODO: should catch this with an analysis phase
            self.render()
            raise error
        self.paths = promote_live_variables(self.paths)
        self.states, self.state_vars = build_state_info(self.paths, outputs, inputs)

        # self.render()
        # render_paths_between_yields(self.paths)
        # render_fsm(self.states)
        # exit()

    def build(self, func_def):
        """
        Called by ``__init__`` to actually construct the CFG
        TODO: Should self.local_vars logic be in here?
        """
        assert isinstance(func_def, ast.FunctionDef)
        self.head_block = HeadBlock()
        self.blocks.append(self.head_block)
        self.curr_block = self.gen_new_block()
        add_edge(self.head_block, self.curr_block)
        self.head_block.initial_statements = func_def.body[:-1]

        # for statement in self.initial_statements:
        #     if isinstance(statement, ast.Assign) and isinstance(statement.value, ast.Call) and \
        #        isinstance(statement.value.func, ast.Name) and statement.value.func.id == "Register":
        #         assert isinstance(statement.targets[0], ast.Name) and len(statement.targets) == 1
        #         self.local_vars.add((statement.targets[0].id, statement.value.args[0].n))
        #     else:
        #         raise NotImplementedError()
        assert isinstance(func_def.body[-1], ast.While), "FSMs should end with a ``while True:``"
        self.process_stmt(func_def.body[-1])
        self.consolidate_empty_blocks()
        self.remove_if_trues()


    def find_paths(self, block):
        """
        Given a block, recursively build paths to yields
        """
        if isinstance(block, Yield):
            return [[deepcopy(block)]]
        elif isinstance(block, BasicBlock):
            return [[deepcopy(block)] + path for path in self.find_paths(block.outgoing_edge[0])]
        elif isinstance(block, Branch):
            true_paths = [[deepcopy(block)] + path for path in self.find_paths(block.true_edge)]
            false_paths = [[deepcopy(block)] + path for path in self.find_paths(block.false_edge)]
            for path in true_paths:
                path[0].true_edge = path[1]
            for path in false_paths:
                path[0].false_edge = path[1]
            return true_paths + false_paths
        else:
            raise NotImplementedError(type(block))

    def collect_paths_between_yields(self):
        """
        For each block, if it's a Yield (or HeadBlock): TODO: HeadBlock is confusing
            Add a path for each path returned from calling ``self.find_paths`` on
            the outgoing edge
        """
        paths = []
        for block in self.blocks:
            if isinstance(block, (Yield, HeadBlock)):
                paths.extend([block] + path for path in self.find_paths(block.outgoing_edge[0]))
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
                if eval(astor.to_source(cond)):
                    # FIXME: Interface violation, need a remove method from blocks
                    block.outgoing_edges = {(branch.true_edge, "")}
                else:
                    block.outgoing_edges = {(branch.false_edge, "")}
            except NameError:
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

    def add_new_yield(self, value):
        """
        Adds a new ``Yield`` block to the CFG and connects ``self.curr_block``
        to it.  

        Then adds a new ``BasicBlock`` to the CFG via ``add_new_block`` and
        adds an edge from the new ``Yield`` block to this new ``BasicBlock``.
        """
        old_block = self.curr_block
        self.curr_block = Yield(value)
        add_edge(old_block, self.curr_block)
        self.blocks.append(self.curr_block)
        # We need unique ids for each yield in the current cfg
        self.curr_block.yield_id = self.curr_yield_id
        self.curr_yield_id += 1

        self.add_new_block()

    def add_new_branch(self, cond):
        """
        Adds a new ``Branch`` node with the condition ``cond`` to the CFG and
        connects the current block to it

        Generates a new ``BasicBlock`` corresponding to the True edge of the
        branch and sets ``self.curr_block`` to this new block. 

        Returns the new Branch node so that the calling code can later on add a
        false edge if necessary
        """
        old_block = self.curr_block
        # First we create an explicit branch node
        self.curr_block = Branch(cond)
        self.blocks.append(self.curr_block)
        add_edge(old_block, self.curr_block)
        branch = self.curr_block
        # Then we add a basic block for the true edge
        self.curr_block = self.gen_new_block()
        add_true_edge(branch, self.curr_block)
        # Note we add the block for the false edge later
        # TODO: This is confusing, can we make it simpler?
        return branch

    def process_stmt(self, stmt):
        """
        Adds ``stmt`` to the CFG
        If stmt is a:
            * While or If - Adds a branch node, and basic blocks for the true and false edges
            * Yield - Adds a yield node
        Otherwise appends stmt to the current basic block
        """
        if isinstance(stmt, (ast.While, ast.If)):
            # Emit new blocks for the branching instruction
            branch = self.add_new_branch(stmt.test)
            # stmt.body holds the True path for both If and While nodes
            for sub_stmt in stmt.body:  
                self.process_stmt(sub_stmt)
            if isinstance(stmt, ast.While):
                # Exit the current basic block by looping back to the branch
                # node
                add_edge(self.curr_block, branch)
                # Generate a new basic block and set the false edge of the
                # branch to the new basic block (exiting the loop)
                self.curr_block = self.gen_new_block()
                add_false_edge(branch, self.curr_block)
            elif isinstance(stmt, (ast.If,)):
                end_then_block = self.curr_block
                if stmt.orelse:
                    self.curr_block = self.gen_new_block()
                    add_false_edge(branch, self.curr_block)
                    for sub_stmt in stmt.orelse:
                        self.process_stmt(sub_stmt)
                    end_else_block = self.curr_block
                self.curr_block = self.gen_new_block()
                add_edge(end_then_block, self.curr_block)
                if stmt.orelse:
                    add_edge(end_else_block, self.curr_block)
                else:
                    add_false_edge(branch, self.curr_block)
        elif isinstance(stmt, ast.Expr):
            if isinstance(stmt.value, ast.Yield):
                self.add_new_yield(stmt.value.value)
            elif isinstance(stmt.value, ast.Str):
                # Docstring, ignore
                pass
            else:  # pragma: no cover
                self.curr_block.add(stmt)
                # raise NotImplementedError(stmt.value)
        elif isinstance(stmt, ast.Assign):
            if isinstance(stmt.value, ast.Yield):
                self.add_new_yield(stmt)
            else:
                self.curr_block.add(stmt)
        else:
            # Append a normal statement to the current block
            self.curr_block.add(stmt)

    def remove_block(self, block):
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
                else:
                    assert not block.outgoing_edges
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
                self.remove_block(block)
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
                label = "yield " + astor.to_source(block.value)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                label += "\nGen  : " + str(block.gen)
                label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "oval"})
            elif isinstance(block, BasicBlock):
                label = "\n".join(astor.to_source(stmt) for stmt in block.statements)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                label += "\nGen  : " + str(block.gen)
                label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "box"})
            elif isinstance(block, HeadBlock):
                label = "Initial"
                dot.node(str(id(block)) + "_start", label.rstrip(), {"shape": "doublecircle"})
                label = "\n".join(astor.to_source(stmt).rstrip() for stmt in block.initial_statements)
                # label += "\nLive Ins  : " + str(block.live_ins)
                # label += "\nLive Outs : " + str(block.live_outs)
                label += "\nGen  : " + str(block.gen)
                label += "\nKill : " + str(block.kill)
                dot.node(str(id(block)), label.rstrip(), {"shape": "box"})
                dot.edge(str(id(block)) + "_start", str(id(block)))
            else:
                raise NotImplementedError(type(block))
        # for source, sink, label in self.edges:
            for sink, label in block.outgoing_edges:
                dot.edge(str(id(block)), str(id(sink)), label)


        file_name = tempfile.mktemp("gv")
        dot.render(file_name, view=True)
        # print(file_name)
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
            if isinstance(stmt.value, ast.Num) and len(stmt.targets) == 1:
                if isinstance(stmt.targets[0], ast.Name):
                    constant_assigns[stmt.targets[0].id] = stmt.value.n
                else:
                    # TODO: This should already be guaranteed by a type checker
                    assert stmt.targets[0].name in constant_assigns, \
                           "Assigned to multiple constants"
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
            start_yield_id = 0
        else:
            start_yield_id = path[0].yield_id
        end_yield_id = path[-1].yield_id
        state = State(start_yield_id, end_yield_id)
        for i in range(0, len(path)):
            block = path[i]
            if isinstance(block, Branch):
                cond = block.cond
                if path[i + 1] is block.false_edge:
                    cond = ast.Call(ast.Name("not_", ast.Load()), [cond], [])
                names = collect_names(cond)
                for name in names:
                    if outputs and name not in outputs and \
                       inputs and name not in inputs:
                        state_vars.update(names)
                state.conds.append(cond)
            elif isinstance(block, BasicBlock):
                state.statements.extend(block.statements)
            elif isinstance(block, HeadBlock):
                state.statements.extend(block.initial_statements)
        states.append(state)
    return states, state_vars

