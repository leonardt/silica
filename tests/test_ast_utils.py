from silica.ast_utils import *

def test_is_call_true():
    assert is_call(ast.Call(ast.Name("test", ast.Load()), [], []))

def test_is_call_false():
    assert not is_call(ast.Num(3))

def test_get_call_func():
    node = ast.Call(ast.Name("test", ast.Load()), [], [])
    assert get_call_func(node) == "test"

def test_is_name_true():
    assert is_name(ast.Name("test", ast.Load()))

def test_is_name_false():
    assert not is_name(ast.Num(3))

def test_is_subscript_true():
    assert is_subscript(ast.Subscript(ast.Name("test", ast.Load()), ast.Index(ast.Num(3)), ast.Load()))

def test_is_subscript_false():
    assert not is_subscript(ast.Num(3))

