def magma_compile(coroutine, func_globals, func_locals):
    # TODO: Simplify clock enables wired up to 1
    has_ce = coroutine.has_ce
    tree = get_ast(coroutine._definition).body[0]  # Get the first element of the ast.Module
    func_locals.update(coroutine._defn_locals)
    specialize_arguments(tree, coroutine)
    specialize_constants(tree, coroutine._defn_locals)
    constant_fold(tree)
    specialize_list_comps(tree, func_globals, func_locals)
    desugar_for_loops(tree)
    width_table = {}
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            width_table[input_] = get_input_width(type_)

    constant_fold(tree)
    type_table = {}
    CollectInitialWidthsAndTypes(width_table, type_table).visit(tree)
    PromoteWidths(width_table, type_table).visit(tree)
    Desugar(width_table).visit(tree)
    type_table = {}
    TypeChecker(width_table, type_table).check(tree)
    # DesugarArrays().run(tree)
    cfg = ControlFlowGraph(tree)
    liveness_analysis(cfg)
    # cfg.render()
    # render_paths_between_yields(cfg.paths)
    # render_fsm(cfg.states)
    registers = set()
    outputs = tuple()
    for path in cfg.paths:
        registers |= path[0].live_ins  # Union
        outputs += (collect_names(path[-1].value, ctx=ast.Load), )
    assert all(outputs[1] == output for output in outputs[1:]), "Yield statements must all have the same outputs except for the first"
    outputs = outputs[1]
    io_strings = []
    for output in outputs:
        width = width_table[output]
        if width is None:
            io_strings.append(f"\"{output}\", Out(Bit)")
        else:
            io_strings.append(f"\"{output}\", Out(Bits({width_table[output]}))")

    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            io_strings.append(f"\"{input_}\", In({type_})")
    io_string = ", ".join(io_strings)
    states = cfg.states
    num_yields = cfg.curr_yield_id
    num_states = len(states)
    register_initial_values = {}
    initial_basic_block = False
    sub_coroutines = []
    # cfg.render()
    magma_source = ""
    for node in cfg.paths[0][:-1]:
        if isinstance(node, HeadBlock):
            for statement in node:
                if isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Name) and statement.value.func.id == "coroutine_create":
                    sub_coroutine = eval(astor.to_source(statement.value.args[0]), func_globals, func_locals)
                    magma_source += magma_compile(sub_coroutine(), func_globals, func_locals)
                    statement.value.func = ast.Name(sub_coroutine._name, ast.Load())
                    statement.value.args = []
                    sub_coroutines.append((statement, sub_coroutine))
                else:
                    register_initial_values[statement.targets[0].id] = get_constant(statement.value)
        initial_basic_block |= isinstance(node, BasicBlock)
    if not initial_basic_block:
        num_states -= 1
        num_yields -= 1
        states = states[1:]
    # CE = f"VCC"
    # if has_ce:
        # CE = f"{tree.name}.CE"
    if False:
        new_states = []
        for state in states:
            for new_state in new_states:
                if "\n".join(astor.to_source(statement) for statement in state.statements) == \
                   "\n".join(astor.to_source(statement) for statement in new_state.statements):
                       new_state.start_yield_ids.append(state.start_yield_id)
                       break
            else:
                new_states.append(state)
        states = new_states
    num_states = len(states)
    for i, state in enumerate(states):
        new_statements = []
        for statement in state.statements:
            if isinstance(statement, ast.Assign) and isinstance(statement.value, ast.Call) and isinstance(statement.value.func, ast.Attribute) and statement.value.func.attr == "send":
                if len(statement.targets) == 1:
                    target = statement.targets[0].id
                    sub_coroutine = statement.value.func.value
                    for j, arg in enumerate(statement.value.args[0].elts):
                        new_statements.append(ast.parse(f"wire({astor.to_source(sub_coroutine).rstrip()}_inputs_{j}.I{i}, {astor.to_source(arg).rstrip()})"))
                    statement.value = ast.Attribute(sub_coroutine, target, ast.Load)
                else:
                    raise NotImplementedError()
            new_statements.append(statement)
        state.statements = new_statements
    magma_source += f"""
{tree.name} = DefineCircuit("{tree.name}", {io_string}, *ClockInterface(has_ce={has_ce}))
"""
    if has_ce:
        magma_source += f"CE = {tree.name}.CE\n"
