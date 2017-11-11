from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

Detect111 = DefineCircuit("Detect111", "O", Out(Bit), "I", In(Bit), *ClockInterface(has_ce=False))

Buffer = DefineCircuit("__silica_BufferDetect111", "I", In(Bits(6)), "O", Out(Bits(6)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
__silica_yield_state = Register(2, init=1, has_ce=False)

wireclock(Detect111, __silica_yield_state)

__silica_yield_state_next = Or(6, 2)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
I = Detect111.I
__silica_yield_state_next_0 = And(2, 2)
wire(__silica_yield_state_next_0.O, __silica_yield_state_next.I0)
for __silica_j in range(2):
    wire(__silica_yield_state_next_0.I0[__silica_j], __silica_path_state.O[0])
__silica_yield_state_next_1 = And(2, 2)
wire(__silica_yield_state_next_1.O, __silica_yield_state_next.I1)
for __silica_j in range(2):
    wire(__silica_yield_state_next_1.I0[__silica_j], __silica_path_state.O[1])
__silica_yield_state_next_2 = And(2, 2)
wire(__silica_yield_state_next_2.O, __silica_yield_state_next.I2)
for __silica_j in range(2):
    wire(__silica_yield_state_next_2.I0[__silica_j], __silica_path_state.O[2])
__silica_yield_state_next_3 = And(2, 2)
wire(__silica_yield_state_next_3.O, __silica_yield_state_next.I3)
for __silica_j in range(2):
    wire(__silica_yield_state_next_3.I0[__silica_j], __silica_path_state.O[3])
__silica_yield_state_next_4 = And(2, 2)
wire(__silica_yield_state_next_4.O, __silica_yield_state_next.I4)
for __silica_j in range(2):
    wire(__silica_yield_state_next_4.I0[__silica_j], __silica_path_state.O[4])
__silica_yield_state_next_5 = And(2, 2)
wire(__silica_yield_state_next_5.O, __silica_yield_state_next.I5)
for __silica_j in range(2):
    wire(__silica_yield_state_next_5.I0[__silica_j], __silica_path_state.O[5])
cnt = Register(2, has_ce=False)
wireclock(Detect111, cnt)
cnt_next = Or(6, 2)
wire(cnt_next.O, cnt.I)
cnt_next_0 = And(2, 2)
wire(cnt_next_0.O, cnt_next.I0)
wire(cnt_next_0.I0[0], __silica_path_state.O[0])
wire(cnt_next_0.I0[1], __silica_path_state.O[0])
cnt_next_1 = And(2, 2)
wire(cnt_next_1.O, cnt_next.I1)
wire(cnt_next_1.I0[0], __silica_path_state.O[1])
wire(cnt_next_1.I0[1], __silica_path_state.O[1])
cnt_next_2 = And(2, 2)
wire(cnt_next_2.O, cnt_next.I2)
wire(cnt_next_2.I0[0], __silica_path_state.O[2])
wire(cnt_next_2.I0[1], __silica_path_state.O[2])
cnt_next_3 = And(2, 2)
wire(cnt_next_3.O, cnt_next.I3)
wire(cnt_next_3.I0[0], __silica_path_state.O[3])
wire(cnt_next_3.I0[1], __silica_path_state.O[3])
cnt_next_4 = And(2, 2)
wire(cnt_next_4.O, cnt_next.I4)
wire(cnt_next_4.I0[0], __silica_path_state.O[4])
wire(cnt_next_4.I0[1], __silica_path_state.O[4])
cnt_next_5 = And(2, 2)
wire(cnt_next_5.O, cnt_next.I5)
wire(cnt_next_5.I0[0], __silica_path_state.O[5])
wire(cnt_next_5.I0[1], __silica_path_state.O[5])
O = Or(6, None)
wire(O.O, Detect111.O)
O_0 = And(2, None)
wire(O_0.O, O.I0)
wire(O_0.I0, __silica_path_state.O[0])
O_1 = And(2, None)
wire(O_1.O, O.I1)
wire(O_1.I0, __silica_path_state.O[1])
O_2 = And(2, None)
wire(O_2.O, O.I2)
wire(O_2.I0, __silica_path_state.O[2])
O_3 = And(2, None)
wire(O_3.O, O.I3)
wire(O_3.I0, __silica_path_state.O[3])
O_4 = And(2, None)
wire(O_4.O, O.I4)
wire(O_4.I0, __silica_path_state.O[4])
O_5 = And(2, None)
wire(O_5.O, O.I5)
wire(O_5.I0, __silica_path_state.O[5])
cnt_next_0_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_0 = I
__silica_cond_1 = lt(cnt.O, uint(3, 2))
cnt_next_0_tmp = add(cnt.O, uint(1, 2))
O_0_tmp = eq(cnt_next_0_tmp, uint(3, 2))
wire(__silica_yield_state_next_0.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_0_tmp[__silica_i], cnt_next_0.I1[__silica_i])
wire(O_0_tmp, O_0.I1)
wire(__silica_path_state.I[0], and_(__silica_yield_state.O[0], __silica_cond_0, __silica_cond_1))
cnt_next_1_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_2 = I
__silica_cond_3 = not_(lt(cnt.O, uint(3, 2)))
O_1_tmp = eq(cnt.O, uint(3, 2))
wire(__silica_yield_state_next_1.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_1_tmp[__silica_i], cnt_next_1.I1[__silica_i])
wire(O_1_tmp, O_1.I1)
wire(__silica_path_state.I[1], and_(__silica_yield_state.O[0], __silica_cond_2, __silica_cond_3))
cnt_next_2_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_4 = not_(I)
cnt_next_2_tmp = uint(0, 2)
O_2_tmp = eq(cnt_next_2_tmp, uint(3, 2))
wire(__silica_yield_state_next_2.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_2_tmp[__silica_i], cnt_next_2.I1[__silica_i])
wire(O_2_tmp, O_2.I1)
wire(__silica_path_state.I[2], and_(__silica_yield_state.O[0], __silica_cond_4))
cnt_next_3_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_5 = I
__silica_cond_6 = lt(cnt.O, uint(3, 2))
cnt_next_3_tmp = add(cnt.O, uint(1, 2))
O_3_tmp = eq(cnt_next_3_tmp, uint(3, 2))
wire(__silica_yield_state_next_3.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_3_tmp[__silica_i], cnt_next_3.I1[__silica_i])
wire(O_3_tmp, O_3.I1)
wire(__silica_path_state.I[3], and_(__silica_yield_state.O[1], __silica_cond_5, __silica_cond_6))
cnt_next_4_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_7 = I
__silica_cond_8 = not_(lt(cnt.O, uint(3, 2)))
O_4_tmp = eq(cnt.O, uint(3, 2))
wire(__silica_yield_state_next_4.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_4_tmp[__silica_i], cnt_next_4.I1[__silica_i])
wire(O_4_tmp, O_4.I1)
wire(__silica_path_state.I[4], and_(__silica_yield_state.O[1], __silica_cond_7, __silica_cond_8))
cnt_next_5_tmp = [cnt.O[__silica_i] for __silica_i in range(2)]
__silica_cond_9 = not_(I)
cnt_next_5_tmp = uint(0, 2)
O_5_tmp = eq(cnt_next_5_tmp, uint(3, 2))
wire(__silica_yield_state_next_5.I1, bits(1 << 1, 2))
for __silica_i in range(2):
    wire(cnt_next_5_tmp[__silica_i], cnt_next_5.I1[__silica_i])
wire(O_5_tmp, O_5.I1)
wire(__silica_path_state.I[5], and_(__silica_yield_state.O[1], __silica_cond_9))
EndDefine()