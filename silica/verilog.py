import astor
import ast
from .width import get_width


def get_width_str(width):
    return f"[{width-1}:0] " if width is not None else ""


class RemoveMagmaFuncs(ast.NodeTransformer):
    def visit_Call(self, node):
        if isinstance(node.func, ast.Name) and node.func.id in ['bits', 'uint', 'bit']:
            return node.args[0]
        return node


class TempVarPromoter(ast.NodeTransformer):
    __unique_id = 0

    def __init__(self, width_table):
        self.assigns = []
        self.var_map = {}
        self.width_table = width_table

    def visit_Assign(self, node):
        temp_var_str = f"temp_var_{TempVarPromoter.__unique_id}"
        TempVarPromoter.__unique_id += 1
        node.value = self.visit(node.value)
        self.var_map[astor.to_source(node.targets[0]).rstrip()] = temp_var_str
        self.assigns.append((get_width(node.targets[0], self.width_table),
                             ast.Assign([ast.Name(temp_var_str, ast.Store())],
                                        node.value)))
        node.value = ast.Name(temp_var_str, ast.Load())
        return node

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Load) and node.id in self.var_map:
            node.id = self.var_map[node.id]
        return node

    def visit_Subscript(self, node):
        if isinstance(node.ctx, ast.Load) and astor.to_source(node).rstrip() in self.var_map:
            return ast.Name(self.var_map[astor.to_source(node).rstrip()], ast.Load())
        return node





tab = "    "


def compile_state(state, index, _tab, one_state, width_table):
    offset = ""
    verilog_source = ""
    if state.conds or not one_state:
        offset = tab
        cond = ""
        if state.conds:
            cond += " & ".join(astor.to_source(RemoveMagmaFuncs().visit(cond)).rstrip() for cond in state.conds)
        if not one_state:
            if cond:
                cond += " & "
            cond += f"(yield_state == {state.start_yield_id})"
        if index == 0:
            if_str = "if"
        else:
            if_str = "else if"
        verilog_source += f"\n{_tab}{if_str} ({cond}) begin"
    temp_var_promoter = TempVarPromoter(width_table)
    for statement in state.statements:
        RemoveMagmaFuncs().visit(statement)
        # temp_var_promoter.visit(statement)
        verilog_source += f"\n{_tab + offset}" + astor.to_source(statement).rstrip().replace(" = ", " = ") + ";"
    temp_var_source = ""
    for width, assign in temp_var_promoter.assigns:
        width_str = get_width_str(width)
        temp_var_source += f"    wire {width_str}" + astor.to_source(assign).rstrip() + ";\n"
    if not one_state:
        verilog_source += f"\n{_tab + offset}yield_state = {state.end_yield_id};"
    if state.conds or not one_state:
        verilog_source += f"\n{_tab}end"
    return verilog_source, temp_var_source
