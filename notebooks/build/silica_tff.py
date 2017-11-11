from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator

TFF = DefineCircuit("TFF", "O", Out(Bit), "I", In(Bit), *ClockInterface(has_ce=False))

I = TFF.I
value = DFF(has_ce=False, name="value", init=0)
wireclock(TFF, value)
value_next_0_tmp = value.O
O_0_tmp = value.O
value_next_0_tmp = xor(I, O_0_tmp)
wire(value_next_0_tmp, value.I)
wire(O_0_tmp, TFF.O)
EndDefine()