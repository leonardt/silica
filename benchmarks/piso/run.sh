#!/bin/bash

set -e

python _silica.py
magma -o coreir -m coreir -t PISO build/piso_silica.py
coreir -i build/piso_silica.json -o build/piso_silica.v
echo ""
echo "===== SILICA RESULTS ====="
echo ""
yosys -p 'synth_ice40 -top PISO -blif build/piso_silica.blif' build/piso_silica.v | grep -A 14 "2.27. Printing statistics."
arachne-pnr -q -d 1k -o build/piso_silica.txt build/piso_silica.blif
icetime -tmd hx1k build/piso_silica.txt | grep -B 2 "Total path delay"

echo ""
echo "====== MANTLE RESULTS ====="
echo ""
python _mantle.py
yosys -p 'synth_ice40 -top PISO10 -blif build/piso_mantle.blif' build/piso_mantle.v | grep -A 14 "2.27. Printing statistics."
arachne-pnr -q -d 1k -o build/piso_silica.txt build/piso_silica.blif
icetime -tmd hx1k build/piso_silica.txt | grep -B 2 "Total path delay"