# CE = {CE}
    if num_states > 1:
        magma_source += f"""\
Buffer = DefineCircuit("__silica_Buffer{tree.name}", "I", In(Bits({num_states})), "O", Out(Bits({num_states})))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()

import types
def generate_fsm_mux(next, width, reg, path_state, output=False):
    if hasattr(width, "__len__"):  # Hack to check for tuple since magma overrides it
        filtered_next = []
        for curr, state in next:
            if curr[0] is None:
                assert all(not x for x in curr)
            else:
                filtered_next.append((curr, state))
        if len(filtered_next) == 2:
            muxs = [DefineMux(2, width[1])() for _ in range(width[0])]
            for mux, r in zip(muxs,reg):
                wire(mux.O, r.I)
        else:
            mux = DefineSilicaMux(len(filtered_next), width[1])()
            wire(mux.O, reg.I)
        CES = []
        for i, (input_, state) in enumerate(filtered_next):
            curr = list(filter(lambda x: x, curr))
            for j, input_ in enumerate(input_):
                if isinstance(input_, list):
                    input_ = bits(input_)
                wire(getattr(muxs[j], f"I{{i}}"), input_)
                if len(filtered_next) == 2:
                    if i == 0:
                        wire(muxs[j].S, path_state.O[state])
                else:
                    wire(muxs[j].S[i], path_state.O[state])
            CES.append(path_state.O[state])
        if len(CES) == 1:
            wire(CES[0], reg.CE)
        else:
            for i in range(len(reg)):
                wire(or_(*CES), reg[i].CE)
    else:
        mux = DefineSilicaMux(len(next), width)()
        if output:
            wire(mux.O, reg)
        else:
            wire(mux.O, reg.I)
        for i, (input_, state) in enumerate(next):
            if isinstance(input_, list):
                input_ = bits(input_)
            wire(getattr(mux, f"I{{i}}"), input_)
            wire(mux.S[state], path_state.O[state])
"""
        if num_yields > 0:
            magma_source += f"""\
__silica_yield_state = Register({num_yields}, init=1, has_ce={has_ce})
{wire(__silica_yield_state.CE, CE) if has_ce else ""}
wireclock({tree.name}, __silica_yield_state)
"""
            if all(state.end_yield_id == states[0].end_yield_id for state in states):
                magma_source += f"wire(bits(1 << {states[0].end_yield_id}, {num_yields}), __silica_yield_state.I)\n"
            else:
                yield_id_map = {}
                for i, state in enumerate(states):
                    for start_yield_id in state.start_yield_ids:
                        if start_yield_id not in yield_id_map:
                            yield_id_map[start_yield_id] = []
                        yield_id_map[start_yield_id].append(state.end_yield_id)
                if all(len(value) == 1 for value in yield_id_map.values()):
                    inverse_map = {}
                    for key, value in yield_id_map.items():
                        value = value[0]
                        if value not in inverse_map:
                            inverse_map[value] = []
                        inverse_map[value].append(key)
                    for end_yield_id in inverse_map:
                        starts = inverse_map[end_yield_id]
                        if len(starts) == 1:
                            magma_source += f"wire(__silica_yield_state.O[{starts[0]}], __silica_yield_state.I[{end_yield_id}])\n"
                        else:
                            args = ", ".join(f"__silica_yield_state.O[{id_}]" for id_ in starts)
                            cond = f"or_({args})"
                            magma_source += f"wire({cond}, __silica_yield_state.I[{end_yield_id}])\n"
                    for i in range(num_yields):
                        if i not in inverse_map:
                            magma_source += f"wire(0, __silica_yield_state.I[{i}])\n"

                else:
                    magma_source += f"__silica_yield_state_next = DefineSilicaMux({num_states}, {num_yields})()\n"
                    magma_source += f"wire(__silica_path_state.O, __silica_yield_state_next.S)\n"
                    magma_source += "wire(__silica_yield_state_next.O, __silica_yield_state.I)\n"
                    for i, state in enumerate(states):
                        end_yield_id = state.end_yield_id
                        if not initial_basic_block:
                            end_yield_id -= 1
                        if not all(state.end_yield_id == states[0].end_yield_id for state in states):
                            magma_source += f"wire(__silica_yield_state_next.I{i}, bits(1 << {end_yield_id}, {num_yields}))\n"
    if coroutine._inputs:
        for input_, type_ in coroutine._inputs.items():
            magma_source += f"{input_} = {tree.name}.{input_}\n"

    for statement, sub_coroutine in sub_coroutines:
        magma_source += astor.to_source(statement)
        name = statement.targets[0].id
        if num_states > 1:
            for i, (input_, type_) in enumerate(sub_coroutine._inputs.items()):
                magma_source += f"""\
{name}_inputs_{i} = DefineSilicaMux({num_states}, {get_input_width(type_)})()
wire({name}_inputs_{i}.O, {name}.{input_})
wire(__silica_path_state.O, {name}_inputs_{i}.S)
"""

    for register in registers:
        num_stores = 0
        for state in states:
            stores = set()
            for statement in state.statements:
                stores |= CollectStoredArrays().run(statement)
                stores |= collect_names(statement, ast.Store)
            if register in stores:
                num_stores += 1
        width = width_table[register]
        if width is None:
            init_string = ""
            if register in register_initial_values and register_initial_values[register] is not None:
                init_string = f", init={register_initial_values[register]}"
            magma_source += f"{register} = DFF(has_ce={has_ce}, name=\"{register}\"{init_string})\n"
            # magma_source += f"{register}_CE = [CE]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            magma_source += f"wireclock({tree.name}, {register})\n"
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                # magma_source += f"{register}_next = DefineSilicaMux({num_states}, {width})()\n"
                # magma_source += f"wire(__silica_path_state.O, {register}_next.S)\n"
                # magma_source += f"wire({register}_next.O, {register}.I)\n"
        elif isinstance(width, MemoryType):
            magma_source += f"{register} = DefineCoreirMem({width.height}, {width.width})()\n"
        elif isinstance(width, tuple):
            if len(width) > 2:
                raise NotImplementedError()
            magma_source += f"{register} = [Register({width[1]}, has_ce=True) for _ in range({width[0]})]\n"
            # magma_source += f"{register} = DefineCoreirMem({width[0]}, {width[1]})()\n"
            # magma_source += f"{register}_CE = [[CE] for _ in range({width[0]})]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                for i in range(num_states):
                    magma_source += f"{register}_next_{i}_tmp = [None for _ in range({width[0]})]\n"
                # magma_source += f"{register}_next = [DefineSilicaMux({num_states}, {width[1]})() for _ in range({width[0]})]\n"
