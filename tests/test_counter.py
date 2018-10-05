import silica
from silica import bits, add
import magma as m
m.set_mantle_target('ice40')
import fault
from common import evaluate_circuit


@silica.coroutine
def SilicaCounter(width, init=0, incr=1):
    O = bits(init, width)
    while True:
        yield O
        O = O + bits(incr, width)

def test_counter():
    N = 3
    counter = SilicaCounter(N)
    for _ in range(2):
        for i in range(1 << N):
            assert counter.O == i
            next(counter)

    si_counter = silica.compile(counter, file_name="tests/build/counter_si.v")
    tester = fault.Tester(si_counter, si_counter.CLK)
    for i in range(0, 1 << N):
        tester.expect(si_counter.O, i)
        tester.step(2)
    tester.compile_and_run(target="verilator", directory="tests/build", flags=['-Wno-fatal'])
    from mantle import DefineCounter

    mantle_counter = DefineCounter(N, cout=False)
    mantle_tester = tester.retarget(mantle_counter, mantle_counter.CLK)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  flags=['-Wno-fatal'],
                                  include_verilog_libraries=['../cells_sim.v'])
    if __name__ == '__main__':
        m.compile("tests/build/mantle_counter", mantle_counter)
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("counter_si", "SilicaCounter")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_counter", "Counter3")
        print("===== END   : MANTLE RESULTS =====")

if __name__ == '__main__':
    test_counter()
