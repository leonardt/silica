import delegator
import json
import re


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
    # Uncomment to generate dot files
    # res = run(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif; show -stretch -prefix {top_name} -format dot' tests/build/{verilog_file}.v | grep -A 16 \"2.27. Printing statistics.\"")
    results[top_name]["SB_CARRY"] = 0
    results[top_name]["SB_DFF"] = 0
    results[top_name]["SB_LUT4"] = 0

    results[top_name]["logic levels"] = 0
    results[top_name]["path delay"] = 0
    results[top_name]["Max Clock Freq"] = 0

    results[top_name]["LCs"] = 0
    results[top_name]["PLBs"] = 0

    num_trials = 5
    for i in range(0, num_trials):
        res = run(f"yosys -p 'synth_ice40 -top {top_name} -blif tests/build/{verilog_file}.blif' tests/build/{verilog_file}.v | grep -A 20 \"2.27. Printing statistics.\"")
        for line in res.out.splitlines():
            line = line.split()
            if not line:
                continue
            if line[0] == "Number":
                results[top_name][" ".join(line[2:-1]).replace(":", "")] = line[-1]
            elif any(x in line[0] for x in [
                "SB_CARRY",
                "SB_DFF",
                "SB_LUT4",
            ]):
                if "SB_DFF" in line[0]:
                    results[top_name]["SB_DFF"] += int(line[1])
                else:
                    results[top_name][line[0]] += int(line[1])

        res = run(f"arachne-pnr -d 8k -o tests/build/{verilog_file}.txt tests/build/{verilog_file}.blif")
        for line in res.err.splitlines():
            line = line.split()
            if not line:
                continue
            if line[0] in "LCs":
                results[top_name][line[0]] += int(line[1])
            elif line[0] in "PLBs":
                results[top_name][line[0]] += int(line[1])

        res = run(f"icetime -itmd hx8k tests/build/{verilog_file}.txt | grep -B 2 \"Total path delay\"")
        match = re.compile(r"\((\d*\.?\d+) MHz\)")
        for line in res.out.splitlines():
            line = line.split(":")
            if not line:
                continue
            if line[0] == "Total number of logic levels":
                results[top_name]["logic levels"] += int(line[1].rstrip())
            elif line[0] == "Total path delay":
                results[top_name]["path delay"] += float(line[1].split()[0])
                result = line[1]
                result = match.findall(result)
                assert len(result) == 1, "Should only be one match"
                results[top_name]["Max Clock Freq"] += float(result[0])
    results[top_name]["SB_CARRY"] //= num_trials
    results[top_name]["SB_DFF"] //= num_trials
    results[top_name]["SB_LUT4"] //= num_trials

    results[top_name]["LCs"] //= num_trials
    results[top_name]["PLBs"] //= num_trials

    results[top_name]["logic levels"] //= num_trials
    results[top_name]["path delay"] /= num_trials
    results[top_name]["Max Clock Freq"] /= num_trials

    with open("results.json", "w") as f:
        json.dump(results, f, indent=4)
