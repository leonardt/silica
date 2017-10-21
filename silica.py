class Coroutine:
    """
    Makes the initial call to __next__ upon construction to immediately
    start the routine.

    Overrides __getattr__ to support inspection of the local variables
    """
    def __init__(self, *args, **kwargs):
        self.reset(*args, **kwargs)

    @classmethod
    def definition(cls, *args, **kwargs):
        return cls._definition(*args, **kwargs)

    def reset(self, *args, **kwargs):
        self.co = self.definition(*args, **kwargs)
        next(self.co)

    def __getattr__(self, key):
        return self.co.gi_frame.f_locals[key]

    def send(self, *args):
        return self.co.send(*args)

    def __next__(self):
        return next(self.co)

    def next(self):
        return self.__next__()

def coroutine(func):
    class _Coroutine(Coroutine):
        _definition = func

    return _Coroutine
