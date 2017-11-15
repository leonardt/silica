from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator


@cache_definition
def DefineSilicaMux(height, width):
    if "one-hot" == "one-hot":
        if width is None:
            T = Bit
        else:
            T = Bits(width)
        inputs = []
        for i in range(height):
            inputs += [f"I{i}", In(T)]
        class OneHotMux(Circuit):
            name = "SilicaOneHotMux{}{}".format(height, width)
            IO = inputs + ["S", In(Bits(height)), "O", Out(T)]
            @classmethod
            def definition(io):
                or_ = Or(height, width)
                wire(io.O, or_.O)
                for i in range(height):
                    and_ = And(2, width)
                    wire(and_.I0, getattr(io, f"I{i}"))
                    if width is not None:
                        for j in range(width):
                            wire(and_.I1[j], io.S[i])
                    else:
                        wire(and_.I1, io.S[i])
                    wire(getattr(or_, f"I{i}"), and_.O)
        return OneHotMux
    else:
        raise NotImplementedError()


PISO = DefineCircuit("PISO", "O", Out(Bit), "SI", In(Bit), "PI", In(Bits(10)), "LOAD", In(Bit), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferPISO", "I", In(Bits(2)), "O", Out(Bits(2)))
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
        else:
            muxs = [DefineSilicaMux(len(filtered_next), width[1])() for _ in range(width[0])]
        for i in range(width[0]):
            wire(muxs[i].O, reg[i].I)
        CES = []
        for i, (input_, state) in enumerate(filtered_next):
            curr = list(filter(lambda x: x, curr))
            for j, input_ in enumerate(input_):
                if isinstance(input_, list):
                    input_ = bits(input_)
                wire(getattr(muxs[j], f"I{i}"), input_)
                if len(filtered_next) == 2:
                    if i == 0:
                        wire(muxs[j].S, path_state.O[state])
                else:
                    wire(muxs[j].S[i], path_state.O[state])
            CES.append(path_state.O[state])
        for i in range(width[0]):
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
            wire(getattr(mux, f"I{i}"), input_)
            wire(mux.S[state], path_state.O[state])
SI = PISO.SI
PI = PISO.PI
LOAD = PISO.LOAD
values = Register(10, has_ce=False)
wireclock(PISO, values)
values_next = []
O_output = []
values_next_0_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_0_tmp = values.O[negate(1)]
__silica_cond_0 = LOAD
values_next_0_tmp = PI
values_next.append((values_next_0_tmp, 0))
O_output.append((O_0_tmp, 0))
wire(__silica_path_state.I[0], __silica_cond_0)
values_next_1_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_1_tmp = values.O[negate(1)]
__silica_cond_1 = not_(LOAD)
values_next_1_tmp[9] = values.O[8]
values_next_1_tmp[8] = values_next_1_tmp[7]
values_next_1_tmp[7] = values_next_1_tmp[6]
values_next_1_tmp[6] = values_next_1_tmp[5]
values_next_1_tmp[5] = values_next_1_tmp[4]
values_next_1_tmp[4] = values_next_1_tmp[3]
values_next_1_tmp[3] = values_next_1_tmp[2]
values_next_1_tmp[2] = values_next_1_tmp[1]
values_next_1_tmp[1] = values_next_1_tmp[0]
values_next_1_tmp[0] = SI
values_next.append((values_next_1_tmp, 1))
O_output.append((O_1_tmp, 1))
wire(__silica_path_state.I[1], __silica_cond_1)
generate_fsm_mux(values_next, 10, values, __silica_path_state)
generate_fsm_mux(O_output, None, PISO.O, __silica_path_state, output=True)
EndDefine()