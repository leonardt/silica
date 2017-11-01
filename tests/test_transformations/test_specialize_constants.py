from silica.transformations import specialize_constants
import ast
import astor


def test1():
    tree = ast.parse("""def test_func():
        for i in range(0, x * y - 1):
            print(i + y * 100)""")
    tree = specialize_constants(tree, {"x": 100, "y": 20})
    expected = """def test_func():
    for i in range(0, 100 * 20 - 1):
        print(i + 20 * 100)
"""
    assert astor.to_source(tree) == expected


# def test_mul_by_0():
#     tree = ast.parse("y * 0")
#     tree = specialize_constants(tree, {"x": 100})
#     assert astor.to_source(tree).rstrip() == "0"

# def test_add_by_0():
#     tree = ast.parse("(a + 0) - (0 + b)")
#     tree = specialize_constants(tree, {"x": 100})
#     assert astor.to_source(tree).rstrip() == "a - b"
