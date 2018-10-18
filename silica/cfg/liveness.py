import ast
from .types import Yield, HeadBlock, Branch
import silica.ast_utils as ast_utils

class Analyzer(ast.NodeVisitor):
    def __init__(self):
        self.gen = set()
        self.kill = set()
        self.in_assign = False
        # self.return_values = set()

    def visit_Call(self, node):
        # if ast_utils.is_name(node.func) and node.func.id == "phi":
        #     # skip 
        #     return
        # Ignore function calls
        for arg in node.args:
            self.visit(arg)

    def visit_Assign(self, node):
        # Need to visit loads before store
        self.visit(node.value)
        self.in_assign = True
        self.visit(node.targets[0])
        self.in_assign = False

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Store) or self.in_assign:
            self.kill.add(node.id)
        else:
            if node.id not in self.kill:
                self.gen.add(node.id)
            # if node.id in self.gen:
            #     self.gen.remove(node.id)

#     def visit_Return(self, node):
#         if isinstance(node, ast.Tuple):
#             for val in node.value.elts:
#                 self.return_values.add(val.id)
#         else:
#             self.return_values.add(node.value.id)


def analyze(node):
    analyzer = Analyzer()
    if isinstance(node, Yield):
        analyzer.visit(node.value)
        # analyzer.gen = set(value for value in node.output_map.values())
        # if not node.terminal:  # We only use assigments
        #     analyzer.gen = set()
        # else:
        # analyzer.kill = set()
    elif isinstance(node, HeadBlock):
        for statement in node.initial_statements:
            analyzer.visit(statement)
        if hasattr(node, "initial_yield"):
            analyzer.visit(node.initial_yield.value)
    elif isinstance(node, Branch):
        analyzer.visit(node.cond)
    else:
        for statement in node.statements:
            analyzer.visit(statement)
    return analyzer.gen, analyzer.kill

def do_analysis(block):
    block.gen, block.kill = analyze(block)
    if not isinstance(block, Yield):
        if isinstance(block, Branch):
            true_live_ins = do_analysis(block.true_edge)
            false_live_ins = do_analysis(block.false_edge)
            block.live_outs = true_live_ins | false_live_ins
        else:
            block.live_outs = do_analysis(block.outgoing_edge[0])
    still_live = block.live_outs - block.kill
    block.live_ins = block.gen | still_live
    return block.live_ins

def liveness_analysis(cfg):
    for block in cfg.blocks:
        if isinstance(block, (HeadBlock, Yield)):
            block.live_outs = do_analysis(block.outgoing_edge[0])
            block.gen, block.kill = analyze(block)
            still_live = block.live_outs - block.kill
            block.live_ins = block.gen | still_live
    for block in cfg.blocks:
        if isinstance(block, (HeadBlock, Yield)):
            block.live_outs = do_analysis(block.outgoing_edge[0])
            block.gen, block.kill = analyze(block)
            block.live_outs |= block.kill
            still_live = block.live_outs - block.kill
            block.live_ins = block.gen | still_live
