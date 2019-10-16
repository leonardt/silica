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
                self.replace_self_attr(k0, v0)

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
                    attr_map[attr] = ast.Name(new_name, ast.Load())
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

    return Transformer().visit(tree)


def convert_to_class_methods(tree):
    class Transformer(ast.NodeTransformer):
        def visit_ClassDef(self, node):
            for child in node.body:
                if isinstance(child, ast.FunctionDef):
                    child.decorator_list.append(ast.Name("classmethod",
                                                         ast.Load()))
                    child.args.args[0].arg = "cls"
                    child.body = [self.replace_symbols(s, {"self": "cls"}) for
                                  s in child.body]
            return node

        def replace_symbols(self, tree, symbol_table):
            class Transformer(ast.NodeTransformer):
                def visit_Name(self, node):
                    if node.id in symbol_table:
                        node.id = symbol_table[node.id]
                    return node
            return Transformer().visit(tree)
    return Transformer().visit(tree)


def get_io(cls):
    inputs = {}
    outputs = {}
    class Visitor(ast.NodeVisitor):
        def visit_Assign(self, node):
            if len(node.targets) == 1 and \
                    isinstance(node.targets[0], ast.Name):
                if node.targets[0].id == "inputs":
                    assert isinstance(node.value, ast.Dict)
                    for k, v in zip(node.value.keys, node.value.values):
                        assert isinstance(k, ast.Str)
                        assert isinstance(v, ast.Name)
                        inputs[k.s] = v.id
                elif node.targets[0].id == "outputs":
                    assert isinstance(node.value, ast.Dict)
                    for k, v in zip(node.value.keys, node.value.values):
                        assert isinstance(k, ast.Str)
                        assert isinstance(v, ast.Name)
                        outputs[k.s] = v.id
    Visitor().visit(cls)
    return inputs, outputs


def update_other_class_references(body, other_class, attr):
    class Transformer(ast.NodeTransformer):
        def visit_Attribute(self, node):
            if isinstance(node.value, ast.Name) and node.value.id == other_class and node.attr == attr:
                return ast.Attribute(ast.Name("cls", ast.Load()), other_class +
                                     "_" + attr, ast.Load())
            return node
    return [Transformer().visit(s) for s in body]


def update_this_class_references(body, this_class):
    class Transformer(ast.NodeTransformer):
        def visit_Attribute(self, node):
            if isinstance(node.value, ast.Name) and node.value.id == "cls":
                node.attr = this_class + "_" + node.attr
            return node
    return [Transformer().visit(s) for s in body]


def update_first_class_references(body, first_class):
    class Transformer(ast.NodeTransformer):
        def visit_Attribute(self, node):
            if isinstance(node.value, ast.Name) and node.value.id == first_class:
                node.value.id = "cls"
            return node
    return [Transformer().visit(s) for s in body]


def merge_classes(tree):
    assert isinstance(tree, ast.Module)
    new_body = []
    first_class = None
    for child in tree.body:
        if not isinstance(child, ast.ClassDef):
            new_body.append(child)
        elif first_class is None:
            new_body.append(child)
            first_class = child
        else:
            assert get_io(first_class) == get_io(child)
            to_append = []
            for s in child.body:
                if isinstance(s, ast.FunctionDef):
                    first_class.body = \
                        update_other_class_references(first_class.body,
                                                      child.name, s.name)
                    s.body = \
                        update_this_class_references(s.body, child.name)
                    s.body = \
                        update_first_class_references(s.body, first_class.name)
                    s.name = child.name + "_" + s.name
                    to_append.append(s)
            first_class.body += to_append
    tree.body = new_body
    return tree


def is_yield(node):
    return isinstance(node, ast.Assign) and isinstance(node.value, ast.Yield)


def is_yield_from(node):
    return isinstance(node, ast.Expr) and isinstance(node.value, ast.YieldFrom)


def has_yield_from(l):
    return any(is_yield_from(i) for i in l)


def collect_paths(block):
    if is_yield(block.statements[0]):
        return [[block]]
    paths = []
    if block.exits:
        for exit_ in block.exits:
            target = exit_.target
            paths.extend([
                [block] + s for s in collect_paths(target)
            ])
    else:
        paths.append([block])
    return paths


class FuncPaths:
    def __init__(self):
        self.entry_paths = []
        self.other_paths = []


def build_func_to_paths_map(cfg):
    func_to_paths_map = {}
    for k, v in cfg.functioncfgs.items():
        assert k not in func_to_paths_map
        func_to_paths_map[k] = FuncPaths()
        for block in v:
            if block == v.entryblock:
                if not is_yield(block.statements[0]):
                    for exit_ in block.exits:
                        target = exit_.target
                        func_to_paths_map[k].entry_paths.extend([
                            [block] + s for s in collect_paths(target)
                        ])
                else:
                    func_to_paths_map[k].entry_paths.append([block])

            if is_yield(block.statements[0]):
                for exit_ in block.exits:
                    target = exit_.target
                    func_to_paths_map[k].other_paths.extend([
                        [block] + s for s in collect_paths(target)
                    ])
    return func_to_paths_map


