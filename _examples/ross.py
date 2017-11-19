import silica

@silica.coroutine
def Ross(self):
    reg = 0
    while True:
        I = self.receive()
        x = I + 1
        O_stateful = reg + 1
        O_combinational = x + 1
        reg = x
        yield O_stateful, O_combinational
