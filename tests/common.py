import delegator
import json


def run(cmd):
    print("+ " + cmd)
    res = delegator.run(cmd)
    print(res.out)
    return res


def evaluate_circuit(verilog_file, top_name):
    try:
        with open("results.json", "r") as f:
            results = json.load(f)
    except FileNotFoundError:
        results = {}
    if top_name not in results:
        results[top_name] = {}
    res = run(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif; show -stretch -prefix {top_name} -format dot' tests/build/{verilog_file}.v | grep -A 16 \"2.27. Printing statistics.\"")
    for line in res.out.splitlines():
        line = line.split()
        if not line:
            continue
        if line[0] == "Number":
            results[top_name][" ".join(line[2:-1]).replace(":", "")] = line[-1]
        elif line[0] in [
            "SB_CARRY",
            "SB_DFF",
            "SB_DFFE",
            "SB_LUT4",
        ]:
            results[top_name][line[0]] = line[1]

    res = run(f"arachne-pnr -q -d 1k -o tests/build/{verilog_file}.txt tests/build/{verilog_file}.blif")
    res = run(f"icetime -tmd hx1k tests/build/{verilog_file}.txt | grep -B 2 \"Total path delay\"")
    with open("results.json", "w") as f:
        json.dump(results, f, indent=4)
