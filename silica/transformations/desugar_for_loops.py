import ast
import itertools
import silica
from silica.ast_utils import *
from .replace_symbols import replace_symbols
from .constant_fold import constant_fold
from silica.memory import MemoryType
from copy import deepcopy
import astor
import os

counter = itertools.count()

def get_call_func(node):
    if is_name(node.func):
        return node.func.id
    # Should handle nested expressions/alternate types
    raise NotImplementedError(type(node.value.func))  # pragma: no cover


def desugar_for_loops(tree, type_table, width_table):
    class ForLoopDesugarer(ast.NodeTransformer):
        def __init__(self):
            super().__init__()
            self.loopvars = set()

        def visit_For(self, node):
            new_body = []
            for s in node.body:
                result = self.visit(s)
                if isinstance(result, list):
                    new_body.extend(result)
                else:
                    new_body.append(result)
            node.body = new_body

            # range() iterator
            if is_call(node.iter) and is_name(node.iter.func) and \
               node.iter.func.id == "range":
                if os.environ.get("SILICA_UNROLL"):
                    try:
                        range_object = eval(astor.to_source(node.iter))
                        body = []
                        for i in range_object:
                            symbol_table = {node.target.id: ast.Num(i)}
                            for child in node.body:
                                body.append(
                                    constant_fold(replace_symbols(deepcopy(child), symbol_table))
                                )
                        return body
                    except Exception as e:
                        pass

                if len(node.iter.args) > 0:
                    if not len(node.iter.args) < 4:
                        raise TypeError("range expected at most 3 arguments, got {}"
                                        .format(len(node.iter.args)))
                    if not is_name(node.target):
                        raise NotImplementedError("Target is not a named argument: `{}`"
                                                  .format(to_source(node.target)))

                    start = ast.Num(0)
                    stop  = node.iter.args[0]
                    step  = ast.Num(1)

                    if len(node.iter.args) > 1:
                        start = node.iter.args[0]
                        stop  = node.iter.args[1]

                    if len(node.iter.args) == 3:
                        step  = node.iter.args[2]
                else:
                    raise NotImplementedError("keyword iterators are not yet supported")

                bit_width = eval(astor.to_source(stop).rstrip() + "-" + astor.to_source(start).rstrip()).bit_length()
                # self.loopvars.add((node.target.id, bit_width))
                if isinstance(step, ast.UnaryOp) and isinstance(step.op, ast.USub):
                    comp_op = ast.Eq()
                    assert isinstance(stop, ast.UnaryOp) and isinstance(stop.op, ast.USub) and \
                        isinstance(stop.operand, ast.Num) and stop.operand.n == 1
                    stop = ast.Num(0)
                    step = step.operand
                    step_op = ast.Sub()
                else:
                    comp_op = ast.Lt()
                    step_op = ast.Add()
                start = ast.parse(f"bits({astor.to_source(start).rstrip()}, {width_table[node.target.id]})").body[0].value
                step = ast.parse(f"bits({astor.to_source(step).rstrip()}, {width_table[node.target.id]})").body[0].value
                stop = ast.parse(f"bits({astor.to_source(stop).rstrip()}, {width_table[node.target.id]})").body[0].value

                return [
                    ast.Assign([ast.Name(node.target.id, ast.Store())], start),
                    ast.While(ast.NameConstant(True),
                        node.body + [
                            ast.If(ast.BinOp(ast.Name(node.target.id, ast.Load()), comp_op, stop),
                                   [ast.Break()], []),
                            ast.Assign([ast.Name(node.target.id, ast.Store())], ast.BinOp(
                                ast.Name(node.target.id, ast.Load()), step_op, step))
                        ], [])
                ]
            # for _ in name
            elif is_name(node.iter):
                # TODO: currently just assumes that this is a list
                # TODO: maybe this should just reshape the for-loop to use a range()
                #       iterator and then just call the previous branch
                index = 'silica_count_' + str(next(counter))
                start = ast.Num(0)
                stop  = ast.Num(type_table[node.iter.id][1])
                step  = ast.Num(1)

                bit_width = stop.n.bit_length()
                self.loopvars.add((index, bit_width))

                return [
                    ast.Assign([ast.Name(index, ast.Store())], start),
                    ast.While(ast.BinOp(ast.Name(index, ast.Load()), ast.Lt(), stop),
                        [ast.Assign([ast.Name(node.target.id, ast.Store())],
                                    ast.Subscript(node.iter, ast.Index(ast.Name(index, ast.Load())), ast.Load()))] +
                        node.body + [
                            ast.Assign([ast.Name(index, ast.Store())], ast.BinOp(
                                ast.Name(index, ast.Load()), ast.Add(), step))
                        ], [])
                ]
            else:  # pragma: no cover
                print_ast(node)
                raise NotImplementedError("Unsupported for loop construct `{}`".format(to_source(node.iter)))


    desugarer = ForLoopDesugarer()
    desugarer.visit(tree)
    return tree, desugarer.loopvars

def propagate_types(tree):
    class TypePropagator(ast.NodeTransformer):
        def __init__(self):
            super().__init__()
            self.loopvars = {}

        def visit_Assign(self, node):
            self.generic_visit(node)
            if is_list(node.value):
                self.loopvars[node.targets[0].id] = ('list', len(node.value.elts))

            return node

    propagator = TypePropagator()
    propagator.visit(tree)
    return tree, propagator.loopvars

def get_final_widths(tree, width_table, globals, locals):
    class WidthCalculator(ast.NodeTransformer):
        def __init__(self):
            super().__init__()
            self.loopvars = {}

        def visit_Assign(self, node):
            self.generic_visit(node)
            if is_list(node.value):
                fst = node.value.elts[0]
                if is_name(fst):
                    self.loopvars[node.targets[0].id] = MemoryType(len(node.value.elts), width_table[fst.id])
                elif is_call(fst):
                    if fst.func.id == 'bits':
                        self.loopvars[node.targets[0].id] = MemoryType(len(node.value.elts), fst.args[1].n)
                    else:
                        raise NotImplementedError("Getting width of `{}` is unsupported.".format(to_source(fst)))
                else:
                    raise NotImplementedError("Getting width of `{}` is unsupported.".format(to_source(fst)))

            return node

    wc = WidthCalculator()
    wc.visit(tree)
    return tree, wc.loopvars
