from silica.transformations.desugar_for_loops import desugar_for_loops
import astor
import ast

def test_range_one_args():
    tree = ast.parse("""
for x in range(15):
    print(x)
""")
    tree, loopvars = desugar_for_loops(tree)
    expected = """x = 0
while x < 15:
    print(x)
    x = x + 1
"""
    assert expected == astor.to_source(tree)
    assert loopvars == {("x", (15).bit_length())}

def test_range_two_args():
    tree = ast.parse("""
for x in range(0, 15):
    print(x)
""")
    tree, loopvars = desugar_for_loops(tree)
    expected = """x = 0
while x < 15:
    print(x)
    x = x + 1
"""
    assert expected == astor.to_source(tree)
    assert loopvars == {("x", (15).bit_length())}

def test_range_three_args():
    tree = ast.parse("""
for x in range(0, 15, 4):
    print(x)
""")
    tree, loopvars = desugar_for_loops(tree)
    expected = """x = 0
while x < 15:
    print(x)
    x = x + 4
"""
    assert expected == astor.to_source(tree)
    assert loopvars == {("x", (15).bit_length())}

def test_nested_loops():
    tree = ast.parse("""
for x in range(0, 15):
    for y in range(0, 15):
        print(x, y)
""")
    tree, loopvars = desugar_for_loops(tree)
    expected = """x = 0
while x < 15:
    y = 0
    while y < 15:
        print(x, y)
        y = y + 1
    x = x + 1
"""
    assert expected == astor.to_source(tree)
    assert loopvars == {("x", (15).bit_length()), ("y", (15).bit_length())}
