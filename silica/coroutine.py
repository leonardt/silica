class Coroutine:
    """
    Makes the initial call to __next__ upon construction to immediately
    start the routine.

    Overrides __getattr__ to support inspection of the local variables
    """
    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs
        self.has_ce = False
        self.reset()

    @classmethod
    def definition(cls, *args, **kwargs):
        return cls._definition(*args, **kwargs)

    def reset(self):
        self.co = self.definition(*self.args, **self.kwargs)
        next(self.co)

    def __getattr__(self, key):
        return self.co.gi_frame.f_locals[key]

    def send(self, *args):
        return self.co.send(*args)

    def __next__(self):
        return next(self.co)

    def next(self):
        return self.__next__()

def coroutine(func=None, inputs=None):
    if inputs is not None:
        def wrapper(func):
            class _Coroutine(Coroutine):
                _definition = func
                _inputs = inputs
            return _Coroutine
        return wrapper
    else:
        class _Coroutine(Coroutine):
            _definition = func
            _inputs = inputs
        return _Coroutine
