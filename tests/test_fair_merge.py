import pytest
import silica as si
from silica import Bit, Bits, bit, bits, Wire, compile, coroutine_create


@si.coroutine
def producer(ready: Bit) -> {"valid": Bit, "data": Bits[8]}:
    while True:
        data = bits(0xFE, 8)
        valid = bit(1)
        ready = yield valid, data


@si.coroutine
def consumer(valid: Bit, data: Bits[8]) -> {"ready": Bit}:
    while True:
        ready = bit(1)
        valid, data = yield ready


@si.coroutine
def fair_merge():
    p0 = coroutine_create(producer)
    p1 = coroutine_create(producer)
    c = coroutine_create(consumer)
    yield
    while True:
        while True:
            with Wire() as c_ready:
                p0_valid, p0_data = p0.send(c_ready)
                c_ready = c.send(p0_valid, p0_data)
            # TODO: ANON input not yet implemented
            # p1_valid, p1_data = p1.send(0)
            p1_ready = bit(0)
            p1_valid, p1_data = p1.send(p1_ready)
            if c_ready & p0_valid:
                break
            yield  # Wait for handshake
        yield    # Complete handshake
        while True:
            with Wire() as c_ready:
                p1_valid, p1_data = p1.send(c_ready)
                c_ready = c.send(p1_valid, p1_data)
            # TODO: ANON input not yet implemented
            # p0_valid, p0_data = p0.send(0)
            p0_ready = bit(0)
            p0_valid, p0_data = p0.send(p0_ready)
            if c_ready & p1_valid:
              break
            yield  # Wait for handshake
        yield    # Complete handshake


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_fair_merge(strategy):
    compile(fair_merge(), file_name="tests/build/si_fair_merge.v",
            strategy=strategy)