#                 magma_source += f"""\
# for __silica_i in range({width[0]}):
#     wire(__silica_path_state.O, {register}_next[__silica_i].S)\n
# """
#                 magma_source += f"""\
# for __silica_i in range({width[0]}):
#     wire({register}_next[__silica_i].O, {register}[__silica_i].I)
# """
#                 if num_states > 1:
#                     for i in range(num_states):
#                         magma_source += f"""\
# {register}_next_{i}_tmp = []
# for __silica_j in range({width[0]}):
#     {register}_next_{i}_tmp.append({register}[__silica_j].O)
# """
        else:
            magma_source += f"{register} = Register({width}, has_ce={has_ce})\n"
            # magma_source += f"{register}_CE = [CE]\n"
            magma_source += f"{wire({register}.CE, CE)}" if has_ce else ""
            magma_source += f"wireclock({tree.name}, {register})\n"
            if num_states > 1:
                magma_source += f"{register}_next = []\n"
                # magma_source += f"{register}_next = DefineSilicaMux({num_states}, {width})()\n"
                # magma_source += f"wire(__silica_path_state.O, {register}_next.S)\n"
                # magma_source += f"wire({register}_next.O, {register}.I)\n"

    for output in outputs:
        width = width_table[output]
        orig = output
        if num_states > 1:
            magma_source += f"{output}_output = []\n"
            # magma_source += f"{output} = DefineSilicaMux({num_states}, {width})()\n"
            # magma_source += f"wire(__silica_path_state.O, {output}.S)\n"
            # magma_source += f"wire({output}.O, {tree.name}.{orig})\n"
    raddrs = {}
    waddrs = {}
    wdatas = {}
    wens = {}
    for i, state in enumerate(states):
        load_symbol_map = {}
        store_symbol_map = {}
        arrays = set()
        memories = set()
        for register in registers:
            if isinstance(width_table[register], tuple):
                arrays.add(register)
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
            elif isinstance(width_table[register], MemoryType):
                memories.add(register)
            else:
                load_symbol_map[register] = ast.parse(f"{register}.O").body[0].value
                store_symbol_map[register] = ast.parse(f"{register}_next_{i}_tmp").body[0].value
                if width_table[register] is None:
                    magma_source += f"{register}_next_{i}_tmp = {register}.O\n"
                else:
                    magma_source += f"{register}_next_{i}_tmp = [{register}.O[__silica_i] for __silica_i in range({width_table[register]})]\n"
        for output in outputs:
            if output not in registers:
                store_symbol_map[output] = ast.parse(f"{output}_{i}_tmp").body[0].value
        stores = set()
        for statement in state.statements:
            stores |= CollectStoredArrays().run(statement)
            stores |= collect_names(statement, ast.Store)
            for array in arrays:
                statement, stored, raddr, waddr, wdata = replace_arrays(statement, array, i)
                if stored:
                    stores.add(array)
            for memory in memories:
                statement, raddr, waddr, wdata = replace_memory(statement, memory, i)
                if raddr:
                    assert memory not in raddrs or raddrs[memory] == raddr
                    raddrs[memory] = raddr
                if waddr:
                    assert memory not in waddrs or waddrs[memory] == waddr, (waddr, memory, waddrs[memory])
                    waddrs[memory] = waddr
                    if memory not in wens:
                        wens[memory] = set()
                    wens[memory].add(i)
                if wdata:
                    assert memory not in wdatas or wdatas[memory] == wdata
                    wdatas[memory] = wdata
            statement = replace_assign_to_bits(statement, load_symbol_map, store_symbol_map)
            statement = replace_symbols(statement, load_symbol_map, ast.Load)
            statement = replace_symbols(statement, store_symbol_map, ast.Store)
            magma_source += astor.to_source(statement)
            for var in stores:
                if var in width_table and isinstance(width_table[var], MemoryType):
                    continue
                if var in registers:
                    load_symbol_map[var] = ast.parse(f"{var}_next_{i}_tmp").body[0].value
                elif var in outputs:
                    load_symbol_map[var] = ast.parse(f"{var}_{i}_tmp").body[0].value
        for register in registers:
            if isinstance(width_table[register], MemoryType):
                continue
            if num_states > 1:
                magma_source += f"""{register}_next.append(({register}_next_{i}_tmp, {i}))\n"""
            else:
                magma_source += f"""wire({register}_next_{i}_tmp, {register}.I)\n"""
