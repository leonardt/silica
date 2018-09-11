import silica
import magma as m
m.set_mantle_target("ice40")
import mantle
from silica import bits
from magma.bitutils import seq2int, int2seq
from magma.testing.coroutine import check
import fault
from bit_vector import BitVector

with open("tests/cells_sim.v") as f:
    ice40_verilog_sim = f.read()

def evaluate_circuit(verilog_file, top_name):
    from subprocess import call
    call(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif' tests/build/{verilog_file}.v | grep -A 14 \"2.27. Printing statistics.\"", shell=True)
    call(f"arachne-pnr -q -d 1k -o tests/build/{verilog_file}.txt tests/build/{verilog_file}.blif", shell=True)
    call(f"icetime -tmd hx1k tests/build/{verilog_file}.txt | grep -B 2 \"Total path delay\"", shell=True)


def DefinePISO(n):
    @silica.coroutine(inputs={"PI": silica.Bits(n), "SI": silica.Bit, "LOAD": silica.Bit})
    def PISO():
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
    PISO._name = f"PISO{n}"
    return PISO


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
    piso_magma = silica.compile(piso, "tests/build/piso_si.v")
    tester = fault.Tester(piso_magma, piso_magma.CLK)
    message = [0xDE, 0xAD, 0xBE, 0xEF]
    inputs = inputs_generator(message)
    for i in range(len(message)):
        expected_outputs = inputs.PI[:]
        expected_state = inputs.PI[:]
        piso.send((inputs.PI, inputs.SI, inputs.LOAD))
        # print(f"PI={inputs.PI}, SI={inputs.SI}, LOAD={inputs.LOAD}, O={piso.O}, values={piso.values}")
        tester.poke(piso_magma.PI  , BitVector(inputs.PI))
        tester.poke(piso_magma.SI  , BitVector(inputs.SI))
        tester.poke(piso_magma.LOAD, BitVector(inputs.LOAD))
        next(inputs)
        tester.step(2)
        actual_outputs = []
        for i in range(10):
            expected_state = [inputs.SI] + expected_state[:-1]
            tester.poke(piso_magma.PI  , BitVector(inputs.PI))
            tester.poke(piso_magma.SI  , BitVector(inputs.SI))
            tester.poke(piso_magma.LOAD, BitVector(inputs.LOAD))
            actual_outputs.insert(0, piso.O)
            piso.send((inputs.PI, inputs.SI, inputs.LOAD))
            tester.step(2)
            tester.expect(piso_magma.O, piso.O)
            assert piso.values == expected_state
            next(inputs)
        assert actual_outputs == expected_outputs

    tester.compile_and_run(target="verilator", directory="tests/build", flags=['-Wno-fatal'])
    # check that they are the same
    from magma.circuit import magma_clear_circuit_cache
    from magma import clear_cachedFunctions
    magma_clear_circuit_cache()
    clear_cachedFunctions()
    mantle_PISO = mantle.DefinePISO(10)
    mantle_tester = tester.copy(mantle_PISO, clock=mantle_PISO.CLK)
    m.compile("tests/build/mantle_piso", mantle_PISO)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  include_verilog=ice40_verilog_sim)
    if __name__ == '__main__':


        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("piso_si", "PISO10")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_piso", "PISO10")
        print("===== END   : MANTLE RESULTS =====")

if __name__ == '__main__':
    test_PISO()
