import inspect

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


    def __deepcopy__(self, memo):
        obj = type(self)(*self.args, **self.kwargs)
        memo[id(self)] = obj
        return obj

    def __getattr__(self, key):
        try:
            return self.co.gi_frame.f_locals[key]
        except KeyError as e:
            if self.co.gi_yieldfrom is not None:
                try:
                    return self.co.gi_yieldfrom.gi_frame.f_locals[key]
                except KeyError as e:
                    pass
        raise KeyError(f"Could not find key {key}")

    def send(self, args):
        result = self.co.send(args)
        if not isinstance(result, tuple):
            assert len(self._outputs) == 1
            key = next(iter(self._outputs))
            setattr(self, key, result)
        else:
            for o, r in zip(self._outputs.keys(), result):
                setattr(self, o, r)
        return result


    def __next__(self):
        return next(self.co)

    def __iter__(self):
        return iter(self.co)

    def next(self):
        return self.__next__()

def coroutine(func=None, inputs=None):
    stack = inspect.stack()
    defn_locals = stack[1].frame.f_locals

    inputs = inspect.getfullargspec(func).annotations
    outputs = inspect.signature(func).return_annotation
    if 'return' in inputs:
        del inputs['return']
    args = [ inputs[arg] for arg in inspect.getfullargspec(func).args ]
    kwargs = { arg : inputs[arg] for arg in inspect.getfullargspec(func).kwonlyargs }

    def wrapper():
        class _Coroutine(Coroutine):
            _definition = func
            _inputs = inputs
            _outputs = outputs
            _defn_locals = defn_locals
            _name = func.__name__
        return _Coroutine(*args, **kwargs)
    return wrapper


class Generator(Coroutine):
    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs
        self.has_ce = False
        self.co = self.definition(*self.args, **self.kwargs)
        # self.reset()

    def reset(self):
        self.co = self.definition(*self.args, **self.kwargs)

    def __getattr__(self, key):
        return self.co.gi_frame.f_locals[key]

def generator(func=None, inputs=None):
    stack = inspect.stack()
    defn_locals = stack[1].frame.f_locals
    outputs = inspect.signature(func).return_annotation
    if inputs is not None:
        def wrapper(func):
            class _Generator(Generator):
                _outputs = outputs
                _definition = func
                _inputs = inputs
                _defn_locals = defn_locals
            return _Generator
        return wrapper
    else:
        class _Generator(Generator):
            _outputs = outputs
            _definition = func
            _inputs = inputs
            _defn_locals = defn_locals
        return _Generator
