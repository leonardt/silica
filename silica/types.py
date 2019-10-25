import enum


class Direction(enum.Enum):
    In = 0
    Out = 1


In = Direction.In
Out = Direction.Out


class Channel:
    def __init__(self, type_, direction):
        self.type_ = type_
        self.direction = direction


class Register:
    def __init__(self, T):
        self.T = T
