import silica.types as types
import ast
import astor
from .memory import MemoryType
import silica.ast_utils as ast_utils
import magma as m

def get_width(node, width_table, func_locals={}, func_globals={}):
    if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"bits", "uint", "BitVector"}:
        if isinstance(node.args[1], ast.Call) and node.args[1].func.id == "eval":
            return eval(astor.to_source(node.args[1]).rstrip())
        if not isinstance(node.args[1], ast.Num):
            raise TypeError(f"Cannot get width of {astor.to_source(node.args[1]).rstrip()}, we should know all widths at compile time.")
        return node.args[1].n
    if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"bit"}:
        return None
    elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"memory"}:
           return MemoryType(node.args[0].n, node.args[1].n)
    elif isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and \
       node.func.id in {"zext"}:
        assert isinstance(node.args[1], ast.Num), "We should know all widths at compile time"
        return get_width(node.args[0], width_table) + node.args[1].n
    elif isinstance(node, ast.Name):
        if node.id not in width_table:
            raise Exception(f"Trying to get width of variable that hasn't been previously added to the width_table: {node.id} (width_table={width_table})")
        return width_table[node.id]
    elif ast_utils.is_call(node) and ast_utils.is_name(node.func) and node.func.id == "coroutine_create":
        return eval(astor.to_source(node.args[0]), func_globals, func_locals)()
    elif isinstance(node, ast.Call):
        if isinstance(node.func, ast.Name):
            widths = [get_width(arg, width_table) for arg in node.args]
            if node.func.id in {"add", "xor", "sub", "and_", "not_"}:
                if not all(widths[0] == x for x in widths):
                    raise TypeError(f"Calling {node.func.id} with different length types")
                width = widths[0]
                if node.func.id == "add":
                    for keyword in node.keywords:
                        if keyword.arg == "cout" and isinstance(keyword.value, ast.NameConstant) and keyword.value.value == True:
                            width = (width, None)
                return width
            elif node.func.id == "eq":
                if not all(widths[0] == x for x in widths):
                    raise TypeError("Calling eq with different length types")
                return None
            elif node.func.id == "decoder":
                return 2 ** get_width(node.args[0], width_table)
            else:
                raise NotImplementedError(ast.dump(node))
        else:
            raise NotImplementedError(ast.dump(node))
    elif isinstance(node, ast.UnaryOp):
        return get_width(node.operand, width_table)
    elif isinstance(node, ast.BinOp):
        left_width = get_width(node.left, width_table)
        right_width = get_width(node.right, width_table)
        if left_width != right_width:
            raise TypeError(f"Binary operation with mismatched widths ({left_width}, {right_width}) {ast.dump(node)}")
        return left_width
    elif isinstance(node, ast.IfExp):
        left_width = get_width(node.body, width_table)
        if node.orelse:
            right_width = get_width(node.orelse, width_table)
            if left_width != right_width:
                raise TypeError(f"Binary operation with mismatched widths {ast.dump(node)}")
        return left_width
    elif isinstance(node, ast.Compare):
        # TODO: Check widths of operands
        return None
    elif isinstance(node, ast.NameConstant) and node.value in [True, False]:
        return None
    elif isinstance(node, ast.List):
        widths = [get_width(arg, width_table) for arg in node.elts]
        assert all(widths[0] == width for width in widths)
        return MemoryType(len(node.elts), widths[0])
    elif isinstance(node, ast.Subscript):
        if isinstance(node.slice, ast.Index):
            width = get_width(node.value, width_table)
            if isinstance(width, tuple):
                return width[1]
            elif isinstance(width, MemoryType):
                return width.width
            return None
        elif isinstance(node.slice, ast.Slice):
            width = get_width(node.value, width_table)
            if node.slice.lower is None and isinstance(node.slice.upper, ast.Num):
                if node.slice.step is not None:
                    raise NotImplementedError()
                return node.slice.upper.n
            elif node.slice.upper is None:
                lower = 0
                if isinstance(node.slice.lower, ast.Num):
                    lower = node.slice.lower.n
                width = width_table[node.value.id]
                if isinstance(width, MemoryType):
                    return MemoryType(width.height - lower, width.width)
                else:
                    return width - lower
            elif isinstance(node.slice.upper, ast.Num):
                lower = node.slice.lower.n
                upper = node.slice.upper.n
                width = width_table[node.value.id]
                if isinstance(width, MemoryType):
                    return MemoryType(upper - lower - 1, width.width)
                else:
                    return upper - lower - 1
    elif isinstance(node, ast.Num):
        return max(node.n.bit_length(), 1)
    elif isinstance(node, ast.Attribute):
        type_ = width_table[node.value.id]._outputs[node.attr]
        if issubclass(type_, m.Bit):
            return None
        raise NotImplementedError(type_)



    raise NotImplementedError(ast.dump(node))


def get_io_width(type_):
    if type_ is m.Bit:
        return None
    elif issubclass(type_, m.Array):
        if issubclass(type_.T, m.Array):
            elem_width = get_io_width(type_.T)
            if isinstance(elem_width, tuple):
                return (type_.N, ) + elem_width
            else:
                return (type_.N, elem_width)
        else:
            return type_.N
    elif isinstance(type_, types.Channel):
        return get_io_width(type_.type_)
    elif isinstance(type_, types.Register):
        return get_io_width(type_.T)
    else:
        raise NotImplementedError(type_)
