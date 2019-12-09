def merge(data_in0: si.ReadyValidIn, data_in1: si.ReadyValidIn,
          data_out: si.ReadyValidOut):
    while True:
        # need to stall other channel when doing a pop
        data = yield from [pop(data_in0), stall(data_in1)]
        yield from push(data_out, data)
        data = yield from pop(data_in1)
        yield from push(data_out, data)
        # f is a handshaked rigel module
        data = yield from call_rv(f, data_in1)
