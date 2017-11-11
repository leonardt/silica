from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

Counter = DefineCircuit("Counter", "O", Out(Bits(4)), "cout", Out(Bit), *ClockInterface(has_ce=False))

value = Register(4, has_ce=False)
wireclock(Counter, value)
value_next_0_tmp = [value.O[__silica_i] for __silica_i in range(4)]
O_0_tmp = value.O
value_next_0_tmp, cout_0_tmp = add(value.O, bits(1, 4), cout=True)
for __silica_i in range(4):
    wire(value_next_0_tmp[__silica_i], value.I[__silica_i])
wire(O_0_tmp, Counter.O)
wire(cout_0_tmp, Counter.cout)
EndDefine()