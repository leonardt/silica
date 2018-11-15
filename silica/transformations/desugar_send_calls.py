import silica.ast_utils as ast_utils
import ast


class DesugarSendTransformer(ast.NodeTransformer):
    def __init__(self, sub_coroutines):
        self.sub_coroutines = sub_coroutines

    def visit(self, node):
        """
        For nodes with a `body` attribute, we explicitly traverse them and
        flatten any lists that are returned. This allows visitors to return
        more than one node.
        """
        if not hasattr(node, 'body') or isinstance(node, ast.IfExp):
            return super().visit(node)
        new_body = []
        for statement in node.body:
            result = self.visit(statement)
            if isinstance(result, list):
                new_body.extend(result)
            else:
                new_body.append(result)
        node.body = new_body
        if hasattr(node, 'orelse') and not isinstance(node, ast.IfExp):
            new_orelse = []
            for statement in node.orelse:
                result = self.visit(statement)
                if isinstance(result, list):
                    new_orelse.extend(result)
                else:
                    new_orelse.append(result)
            node.orelse = new_orelse
        return node

    def visit_Attribute(self, node):
        coroutine = node.value.id
        return ast.Name("_si_sub_co_" + coroutine + "_" + node.attr, node.ctx)

    def visit_Expr(self, node):
        if ast_utils.is_call(node.value) and ast_utils.is_attribute(node.value.func) and node.value.func.attr == "send":
            coroutine = node.value.func.value.id
            assigns = []
            inputs = []
            for key, value in self.sub_coroutines[coroutine].IO.ports.items():
                if key == "CLK":
                    continue
                if value.isinput():
                    inputs.append(key)
            args = node.value.args
            if isinstance(args[0], ast.Tuple) and len(args) == 1:
                args = args[0].elts
            for key, arg in zip(inputs, args):
                assigns.append(ast.Assign([ast.Name("_si_sub_co_" + coroutine + "_" + key, ast.Store())], arg))
            return assigns
        return node

    def visit_Assign(self, node):
        if ast_utils.is_call(node.value) and ast_utils.is_attribute(node.value.func) and node.value.func.attr == "send":
            coroutine = node.value.func.value.id
            assigns = []
            inputs = []
            outputs = []
            for key, value in self.sub_coroutines[coroutine].IO.ports.items():
                if key == "CLK":
                    continue
                if value.isinput():
                    inputs.append(key)
                elif value.isoutput():
                    outputs.append(key)
            outputs.sort()
            args = node.value.args
            if isinstance(args[0], ast.Tuple) and len(args) == 1:
                args = args[0].elts
            for key, arg in zip(inputs, args):
                assigns.append(ast.Assign([ast.Name("_si_sub_co_" + coroutine + "_" + key, ast.Store())], arg))
            if isinstance(node.targets[0], ast.Tuple):
                targets = node.targets[0].elts
            else:
                targets = node.targets
            for key, arg in zip(outputs, targets):
                assigns.append(ast.Assign([arg], ast.Name("_si_sub_co_" + coroutine + "_" + key, ast.Load())))
            return assigns
        node.value = self.visit(node.value)
        return node


def desugar_send_calls(tree, sub_coroutines):
    return DesugarSendTransformer(sub_coroutines).visit(tree)
