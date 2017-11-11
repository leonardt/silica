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


Serializer4 = DefineCircuit("Serializer4", "O", Out(Bits(16)), "I", In(Array(4,Bits(16))), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferSerializer4", "I", In(Bits(5)), "O", Out(Bits(5)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
__silica_yield_state = Register(5, init=1, has_ce=False)

wireclock(Serializer4, __silica_yield_state)
__silica_yield_state_next = DefineSilicaMux(5, 5, strategy="one-hot")()
wire(__silica_path_state.O, __silica_yield_state_next.S)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
I = Serializer4.I
data = [Register(16, has_ce=False) for _ in range(3)]
data_next = [DefineSilicaMux(5, 16, strategy="one-hot")() for _ in range(3)]
for __silica_i in range(3):
    wire(__silica_path_state.O, data_next[__silica_i].S)

for __silica_i in range(3):
    wire(data_next[__silica_i].O, data[__silica_i].I)
data_next_0_tmp = []
for __silica_j in range(3):
    data_next_0_tmp.append(data[__silica_j].O)
data_next_1_tmp = []
for __silica_j in range(3):
    data_next_1_tmp.append(data[__silica_j].O)
data_next_2_tmp = []
for __silica_j in range(3):
    data_next_2_tmp.append(data[__silica_j].O)
data_next_3_tmp = []
for __silica_j in range(3):
    data_next_3_tmp.append(data[__silica_j].O)
data_next_4_tmp = []
for __silica_j in range(3):
    data_next_4_tmp.append(data[__silica_j].O)
O = DefineSilicaMux(5, 16, strategy="one-hot")()
wire(__silica_path_state.O, O.S)
wire(O.O, Serializer4.O)
O_0_tmp = I[0]
data_next_0_tmp[0] = I[1]
data_next_0_tmp[1] = I[2]
data_next_0_tmp[2] = I[3]
wire(__silica_yield_state_next.I0, bits(1 << 1, 5))
for __silica_i in range(3):
    wire(data_next_0_tmp[__silica_i], data_next[__silica_i].I0)
wire(O_0_tmp, O.I0)
wire(__silica_path_state.I[0], __silica_yield_state.O[0])
O_1_tmp = data[0].O
wire(__silica_yield_state_next.I1, bits(1 << 2, 5))
for __silica_i in range(3):
    wire(data_next_1_tmp[__silica_i], data_next[__silica_i].I1)
wire(O_1_tmp, O.I1)
wire(__silica_path_state.I[1], __silica_yield_state.O[1])
O_2_tmp = data[1].O
wire(__silica_yield_state_next.I2, bits(1 << 3, 5))
for __silica_i in range(3):
    wire(data_next_2_tmp[__silica_i], data_next[__silica_i].I2)
wire(O_2_tmp, O.I2)
wire(__silica_path_state.I[2], __silica_yield_state.O[2])
O_3_tmp = data[2].O
wire(__silica_yield_state_next.I3, bits(1 << 4, 5))
for __silica_i in range(3):
    wire(data_next_3_tmp[__silica_i], data_next[__silica_i].I3)
wire(O_3_tmp, O.I3)
wire(__silica_path_state.I[3], __silica_yield_state.O[3])
O_4_tmp = I[0]
data_next_4_tmp[0] = I[1]
data_next_4_tmp[1] = I[2]
data_next_4_tmp[2] = I[3]
wire(__silica_yield_state_next.I4, bits(1 << 1, 5))
for __silica_i in range(3):
    wire(data_next_4_tmp[__silica_i], data_next[__silica_i].I4)
wire(O_4_tmp, O.I4)
wire(__silica_path_state.I[4], __silica_yield_state.O[4])
EndDefine()