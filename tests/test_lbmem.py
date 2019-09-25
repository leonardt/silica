import pytest
import logging
logging.basicConfig(level=logging.DEBUG)
import silica as si
from silica import uint, eval, memory, bit, bits, coroutine_create
import math
import fault
import magma as m
from hwtypes import BitVector
from tests.common import evaluate_circuit
from collections import OrderedDict as OD


# @si.combinational
# def saturating_add(a : si.UInt(7), b : si.UInt(7), max_ : si.UInt(7)) ->
#                    si.UInt(7):
#     c = a + b
#     if c == max_:
#         c = 0
#     return c


@si.generator
def FillingState(lbmem_width, depth, lbmem, raddr, waddr, wdata, wen):
    # Linebuffer filling state
    # rdata is always invalid
    # Remains in this state until `lbmem_width` writes have occured (wen is
    # high for `lbmem` cycles)
    for i in range(lbmem_width):
        while ~wen:
            rdata = lbmem[raddr]
            valid = bit(0)
            wdata, wen = yield rdata, valid
        rdata = lbmem[raddr]
        valid = i == 7
        lbmem[waddr] = wdata
        # waddr = saturating_add(waddr, bit(1), bits(depth, 7))
        waddr = waddr + 1
        wdata, wen = yield rdata, valid
    return waddr


@si.generator
def DrainingState(lbmem_width, depth, lbmem, raddr, waddr, wdata, wen):
    # Linebuffer draining state
    # rdata is always valid
    # Remains in this state until `lbmem_width` cycles without a write have
    # occured
    not_drained = bits(lbmem_width - 1, 3)
    while (not_drained != 0):
        raddr = raddr + 1
        rdata = lbmem[raddr]
        valid = not_drained != 0
        wdata, wen = yield rdata, valid
        if wen:
            lbmem[waddr] = wdata
            # waddr = saturating_add(waddr, bit(1), bits(depth, 7))
            waddr = waddr + 1
        else:
            not_drained = not_drained - bits(1, 3)
        # raddr = saturating_add(raddr, bit(1), bits(depth, 7))
    # raddr = raddr + 1
    # rdata = lbmem[raddr]
    # valid = bit(0)
    # wdata, wen = yield rdata, valid
    raddr = raddr + 1
    rdata = lbmem[raddr]
    valid = bit(0)
    return waddr, raddr


def SILbMem(depth=64, lbmem_width=8):
    addr_width = eval(math.ceil(math.log2(depth)))

    @si.coroutine
    def WAddrCounter(wen: si.Bit) -> {"waddr": si.Bits[addr_width]}:
        count = uint(0, addr_width)
        wen = yield
        while True:
            waddr = count
            if wen:
                count = count + 1
            wen = yield waddr

    @si.coroutine
    def Memory(wen: si.Bit, incr: si.Bit, wdata: si.Bits[8], waddr:
               si.Bits[addr_width], count: si.Bits[3]) -> \
            {"rdata": si.Bits[8]}:
        lbmem = memory(depth, lbmem_width)
        wen, incr, wdata, waddr, count = yield
        while True:
            rdata = lbmem[waddr - uint(count, 6)]
            if wen:
                lbmem[waddr] = wdata
            wen, incr, wdata, waddr, count = yield rdata

    @si.coroutine
    def Linebuffer(wdata: si.Bits[8], wen: si.Bit) -> \
            {"rdata": si.Bits[8], "valid": si.Bit}:
        waddr_counter = coroutine_create(WAddrCounter)
        write_controller = coroutine_create(Memory)
        count = uint(0, 3)
        waddr = bits(0, addr_width)
        wdata, wen = yield
        while True:
            while True:
                waddr = waddr_counter.send(wen)
                valid = bit(0)
                rdata = write_controller.send((wen, 1, wdata, waddr, count))
                count = count + bits(wen, 3)
                wdata, wen = yield rdata, valid
                if ~((count < uint(7, 3)) | ~wen):
                    break
            while True:
                valid = bit(1)
                waddr = waddr_counter.send(wen)
                rdata = write_controller.send((wen, 0, wdata, waddr, count))
                count = count - bits(wen == 0, 3)
                wdata, wen = yield rdata, valid
                if count == 0:
                    break

        # while True:
        #     if wen:
        #         raddr = waddr - uint(count, 6)
        #     else:
        #         raddr = waddr - uint(count - 1, 6)
        #     rdata = lbmem[raddr]
        #     valid = (state & (bit(count != 1) | wen)) | \
        #             (bit(count == 7) & wen)
        #     if state == 0:
        #         state = (count == 7) & wen
        #         if wen:
        #             count = count + 1
        #     else:
        #         state = (count != 1) | wen
        #         if ~wen:
        #             count = count - 1
        #     if wen:
        #         lbmem[waddr] = wdata
        #         waddr = waddr + 1
        #     wdata, wen = yield rdata, valid

            # while True:
            #     waddr = yield from FillingState(lbmem_width, depth, lbmem,
            #                                     raddr, waddr, wdata, wen)
            #     waddr, raddr = yield from DrainingState(lbmem_width, depth,
            #                                             lbmem, raddr, waddr,
            #                                             wdata, wen)
    return Linebuffer()


