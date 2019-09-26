import pytest
from magma import *
import silica as si
import magma as m
m.set_mantle_target("ice40")
import mantle
from silica import bits
from magma.bitutils import seq2int, int2seq
from magma.testing.coroutine import check
import fault
from hwtypes import BitVector
from tests.common import evaluate_circuit


def DefinePISO(n):
    @si.coroutine
    def SIPISO(PI: si.Bits[n], SI: si.Bit, LOAD: si.Bit) -> {"O": si.Bit}:
        values = bits(0, n)
        # O = values[-1]
        PI, SI, LOAD = yield
        while True:
            if LOAD:
                values = PI
            else:
                # values = [SI] + values[:-1]
                values = (bits(SI, n) | (values << 1))
            O = values[n-1]
            PI, SI, LOAD = yield O
    SIPISO._name = f"SIPISO{n}"
    return SIPISO


def inputs_generator(message):
    @si.coroutine
    def gen():
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
    return gen()


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_PISO(strategy):
    piso = DefinePISO(10)()
    si_piso = si.compile(piso, "tests/build/si_piso.v", strategy=strategy)
    # si_piso = m.DefineFromVerilogFile("tests/build/si_piso.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_piso, si_piso.CLK)
    message = [0xDE, 0xAD, 0xBE, 0xEF]
    inputs = inputs_generator(message)
    for i in range(len(message)):
        actual_outputs = []
        expected_outputs = [False] + inputs.PI[:]
        expected_state = inputs.PI[:]
        piso.send((BitVector[10](inputs.PI), inputs.SI, inputs.LOAD))
        actual_outputs.insert(0, piso.O)
        # print(f"PI={inputs.PI}, SI={inputs.SI}, LOAD={inputs.LOAD}, "
        #       f"O={piso.O}, values={piso.values}")
        tester.poke(si_piso.PI, BitVector[10](inputs.PI))
        tester.poke(si_piso.SI, BitVector[10](inputs.SI))
        tester.poke(si_piso.LOAD, BitVector[10](inputs.LOAD))
        next(inputs)
        tester.step(2)
        tester.expect(si_piso.O, piso.O)
        for j in range(10):
            tester.poke(si_piso.PI, BitVector[10](inputs.PI))
            tester.poke(si_piso.SI, BitVector[10](inputs.SI))
            tester.poke(si_piso.LOAD, BitVector[10](inputs.LOAD))
            assert piso.values.bits() == expected_state, (i, j)
            piso.send((BitVector[10](inputs.PI), inputs.SI, inputs.LOAD))
            actual_outputs.insert(0, piso.O)
            expected_state = [inputs.SI] + expected_state[:-1]
            tester.eval()
            tester.expect(si_piso.O, piso.O)
            tester.step(2)
            next(inputs)
        assert actual_outputs == expected_outputs

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")
    # check that they are the same

    # mantle_PISO = mantle.DefinePISO(10)
    from mantle import Mux
    from mantle.common.register import _RegisterName, Register, FFs
    T = Bits[10]
    n = 10
    init = 0
    has_ce = False
    has_reset = False

    class _PISO(Circuit):
        name = _RegisterName('PISO', n, init, has_ce, has_reset)
        IO = ['SI', In(Bit), 'PI', In(T), 'LOAD', In(Bit),
              'O', Out(Bit)] + ClockInterface(has_ce, has_reset)

        @classmethod
        def definition(piso):
            def mux2(y):
                return curry(Mux(2), prefix='I')

            mux = braid(col(mux2, n), forkargs=['S'])
            reg = Register(n - 1, init, has_ce=has_ce, has_reset=has_reset)

            si = concat(array(piso.SI), reg.O[0:n-1])
            mux(si, piso.PI, piso.LOAD)
            reg(mux.O[:-1])
            wire(mux.O[-1], piso.O)
            wireclock(piso, reg)
    mantle_tester = tester.retarget(_PISO, clock=_PISO.CLK)
    m.compile("tests/build/mantle_piso", _PISO)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  include_verilog_libraries=['../cells_sim.v'],
                                  magma_output="verilog")
    if __name__ == '__main__':

        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_piso", "SIPISO")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_piso", "PISO10")
        print("===== END   : MANTLE RESULTS =====")


if __name__ == '__main__':
    import sys
    test_PISO(sys.argv[1])
