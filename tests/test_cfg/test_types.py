import ast
from orderedset import OrderedSet

def test_Block():
    from silica.cfg.types import Block

    b = Block()
    assert len(b.incoming_edges) == 0
    assert len(b.outgoing_edges) == 0
    assert isinstance(b.incoming_edges, OrderedSet)
    assert isinstance(b.outgoing_edges, OrderedSet)

    get_item_from_set = lambda _set: next(iter(_set))
    c = Block()
    b.add_outgoing_edge(c)
    assert get_item_from_set(b.outgoing_edges) == (c, "")

    d = Block()
    d.add_incoming_edge(b, "F")
    assert get_item_from_set(d.incoming_edges) == (b, "F")


def test_BasicBlock():
    from silica.cfg.types import BasicBlock, Block
    a = BasicBlock()
    assert isinstance(a, Block)
    assert isinstance(a.statements, list)
    assert len(a.statements) == 0

    a.add("Test")
    assert len(a.statements) == 1
    assert a.statements[0] == "Test"


def test_Branch():
    from silica.cfg.types import Branch, Block
    a = Branch(ast.parse("if cond: pass").body[0])
    assert isinstance(a, Block)
    assert isinstance(a.cond, ast.Name)
    assert a.cond.id == "cond"
    assert a.false_edge is None
    assert a.true_edge is None

    b = Block()
    a.add_false_edge(b)
    assert a.false_edge is b
    a.add_true_edge(b)
    assert a.true_edge is b

def test_Yield():
    from silica.cfg.types import Block, Yield
    y = Yield(ast.parse("(A, B)").body[0].value, {})
    assert isinstance(y, Block)

