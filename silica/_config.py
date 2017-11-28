class Config:
    def __init__(self):
        self._compile_dir = None

    @property
    def compile_dir(self):
        return self._compile_dir

    @compile_dir.setter
    def compile_dir(self, value):
        self._compile_dir = value

config = Config()
