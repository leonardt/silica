from silica.transformations.desugar_yield_from_range import desugar_yield_from_range
import astor
import ast

def test():
    tree = ast.parse("yield from range(0, 15)")
    print(ast.dump(tree))
    tree, loopvars = desugar_yield_from_range(tree)
    assert len(loopvars) == 1
    assert next(iter(loopvars)) == ("____x0", (15).bit_length())
    expected = """for ____x0 in range(0, 15):
    yield
"""
    assert expected == astor.to_source(tree)
