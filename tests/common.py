def evaluate_circuit(verilog_file, top_name):
    from subprocess import call
    print(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif' tests/build/{verilog_file}.v | grep -A 16 \"2.27. Printing statistics.\"")
    call(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif' tests/build/{verilog_file}.v | grep -A 16 \"2.27. Printing statistics.\"", shell=True)
    call(f"arachne-pnr -q -d 8k -o tests/build/{verilog_file}.txt tests/build/{verilog_file}.blif", shell=True)
    call(f"icetime -tmd hx1k tests/build/{verilog_file}.txt | grep -B 2 \"Total path delay\"", shell=True)
