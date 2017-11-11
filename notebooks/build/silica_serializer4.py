from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

Serializer4 = DefineCircuit("Serializer4", "O", Out(Bits(16)), "I", In(Array(4,Bits(16))), *ClockInterface(has_ce=False))

Buffer = DefineCircuit("__silica_BufferSerializer4", "I", In(Bits(5)), "O", Out(Bits(5)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
__silica_yield_state = Register(5, init=1, has_ce=False)

wireclock(Serializer4, __silica_yield_state)

__silica_yield_state_next = Or(5, 5)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
I = Serializer4.I
__silica_yield_state_next_0 = And(2, 5)
wire(__silica_yield_state_next_0.O, __silica_yield_state_next.I0)
for __silica_j in range(5):
    wire(__silica_yield_state_next_0.I0[__silica_j], __silica_path_state.O[0])
__silica_yield_state_next_1 = And(2, 5)
wire(__silica_yield_state_next_1.O, __silica_yield_state_next.I1)
for __silica_j in range(5):
    wire(__silica_yield_state_next_1.I0[__silica_j], __silica_path_state.O[1])
__silica_yield_state_next_2 = And(2, 5)
wire(__silica_yield_state_next_2.O, __silica_yield_state_next.I2)
for __silica_j in range(5):
    wire(__silica_yield_state_next_2.I0[__silica_j], __silica_path_state.O[2])
__silica_yield_state_next_3 = And(2, 5)
wire(__silica_yield_state_next_3.O, __silica_yield_state_next.I3)
for __silica_j in range(5):
    wire(__silica_yield_state_next_3.I0[__silica_j], __silica_path_state.O[3])
__silica_yield_state_next_4 = And(2, 5)
wire(__silica_yield_state_next_4.O, __silica_yield_state_next.I4)
for __silica_j in range(5):
    wire(__silica_yield_state_next_4.I0[__silica_j], __silica_path_state.O[4])
data = [Register(16, has_ce=False) for _ in range(3)]
data_next = [Or(5, 16) for _ in range(3)]
for __silica_i in range(3):
    wire(data_next[__silica_i].O, data[__silica_i].I)
data_next_0 = [And(2, 16) for _ in range(3)]
data_next_0_tmp = []
for __silica_j in range(3):
    data_next_0_tmp.append(data[__silica_j].O)
    wire(data_next_0[__silica_j].O, data_next[__silica_j].I0)
    for __silica_k in range(16):
        wire(data_next_0[__silica_j].I0[__silica_k], __silica_path_state.O[0])
data_next_1 = [And(2, 16) for _ in range(3)]
data_next_1_tmp = []
for __silica_j in range(3):
    data_next_1_tmp.append(data[__silica_j].O)
    wire(data_next_1[__silica_j].O, data_next[__silica_j].I1)
    for __silica_k in range(16):
        wire(data_next_1[__silica_j].I0[__silica_k], __silica_path_state.O[1])
data_next_2 = [And(2, 16) for _ in range(3)]
data_next_2_tmp = []
for __silica_j in range(3):
    data_next_2_tmp.append(data[__silica_j].O)
    wire(data_next_2[__silica_j].O, data_next[__silica_j].I2)
    for __silica_k in range(16):
        wire(data_next_2[__silica_j].I0[__silica_k], __silica_path_state.O[2])
data_next_3 = [And(2, 16) for _ in range(3)]
data_next_3_tmp = []
for __silica_j in range(3):
    data_next_3_tmp.append(data[__silica_j].O)
    wire(data_next_3[__silica_j].O, data_next[__silica_j].I3)
    for __silica_k in range(16):
        wire(data_next_3[__silica_j].I0[__silica_k], __silica_path_state.O[3])
data_next_4 = [And(2, 16) for _ in range(3)]
data_next_4_tmp = []
for __silica_j in range(3):
    data_next_4_tmp.append(data[__silica_j].O)
    wire(data_next_4[__silica_j].O, data_next[__silica_j].I4)
    for __silica_k in range(16):
        wire(data_next_4[__silica_j].I0[__silica_k], __silica_path_state.O[4])
O = Or(5, 16)
wire(O.O, Serializer4.O)
O_0 = And(2, 16)
wire(O_0.O, O.I0)
for __silica_j in range(16):
    wire(O_0.I0[__silica_j], __silica_path_state.O[0])
O_1 = And(2, 16)
wire(O_1.O, O.I1)
for __silica_j in range(16):
    wire(O_1.I0[__silica_j], __silica_path_state.O[1])
O_2 = And(2, 16)
wire(O_2.O, O.I2)
for __silica_j in range(16):
    wire(O_2.I0[__silica_j], __silica_path_state.O[2])
O_3 = And(2, 16)
wire(O_3.O, O.I3)
for __silica_j in range(16):
    wire(O_3.I0[__silica_j], __silica_path_state.O[3])
O_4 = And(2, 16)
wire(O_4.O, O.I4)
for __silica_j in range(16):
    wire(O_4.I0[__silica_j], __silica_path_state.O[4])
O_0_tmp = I[0]
data_next_0_tmp[0] = I[1]
data_next_0_tmp[1] = I[2]
data_next_0_tmp[2] = I[3]
wire(__silica_yield_state_next_0.I1, bits(1 << 1, 5))
for __silica_i in range(3):
    wire(data_next_0_tmp[__silica_i], data_next_0[__silica_i].I1)
wire(O_0_tmp, O_0.I1)
wire(__silica_path_state.I[0], __silica_yield_state.O[0])
O_1_tmp = data[0].O
wire(__silica_yield_state_next_1.I1, bits(1 << 2, 5))
for __silica_i in range(3):
    wire(data_next_1_tmp[__silica_i], data_next_1[__silica_i].I1)
wire(O_1_tmp, O_1.I1)
wire(__silica_path_state.I[1], __silica_yield_state.O[1])
O_2_tmp = data[1].O
wire(__silica_yield_state_next_2.I1, bits(1 << 3, 5))
for __silica_i in range(3):
    wire(data_next_2_tmp[__silica_i], data_next_2[__silica_i].I1)
wire(O_2_tmp, O_2.I1)
wire(__silica_path_state.I[2], __silica_yield_state.O[2])
O_3_tmp = data[2].O
wire(__silica_yield_state_next_3.I1, bits(1 << 4, 5))
for __silica_i in range(3):
    wire(data_next_3_tmp[__silica_i], data_next_3[__silica_i].I1)
wire(O_3_tmp, O_3.I1)
wire(__silica_path_state.I[3], __silica_yield_state.O[3])
O_4_tmp = I[0]
data_next_4_tmp[0] = I[1]
data_next_4_tmp[1] = I[2]
data_next_4_tmp[2] = I[3]
wire(__silica_yield_state_next_4.I1, bits(1 << 1, 5))
for __silica_i in range(3):
    wire(data_next_4_tmp[__silica_i], data_next_4[__silica_i].I1)
wire(O_4_tmp, O_4.I1)
wire(__silica_path_state.I[4], __silica_yield_state.O[4])
EndDefine()