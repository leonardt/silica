import ast
import silica.cfg.types as cfg_types

class Analyzer(ast.NodeVisitor):
    def __init__(self):
        self.gen = set()
        self.kill = set()
        # self.return_values = set()

    def visit_Call(self, node):
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

def liveness_analysis(paths):
    for path in paths:
        for index, block in enumerate(reversed(path)):
            analyzer = Analyzer()
            if isinstance(block, cfg_types.Yield):
                analyzer.visit(block.value)
                if block is path[0]:  # We only use assigments
                    analyzer.gen = set()
                else:
                    assert block is path[-1]  # Only use reads
                    analyzer.kill = set()
            elif isinstance(block, cfg_types.HeadBlock):
                for statement in block.initial_statements:
                    analyzer.visit(statement)
            else:
                for statement in block.statements:
                    analyzer.visit(statement)
            block.gen = analyzer.gen
            block.kill = analyzer.kill
            if index > 0:
                block.live_outs = block.live_outs.union(path[-index].live_ins)
            block.live_ins = analyzer.gen | (block.live_outs - analyzer.kill)
