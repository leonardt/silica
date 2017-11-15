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


PISO = DefineCircuit("PISO", "O", Out(Bit), "SI", In(Bit), "PI", In(Bits(8)), "LOAD", In(Bit), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferPISO", "I", In(Bits(2)), "O", Out(Bits(2)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
SI = PISO.SI
PI = PISO.PI
LOAD = PISO.LOAD
values = Register(8, has_ce=False)
wireclock(PISO, values)
values_next = DefineSilicaMux(2, 8)()
wire(__silica_path_state.O, values_next.S)
wire(values_next.O, values.I)
O = DefineSilicaMux(2, None)()
wire(__silica_path_state.O, O.S)
wire(O.O, PISO.O)
values_next_0_tmp = [values.O[__silica_i] for __silica_i in range(8)]
O_0_tmp = values.O[negate(1)]
__silica_cond_6 = LOAD
values_next_0_tmp = PI
wire(bits(values_next_0_tmp), values_next.I0)
wire(O_0_tmp, O.I0)
wire(__silica_path_state.I[0], __silica_cond_6)
values_next_1_tmp = [values.O[__silica_i] for __silica_i in range(8)]
O_1_tmp = values.O[negate(1)]
__silica_cond_7 = not_(LOAD)
values_next_1_tmp[7] = values.O[6]
values_next_1_tmp[6] = values_next_1_tmp[5]
values_next_1_tmp[5] = values_next_1_tmp[4]
values_next_1_tmp[4] = values_next_1_tmp[3]
values_next_1_tmp[3] = values_next_1_tmp[2]
values_next_1_tmp[2] = values_next_1_tmp[1]
values_next_1_tmp[1] = values_next_1_tmp[0]
values_next_1_tmp[0] = SI
wire(bits(values_next_1_tmp), values_next.I1)
wire(O_1_tmp, O.I1)
wire(__silica_path_state.I[1], __silica_cond_7)
EndDefine()
UART_TX = DefineCircuit("UART_TX", "O", Out(Bit), "valid", In(Bit), "message", In(Bits(8)), *ClockInterface(has_ce=False))
Buffer = DefineCircuit("__silica_BufferUART_TX", "I", In(Bits(15)), "O", Out(Bits(15)))
wire(Buffer.I, Buffer.O)
EndDefine()
__silica_path_state = Buffer()
__silica_yield_state = Register(12, init=1, has_ce=False)

wireclock(UART_TX, __silica_yield_state)
__silica_yield_state_next = DefineSilicaMux(15, 12)()
wire(__silica_path_state.O, __silica_yield_state_next.S)
wire(__silica_yield_state_next.O, __silica_yield_state.I)
wire(__silica_yield_state_next.I0, bits(1 << 1, 12))
wire(__silica_yield_state_next.I1, bits(1 << 11, 12))
wire(__silica_yield_state_next.I2, bits(1 << 2, 12))
wire(__silica_yield_state_next.I3, bits(1 << 3, 12))
wire(__silica_yield_state_next.I4, bits(1 << 4, 12))
wire(__silica_yield_state_next.I5, bits(1 << 5, 12))
wire(__silica_yield_state_next.I6, bits(1 << 6, 12))
wire(__silica_yield_state_next.I7, bits(1 << 7, 12))
wire(__silica_yield_state_next.I8, bits(1 << 8, 12))
wire(__silica_yield_state_next.I9, bits(1 << 9, 12))
wire(__silica_yield_state_next.I10, bits(1 << 10, 12))
wire(__silica_yield_state_next.I11, bits(1 << 1, 12))
wire(__silica_yield_state_next.I12, bits(1 << 11, 12))
wire(__silica_yield_state_next.I13, bits(1 << 1, 12))
wire(__silica_yield_state_next.I14, bits(1 << 11, 12))
valid = UART_TX.valid
message = UART_TX.message
piso = PISO()
piso_inputs_0 = DefineSilicaMux(15, None)()
wire(piso_inputs_0.O, piso.SI)
wire(__silica_path_state.O, piso_inputs_0.S)
piso_inputs_1 = DefineSilicaMux(15, 8)()
wire(piso_inputs_1.O, piso.PI)
wire(__silica_path_state.O, piso_inputs_1.S)
piso_inputs_2 = DefineSilicaMux(15, None)()
wire(piso_inputs_2.O, piso.LOAD)
wire(__silica_path_state.O, piso_inputs_2.S)
O = DefineSilicaMux(15, None)()
wire(__silica_path_state.O, O.S)
wire(O.O, UART_TX.O)
wire(piso_inputs_0.I0, 1)
wire(piso_inputs_1.I0, message)
wire(piso_inputs_2.I0, valid)
O_0_tmp = piso.O
__silica_cond_0 = valid
O_0_tmp = bit(False)
wire(O_0_tmp, O.I0)
wire(__silica_path_state.I[0], and_(__silica_yield_state.O[0], __silica_cond_0))
wire(piso_inputs_0.I1, 1)
wire(piso_inputs_1.I1, message)
wire(piso_inputs_2.I1, valid)
O_1_tmp = piso.O
__silica_cond_1 = not_(valid)
wire(O_1_tmp, O.I1)
wire(__silica_path_state.I[1], and_(__silica_yield_state.O[0], __silica_cond_1))
wire(piso_inputs_0.I2, 1)
wire(piso_inputs_1.I2, message)
wire(piso_inputs_2.I2, 0)
O_2_tmp = piso.O
wire(O_2_tmp, O.I2)
wire(__silica_path_state.I[2], __silica_yield_state.O[1])
wire(piso_inputs_0.I3, 1)
wire(piso_inputs_1.I3, message)
wire(piso_inputs_2.I3, 0)
O_3_tmp = piso.O
wire(O_3_tmp, O.I3)
wire(__silica_path_state.I[3], __silica_yield_state.O[2])
wire(piso_inputs_0.I4, 1)
wire(piso_inputs_1.I4, message)
wire(piso_inputs_2.I4, 0)
O_4_tmp = piso.O
wire(O_4_tmp, O.I4)
wire(__silica_path_state.I[4], __silica_yield_state.O[3])
wire(piso_inputs_0.I5, 1)
wire(piso_inputs_1.I5, message)
wire(piso_inputs_2.I5, 0)
O_5_tmp = piso.O
wire(O_5_tmp, O.I5)
wire(__silica_path_state.I[5], __silica_yield_state.O[4])
wire(piso_inputs_0.I6, 1)
wire(piso_inputs_1.I6, message)
wire(piso_inputs_2.I6, 0)
O_6_tmp = piso.O
wire(O_6_tmp, O.I6)
wire(__silica_path_state.I[6], __silica_yield_state.O[5])
wire(piso_inputs_0.I7, 1)
wire(piso_inputs_1.I7, message)
wire(piso_inputs_2.I7, 0)
O_7_tmp = piso.O
wire(O_7_tmp, O.I7)
wire(__silica_path_state.I[7], __silica_yield_state.O[6])
wire(piso_inputs_0.I8, 1)
wire(piso_inputs_1.I8, message)
wire(piso_inputs_2.I8, 0)
O_8_tmp = piso.O
wire(O_8_tmp, O.I8)
wire(__silica_path_state.I[8], __silica_yield_state.O[7])
wire(piso_inputs_0.I9, 1)
wire(piso_inputs_1.I9, message)
wire(piso_inputs_2.I9, 0)
O_9_tmp = piso.O
wire(O_9_tmp, O.I9)
wire(__silica_path_state.I[9], __silica_yield_state.O[8])
wire(piso_inputs_0.I10, 1)
wire(piso_inputs_1.I10, message)
wire(piso_inputs_2.I10, 0)
O_10_tmp = piso.O
wire(O_10_tmp, O.I10)
wire(__silica_path_state.I[10], __silica_yield_state.O[9])
wire(piso_inputs_0.I11, 1)
wire(piso_inputs_1.I11, message)
wire(piso_inputs_2.I11, valid)
O_11_tmp = piso.O
__silica_cond_2 = valid
O_11_tmp = bit(False)
wire(O_11_tmp, O.I11)
wire(__silica_path_state.I[11], and_(__silica_yield_state.O[10], __silica_cond_2))
wire(piso_inputs_0.I12, 1)
wire(piso_inputs_1.I12, message)
wire(piso_inputs_2.I12, valid)
O_12_tmp = piso.O
__silica_cond_3 = not_(valid)
wire(O_12_tmp, O.I12)
wire(__silica_path_state.I[12], and_(__silica_yield_state.O[10], __silica_cond_3))
wire(piso_inputs_0.I13, 1)
wire(piso_inputs_1.I13, message)
wire(piso_inputs_2.I13, valid)
O_13_tmp = piso.O
__silica_cond_4 = valid
O_13_tmp = bit(False)
wire(O_13_tmp, O.I13)
wire(__silica_path_state.I[13], and_(__silica_yield_state.O[11], __silica_cond_4))
wire(piso_inputs_0.I14, 1)
wire(piso_inputs_1.I14, message)
wire(piso_inputs_2.I14, valid)
O_14_tmp = piso.O
__silica_cond_5 = not_(valid)
wire(O_14_tmp, O.I14)
wire(__silica_path_state.I[14], and_(__silica_yield_state.O[11], __silica_cond_5))
EndDefine()