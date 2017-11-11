from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator


@cache_definition
def DefineSilicaMux(height, width, strategy):
    if strategy == "one-hot":
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
__silica_yield_state = Register(2, init=1, has_ce=False)

wireclock(Detect111, __silica_yield_state)
__silica_yield_state_next = DefineSilicaMux(6, 2, strategy="one-hot")()
wire(__silica_path_state.O, __silica_yield_state_next.S)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
I = Detect111.I
cnt = Register(2, has_ce=False)
wireclock(Detect111, cnt)
cnt_next = DefineSilicaMux(6, 2, strategy="one-hot")()
wire(__silica_path_state.O, cnt_next.S)
wire(cnt_next.O, cnt.I)
O = DefineSilicaMux(6, None, strategy="one-hot")()
wire(__silica_path_state.O, O.S)
wire(O.O, Detect111.O)
cnt_next_0_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_0 = I
__silica_cond_1 = lt(cnt.O, uint(3, 2))
cnt_next_0_tmp = add(cnt.O, uint(1, 2))
O_0_tmp = eq(cnt_next_0_tmp, uint(3, 2))
wire(__silica_yield_state_next.I0, bits(1 << 1, 2))
wire(bits(cnt_next_0_tmp), cnt_next.I0)
wire(O_0_tmp, O.I0)
wire(__silica_path_state.I[0], and_(__silica_yield_state.O[0], __silica_cond_0, __silica_cond_1))
cnt_next_1_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_2 = I
__silica_cond_3 = not_(lt(cnt.O, uint(3, 2)))
O_1_tmp = eq(cnt.O, uint(3, 2))
wire(__silica_yield_state_next.I1, bits(1 << 1, 2))
wire(bits(cnt_next_1_tmp), cnt_next.I1)
wire(O_1_tmp, O.I1)
wire(__silica_path_state.I[1], and_(__silica_yield_state.O[0], __silica_cond_2, __silica_cond_3))
cnt_next_2_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_4 = not_(I)
cnt_next_2_tmp = uint(0, 2)
O_2_tmp = eq(cnt_next_2_tmp, uint(3, 2))
wire(__silica_yield_state_next.I2, bits(1 << 1, 2))
wire(bits(cnt_next_2_tmp), cnt_next.I2)
wire(O_2_tmp, O.I2)
wire(__silica_path_state.I[2], and_(__silica_yield_state.O[0], __silica_cond_4))
cnt_next_3_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_5 = I
__silica_cond_6 = lt(cnt.O, uint(3, 2))
cnt_next_3_tmp = add(cnt.O, uint(1, 2))
O_3_tmp = eq(cnt_next_3_tmp, uint(3, 2))
wire(__silica_yield_state_next.I3, bits(1 << 1, 2))
wire(bits(cnt_next_3_tmp), cnt_next.I3)
wire(O_3_tmp, O.I3)
wire(__silica_path_state.I[3], and_(__silica_yield_state.O[1], __silica_cond_5, __silica_cond_6))
cnt_next_4_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_7 = I
__silica_cond_8 = not_(lt(cnt.O, uint(3, 2)))
O_4_tmp = eq(cnt.O, uint(3, 2))
wire(__silica_yield_state_next.I4, bits(1 << 1, 2))
wire(bits(cnt_next_4_tmp), cnt_next.I4)
wire(O_4_tmp, O.I4)
wire(__silica_path_state.I[4], and_(__silica_yield_state.O[1], __silica_cond_7, __silica_cond_8))
cnt_next_5_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_9 = not_(I)
cnt_next_5_tmp = uint(0, 2)
O_5_tmp = eq(cnt_next_5_tmp, uint(3, 2))
wire(__silica_yield_state_next.I5, bits(1 << 1, 2))
wire(bits(cnt_next_5_tmp), cnt_next.I5)
wire(O_5_tmp, O.I5)
wire(__silica_path_state.I[5], and_(__silica_yield_state.O[1], __silica_cond_9))
EndDefine()