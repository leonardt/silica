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


Detect111 = DefineCircuit("Detect111", "O", Out(Bit), "I", In(Bit), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferDetect111", "I", In(Bits(6)), "O", Out(Bits(6)))
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
__silica_yield_state = Register(2, init=1, has_ce=False)

wireclock(Detect111, __silica_yield_state)
wire(bits(1 << 1, 2), __silica_yield_state.I)
I = Detect111.I
cnt = Register(2, has_ce=False)
wireclock(Detect111, cnt)
cnt_next = []
O_output = []
cnt_next_0_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_0 = I
__silica_cond_1 = lt(cnt.O, uint(3, 2))
cnt_next_0_tmp = add(cnt.O, uint(1, 2))
O_0_tmp = eq(cnt_next_0_tmp, uint(3, 2))
cnt_next.append((cnt_next_0_tmp, 0))
O_output.append((O_0_tmp, 0))
wire(__silica_path_state.I[0], and_(__silica_yield_state.O[0], __silica_cond_0, __silica_cond_1))
cnt_next_1_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_2 = I
__silica_cond_3 = not_(lt(cnt.O, uint(3, 2)))
O_1_tmp = eq(cnt.O, uint(3, 2))
cnt_next.append((cnt_next_1_tmp, 1))
O_output.append((O_1_tmp, 1))
wire(__silica_path_state.I[1], and_(__silica_yield_state.O[0], __silica_cond_2, __silica_cond_3))
cnt_next_2_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_4 = not_(I)
cnt_next_2_tmp = uint(0, 2)
O_2_tmp = eq(cnt_next_2_tmp, uint(3, 2))
cnt_next.append((cnt_next_2_tmp, 2))
O_output.append((O_2_tmp, 2))
wire(__silica_path_state.I[2], and_(__silica_yield_state.O[0], __silica_cond_4))
cnt_next_3_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_5 = I
__silica_cond_6 = lt(cnt.O, uint(3, 2))
cnt_next_3_tmp = add(cnt.O, uint(1, 2))
O_3_tmp = eq(cnt_next_3_tmp, uint(3, 2))
cnt_next.append((cnt_next_3_tmp, 3))
O_output.append((O_3_tmp, 3))
wire(__silica_path_state.I[3], and_(__silica_yield_state.O[1], __silica_cond_5, __silica_cond_6))
cnt_next_4_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_7 = I
__silica_cond_8 = not_(lt(cnt.O, uint(3, 2)))
O_4_tmp = eq(cnt.O, uint(3, 2))
cnt_next.append((cnt_next_4_tmp, 4))
O_output.append((O_4_tmp, 4))
wire(__silica_path_state.I[4], and_(__silica_yield_state.O[1], __silica_cond_7, __silica_cond_8))
cnt_next_5_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_9 = not_(I)
cnt_next_5_tmp = uint(0, 2)
O_5_tmp = eq(cnt_next_5_tmp, uint(3, 2))
cnt_next.append((cnt_next_5_tmp, 5))
O_output.append((O_5_tmp, 5))
wire(__silica_path_state.I[5], and_(__silica_yield_state.O[1], __silica_cond_9))
generate_fsm_mux(cnt_next, 2, cnt, __silica_path_state)
generate_fsm_mux(O_output, None, Detect111.O, __silica_path_state, output=True)
EndDefine()