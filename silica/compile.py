import ast

from silica.coroutine import Coroutine
from silica.cfg import ControlFlowGraph
from silica.ast_utils import get_ast


def compile(coroutine):
    if not isinstance(coroutine, Coroutine):
        raise ValueError("silica.compile expects a silica.Coroutine")
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    print(ast.dump(tree))
    cfg = ControlFlowGraph(tree)
    # cfg.render()
    # raise NotImplementedError()
