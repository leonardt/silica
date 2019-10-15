import copy
import ast
from collections import defaultdict
from staticfg import CFGBuilder
import astor


class State:
    pass


class Bit:
    pass


class FSM:
    pass




def count_yields(statement):
    class Visitor(ast.NodeVisitor):
        def __init__(self):
            self.num_yields = 0

        def visit_Yield(self, _):
            self.num_yields += 1

        def visit(self, node):
            super().visit(node)
            return self.num_yields

    return Visitor().visit(statement)


def specialize_init_methods(tree):
    class Transformer(ast.NodeTransformer):
        def __init__(self):
            self.class_defs = {}

        def visit_ClassDef(self, node):
            self.class_defs[node.name] = node
            return node

        def visit_Module(self, node):
            for child in node.body:
                self.visit(child)

            attrs_to_specialize = {}
            classes_to_specialize = {}
            for class_def in self.class_defs.values():
                init_method = self.get_init_method(class_def.body)
                attr_map, value_map = self.process_init(class_def.name, init_method)
                attrs_to_specialize[class_def] = attr_map
                # class_def.body.remove(init_method)
                for k0, v0 in value_map.items():
                    if k0 not in classes_to_specialize:
                        classes_to_specialize[k0] = {}
                    for k1, v1 in v0.items():
                        classes_to_specialize[k0][k1] = v1

            specialized_classes = {}
            for k0, v0 in classes_to_specialize.items():
                class_tree = self.class_defs[k0]
                for k1, v1 in v0.items():
                    specialized_classes[k1] = self.specialize_class(k1, class_tree,
                                                                    v1)
            for k0, v0 in attrs_to_specialize.items():
                if not v0:
                    continue
                self.replace_symbols(k0, v0)

            for k0 in classes_to_specialize:
                node.body.remove(self.class_defs[k0])

            for item in node.body:
                if isinstance(item, ast.ClassDef):
                    item.body.remove(self.get_init_method(item.body))

            node.body += list(specialized_classes.values())

            return node

        def get_init_method(self, body):
            for node in body:
                if isinstance(node, ast.FunctionDef) and \
                        node.name == "__init__":
                    return node
            raise Exception("Did not find __init__ method")

        def process_init(self, class_name, method):
            attr_map = {}
            value_map = {}
            for statement in method.body:
                assert isinstance(statement, ast.Assign)
                assert len(statement.targets) == 1
                assert isinstance(statement.targets[0], ast.Attribute)
                assert isinstance(statement.targets[0].value, ast.Name)
                assert statement.targets[0].value.id == "self"
                value = statement.value
                attr = statement.targets[0].attr
                if isinstance(value, ast.Call):
                    assert isinstance(value.func, ast.Name)
                    assert value.func.id in self.class_defs
                    orig_name = value.func.id
                    new_name = orig_name + "_"
                    args = value.args
                    args = [ast.Name(class_name, ast.Load()) if arg.id == "self" else
                            arg for arg in args]
                    assert all(isinstance(arg, ast.Name) for arg in args)
                    new_name += "_".join(arg.id for arg in args)
                    assert all(isinstance(k.value, ast.Num) for k in value.keywords)
                    new_name = orig_name + "_" + \
                        "_".join(str(k.value.n) for k in value.keywords)
                    attr_map[attr] = new_name
                    if value.func.id not in value_map:
                        value_map[value.func.id] = {}
                    value_map[value.func.id][new_name] = (args,
                                                          value.keywords)
            return attr_map, value_map

        def specialize_class(self, name, class_tree, arg_vals):
            args, kwargs = arg_vals
            init_method = self.get_init_method(class_tree.body)
            symbol_table = {}
            for arg, value in zip(init_method.args.args[1:], args):
                symbol_table[arg.arg] = value
            symbol_table[init_method.args.kwarg.arg] = {}
            for arg in kwargs:
                symbol_table[init_method.args.kwarg.arg][arg.arg] = arg.value
            tree = self.replace_self_attr(copy.deepcopy(class_tree), symbol_table)
            tree.name = name
            tree.body.remove(self.get_init_method(tree.body))
            return tree

        def replace_self_attr(self, class_def, symbol_table):
            class Transformer(ast.NodeTransformer):
                def visit_Attribute(self, node):
                    node.value = self.visit(node.value)
                    if isinstance(node.value, ast.Name) and \
                            node.value.id == "self" and \
                            node.attr in symbol_table:
                        return symbol_table[node.attr]
                    return node

                def visit_Subscript(self, node):
                    node.value = self.visit(node.value)
                    if isinstance(node.value, dict):
                        assert isinstance(node.slice, ast.Index)
                        assert isinstance(node.slice.value, ast.Str)
                        return node.value[node.slice.value.s]
                    return node

            return Transformer().visit(class_def)

        def replace_symbols(self, tree, symbol_table):
            class Transformer(ast.NodeTransformer):
                def visit_Name(self, node):
                    if node.id in symbol_table:
                        node.id = symbol_table[node.id]
                    return node
            return Transformer().visit(tree)

    return Transformer().visit(tree)


def compile(file):
    name = file[-3:]
    with open(file, 'r') as src_file:
        src = src_file.read()
        tree = ast.parse(src, mode='exec')
    tree = specialize_init_methods(tree)
    print(astor.to_source(tree))
    cfg = CFGBuilder().build(name, tree)
    # cfg.build_visual(name, 'pdf')
    num_yields = sum(count_yields(s) for s in cfg.entryblock.statements)
    print(num_yields)


compile("fsm.py")