def inputs_generator(inputs):
    @si.coroutine
    def gen():
        while True:
            for wdata, wen in inputs:
                yield wdata, wen
    return gen()


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_lbmem(strategy):
    lbmem = SILbMem()
    si_lbmem = si.compile(lbmem, "tests/build/si_lbmem.v", strategy=strategy)
    # si_lbmem = m.DefineFromVerilogFile("tests/build/si_lbmem.v",
    #                                    type_map={"CLK": m.In(m.Clock)},
    #                                    target_modules=["mem"])[0]
    tester = fault.Tester(si_lbmem, si_lbmem.CLK)
    # wdata = [BitVector(i, 16) for i in range(40)]
    # wen =   [BitVector(i%2) for i in range(40)]
    expected_written = []
    expected_valid = False
    num_writes = 0
    # for cycle, inputs in enumerate(zip(wdata,wen)):
    for i in range(0, 8):
        tester.poke(si_lbmem.wdata, i)
        tester.poke(si_lbmem.wen, 1)
        lbmem.send((i, BitVector(1)))
        tester.eval()
        assert lbmem.valid == (i == 7), (lbmem.valid, i)
        # tester.print(si_lbmem.valid)
        tester.expect(si_lbmem.valid, i == 7), "Valid only on last write"
        assert lbmem.rdata == 0, \
            f"should be 0, even on first read, iter={i}, got {lbmem.rdata}"
        tester.expect(si_lbmem.rdata, 0)
        tester.step(2)
    for i in range(0, 8):
        tester.poke(si_lbmem.wdata, 0)
        tester.poke(si_lbmem.wen, 0)
        lbmem.send((0, BitVector(0)))
        # print(lbmem.lbmem)
        tester.eval()
        # i + 1  because 0 was read on the final write, 7 when i == 7 because
        # there's nothing left to drain
        rdata = i + 1 if i < 7 else 0
        valid = i < 7
        assert lbmem.rdata == rdata, \
            (i, (lbmem.rdata, lbmem.valid), (rdata, valid))
        assert lbmem.valid == valid, \
            (i, (lbmem.rdata, lbmem.valid), (rdata, valid))
        tester.expect(si_lbmem.rdata, rdata)
        # tester.print(si_lbmem.valid)
        tester.expect(si_lbmem.valid, valid)
        tester.step(2)

        # print(f"inputs={inputs}, rdata={lbmem.rdata}, valid={lbmem.valid}")
        # wen = inputs[1]
        # if wen:
        #     expected_written.append(inputs[0])
        # num_writes += wen.as_int()
        # if not expected_valid and num_writes == 8:
        #     expected_valid = True
        #     drain_state = 8
        # if expected_valid and drain_state and not wen:
        #     drain_state -= 1
        # if expected_valid and not drain_state:
        #     expected_valid = False
        #     num_writes = 0
        # assert expected_valid == lbmem.valid
        # tester.expect(si_lbmem.valid, lbmem.valid)
        # if expected_valid:
        #     rdata = expected_written.pop(0)
        #     assert lbmem.rdata == rdata
        #     tester.expect(si_lbmem.rdata, rdata)
        # print(drain_state)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")
    verilog_lbmem = m.DefineFromVerilogFile("verilog/lbmem.v",
                                            type_map={"CLK": m.In(m.Clock)})[0]
    verilog_tester = tester.retarget(verilog_lbmem, verilog_lbmem.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'],
                                   include_directories=["../../verilog"],
                                   magma_output="verilog")
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_lbmem", "Linebuffer")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('verilog/lbmem.v', 'tests/build/verilog_lbmem.v')
        print("===== BEGIN : MAGMA RESULTS =====")
        evaluate_circuit("verilog_lbmem", "lbmem")
        print("===== END   : MAGMA RESULTS =====")


if __name__ == "__main__":
    import sys
    test_lbmem(sys.argv[1])


"""
$display("-------------------");
$display("start_yield_state      =  %d", yield_state);
$display("lbmem_0[0]       = %d", lbmem_0[0]);
$display("lbmem_0[1]       = %d", lbmem_0[1]);
$display("lbmem_0[2]       = %d", lbmem_0[2]);
$display("lbmem_0[3]       = %d", lbmem_0[3]);
$display("lbmem_0[4]       = %d", lbmem_0[4]);
$display("lbmem_0[5]       = %d", lbmem_0[5]);
$display("lbmem_0[6]       = %d", lbmem_0[6]);
$display("lbmem_0[7]       = %d", lbmem_0[7]);
$display("raddr1       = %d", raddr_1);
$display("rdata       = %d", rdata);
$display("end yield state   = %d", yield_state);
$display("-------------------");
"""
