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