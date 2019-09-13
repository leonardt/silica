import astor
import silica as si
import ast
import silica.types as types
import inspect


def desugar_channels(tree, coroutine):
    new_inputs = {}
    channels = {}
    for input_, type_ in coroutine._inputs.items():
        if not isinstance(type_, types.Channel):
            new_inputs[input_] = type_
        else:
            if coroutine._outputs is inspect._empty:
                coroutine._outputs = {}
            channels[input_] = type_
            if type_.direction is types.In:
                new_inputs[input_ + "_data"] = type_.type_
                new_inputs[input_ + "_valid"] = si.Bit
                coroutine._outputs[input_ + "_ready"] = si.Bit
            else:
                new_inputs[input_ + "_ready"] = si.Bit
                coroutine._outputs[input_ + "_data"] = type_.type_
                coroutine._outputs[input_ + "_valid"] = si.Bit
    coroutine._inputs = new_inputs

    defaults = []
    for name, channel in channels.items():
        if channel.direction is types.Out:
            defaults.append(f"{name}_valid = 0")
            defaults.append(f"{name}_data = 0")
        else:
            defaults.append(f"{name}_ready = 0")
    default_str = '\n    '.join(defaults)

    class Transformer(ast.NodeTransformer):
        def visit_Expr(self, node):
            node.value = self.visit(node.value)
            if isinstance(node.value, list):
                return node.value
            return node

        def visit(self, node):
            node = super().visit(node)
            for block_field in ["body", "orelse"]:
                if hasattr(node, block_field) and not isinstance(node, ast.IfExp):
                    new_block = []
                    for statement in getattr(node, block_field):
                        if isinstance(statement, list):
                            new_block.extend(statement)
                        else:
                            new_block.append(statement)
                    setattr(node, block_field, new_block)
            return node

        def visit_Call(self, node):
            if isinstance(node, ast.Call) and \
                    isinstance(node.func, ast.Attribute) and \
                    isinstance(node.func.value, ast.Name) and \
                    node.func.value.id in channels:
                if node.func.attr == "is_full":
                    return ast.UnaryOp(ast.Invert(),
                                       ast.Name(node.func.value.id + "_ready",
                                                ast.Load()))
                elif node.func.attr == "is_empty":
                    return ast.UnaryOp(ast.Invert(),
                                       ast.Name(node.func.value.id + "_valid",
                                                ast.Load()))
                elif node.func.attr == "push":
                    inputs_str = ", ".join(coroutine._inputs)
                    outputs_str = ", ".join(coroutine._outputs)
                    wait_block = ast.parse(f"""\
while True:
    {node.func.value.id}_valid = 1
    {node.func.value.id}_data = {astor.to_source(node.args[0]).rstrip()}
    if {node.func.value.id}_ready:
        break
    {inputs_str} = yield {outputs_str}
    {default_str}
""").body
                    return wait_block
                else:
                    assert False, f"Got unexpected channel method {astor.to_source(node).rstrip()}"
            return node

        def visit_Assign(self, node):
            if isinstance(node.value, ast.Call) and \
                    isinstance(node.value.func, ast.Attribute) and \
                    isinstance(node.value.func.value, ast.Name) and \
                    node.value.func.value.id in channels:
                assert node.value.func.attr == "pop", f"Got unexpected channel method {astor.to_source(node).rstrip()}"
                inputs_str = ", ".join(coroutine._inputs)
                outputs_str = ", ".join(coroutine._outputs)
                wait_block = ast.parse(f"""\
while True:
    {node.value.func.value.id}_ready = 1
    if {node.value.func.value.id}_valid:
        break
    {inputs_str} = yield {outputs_str}
    {default_str}
""").body
                node.value = ast.Name(node.value.func.value.id + "_data", ast.Load())
                return wait_block + [node]
            if not isinstance(node.value, ast.Yield):
                return node
            assert len(node.targets) == 1
            targets = node.targets[0]
            if isinstance(targets, ast.Name):
                targets = [targets]
            elif isinstance(targets, ast.Tuple):
                targets = targets.elts
            new_targets = []
            new_values = []
            for target in targets:
                assert isinstance(target, ast.Name)
                if target.id in channels:
                    assert channels[target.id].direction is types.In
                    new_targets.extend((
                        ast.Name(target.id + "_data", ast.Store()),
                        ast.Name(target.id + "_valid", ast.Store())
                    ))
                    new_values.append(
                        ast.Name(target.id + "_ready", ast.Load())
                    )
                else:
                    new_targets.append(target)

            value = node.value.value
            if value is not None:
                if isinstance(value, ast.Name):
                    values = [value]
                else:
                    assert isinstance(value, ast.Tuple), ast.dump(value)
                    values = value.elts
                for value in values:
                    assert isinstance(value, ast.Name)
                    if value.id in channels:
                            new_targets.append(
                                ast.Name(value.id + "_ready", ast.Store())
                            )
                            new_values.extend((
                                ast.Name(value.id + "_data", ast.Load()),
                                ast.Name(value.id + "_valid", ast.Load())
                            ))
                    else:
                        new_values.append(value)
                if len(new_values) == 1:
                    node.value.value = new_values[0]
                else:
                    node.value.value = ast.Tuple(new_values, ast.Load())
            else:
                for name, channel in channels.items():
                    if channel.direction is types.Out:
                        new_targets.append(ast.Name(name + "_ready",
                                                    ast.Store()))
            if len(new_targets) > 1:
                node.targets = [ast.Tuple(new_targets, ast.Store())]
            else:
                node.targets = new_targets
            defaults = []
            for name, channel in channels.items():
                if channel.direction is types.Out:
                    defaults.append(ast.parse(f"{name}_valid = 0").body[0])
                    defaults.append(ast.parse(f"{name}_data = 0").body[0])
                else:
                    defaults.append(ast.parse(f"{name}_ready = 0").body[0])
            return [node] + defaults

    tree = Transformer().visit(tree)
    print(astor.to_source(tree))
    return tree, coroutine
