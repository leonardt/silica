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


Serializer4 = DefineCircuit("Serializer4", "O", Out(Bits(16)), "I", In(Array(4,Bits(16))), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferSerializer4", "I", In(Bits(5)), "O", Out(Bits(5)))
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
__silica_yield_state = Register(5, init=1, has_ce=False)

wireclock(Serializer4, __silica_yield_state)
wire(or_(__silica_yield_state.O[0], __silica_yield_state.O[4]), __silica_yield_state.I[1])
wire(__silica_yield_state.O[1], __silica_yield_state.I[2])
wire(__silica_yield_state.O[2], __silica_yield_state.I[3])
wire(__silica_yield_state.O[3], __silica_yield_state.I[4])
wire(0, __silica_yield_state.I[0])
I = Serializer4.I
data = [Register(16, has_ce=True) for _ in range(3)]
data_next = []
data_next_0_tmp = [None for _ in range(3)]
data_next_1_tmp = [None for _ in range(3)]
data_next_2_tmp = [None for _ in range(3)]
data_next_3_tmp = [None for _ in range(3)]
data_next_4_tmp = [None for _ in range(3)]
O_output = []
O_0_tmp = I[0]
data_next_0_tmp[0] = I[1]
data_next_0_tmp[1] = I[2]
data_next_0_tmp[2] = I[3]
data_next.append((data_next_0_tmp, 0))
O_output.append((O_0_tmp, 0))
wire(__silica_path_state.I[0], __silica_yield_state.O[0])
O_1_tmp = data[0].O
data_next.append((data_next_1_tmp, 1))
O_output.append((O_1_tmp, 1))
wire(__silica_path_state.I[1], __silica_yield_state.O[1])
O_2_tmp = data[1].O
data_next.append((data_next_2_tmp, 2))
O_output.append((O_2_tmp, 2))
wire(__silica_path_state.I[2], __silica_yield_state.O[2])
O_3_tmp = data[2].O
data_next.append((data_next_3_tmp, 3))
O_output.append((O_3_tmp, 3))
wire(__silica_path_state.I[3], __silica_yield_state.O[3])
O_4_tmp = I[0]
data_next_4_tmp[0] = I[1]
data_next_4_tmp[1] = I[2]
data_next_4_tmp[2] = I[3]
data_next.append((data_next_4_tmp, 4))
O_output.append((O_4_tmp, 4))
wire(__silica_path_state.I[4], __silica_yield_state.O[4])
generate_fsm_mux(data_next, (3, 16), data, __silica_path_state)
generate_fsm_mux(O_output, 16, Serializer4.O, __silica_path_state, output=True)
EndDefine()