import os
os.environ["MANTLE"] = "lattice"
from magma import compile
from mantle import DefinePISO
compile("build/piso_mantle", DefinePISO(10))
