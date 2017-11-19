from magma import *
import os
os.environ["MANTLE"] = os.getenv("MANTLE", "coreir")
from mantle import *
import mantle.common.operator


@cache_definition
def DefineSilicaMux(height, width):
    if "one-hot" == "one-hot":
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


SilicaCounter = DefineCircuit("SilicaCounter", "O", Out(Bits(3)), "COUT", Out(Bit), *ClockInterface(has_ce=False))
value = Register(3, has_ce=False)
wireclock(SilicaCounter, value)
value_next_0_tmp = [value.O[__silica_i] for __silica_i in range(3)]
O_0_tmp = value.O
value_next_0_tmp, COUT_0_tmp = add(value.O, bits(1, 3), cout=True)
wire(value_next_0_tmp, value.I)
wire(O_0_tmp, SilicaCounter.O)
wire(COUT_0_tmp, SilicaCounter.COUT)
EndDefine()