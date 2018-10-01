"""
Class definitions for nodes in the CFG
"""
import ast

class Block:
    def __init__(self):
        self.outgoing_edges = set()
        self.incoming_edges = set()
        self.live_outs = set()
        self.live_ins = set()
        self.gen = set()
        self.kill = set()

    def add_outgoing_edge(self, sink, label=""):
        self.outgoing_edges.add((sink, label))

    def add_incoming_edge(self, source, label=""):
        self.incoming_edges.add((source, label))

    @property
    def outgoing_edge(self):
        assert len(self.outgoing_edges) == 1
        return next(iter(self.outgoing_edges))


class HeadBlock(Block):
    def __init__(self):
        super().__init__()
        self.initial_statements = []

    def add(self, stmt):
        self.initial_statements.append(stmt)

    def __iter__(self):
        return iter(self.initial_statements)


class BasicBlock(Block):
    def __init__(self):
        super().__init__()
        self.statements = []

    def add(self, stmt):
        self.statements.append(stmt)

    def __iter__(self):
        return iter(self.statements)



class Branch(Block):
    def __init__(self, cond):
        super().__init__()
        self.cond = cond
        self.true_edge = None
        self.false_edge = None

    def add_false_edge(self, sink):
        self.false_edge = sink

    def add_true_edge(self, sink):
        self.true_edge = sink


class Yield(Block):
    def __init__(self, value, output_map={}, array_stores_to_process=[]):
        super().__init__()
        self.value = value
        self.output_map = output_map
        self.array_stores_to_process = array_stores_to_process

    @property
    def is_initial_yield(self):
        return (isinstance(self.value, ast.Yield) \
                and self.value.value is None \
                or isinstance(self.value, ast.Assign) \
                and isinstance(self.value.value, ast.Yield) \
                and self.value.value.value is None)


class State:
    def __init__(self, start_yield_id, end_yield_id, path):
        self.start_yield_id = start_yield_id
        self.end_yield_id = end_yield_id
        self.conds = []
        self.statements = []
        self.start_yield_ids = [start_yield_id]
        self.path = path
        # self.statements.append(ast.Assign(
        #     [ast.Name("yield_state", ast.Store())],
        #     ast.Num(end_yield_id)
        # ))
