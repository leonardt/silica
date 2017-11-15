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


PISO = DefineCircuit("PISO", "O", Out(Bit), "PI", In(Bits(10)), "SI", In(Bit), "LOAD", In(Bit), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferPISO", "I", In(Bits(2)), "O", Out(Bits(2)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
PI = PISO.PI
SI = PISO.SI
LOAD = PISO.LOAD
values = Register(10, has_ce=False)
wireclock(PISO, values)
values_next = DefineSilicaMux(2, 10)()
wire(__silica_path_state.O, values_next.S)
wire(values_next.O, values.I)
O = DefineSilicaMux(2, None)()
wire(__silica_path_state.O, O.S)
wire(O.O, PISO.O)
values_next_0_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_0_tmp = values.O[negate(1)]
__silica_cond_4 = LOAD
values_next_0_tmp = PI
wire(bits(values_next_0_tmp), values_next.I0)
wire(O_0_tmp, O.I0)
wire(__silica_path_state.I[0], __silica_cond_4)
values_next_1_tmp = [values.O[__silica_i] for __silica_i in range(10)]
O_1_tmp = values.O[negate(1)]
__silica_cond_5 = not_(LOAD)
values_next_1_tmp[9] = values.O[8]
values_next_1_tmp[8] = values_next_1_tmp[7]
values_next_1_tmp[7] = values_next_1_tmp[6]
values_next_1_tmp[6] = values_next_1_tmp[5]
values_next_1_tmp[5] = values_next_1_tmp[4]
values_next_1_tmp[4] = values_next_1_tmp[3]
values_next_1_tmp[3] = values_next_1_tmp[2]
values_next_1_tmp[2] = values_next_1_tmp[1]
values_next_1_tmp[1] = values_next_1_tmp[0]
values_next_1_tmp[0] = SI
wire(bits(values_next_1_tmp), values_next.I1)
wire(O_1_tmp, O.I1)
wire(__silica_path_state.I[1], __silica_cond_5)
EndDefine()