import magma as m

circ = m.DefineFromVerilogFile("counter.v", target_modules=["vcounter"])[0]
m.compile("counter2", circ, output="coreir-verilog")
