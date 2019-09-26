import pytest
import fault
from tests.common import evaluate_circuit
import shutil
import silica as si
from silica import bits, add
import magma as m
m.set_mantle_target('ice40')


def SilicaCounter(width, init=0, incr=1):
    @si.coroutine
    def counter() -> {"O": si.Bits[width]}:
        count = bits(init, width)
        while True:
            O = count
            count = count + bits(incr, width)
            yield O
    return counter()


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_counter(strategy):
    N = 3
    counter = SilicaCounter(N)
    for _ in range(2):
        for i in range(1 << N):
            assert counter.O == i
            next(counter)

    si_counter = si.compile(counter, file_name="tests/build/counter_si.v", strategy=strategy)
    tester = fault.Tester(si_counter, si_counter.CLK)
    for i in range(0, 1 << N):
        tester.expect(si_counter.O, i)
        tester.step(2)
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")
    from mantle import DefineCounter

    mantle_counter = DefineCounter(N, cout=False)
    mantle_tester = tester.retarget(mantle_counter, mantle_counter.CLK)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  flags=['-Wno-fatal'],
                                  include_verilog_libraries=['../cells_sim.v'],
                                  magma_output="verilog")

    verilog_counter = m.DefineFromVerilogFile(
        "verilog/counter.v", type_map={"CLK": m.In(m.Clock)})[0]
    verilog_tester = tester.retarget(verilog_counter, verilog_counter.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'],
                                   magma_output="verilog")
    if __name__ == '__main__':
        m.compile("tests/build/mantle_counter", mantle_counter)
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("counter_si", "counter")
        print("===== END   : SILICA RESULTS =====")
        # print("===== BEGIN : MANTLE RESULTS =====")
        # evaluate_circuit("mantle_counter", "Counter3")
        # print("===== END   : MANTLE RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        shutil.copy("verilog/counter.v", "tests/build/vcounter.v")
        evaluate_circuit("vcounter", "vcounter")
        print("===== END   : MANTLE RESULTS =====")


if __name__ == '__main__':
    import sys
    test_counter(sys.argv[1])