def join_yield_froms(func_to_paths_map):
    # print(list(func_to_paths_map.keys()))
    new_func_to_paths_map = {}
    for k, v in func_to_paths_map.items():
        new_entry_paths = []
        new_other_paths = []
        for orig, new in zip((v.entry_paths, v.other_paths),
                             (new_entry_paths, new_other_paths)):
            for path in orig:
                num_yield_froms = sum(has_yield_from(block.statements) for block in
                                      path)
                assert num_yield_froms <= 1
                if num_yield_froms == 1:
                    block = path[-1]
                    assert has_yield_from(block.statements)
                    assert sum(map(is_yield_from, block.statements)) == 1
                    for node in block.statements:
                        if is_yield_from(node):
                            func = node.value.value
                            # print(astor.to_source(node.value.value))
                            if isinstance(func.func, ast.Attribute) and \
                                    isinstance(func.func.value, ast.Name) and \
                                    func.func.value.id == "cls":
                                new.extend([
                                    path + entry_path for entry_path in
                                    func_to_paths_map[func.func.attr].entry_paths
                                ])
                            else:
                                raise Exception(func.func.value.id)
                else:
                    new.append(path)
        new_func_to_paths_map[k] = FuncPaths()
        new_func_to_paths_map[k].entry_paths = new_entry_paths
        new_func_to_paths_map[k].other_paths = new_other_paths
    for k, v in new_func_to_paths_map.items():
        func_to_paths_map[k].entry_paths = v.entry_paths
        func_to_paths_map[k].other_paths = v.other_paths


def compile(file):
    name = file[:-3]
    with open(file, 'r') as src_file:
        src = src_file.read()
        tree = ast.parse(src, mode='exec')
    tree = specialize_init_methods(tree)
    tree = convert_to_class_methods(tree)
    tree = merge_classes(tree)
    io = get_io(tree.body[-1])
    # print(astor.to_source(tree))
    cfg = CFGBuilder().build(name, tree)
    # cfg.build_visual(name, 'pdf')
    num_yields = sum(count_yields(s) for s in cfg.entryblock.statements)
    func_to_paths_map = build_func_to_paths_map(cfg)
    join_yield_froms(func_to_paths_map)
    # for k, v in func_to_paths_map.items():
    #     print(f"Function == {k}")
    #     print(f"Entry paths")
    #     for path in v.entry_paths:
    #         print("===== PATH START =====")
    #         for block in path:
    #             print(block.get_source().rstrip())
    #         print("=====  PATH END  =====")
    #         print()
    #     print(f"Other paths")
    #     for path in v.other_paths:
    #         print("===== PATH START =====")
    #         for block in path:
    #             print(block.get_source().rstrip())
    #         print("=====  PATH END  =====")
    #         print()
    # print(num_yields)
    transitions = []
    for k, v in func_to_paths_map.items():
        for path in v.entry_paths + v.other_paths:
            # Ignore entry paths
            if is_yield(path[0].statements[0]) and \
                    is_yield(path[-1].statements[0]) and len(path) > 1:
                start_state = path[0].statements[0].value.value.n
                end_state = path[-1].statements[0].value.value.n
                cases = set()
                for i, block in enumerate(path):
                    if i == len(path) - 1:
                        continue
                    for exit_ in block.exits:
                        if exit_.target == path[i + 1]:
                            break
                    if exit_.exitcase:
                        cases.add(exit_.get_exitcase().rstrip())
                # print("cases:", cases)
                # FIXME: Hack to remove impossible transitions
                impossible = False
                for case in cases:
                    if "==" in case and case.replace("==", "!=") in cases or \
                            "!=" in case and case.replace("!=", "==") in cases:
                        impossible = True
                if not impossible:
                    if "True" in cases:
                        cases.remove("True")
                    transitions.append((start_state, end_state, cases))
    print("\n".join(str(x) for x in transitions))
    print(f"num_transitions={len(transitions)}")
    print(f"num_states={num_yields}")
    print(f"inputs={io[0]}, outputs={io[1]}")

    state_width = (num_yields - 1).bit_length()
    io_str = ""
    for input_, t in io[0].items():
        if io_str:
            io_str += ", "
        if t != "Bit":
            raise NotImplementedError()
        io_str += f"input {input_}"

    for output_, t in io[1].items():
        if io_str:
            io_str += ", "
        if t != "State":
            raise NotImplementedError()
        width = f"[{state_width - 1}:0] "
        io_str += f"output {width}{output_}"

    case_map = defaultdict(list)
    for transition in transitions:
        case_map[transition[0]].append(transition[1:])

    case_str = ""
    case_str += "case (state)\n"
    for case, transitions in case_map.items():
        case_str += "    "
        case_str += f"{case}: "
        for transition in transitions:
            if transition != transitions[0]:
                case_str += " else "
            cond = " && ".join(transition[1])
            case_str += f"if ({cond}) begin\n"
            case_str += f"        state <= {transition[0]}\n"
            case_str += f"    end"
        case_str += "\n"
    case_str += "endcase"
    case_str = "   " + "\n    ".join(line for line in case_str.splitlines())
    module_tmpl = f"""
module {name}({io_str}, input CLK);
reg [{state_width - 1}:0] state;
always @(posedge CLK) begin
{case_str}
end
endmodule
    """
    # print(module_tmpl)
    with open(f"{name}.v", "w") as f:
        f.write(module_tmpl)


compile("fsm.py")
