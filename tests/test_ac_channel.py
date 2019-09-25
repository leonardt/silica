import fault
import magma as m
import silica as si
from silica import memory, uint
from hwtypes import BitVector


def gen_ac_channel(depth, width):
    num_address_bits = m.bitutils.clog2(depth)

    @si.coroutine
    def ac_channel(read_ready: si.Bit, write_valid: si.Bit,
                   write_data: si.Bits[width]) -> \
            {"read_data": si.Bits[width], "read_valid": si.Bit,
             "write_ready": si.Bit}:
        buffer = memory(depth, width)
        raddr = uint(0, num_address_bits + 1)
        waddr = uint(0, num_address_bits + 1)
        read_ready, write_valid, write_data = yield
        while True:
            full = (waddr[:num_address_bits] == raddr[:num_address_bits]) & \
                   (waddr[num_address_bits] != raddr[num_address_bits])
            write_ready = ~full
            empty = waddr == raddr
            read_valid = ~empty
            read_data = buffer[raddr[:num_address_bits]]
            write = write_valid & write_ready
            read = read_ready & read_valid
            if write:
                buffer[waddr[:num_address_bits]] = write_data
                waddr = waddr + uint(1, num_address_bits + 1)
            if read:
                raddr = raddr + uint(1, 3)
            read_ready, write_valid, write_data = \
                yield read_data, read_valid, write_ready
    return ac_channel


expected_trace = [
    {'write_data': 1, 'write_valid': 0, 'read_ready': 1, 'read_data': 0,
     'write_ready': True, 'read_valid': False, 'buffer': [0, 0, 0, 0],
     'raddr': 0, 'waddr': 0},
    {'write_data': 2, 'write_valid': 1, 'read_ready': 0, 'read_data': 0,
     'write_ready': True, 'read_valid': False, 'buffer': [2, 0, 0, 0],
     'raddr': 0, 'waddr': 1},
    {'write_data': 3, 'write_valid': 1, 'read_ready': 1, 'read_data': 2,
     'write_ready': True, 'read_valid': True, 'buffer': [2, 3, 0, 0],
     'raddr': 1, 'waddr': 2},
    {'write_data': 4, 'write_valid': 1, 'read_ready': 0, 'read_data': 3,
     'write_ready': True, 'read_valid': True, 'buffer': [2, 3, 4, 0],
     'raddr': 1, 'waddr': 3},
    {'write_data': 5, 'write_valid': 0, 'read_ready': 1, 'read_data': 3,
     'write_ready': True, 'read_valid': True, 'buffer': [2, 3, 4, 0],
     'raddr': 2, 'waddr': 3},
    {'write_data': 6, 'write_valid': 0, 'read_ready': 1, 'read_data': 4,
     'write_ready': True, 'read_valid': True, 'buffer': [2, 3, 4, 0],
     'raddr': 3, 'waddr': 3},
    {'write_data': 7, 'write_valid': 1, 'read_ready': 0, 'read_data': 0,
     'write_ready': True, 'read_valid': False, 'buffer': [2, 3, 4, 7],
     'raddr': 3, 'waddr': 4},
    {'write_data': 8, 'write_valid': 0, 'read_ready': 1, 'read_data': 7,
     'write_ready': True, 'read_valid': True, 'buffer': [2, 3, 4, 7],
     'raddr': 4, 'waddr': 4},
    {'write_data': 9, 'write_valid': 1, 'read_ready': 1, 'read_data': 2,
     'write_ready': True, 'read_valid': False, 'buffer': [9, 3, 4, 7],
     'raddr': 4, 'waddr': 5},
    {'write_data': 10, 'write_valid': 1, 'read_ready': 0, 'read_data': 9,
     'write_ready': True, 'read_valid': True, 'buffer': [9, 10, 4, 7],
     'raddr': 4, 'waddr': 6},
    {'write_data': 11, 'write_valid': 1, 'read_ready': 0, 'read_data': 9,
     'write_ready': True, 'read_valid': True, 'buffer': [9, 10, 11, 7],
     'raddr': 4, 'waddr': 7},
    {'write_data': 12, 'write_valid': 1, 'read_ready': 0, 'read_data': 9,
     'write_ready': True, 'read_valid': True, 'buffer': [9, 10, 11, 12],
     'raddr': 4, 'waddr': 0},
    {'write_data': 13, 'write_valid': 1, 'read_ready': 0, 'read_data': 9,
     'write_ready': False, 'read_valid': True,
     'buffer': [9, 10, 11, 12], 'raddr': 4, 'waddr': 0},
    {'write_data': 13, 'write_valid': 0, 'read_ready': 1, 'read_data': 9,
     'write_ready': False, 'read_valid': True,
     'buffer': [9, 10, 11, 12], 'raddr': 5, 'waddr': 0},
    {'write_data': 14, 'write_valid': 1, 'read_ready': 1, 'read_data': 10,
     'write_ready': True, 'read_valid': True, 'buffer': [14, 10, 11, 12],
     'raddr': 6, 'waddr': 1},
]


def inputs_generator(N):
    @si.coroutine
    def gen():
        while True:
            for trace in expected_trace:
                write_data = bits(trace["write_data"], N)
                write_valid = bool(trace["write_valid"])
                read_ready = bool(trace["read_ready"])
                yield write_data, write_valid, read_ready
    return gen()


def test_ac_channel():
    ac_channel = gen_ac_channel(4, 4)()
    si_ac_channel = si.compile(ac_channel,
                               file_name="tests/build/si_ac_channel.v")

    inputs = ("read_ready", "write_valid", "write_data")
    outputs = ("read_data", "read_valid", "write_ready")
    states = ("buffer", "raddr", "waddr")
    tester = fault.Tester(si_ac_channel, si_ac_channel.CLK)
    for i, trace in enumerate(expected_trace):
        args = ()
        for input_ in inputs:
            args += (BitVector[4](trace[input_]))
            tester.poke(si_ac_channel.interface.ports[input_], trace[input_])
        ac_channel.send(args)
        tester.eval()
        for output in outputs:
            assert getattr(ac_channel, output) == trace[output], \
                (i, output, getattr(ac_channel, output), trace[output])
            tester.expect(si_ac_channel.interface.ports[output], trace[output])
        tester.step(2)
        for state in states:
            assert getattr(ac_channel, state) == trace[state], \
                (i, state, getattr(ac_channel, state), trace[state])

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")


if __name__ == "__main__":
    test_ac_channel()
