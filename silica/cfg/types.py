"""
Class definitions for nodes in the CFG
"""
import ast

class Block:
    def __init__(self):
        self.outgoing_edges = set()
        self.incoming_edges = set()

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
        self.initial_statements = None


class BasicBlock(Block):
    def __init__(self):
        super().__init__()
        self.statements = []

    def add(self, stmt):
        self.statements.append(stmt)



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
    def __init__(self, value):
        super().__init__()
        self.value = value


class State:
    def __init__(self, start_yield_id, end_yield_id):
        self.start_yield_id = start_yield_id
        self.yield_state = ast.Compare(
            ast.Name("yield_state", ast.Load()),
            [ast.Eq()],
            [ast.Num(start_yield_id)]
        )
        self.end_yield_id = end_yield_id
        self.conds = []
        self.statements = []
        self.statements.append(ast.Assign(
            [ast.Name("yield_state", ast.Store())],
            ast.Num(end_yield_id)
        ))
