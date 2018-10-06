import silica
import magma as m
m.set_mantle_target("ice40")
import mantle
from silica import bits
from magma.bitutils import seq2int, int2seq
from magma.testing.coroutine import check
import fault
from bit_vector import BitVector
from common import evaluate_circuit


def DefinePISO(n):
    @silica.coroutine(inputs={"PI": silica.Bits(n), "SI": silica.Bit, "LOAD": silica.Bit})
    def SIPISO():
        values = bits(0, n)
        # O = values[-1]
        O = values[n-1]
        while True:
            PI, SI, LOAD = yield O
            if LOAD:
                values = PI
            else:
                # values = [SI] + values[:-1]
                for i in range(n - 1, 0, -1):
                    values[i] = values[i - 1]
                values[0] = SI
            O = values[n-1]
    SIPISO._name = f"SIPISO{n}"
    return SIPISO


@silica.coroutine
def inputs_generator(message):
    while True:
        for byte in message:
            PI = [bool(x) for x in [0] + int2seq(byte) + [1]]
            SI = False
            LOAD = True
            yield PI, SI, LOAD
            for i in range(10):
                LOAD = False
                PI = [bool(x) for x in int2seq(0xFF, 10)]
                yield PI, SI, LOAD


def test_PISO():
    piso = DefinePISO(10)()
    si_piso = silica.compile(piso, "tests/build/si_piso.v")
    # si_piso = m.DefineFromVerilogFile("tests/build/si_piso.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_piso, si_piso.CLK)
    message = [0xDE, 0xAD, 0xBE, 0xEF]
    inputs = inputs_generator(message)
    for i in range(len(message)):
        expected_outputs = inputs.PI[:]
        expected_state = inputs.PI[:]
        piso.send((inputs.PI, inputs.SI, inputs.LOAD))
        # print(f"PI={inputs.PI}, SI={inputs.SI}, LOAD={inputs.LOAD}, O={piso.O}, values={piso.values}")
        tester.poke(si_piso.PI  , BitVector(inputs.PI))
        tester.poke(si_piso.SI  , BitVector(inputs.SI))
        tester.poke(si_piso.LOAD, BitVector(inputs.LOAD))
        next(inputs)
        tester.step(2)
        actual_outputs = []
        for i in range(10):
            expected_state = [inputs.SI] + expected_state[:-1]
            tester.poke(si_piso.PI  , BitVector(inputs.PI))
            tester.poke(si_piso.SI  , BitVector(inputs.SI))
            tester.poke(si_piso.LOAD, BitVector(inputs.LOAD))
            actual_outputs.insert(0, piso.O)
            piso.send((inputs.PI, inputs.SI, inputs.LOAD))
            tester.step(2)
            tester.print(si_piso.O)
            tester.expect(si_piso.O, piso.O)
            assert piso.values == expected_state
            next(inputs)
        assert actual_outputs == expected_outputs

    tester.compile_and_run(target="verilator", directory="tests/build", flags=['-Wno-fatal'])
    # check that they are the same
    mantle_PISO = mantle.DefinePISO(10)
    mantle_tester = tester.retarget(mantle_PISO, clock=mantle_PISO.CLK)
    m.compile("tests/build/mantle_piso", mantle_PISO)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  include_verilog_libraries=['../cells_sim.v'])
    if __name__ == '__main__':


        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("piso_si", "SIPISO10")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_piso", "PISO10")
        print("===== END   : MANTLE RESULTS =====")

if __name__ == '__main__':
    test_PISO()
