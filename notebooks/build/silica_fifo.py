from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

Fifo = DefineCircuit("Fifo", "full", Out(Bit), "empty", Out(Bit), "rdata", Out(Bits(4)), "wdata", In(Bits(4)), "wen", In(Bit), "ren", In(Bit), *ClockInterface(has_ce=False))

Buffer = DefineCircuit("__silica_BufferFifo", "I", In(Bits(8)), "O", Out(Bits(8)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
__silica_yield_state = Register(2, init=1, has_ce=False)

wireclock(Fifo, __silica_yield_state)

__silica_yield_state_next = Or(8, 2)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
wdata = Fifo.wdata
wen = Fifo.wen
ren = Fifo.ren
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
__silica_yield_state_next_6 = And(2, 2)
wire(__silica_yield_state_next_6.O, __silica_yield_state_next.I6)
for __silica_j in range(2):
    wire(__silica_yield_state_next_6.I0[__silica_j], __silica_path_state.O[6])
__silica_yield_state_next_7 = And(2, 2)
wire(__silica_yield_state_next_7.O, __silica_yield_state_next.I7)
for __silica_j in range(2):
    wire(__silica_yield_state_next_7.I0[__silica_j], __silica_path_state.O[7])
memory = [Register(4, has_ce=False) for _ in range(4)]
memory_next = [Or(8, 4) for _ in range(4)]
for __silica_i in range(4):
    wire(memory_next[__silica_i].O, memory[__silica_i].I)
memory_next_0 = [And(2, 4) for _ in range(4)]
memory_next_0_tmp = []
for __silica_j in range(4):
    memory_next_0_tmp.append(memory[__silica_j].O)
    wire(memory_next_0[__silica_j].O, memory_next[__silica_j].I0)
    for __silica_k in range(4):
        wire(memory_next_0[__silica_j].I0[__silica_k], __silica_path_state.O[0])
memory_next_1 = [And(2, 4) for _ in range(4)]
memory_next_1_tmp = []
for __silica_j in range(4):
    memory_next_1_tmp.append(memory[__silica_j].O)
    wire(memory_next_1[__silica_j].O, memory_next[__silica_j].I1)
    for __silica_k in range(4):
        wire(memory_next_1[__silica_j].I0[__silica_k], __silica_path_state.O[1])
memory_next_2 = [And(2, 4) for _ in range(4)]
memory_next_2_tmp = []
for __silica_j in range(4):
    memory_next_2_tmp.append(memory[__silica_j].O)
    wire(memory_next_2[__silica_j].O, memory_next[__silica_j].I2)
    for __silica_k in range(4):
        wire(memory_next_2[__silica_j].I0[__silica_k], __silica_path_state.O[2])
memory_next_3 = [And(2, 4) for _ in range(4)]
memory_next_3_tmp = []
for __silica_j in range(4):
    memory_next_3_tmp.append(memory[__silica_j].O)
    wire(memory_next_3[__silica_j].O, memory_next[__silica_j].I3)
    for __silica_k in range(4):
        wire(memory_next_3[__silica_j].I0[__silica_k], __silica_path_state.O[3])
memory_next_4 = [And(2, 4) for _ in range(4)]
memory_next_4_tmp = []
for __silica_j in range(4):
    memory_next_4_tmp.append(memory[__silica_j].O)
    wire(memory_next_4[__silica_j].O, memory_next[__silica_j].I4)
    for __silica_k in range(4):
        wire(memory_next_4[__silica_j].I0[__silica_k], __silica_path_state.O[4])
memory_next_5 = [And(2, 4) for _ in range(4)]
memory_next_5_tmp = []
for __silica_j in range(4):
    memory_next_5_tmp.append(memory[__silica_j].O)
    wire(memory_next_5[__silica_j].O, memory_next[__silica_j].I5)
    for __silica_k in range(4):
        wire(memory_next_5[__silica_j].I0[__silica_k], __silica_path_state.O[5])
memory_next_6 = [And(2, 4) for _ in range(4)]
memory_next_6_tmp = []
for __silica_j in range(4):
    memory_next_6_tmp.append(memory[__silica_j].O)
    wire(memory_next_6[__silica_j].O, memory_next[__silica_j].I6)
    for __silica_k in range(4):
        wire(memory_next_6[__silica_j].I0[__silica_k], __silica_path_state.O[6])
memory_next_7 = [And(2, 4) for _ in range(4)]
memory_next_7_tmp = []
for __silica_j in range(4):
    memory_next_7_tmp.append(memory[__silica_j].O)
    wire(memory_next_7[__silica_j].O, memory_next[__silica_j].I7)
    for __silica_k in range(4):
        wire(memory_next_7[__silica_j].I0[__silica_k], __silica_path_state.O[7])
raddr = Register(2, has_ce=False)
wireclock(Fifo, raddr)
raddr_next = Or(8, 2)
wire(raddr_next.O, raddr.I)
raddr_next_0 = And(2, 2)
wire(raddr_next_0.O, raddr_next.I0)
wire(raddr_next_0.I0[0], __silica_path_state.O[0])
wire(raddr_next_0.I0[1], __silica_path_state.O[0])
raddr_next_1 = And(2, 2)
wire(raddr_next_1.O, raddr_next.I1)
wire(raddr_next_1.I0[0], __silica_path_state.O[1])
wire(raddr_next_1.I0[1], __silica_path_state.O[1])
raddr_next_2 = And(2, 2)
wire(raddr_next_2.O, raddr_next.I2)
wire(raddr_next_2.I0[0], __silica_path_state.O[2])
wire(raddr_next_2.I0[1], __silica_path_state.O[2])
raddr_next_3 = And(2, 2)
wire(raddr_next_3.O, raddr_next.I3)
wire(raddr_next_3.I0[0], __silica_path_state.O[3])
wire(raddr_next_3.I0[1], __silica_path_state.O[3])
raddr_next_4 = And(2, 2)
wire(raddr_next_4.O, raddr_next.I4)
wire(raddr_next_4.I0[0], __silica_path_state.O[4])
wire(raddr_next_4.I0[1], __silica_path_state.O[4])
raddr_next_5 = And(2, 2)
wire(raddr_next_5.O, raddr_next.I5)
wire(raddr_next_5.I0[0], __silica_path_state.O[5])
wire(raddr_next_5.I0[1], __silica_path_state.O[5])
raddr_next_6 = And(2, 2)
wire(raddr_next_6.O, raddr_next.I6)
wire(raddr_next_6.I0[0], __silica_path_state.O[6])
wire(raddr_next_6.I0[1], __silica_path_state.O[6])
raddr_next_7 = And(2, 2)
wire(raddr_next_7.O, raddr_next.I7)
wire(raddr_next_7.I0[0], __silica_path_state.O[7])
wire(raddr_next_7.I0[1], __silica_path_state.O[7])
waddr = Register(2, has_ce=False)
wireclock(Fifo, waddr)
waddr_next = Or(8, 2)
wire(waddr_next.O, waddr.I)
waddr_next_0 = And(2, 2)
wire(waddr_next_0.O, waddr_next.I0)
wire(waddr_next_0.I0[0], __silica_path_state.O[0])
wire(waddr_next_0.I0[1], __silica_path_state.O[0])
waddr_next_1 = And(2, 2)
wire(waddr_next_1.O, waddr_next.I1)
wire(waddr_next_1.I0[0], __silica_path_state.O[1])
wire(waddr_next_1.I0[1], __silica_path_state.O[1])
waddr_next_2 = And(2, 2)
wire(waddr_next_2.O, waddr_next.I2)
wire(waddr_next_2.I0[0], __silica_path_state.O[2])
wire(waddr_next_2.I0[1], __silica_path_state.O[2])
waddr_next_3 = And(2, 2)
wire(waddr_next_3.O, waddr_next.I3)
wire(waddr_next_3.I0[0], __silica_path_state.O[3])
wire(waddr_next_3.I0[1], __silica_path_state.O[3])
waddr_next_4 = And(2, 2)
wire(waddr_next_4.O, waddr_next.I4)
wire(waddr_next_4.I0[0], __silica_path_state.O[4])
wire(waddr_next_4.I0[1], __silica_path_state.O[4])
waddr_next_5 = And(2, 2)
wire(waddr_next_5.O, waddr_next.I5)
wire(waddr_next_5.I0[0], __silica_path_state.O[5])
wire(waddr_next_5.I0[1], __silica_path_state.O[5])
waddr_next_6 = And(2, 2)
wire(waddr_next_6.O, waddr_next.I6)
wire(waddr_next_6.I0[0], __silica_path_state.O[6])
wire(waddr_next_6.I0[1], __silica_path_state.O[6])
waddr_next_7 = And(2, 2)
wire(waddr_next_7.O, waddr_next.I7)
wire(waddr_next_7.I0[0], __silica_path_state.O[7])
wire(waddr_next_7.I0[1], __silica_path_state.O[7])
prev_full = DFF(has_ce=False, name="prev_full", init=0)
wireclock(Fifo, prev_full)
prev_full_next = Or(8, None)
wire(prev_full_next.O, prev_full.I)
prev_full_next_0 = And(2, None)
wire(prev_full_next_0.O, prev_full_next.I0)
wire(prev_full_next_0.I0, __silica_path_state.O[0])
prev_full_next_1 = And(2, None)
wire(prev_full_next_1.O, prev_full_next.I1)
wire(prev_full_next_1.I0, __silica_path_state.O[1])
prev_full_next_2 = And(2, None)
wire(prev_full_next_2.O, prev_full_next.I2)
wire(prev_full_next_2.I0, __silica_path_state.O[2])
prev_full_next_3 = And(2, None)
wire(prev_full_next_3.O, prev_full_next.I3)
wire(prev_full_next_3.I0, __silica_path_state.O[3])
prev_full_next_4 = And(2, None)
wire(prev_full_next_4.O, prev_full_next.I4)
wire(prev_full_next_4.I0, __silica_path_state.O[4])
prev_full_next_5 = And(2, None)
wire(prev_full_next_5.O, prev_full_next.I5)
wire(prev_full_next_5.I0, __silica_path_state.O[5])
prev_full_next_6 = And(2, None)
wire(prev_full_next_6.O, prev_full_next.I6)
wire(prev_full_next_6.I0, __silica_path_state.O[6])
prev_full_next_7 = And(2, None)
wire(prev_full_next_7.O, prev_full_next.I7)
wire(prev_full_next_7.I0, __silica_path_state.O[7])
prev_empty = DFF(has_ce=False, name="prev_empty", init=1)
wireclock(Fifo, prev_empty)
prev_empty_next = Or(8, None)
wire(prev_empty_next.O, prev_empty.I)
prev_empty_next_0 = And(2, None)
wire(prev_empty_next_0.O, prev_empty_next.I0)
wire(prev_empty_next_0.I0, __silica_path_state.O[0])
prev_empty_next_1 = And(2, None)
wire(prev_empty_next_1.O, prev_empty_next.I1)
wire(prev_empty_next_1.I0, __silica_path_state.O[1])
prev_empty_next_2 = And(2, None)
wire(prev_empty_next_2.O, prev_empty_next.I2)
wire(prev_empty_next_2.I0, __silica_path_state.O[2])
prev_empty_next_3 = And(2, None)
wire(prev_empty_next_3.O, prev_empty_next.I3)
wire(prev_empty_next_3.I0, __silica_path_state.O[3])
prev_empty_next_4 = And(2, None)
wire(prev_empty_next_4.O, prev_empty_next.I4)
wire(prev_empty_next_4.I0, __silica_path_state.O[4])
prev_empty_next_5 = And(2, None)
wire(prev_empty_next_5.O, prev_empty_next.I5)
wire(prev_empty_next_5.I0, __silica_path_state.O[5])
prev_empty_next_6 = And(2, None)
wire(prev_empty_next_6.O, prev_empty_next.I6)
wire(prev_empty_next_6.I0, __silica_path_state.O[6])
prev_empty_next_7 = And(2, None)
wire(prev_empty_next_7.O, prev_empty_next.I7)
wire(prev_empty_next_7.I0, __silica_path_state.O[7])
full = Or(8, None)
wire(full.O, Fifo.full)
full_0 = And(2, None)
wire(full_0.O, full.I0)
wire(full_0.I0, __silica_path_state.O[0])
full_1 = And(2, None)
wire(full_1.O, full.I1)
wire(full_1.I0, __silica_path_state.O[1])
full_2 = And(2, None)
wire(full_2.O, full.I2)
wire(full_2.I0, __silica_path_state.O[2])
full_3 = And(2, None)
wire(full_3.O, full.I3)
wire(full_3.I0, __silica_path_state.O[3])
full_4 = And(2, None)
wire(full_4.O, full.I4)
wire(full_4.I0, __silica_path_state.O[4])
full_5 = And(2, None)
wire(full_5.O, full.I5)
wire(full_5.I0, __silica_path_state.O[5])
full_6 = And(2, None)
wire(full_6.O, full.I6)
wire(full_6.I0, __silica_path_state.O[6])
full_7 = And(2, None)
wire(full_7.O, full.I7)
wire(full_7.I0, __silica_path_state.O[7])
empty = Or(8, None)
wire(empty.O, Fifo.empty)
empty_0 = And(2, None)
wire(empty_0.O, empty.I0)
wire(empty_0.I0, __silica_path_state.O[0])
empty_1 = And(2, None)
wire(empty_1.O, empty.I1)
wire(empty_1.I0, __silica_path_state.O[1])
empty_2 = And(2, None)
wire(empty_2.O, empty.I2)
wire(empty_2.I0, __silica_path_state.O[2])
empty_3 = And(2, None)
wire(empty_3.O, empty.I3)
wire(empty_3.I0, __silica_path_state.O[3])
empty_4 = And(2, None)
wire(empty_4.O, empty.I4)
wire(empty_4.I0, __silica_path_state.O[4])
empty_5 = And(2, None)
wire(empty_5.O, empty.I5)
wire(empty_5.I0, __silica_path_state.O[5])
empty_6 = And(2, None)
wire(empty_6.O, empty.I6)
wire(empty_6.I0, __silica_path_state.O[6])
empty_7 = And(2, None)
wire(empty_7.O, empty.I7)
wire(empty_7.I0, __silica_path_state.O[7])
rdata = Or(8, 4)
wire(rdata.O, Fifo.rdata)
rdata_0 = And(2, 4)
wire(rdata_0.O, rdata.I0)
for __silica_j in range(4):
    wire(rdata_0.I0[__silica_j], __silica_path_state.O[0])
rdata_1 = And(2, 4)
wire(rdata_1.O, rdata.I1)
for __silica_j in range(4):
    wire(rdata_1.I0[__silica_j], __silica_path_state.O[1])
rdata_2 = And(2, 4)
wire(rdata_2.O, rdata.I2)
for __silica_j in range(4):
    wire(rdata_2.I0[__silica_j], __silica_path_state.O[2])
rdata_3 = And(2, 4)
wire(rdata_3.O, rdata.I3)
for __silica_j in range(4):
    wire(rdata_3.I0[__silica_j], __silica_path_state.O[3])
rdata_4 = And(2, 4)
wire(rdata_4.O, rdata.I4)
for __silica_j in range(4):
    wire(rdata_4.I0[__silica_j], __silica_path_state.O[4])
rdata_5 = And(2, 4)
wire(rdata_5.O, rdata.I5)
for __silica_j in range(4):
    wire(rdata_5.I0[__silica_j], __silica_path_state.O[5])
rdata_6 = And(2, 4)
wire(rdata_6.O, rdata.I6)
for __silica_j in range(4):
    wire(rdata_6.I0[__silica_j], __silica_path_state.O[6])
rdata_7 = And(2, 4)
wire(rdata_7.O, rdata.I7)
for __silica_j in range(4):
    wire(rdata_7.I0[__silica_j], __silica_path_state.O[7])
raddr_next_0_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_0_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_0_tmp = prev_full.O
prev_empty_next_0_tmp = prev_empty.O
full_0_tmp = prev_full.O
empty_0_tmp = prev_empty.O
__silica_cond_16 = and_(wen, not_(prev_full.O))
__silica_decoder_8 = decoder(waddr.O)
for i in range(len(memory_next_0_tmp)):
    memory_next_0_tmp[i] = Mux(2, len(mux([x for x in memory_next_0_tmp], i)))(
        mux([x for x in memory_next_0_tmp], i), wdata, __silica_decoder_8[i])
waddr_next_0_tmp = add(waddr.O, uint(1, 2))
full_0_tmp = eq(raddr.O, waddr_next_0_tmp)
empty_0_tmp = bit(False)
rdata_0_tmp = mux([x for x in memory_next_0_tmp], raddr.O)
__silica_cond_17 = and_(ren, not_(prev_empty.O))
raddr_next_0_tmp = add(raddr.O, uint(1, 2))
empty_0_tmp = eq(raddr_next_0_tmp, waddr_next_0_tmp)
full_0_tmp = bit(False)
prev_full_next_0_tmp = full_0_tmp
prev_empty_next_0_tmp = empty_0_tmp
wire(__silica_yield_state_next_0.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_0_tmp[__silica_i], memory_next_0[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_0_tmp[__silica_i], raddr_next_0.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_0_tmp[__silica_i], waddr_next_0.I1[__silica_i])
wire(prev_full_next_0_tmp, prev_full_next_0.I1)
wire(prev_empty_next_0_tmp, prev_empty_next_0.I1)
wire(full_0_tmp, full_0.I1)
wire(empty_0_tmp, empty_0.I1)
wire(rdata_0_tmp, rdata_0.I1)
wire(__silica_path_state.I[0], and_(__silica_yield_state.O[0], __silica_cond_16, __silica_cond_17))
raddr_next_1_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_1_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_1_tmp = prev_full.O
prev_empty_next_1_tmp = prev_empty.O
full_1_tmp = prev_full.O
empty_1_tmp = prev_empty.O
__silica_cond_18 = and_(wen, not_(prev_full.O))
__silica_decoder_8 = decoder(waddr.O)
for i in range(len(memory_next_1_tmp)):
    memory_next_1_tmp[i] = Mux(2, len(mux([x for x in memory_next_1_tmp], i)))(
        mux([x for x in memory_next_1_tmp], i), wdata, __silica_decoder_8[i])
waddr_next_1_tmp = add(waddr.O, uint(1, 2))
full_1_tmp = eq(raddr.O, waddr_next_1_tmp)
empty_1_tmp = bit(False)
rdata_1_tmp = mux([x for x in memory_next_1_tmp], raddr.O)
__silica_cond_19 = not_(and_(ren, not_(prev_empty.O)))
prev_full_next_1_tmp = full_1_tmp
prev_empty_next_1_tmp = empty_1_tmp
wire(__silica_yield_state_next_1.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_1_tmp[__silica_i], memory_next_1[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_1_tmp[__silica_i], raddr_next_1.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_1_tmp[__silica_i], waddr_next_1.I1[__silica_i])
wire(prev_full_next_1_tmp, prev_full_next_1.I1)
wire(prev_empty_next_1_tmp, prev_empty_next_1.I1)
wire(full_1_tmp, full_1.I1)
wire(empty_1_tmp, empty_1.I1)
wire(rdata_1_tmp, rdata_1.I1)
wire(__silica_path_state.I[1], and_(__silica_yield_state.O[0], __silica_cond_18, __silica_cond_19))
raddr_next_2_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_2_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_2_tmp = prev_full.O
prev_empty_next_2_tmp = prev_empty.O
full_2_tmp = prev_full.O
empty_2_tmp = prev_empty.O
__silica_cond_20 = not_(and_(wen, not_(prev_full.O)))
rdata_2_tmp = mux([x for x in memory_next_2_tmp], raddr.O)
__silica_cond_21 = and_(ren, not_(prev_empty.O))
raddr_next_2_tmp = add(raddr.O, uint(1, 2))
empty_2_tmp = eq(raddr_next_2_tmp, waddr.O)
full_2_tmp = bit(False)
prev_full_next_2_tmp = full_2_tmp
prev_empty_next_2_tmp = empty_2_tmp
wire(__silica_yield_state_next_2.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_2_tmp[__silica_i], memory_next_2[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_2_tmp[__silica_i], raddr_next_2.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_2_tmp[__silica_i], waddr_next_2.I1[__silica_i])
wire(prev_full_next_2_tmp, prev_full_next_2.I1)
wire(prev_empty_next_2_tmp, prev_empty_next_2.I1)
wire(full_2_tmp, full_2.I1)
wire(empty_2_tmp, empty_2.I1)
wire(rdata_2_tmp, rdata_2.I1)
wire(__silica_path_state.I[2], and_(__silica_yield_state.O[0], __silica_cond_20, __silica_cond_21))
raddr_next_3_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_3_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_3_tmp = prev_full.O
prev_empty_next_3_tmp = prev_empty.O
full_3_tmp = prev_full.O
empty_3_tmp = prev_empty.O
__silica_cond_22 = not_(and_(wen, not_(prev_full.O)))
rdata_3_tmp = mux([x for x in memory_next_3_tmp], raddr.O)
__silica_cond_23 = not_(and_(ren, not_(prev_empty.O)))
prev_full_next_3_tmp = full_3_tmp
prev_empty_next_3_tmp = empty_3_tmp
wire(__silica_yield_state_next_3.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_3_tmp[__silica_i], memory_next_3[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_3_tmp[__silica_i], raddr_next_3.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_3_tmp[__silica_i], waddr_next_3.I1[__silica_i])
wire(prev_full_next_3_tmp, prev_full_next_3.I1)
wire(prev_empty_next_3_tmp, prev_empty_next_3.I1)
wire(full_3_tmp, full_3.I1)
wire(empty_3_tmp, empty_3.I1)
wire(rdata_3_tmp, rdata_3.I1)
wire(__silica_path_state.I[3], and_(__silica_yield_state.O[0], __silica_cond_22, __silica_cond_23))
raddr_next_4_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_4_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_4_tmp = prev_full.O
prev_empty_next_4_tmp = prev_empty.O
full_4_tmp = prev_full.O
empty_4_tmp = prev_empty.O
__silica_cond_24 = and_(wen, not_(prev_full.O))
__silica_decoder_8 = decoder(waddr.O)
for i in range(len(memory_next_4_tmp)):
    memory_next_4_tmp[i] = Mux(2, len(mux([x for x in memory_next_4_tmp], i)))(
        mux([x for x in memory_next_4_tmp], i), wdata, __silica_decoder_8[i])
waddr_next_4_tmp = add(waddr.O, uint(1, 2))
full_4_tmp = eq(raddr.O, waddr_next_4_tmp)
empty_4_tmp = bit(False)
rdata_4_tmp = mux([x for x in memory_next_4_tmp], raddr.O)
__silica_cond_25 = and_(ren, not_(prev_empty.O))
raddr_next_4_tmp = add(raddr.O, uint(1, 2))
empty_4_tmp = eq(raddr_next_4_tmp, waddr_next_4_tmp)
full_4_tmp = bit(False)
prev_full_next_4_tmp = full_4_tmp
prev_empty_next_4_tmp = empty_4_tmp
wire(__silica_yield_state_next_4.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_4_tmp[__silica_i], memory_next_4[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_4_tmp[__silica_i], raddr_next_4.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_4_tmp[__silica_i], waddr_next_4.I1[__silica_i])
wire(prev_full_next_4_tmp, prev_full_next_4.I1)
wire(prev_empty_next_4_tmp, prev_empty_next_4.I1)
wire(full_4_tmp, full_4.I1)
wire(empty_4_tmp, empty_4.I1)
wire(rdata_4_tmp, rdata_4.I1)
wire(__silica_path_state.I[4], and_(__silica_yield_state.O[1], __silica_cond_24, __silica_cond_25))
raddr_next_5_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_5_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_5_tmp = prev_full.O
prev_empty_next_5_tmp = prev_empty.O
full_5_tmp = prev_full.O
empty_5_tmp = prev_empty.O
__silica_cond_26 = and_(wen, not_(prev_full.O))
__silica_decoder_8 = decoder(waddr.O)
for i in range(len(memory_next_5_tmp)):
    memory_next_5_tmp[i] = Mux(2, len(mux([x for x in memory_next_5_tmp], i)))(
        mux([x for x in memory_next_5_tmp], i), wdata, __silica_decoder_8[i])
waddr_next_5_tmp = add(waddr.O, uint(1, 2))
full_5_tmp = eq(raddr.O, waddr_next_5_tmp)
empty_5_tmp = bit(False)
rdata_5_tmp = mux([x for x in memory_next_5_tmp], raddr.O)
__silica_cond_27 = not_(and_(ren, not_(prev_empty.O)))
prev_full_next_5_tmp = full_5_tmp
prev_empty_next_5_tmp = empty_5_tmp
wire(__silica_yield_state_next_5.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_5_tmp[__silica_i], memory_next_5[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_5_tmp[__silica_i], raddr_next_5.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_5_tmp[__silica_i], waddr_next_5.I1[__silica_i])
wire(prev_full_next_5_tmp, prev_full_next_5.I1)
wire(prev_empty_next_5_tmp, prev_empty_next_5.I1)
wire(full_5_tmp, full_5.I1)
wire(empty_5_tmp, empty_5.I1)
wire(rdata_5_tmp, rdata_5.I1)
wire(__silica_path_state.I[5], and_(__silica_yield_state.O[1], __silica_cond_26, __silica_cond_27))
raddr_next_6_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_6_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_6_tmp = prev_full.O
prev_empty_next_6_tmp = prev_empty.O
full_6_tmp = prev_full.O
empty_6_tmp = prev_empty.O
__silica_cond_28 = not_(and_(wen, not_(prev_full.O)))
rdata_6_tmp = mux([x for x in memory_next_6_tmp], raddr.O)
__silica_cond_29 = and_(ren, not_(prev_empty.O))
raddr_next_6_tmp = add(raddr.O, uint(1, 2))
empty_6_tmp = eq(raddr_next_6_tmp, waddr.O)
full_6_tmp = bit(False)
prev_full_next_6_tmp = full_6_tmp
prev_empty_next_6_tmp = empty_6_tmp
wire(__silica_yield_state_next_6.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_6_tmp[__silica_i], memory_next_6[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_6_tmp[__silica_i], raddr_next_6.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_6_tmp[__silica_i], waddr_next_6.I1[__silica_i])
wire(prev_full_next_6_tmp, prev_full_next_6.I1)
wire(prev_empty_next_6_tmp, prev_empty_next_6.I1)
wire(full_6_tmp, full_6.I1)
wire(empty_6_tmp, empty_6.I1)
wire(rdata_6_tmp, rdata_6.I1)
wire(__silica_path_state.I[6], and_(__silica_yield_state.O[1], __silica_cond_28, __silica_cond_29))
raddr_next_7_tmp = [raddr.O[__silica_i] for __silica_i in range(2)]
waddr_next_7_tmp = [waddr.O[__silica_i] for __silica_i in range(2)]
prev_full_next_7_tmp = prev_full.O
prev_empty_next_7_tmp = prev_empty.O
full_7_tmp = prev_full.O
empty_7_tmp = prev_empty.O
__silica_cond_30 = not_(and_(wen, not_(prev_full.O)))
rdata_7_tmp = mux([x for x in memory_next_7_tmp], raddr.O)
__silica_cond_31 = not_(and_(ren, not_(prev_empty.O)))
prev_full_next_7_tmp = full_7_tmp
prev_empty_next_7_tmp = empty_7_tmp
wire(__silica_yield_state_next_7.I1, bits(1 << 1, 2))
for __silica_i in range(4):
    wire(memory_next_7_tmp[__silica_i], memory_next_7[__silica_i].I1)
for __silica_i in range(2):
    wire(raddr_next_7_tmp[__silica_i], raddr_next_7.I1[__silica_i])
for __silica_i in range(2):
    wire(waddr_next_7_tmp[__silica_i], waddr_next_7.I1[__silica_i])
wire(prev_full_next_7_tmp, prev_full_next_7.I1)
wire(prev_empty_next_7_tmp, prev_empty_next_7.I1)
wire(full_7_tmp, full_7.I1)
wire(empty_7_tmp, empty_7.I1)
wire(rdata_7_tmp, rdata_7.I1)
wire(__silica_path_state.I[7], and_(__silica_yield_state.O[1], __silica_cond_30, __silica_cond_31))
EndDefine()