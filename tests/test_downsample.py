import logging
logging.basicConfig(level=logging.DEBUG)
import random
import pytest
import silica as si
from silica import bits
import fault
import magma as m
import hwtypes


@si.coroutine
def Downsample(
    data_in_valid: si.Bit,
    data_in_data: si.Bits[16],
    data_out_ready: si.Bit
) -> {"data_in_ready": si.Bit,
      "data_out_data": si.Bits[16],
      "data_out_valid": si.Bit}:
    x = bits(0, 5)
    y = bits(0, 5)
    yield
    while True:
        y = 0
        while True:
            x = 0
            while True:
                keep = ((x % bits(2, 5)) == 0) & ((y % bits(2, 5)) == 0)
                data_out_valid = keep & data_in_valid
                data_out_data = data_in_data
                data_in_ready = data_out_ready | ~keep
                if data_in_ready & data_in_valid:
                    if x == 31:
                        yield data_in_ready, data_out_data, data_out_valid
                        break
                    x = x + 1
                # dropping or data_out is ready
                yield data_in_ready, data_out_data, data_out_valid
            if y == 31:
                break
            y = y + 1


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_downsample_simple(strategy):
    downsample = Downsample()
    magma_downsample = si.compile(downsample,
                                  file_name="tests/build/si_downsample.v",
                                  strategy=strategy)

    tester = fault.Tester(magma_downsample, magma_downsample.CLK)
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    tester.poke(magma_downsample.RESET, 1)
    tester.eval()
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    tester.poke(magma_downsample.data_in_valid, 0)
    tester.poke(magma_downsample.data_in_data, 0xDEAD)
    tester.poke(magma_downsample.data_out_ready, 0)
    tester.step(2)
    tester.expect(magma_downsample.data_out_valid, 0)
    tester.expect(magma_downsample.data_in_ready, 0)
    tester.step(2)
    tester.expect(magma_downsample.data_out_valid, 0)
    tester.expect(magma_downsample.data_in_ready, 0)
    tester.step(2)
    tester.expect(magma_downsample.data_out_valid, 0)
    tester.expect(magma_downsample.data_in_ready, 0)
    tester.poke(magma_downsample.data_in_valid, 1)
    tester.step(2)
    tester.poke(magma_downsample.data_out_ready, 1)
    tester.eval()
    tester.expect(magma_downsample.data_out_valid, 1)
    tester.expect(magma_downsample.data_in_ready, 1)
    tester.expect(magma_downsample.data_out_data, 0xDEAD)
    tester.step(2)
    tester.expect(magma_downsample.data_out_valid, 0)
    tester.step(2)
    tester.expect(magma_downsample.data_out_valid, 1)
    tester.expect(magma_downsample.data_out_data, 0xDEAD)

    print(tester)
    tester.compile_and_run("verilator", flags=["-Wno-fatal", "--trace"],
                           magma_output="verilog")

    verilog_downsample = m.DefineFromVerilogFile(
        "verilog/downsample.v", type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_downsample,
                                     verilog_downsample.CLK)
    verilog_tester.compile_and_run(target="verilator",
                                   flags=['-Wno-fatal'],
                                   include_directories=["../../verilog"],
                                   magma_output="verilog")


def test_downsample_loops_simple():
    downsample = Downsample()
    magma_downsample = si.compile(downsample,
                                  file_name="tests/build/si_downsample.v")

    tester = fault.Tester(magma_downsample, magma_downsample.CLK)
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    tester.poke(magma_downsample.RESET, 1)
    tester.eval()
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    for i in range(2):
        for y in range(32):
            for x in range(32):
                tester.poke(magma_downsample.data_in_valid, 1)
                tester.poke(magma_downsample.data_in_data, y * 32 + x)
                tester.poke(magma_downsample.data_out_ready, 1)
                tester.eval()
                tester.expect(magma_downsample.data_out_data, y * 32 + x)
                if (y % 2 == 0) & (x % 2 == 0):
                    tester.expect(magma_downsample.data_out_valid,
                                  (y % 2 == 0) & (x % 2 == 0))
                tester.expect(magma_downsample.data_in_ready, 1)
                tester.step(2)
                tester.poke(magma_downsample.data_in_valid, 0)
                tester.poke(magma_downsample.data_out_ready, 0)
                tester.eval()
                tester.expect(magma_downsample.data_out_valid, 0)

    tester.compile_and_run("verilator", flags=["-Wno-fatal", "--trace"],
                           magma_output="verilog")

    verilog_downsample = m.DefineFromVerilogFile(
        "verilog/downsample.v", type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_downsample,
                                     verilog_downsample.CLK)
    verilog_tester.compile_and_run(target="verilator",
                                   flags=['-Wno-fatal'],
                                   include_directories=["../../verilog"],
                                   magma_output="verilog")


def test_downsample_loops_simple_random_stalls():
    downsample = Downsample()
    magma_downsample = si.compile(downsample,
                                  file_name="tests/build/si_downsample.v")

    tester = fault.Tester(magma_downsample, magma_downsample.CLK)
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    tester.poke(magma_downsample.RESET, 1)
    tester.eval()
    tester.poke(magma_downsample.RESET, 0)
    tester.eval()
    for i in range(2):
        for y in range(32):
            for x in range(32):
                while True:
                    in_valid = hwtypes.Bit(random.getrandbits(1))
                    tester.poke(magma_downsample.data_in_valid, in_valid)
                    tester.poke(magma_downsample.data_in_data, y * 32 + x)
                    out_ready = random.getrandbits(1)
                    tester.poke(magma_downsample.data_out_ready, out_ready)
                    tester.eval()
                    keep = hwtypes.Bit((y % 2 == 0) & (x % 2 == 0))
                    out_valid = keep & in_valid
                    if out_ready:
                        tester.expect(magma_downsample.data_out_valid,
                                      out_valid)
                    if out_valid & out_ready:
                        tester.expect(magma_downsample.data_out_data,
                                      y * 32 + x)
                    in_ready = hwtypes.Bit(out_ready) | ~keep
                    if in_valid & in_ready:
                        tester.expect(magma_downsample.data_in_ready,
                                      in_ready)
                    tester.step(2)
                    if in_ready & in_valid:
                        break

    tester.compile_and_run("verilator", flags=["-Wno-fatal"],
                           magma_output="verilog")

    verilog_downsample = m.DefineFromVerilogFile(
        "verilog/downsample.v", type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_downsample,
                                     verilog_downsample.CLK)
    verilog_tester.compile_and_run(target="verilator",
                                   flags=['-Wno-fatal'],
                                   include_directories=["../../verilog"],
                                   magma_output="verilog")
