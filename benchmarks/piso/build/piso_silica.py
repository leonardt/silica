from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

PISO = DefineCircuit("PISO", "O", Out(Bit), "PI", In(Bits(10)), "SI", In(Bit), "LOAD", In(Bit), *ClockInterface(has_ce=False))
CE = VCC
Buffer = DefineCircuit("__silica_BufferPISO", "I", In(Bits(2)), "O", Out(Bits(2)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
PI = PISO.PI
SI = PISO.SI
LOAD = PISO.LOAD
values = Register(10, has_ce=True)
values_CE = [CE]
wireclock(PISO, values)
values_next = Or(2, 10)
wire(values_next.O, values.I)
values_next_0 = And(2, 10)
wire(values_next_0.O, values_next.I0)
wire(values_next_0.I0[0], __silica_path_state.O[0])
wire(values_next_0.I0[1], __silica_path_state.O[0])
wire(values_next_0.I0[2], __silica_path_state.O[0])
wire(values_next_0.I0[3], __silica_path_state.O[0])
wire(values_next_0.I0[4], __silica_path_state.O[0])
wire(values_next_0.I0[5], __silica_path_state.O[0])
wire(values_next_0.I0[6], __silica_path_state.O[0])
wire(values_next_0.I0[7], __silica_path_state.O[0])
wire(values_next_0.I0[8], __silica_path_state.O[0])
wire(values_next_0.I0[9], __silica_path_state.O[0])
values_next_1 = And(2, 10)
wire(values_next_1.O, values_next.I1)
wire(values_next_1.I0[0], __silica_path_state.O[1])
wire(values_next_1.I0[1], __silica_path_state.O[1])
wire(values_next_1.I0[2], __silica_path_state.O[1])
wire(values_next_1.I0[3], __silica_path_state.O[1])
wire(values_next_1.I0[4], __silica_path_state.O[1])
wire(values_next_1.I0[5], __silica_path_state.O[1])
wire(values_next_1.I0[6], __silica_path_state.O[1])
wire(values_next_1.I0[7], __silica_path_state.O[1])
wire(values_next_1.I0[8], __silica_path_state.O[1])
wire(values_next_1.I0[9], __silica_path_state.O[1])
O = Or(2, None)
wire(O.O, PISO.O)
O_0 = And(2, None)
wire(O_0.O, O.I0)
wire(O_0.I0, __silica_path_state.O[0])
O_1 = And(2, None)
wire(O_1.O, O.I1)
wire(O_1.I0, __silica_path_state.O[1])
values_next_0_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_0_tmp = values.O[negate(1)]
__silica_cond_0 = LOAD
values_next_0_tmp = PI
for __silica_i in range(10):
    wire(values_next_0_tmp[__silica_i], values_next_0.I1[__silica_i])
wire(O_0_tmp, O_0.I1)
wire(__silica_path_state.I[0], __silica_cond_0)
values_next_1_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_1_tmp = values.O[negate(1)]
__silica_cond_1 = not_(LOAD)
values_next_1_tmp[9] = values_next_1_tmp[8]
values_next_1_tmp[8] = values_next_1_tmp[7]
values_next_1_tmp[7] = values_next_1_tmp[6]
values_next_1_tmp[6] = values_next_1_tmp[5]
values_next_1_tmp[5] = values_next_1_tmp[4]
values_next_1_tmp[4] = values_next_1_tmp[3]
values_next_1_tmp[3] = values_next_1_tmp[2]
values_next_1_tmp[2] = values_next_1_tmp[1]
values_next_1_tmp[1] = values_next_1_tmp[0]
values_next_1_tmp[0] = SI
for __silica_i in range(10):
    wire(values_next_1_tmp[__silica_i], values_next_1.I1[__silica_i])
wire(O_1_tmp, O_1.I1)
wire(__silica_path_state.I[1], __silica_cond_1)
if len(values_CE) == 1:
    wire(values_CE[0], values.CE)
else:
    wire(and_(*values_CE), values.CE)
EndDefine()