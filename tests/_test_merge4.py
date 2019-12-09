def merge(data_in0: si.ReadyValidIn, data_in1: si.ReadyValidIn,
          data_out: si.ReadyValidOut):
    while True:
        if ~data_in0.empty():
            data = data_in0.pop()
            data_out.push(data)
        elif ~data_in1.empty():
            data = data_in1.pop()
            data_out.push(data)


def foo():
    a, b = yield
    while True:
        a, b = yield a + b
        a, b = yield a - b


f = foo()
c = f.send(1, 2)
# c == 3
c = f.send(2, 1)
# c == 1