#             if isinstance(width_table[register], tuple):
#                 if register in stores:
#                     magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     wire({register}_next_{i}_tmp[__silica_i], {register}_next[__silica_i].I{i})
# """
#                 else:
#                     magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     wire({register}[__silica_i].O, {register}_next[__silica_i].I{i})
# """
#             else:
#                 if width_table[register] is None:
#                     if num_states > 1:
#                         magma_source += f"wire({register}_next_{i}_tmp, {register}_next.I{i})\n"
#                     else:
#                         magma_source += f"wire({register}_next_{i}_tmp, {register}.I)\n"
#                 else:
#                     if num_states > 1:
#                         magma_source += f"""\
# wire(bits({register}_next_{i}_tmp), {register}_next.I{i})
# """
#                     else:
#                         magma_source += f"""\
# wire(bits({register}_next_{i}_tmp), {register}.I)
# """

        for output in outputs:
            if output not in registers:
                if num_states > 1:
                    # magma_source += f"wire({output}_{i}_tmp, {output}.I{i})\n"
                    magma_source += f"{output}_output.append(({output}_{i}_tmp, {i}))\n"
                else:
                    magma_source += f"wire({output}_{i}_tmp, {tree.name}.{output})\n"
            elif output in stores:
                # magma_source += f"wire({output}_next_{i}_tmp, {output}_output.I{i})\n"
                magma_source += f"{output}_output.append(({output}_next_{i}_tmp, {i}))\n"
            # else:
            #     # magma_source += f"wire({output}.O, {output}_output.I{i})\n"
            #     magma_source += f"{output}_output.append(({output}.O, {i}))\n"

        # curr = ast.parse(f"__silica_yield_state_next_{i}.O[{state.start_yield_id}]").body[0].value
        conds = []
        if num_yields > 0:
            for start_yield_id in state.start_yield_ids:
                if not initial_basic_block and num_yields > 0:
                    start_yield_id -= 1
                conds.append(ast.parse(f"__silica_yield_state.O[{start_yield_id}]").body[0].value)
        if len(conds) > 1:
            conds = [ast.Call(ast.Name("or_", ast.Load()), conds, [])]
        if state.conds:
            for cond in state.conds:
                cond = replace_symbols(cond, load_symbol_map, ast.Load)
                conds.append(cond)
        if not conds:
            cond = ast.parse("True")
        elif len(conds) > 1:
            cond = ast.Call(ast.Name("and_", ast.Load()), conds, [])
        else:
            cond = conds[0]
        if num_states > 1 :
            magma_source += f"wire(__silica_path_state.I[{i}], {astor.to_source(cond).rstrip()})\n"
    for array, raddr in raddrs.items():
        magma_source += f"wire({array}.raddr, {raddr}.O)\n"
    for array, waddr in waddrs.items():
        magma_source += f"wire({array}.waddr, {waddr}.O)\n"
    for array, wdata in wdatas.items():
        magma_source += f"wire({array}.wdata, {wdata})\n"
    for array, wens in wens.items():
        wens = ", ".join(f"__silica_path_state.O[{i}]" for i in wens)
        magma_source += f"wire({array}.wen, or_({wens}))\n"
    if num_states > 1:
        for register in registers:
            width = width_table[register]
            if not isinstance(width, MemoryType):
                magma_source += f"generate_fsm_mux({register}_next, {width}, {register}, __silica_path_state)\n"
        for output in outputs:
            width = width_table[output]
            magma_source += f"generate_fsm_mux({output}_output, {width}, {tree.name}.{output}, __silica_path_state, output=True)\n"

