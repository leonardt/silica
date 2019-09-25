import silica as si
from silica import bits, uint, memory
from magma.testing.coroutine import check
import shutil
import pytest


@si.coroutine(inputs={"wdata": si.Bits(4), "wen": si.Bit, "ren": si.Bit})
def Fifo():
    buffer = memory(4, 4)
    raddr = uint(0, 2)
    waddr = uint(0, 2)
    next_empty = True
    next_full  = False
    full = next_full
    empty = next_empty
    rdata = buffer[raddr]
    wdata, wen, ren = yield
    while True:
        full = next_full
        empty = next_empty
        rdata = buffer[raddr]
        if wen and not full:
            buffer[waddr] = wdata
            waddr = waddr + 1
            next_full = raddr == waddr
            next_empty = False
        if ren and not empty:
            raddr = raddr + 1
            next_empty = raddr == waddr
            next_full = False
        wdata, wen, ren = yield rdata, empty, full

expected_trace = [
    {'wdata': 1, 'wen': 0, 'ren': 1, 'rdata': 0, 'full': False, 'empty': True, 'buffer': [0, 0, 0, 0], 'raddr': 0, 'waddr': 0},
    {'wdata': 2, 'wen': 1, 'ren': 0, 'rdata': 0, 'full': False, 'empty': True, 'buffer': [2, 0, 0, 0], 'raddr': 0, 'waddr': 1},
    {'wdata': 3, 'wen': 1, 'ren': 1, 'rdata': 2, 'full': False, 'empty': False, 'buffer': [2, 3, 0, 0], 'raddr': 1, 'waddr': 2},
    {'wdata': 4, 'wen': 1, 'ren': 0, 'rdata': 3, 'full': False, 'empty': False, 'buffer': [2, 3, 4, 0], 'raddr': 1, 'waddr': 3},
    {'wdata': 5, 'wen': 0, 'ren': 1, 'rdata': 3, 'full': False, 'empty': False, 'buffer': [2, 3, 4, 0], 'raddr': 2, 'waddr': 3},
    {'wdata': 6, 'wen': 0, 'ren': 1, 'rdata': 4, 'full': False, 'empty': False, 'buffer': [2, 3, 4, 0], 'raddr': 3, 'waddr': 3},
    {'wdata': 7, 'wen': 1, 'ren': 0, 'rdata': 0, 'full': False, 'empty': True, 'buffer': [2, 3, 4, 7], 'raddr': 3, 'waddr': 0},
    {'wdata': 8, 'wen': 0, 'ren': 1, 'rdata': 7, 'full': False, 'empty': False, 'buffer': [2, 3, 4, 7], 'raddr': 0, 'waddr': 0},
    {'wdata': 9, 'wen': 1, 'ren': 1, 'rdata': 2, 'full': False, 'empty': True, 'buffer': [9, 3, 4, 7], 'raddr': 0, 'waddr': 1},
    {'wdata': 10, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': False, 'empty': False, 'buffer': [9, 10, 4, 7], 'raddr': 0, 'waddr': 2},
    {'wdata': 11, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': False, 'empty': False, 'buffer': [9, 10, 11, 7], 'raddr': 0, 'waddr': 3},
    {'wdata': 12, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': False, 'empty': False, 'buffer': [9, 10, 11, 12], 'raddr': 0, 'waddr': 0},
    {'wdata': 13, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': True, 'empty': False, 'buffer': [9, 10, 11, 12], 'raddr': 0, 'waddr': 0},
    {'wdata': 13, 'wen': 0, 'ren': 1, 'rdata': 9, 'full': True, 'empty': False, 'buffer': [9, 10, 11, 12], 'raddr': 1, 'waddr': 0},
    {'wdata': 14, 'wen': 1, 'ren': 1, 'rdata': 10, 'full': False, 'empty': False, 'buffer': [14, 10, 11, 12], 'raddr': 2, 'waddr': 1},
]

@si.coroutine
def inputs_generator(N):
    while True:
        for trace in expected_trace:
            wdata = bits(trace["wdata"], N)
            wen = bool(trace["wen"])
            ren = bool(trace["ren"])
            yield wdata, wen, ren


@si.coroutine
def PipelinedFifo():
    fifos = [Fifo() for _ in range(3)]
    wdata, wen, ren = yield
    while True:
        fifo0_empty, fifo0_full = fifos[0].empty, fifos[0].full
        fifo1_empty, fifo1_full = fifos[1].empty, fifos[1].full
        rdata, fifo2_empty, fifo2_full = fifos[2].rdata, fifos[2].empty, fifos[2].full
        full, empty = fifo0_full, fifo2_empty

        fifo0_wen = not fifo0_full
        fifo1_wen = fifo0_ren = not fifo0_empty and not fifo1_full
        fifo2_wen = fifo1_ren = not fifo1_empty and not fifo2_full
        fifo2_ren = not fifo2_empty and ren
                    # wdata, wen, ren
        fifos[0].send((wdata, fifo0_wen, fifo0_ren))
        fifos[1].send((fifos[0].rdata, fifo1_wen, fifo1_ren))
        fifos[2].send((fifos[1].rdata, fifo2_wen, fifo2_ren))
        wdata, wen, ren = yield rdata, empty, full

pipelined_fifo = PipelinedFifo()
# fifo_magma = si.compile(fifo, file_name="fifo_magma.py")
@pytest.mark.skip(reason="not implemented yet")
def test_fifo():
    inputs = ("wdata", "wen", "ren")
    outputs = ("rdata", "full", "empty")
    # states = ("buffer", "raddr", "waddr")

    for i, trace in enumerate(expected_trace):
        args = ()
        for input_ in inputs:
            args += (trace[input_], )

        pipelined_fifo.send(*args)

        print(f"Cycle {i}: ", end="")
        # assert getattr(fifo, output) == trace[output], i
        print(", ".join(f"{output}={getattr(pipelined_fifo, output)}" for output in outputs))
        for i in range(3):
            state = "buffer"
            print(f"fifos[{i}].buffer={pipelined_fifo.fifos[i].buffer}")
            # print(f"fifos[{i}].waddr={pipelined_fifo.fifos[i].waddr}, fifos[{i}].raddr={pipelined_fifo.fifos[i].raddr}")
        # for state in states:
        #     print(getattr(pipelined_fifo, state))

    # check(fifo_magma, Fifo(), len(expected_trace), inputs_generator(4))

# @pytest.mark.skipif(shutil.which("verilator") is None, reason="verilator not installed")
# def test_verilog():
#     check_verilog("fifo", fifo_magma, Fifo(), len(expected_trace), inputs_generator(4))

if __name__ == "__main__":
    test_fifo()
