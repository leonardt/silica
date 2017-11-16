import magma
from magma.testing.verilator import compile as compileverilator
from magma.testing.verilator import run_verilator_test
from magma.bit_vector import BitVector

def check_verilog(name, circ, circ_sim, num_cycles, inputs_generator=None):
    test_vectors = magma.testing.coroutine.testvectors(circ, circ_sim, num_cycles,
            inputs_generator if inputs_generator else None)

    with open(f"build/sim_{name}_verilator.cpp", "w") as verilator_harness:
        verilator_harness.write(f'''\
#include "V{name}.h"
#include "verilated.h"
#include <cassert>
#include <iostream>

void check(const char* port, int a, int b, int cycle) {{
    if (!(a == b)) {{
        std::cerr << \"Got      : \" << a << std::endl;
        std::cerr << \"Expected : \" << b << std::endl;
        std::cerr << \"Cycle    : \" << cycle << std::endl;
        std::cerr << \"Port     : \" << port << std::endl;
        exit(1);
    }}
}}

int main(int argc, char **argv, char **env) {{
    Verilated::commandArgs(argc, argv);
    V{name}* top = new V{name};
''')
        cycle = 0
        for inputs, outputs in zip(test_vectors[0], test_vectors[1]):
            for port_name, value in inputs.items():
                if isinstance(value, list):
                    string = ""
                    for elem in value:
                        string = elem.as_binary_string()[2:] + string
                    value = "0b" + string
                elif isinstance(value, BitVector):
                    value = value.as_int()
                else:
                    value = int(value)
                verilator_harness.write("    top->{} = {};\n".format(port_name, value))
            for port_name, value in outputs.items():
                if isinstance(value, BitVector):
                    value = value.as_binary_string()
                else:
                    value = int(value)
                verilator_harness.write("    top->eval();\n")
                verilator_harness.write("    check(\"{port_name}\", top->{port_name}, {expected}, {cycle});\n".format(port_name=port_name, expected=value, cycle=cycle))

            verilator_harness.write("    top->CLK = 0;\n")
            verilator_harness.write("    top->eval();\n")
            verilator_harness.write("    top->CLK = 1;\n")
            verilator_harness.write("    top->eval();\n")
            cycle += 1
        verilator_harness.write("}\n")

    run_verilator_test(
        name,
        f"sim_{name}_verilator",
        name,
        "-I../verilog"
    )