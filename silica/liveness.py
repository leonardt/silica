import ast
import silica.cfg.types as cfg_types

class Analyzer(ast.NodeVisitor):
    def __init__(self):
        self.gen = set()
        self.kill = set()
        # self.return_values = set()

    def visit_Call(self, node):
        # Ignore function calls
        for arg in node.args:
            self.visit(arg)

    def visit_Assign(self, node):
        # Need to visit loads before store
        self.visit(node.value)
        self.visit(node.targets[0])

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load):
            if node.id not in self.kill:
                self.gen.add(node.id)
        else:
            self.kill.add(node.id)

#     def visit_Return(self, node):
#         if isinstance(node, ast.Tuple):
#             for val in node.value.elts:
#                 self.return_values.add(val.id)
#         else:
#             self.return_values.add(node.value.id)


def analyze(node):
    analyzer = Analyzer()
    if isinstance(node, cfg_types.Yield):
        analyzer.visit(node.value)
        if not node.terminal:  # We only use assigments
            analyzer.gen = set()
        else:
            analyzer.kill = set()
    elif isinstance(node, cfg_types.HeadBlock):
        for statement in node.initial_statements:
            analyzer.visit(statement)
        if hasattr(node, "initial_yield"):
            analyzer.visit(node.initial_yield.value)
    elif isinstance(node, cfg_types.Branch):
        analyzer.visit(node.cond)
    else:
        for statement in node.statements:
            analyzer.visit(statement)
    return analyzer.gen, analyzer.kill

def liveness_analysis(cfg):
    for path in cfg.paths_between_yields:
        path[-1].live_outs = set()
        for node in reversed(path):
            node.gen, node.kill = analyze(node)
            if node.next is not None:
                node.live_outs = node.next.live_ins
            still_live = node.live_outs - node.kill
            node.live_ins = node.gen | still_live