#     for register in registers:
#         if isinstance(width_table[register], tuple):
#             magma_source += f"""\
# for __silica_i in range({width_table[register][0]}):
#     if len({register}_CE[__silica_i]) == 1:
#         wire({register}_CE[__silica_i][0], {register}[__silica_i].CE)
#     else:
#         wire(and_(*{register}_CE[__silica_i]), {register}[__silica_i].CE)
# """
#         else:
#             magma_source += f"""\
# if len({register}_CE) == 1:
#     wire({register}_CE[0], {register}.CE)
# else:
#     wire(and_(*{register}_CE), {register}.CE)
# """
    magma_source += "EndDefine()"

    return magma_source

def compile_magma(coroutine, file_name, mux_strategy, output):
    stack = inspect.stack()
    func_locals = stack[2].frame.f_locals
    func_globals = stack[2].frame.f_globals
    magma_source = magma_compile(coroutine, func_globals, func_locals)
    magma_source = f"""\
from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator


@cache_definition
def DefineSilicaMux(height, width):
    if "{mux_strategy}" == "one-hot":
        if width is None:
            T = Bit
        else:
            T = Bits(width)
        inputs = []
        for i in range(height):
            inputs += [f"I{{i}}", In(T)]
        class OneHotMux(Circuit):
            name = "SilicaOneHotMux{{}}{{}}".format(height, width)
            IO = inputs + ["S", In(Bits(height)), "O", Out(T)]
            @classmethod
            def definition(io):
                or_ = Or(height, width)
                wire(io.O, or_.O)
                for i in range(height):
                    and_ = And(2, width)
                    wire(and_.I0, getattr(io, f"I{{i}}"))
                    if width is not None:
                        for j in range(width):
                            wire(and_.I1[j], io.S[i])
                    else:
                        wire(and_.I1, io.S[i])
                    wire(getattr(or_, f"I{{i}}"), and_.O)
        return OneHotMux
    else:
        raise NotImplementedError()

""" + magma_source
    if int(os.environ.get("SILICA_DEBUG_LEVEL", "0")) > 0:
        print("\n".join(f"{i + 1}: {line}" for i, line in enumerate(magma_source.splitlines())))
    if file_name is None:
        exec(magma_source, func_globals, func_locals)
        return eval(coroutine._name, func_globals, func_locals)
    else:
        if silica.config.compile_dir == 'callee_file_dir':
            (_, callee_file_name, _, _, _, _) = inspect.getouterframes(inspect.currentframe())[1]
            file_path = os.path.dirname(callee_file_name)
            file_name = os.path.join(file_path, file_name)

        with open(file_name, "w") as output_file:
            output_file.write(magma_source)
        base = os.path.basename(file_name)
        import importlib.util
        spec = importlib.util.spec_from_file_location(os.path.splitext(base)[0], file_name)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return getattr(module, coroutine._name)
