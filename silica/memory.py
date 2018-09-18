class MemoryType:
    def __init__(self, height, width):
        self.height = height
        self.width = width

    def __eq__(self, other):
        return isinstance(other, MemoryType) and self.height == other.height and self.width == other.width
