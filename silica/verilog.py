import astor
import ast


class RemoveMagmaFuncs(ast.NodeTransformer):
    def visit_Call(self, node):
        if isinstance(node.func, ast.Name) and node.func.id in ['bits', 'uint', 'bit']:
            return node.args[0]
        return node


tab = "    "


def compile_state(state, index, _tab, one_state):
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
    for statement in state.statements:
        RemoveMagmaFuncs().visit(statement)
        verilog_source += f"\n{_tab + offset}" + astor.to_source(statement).rstrip() + ";"
    if not one_state:
        verilog_source += f"\n{_tab + offset}yield_state = {state.end_yield_id};"
    if state.conds or not one_state:
        verilog_source += f"\n{_tab}end"
    return verilog_source
