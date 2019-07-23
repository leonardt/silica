import silica as si


def gen_ac_channel(depth, width):
    num_address_bits = m.bitutils.clog2(depth)

    @si.coroutine(
        inputs={
            "read_ready": si.Bit,
            "write_valid": si.Bit,
            "write_data": si.Bits[width]
        }, outputs={
            "read_data": si.Bits[width],
            "read_valid": si.Bit,
            "write_ready": si.Bit
        }
    )
    def ac_channel():
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


DATAWIDTH = 16
ac_channel = gen_ac_channel(4, DATAWIDTH)


@si.coroutine
def pop(channel: ac_channel) -> si.Bits[DATAWIDTH]:
    read_ready = 1
    write_valid = 0
    write_data = 0xDEAD
    while True:
        read_data, read_valid, write_ready = \
            channel.send(read_ready, write_valid, write_data)
        if read_valid:
            break
        yield
    return read_data


@si.coroutine
def push(channel: ac_channel, value: si.Bits[DATAWIDTH]):
    read_ready = 0
    write_valid = 1
    wire_data = value
    while True:
        read_data, read_valid, write_ready = \
            channel.send(read_ready, write_valid, write_data)
        if write_ready:
            break
        yield


@si.coroutine
def merge(
    in_0: ac_channel,
    in_1: ac_channel,
    out: ac_channel
):
    while True:
        data = yield from pop(in_0)
        yield from push(out, data)
        data = yield from pop(in_1)
        yield from push(out, data)


"""
@si.coroutine
def merge(
    data_in0: si.Bits[DATAWIDTH],
    data_in0_valid: si.Bit,
    data_in1: si.Bits[DATAWIDTH],
    data_in1_valid: si.Bit,
    data_out_ready: si.Bit
) -> {
    "data_in0_ready": si.Bit,
    "data_in1_ready": si.Bit,
    "data_out": si.Bit,
    "data_out_valid": si.Bit
}:
    data_in0, data_in0_valid, data_in1, data_in1_valid, data_out_ready = yield
    while True:
        while ~data_in0_valid:
            data_in0, data_in0_valid, data_in1, data_in1_valid, \
                data_out_ready = yield 0, 0, data_in0, 0
        data_out = data_in0
        data_in0_ready = 1
        while True:
            data_in0, data_in0_valid, data_in1, data_in1_valid, \
                data_out_ready = yield data_in0_ready, 0, data_out, 1
            if data_out_ready:
                break
            data_in0_ready = 0

        while ~data_in1_valid:
            data_in0, data_in0_valid, data_in1, data_in1_valid, \
                data_out_ready = yield 0, 0, data_in0, 0
        data_out = data_in1
        data_in1_ready = 1
        while True:
            data_in0, data_in0_valid, data_in1, data_in1_valid, \
                data_out_ready = yield 0, data_in1_ready, data_out, 1
            if data_out_ready:
                break
            data_in1_ready = 0
"""
