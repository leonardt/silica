from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

Counter = DefineCircuit("Counter", "cout", Out(Bit), "O", Out(Bits(3)), *ClockInterface(has_ce=False))
CE = VCC
value = Register(3, has_ce=True)
value_CE = [CE]
wireclock(Counter, value)
value_next_0_tmp = [value.O[__silica_i] for __silica_i in range(3)]
O_0_tmp = value.O
value_next_0_tmp, cout_0_tmp = add(value.O, bits(1, 3), cout=True)
for __silica_i in range(3):
    wire(value_next_0_tmp[__silica_i], value.I[__silica_i])
wire(cout_0_tmp, Counter.cout)
wire(O_0_tmp, Counter.O)
if len(value_CE) == 1:
    wire(value_CE[0], value.CE)
else:
    wire(and_(*value_CE), value.CE)
EndDefine()