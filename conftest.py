import pytest


@pytest.fixture(autouse=True)
def silica_test():
    import silica
    silica.config.compile_dir = 'callee_file_dir'
    import magma
    magma.config.set_compile_dir('callee_file_dir')
