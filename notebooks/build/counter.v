module Register2CE_0001 (input [1:0] I, output [1:0] O, input  CLK, input  CE);
wire  inst0_Q;
wire  inst1_O;
wire  inst2_O;
wire  inst3_Q;
SB_DFFE inst0 (.C(CLK), .E(CE), .D(inst1_O), .Q(inst0_Q));
SB_LUT4 #(.LUT_INIT(16'h5555)) inst1 (.I0(I[0]), .I1(1'b0), .I2(1'b0), .I3(1'b0), .O(inst1_O));
SB_LUT4 #(.LUT_INIT(16'h5555)) inst2 (.I0(inst0_Q), .I1(1'b0), .I2(1'b0), .I3(1'b0), .O(inst2_O));
SB_DFFE inst3 (.C(CLK), .E(CE), .D(I[1]), .Q(inst3_Q));
assign O = {inst3_Q,inst2_O};
endmodule

module Or2 (input [1:0] I, output  O);
wire  inst0_O;
SB_LUT4 #(.LUT_INIT(16'hEEEE)) inst0 (.I0(I[0]), .I1(I[1]), .I2(1'b0), .I3(1'b0), .O(inst0_O));
assign O = inst0_O;
endmodule

module Or2x2 (input [1:0] I0, input [1:0] I1, output [1:0] O);
wire  inst0_O;
wire  inst1_O;
Or2 inst0 (.I({I1[0],I0[0]}), .O(inst0_O));
Or2 inst1 (.I({I1[1],I0[1]}), .O(inst1_O));
assign O = {inst1_O,inst0_O};
endmodule

module __silica_BufferCounter (input [1:0] I, output [1:0] O);
assign O = I;
endmodule

module And2 (input [1:0] I, output  O);
wire  inst0_O;
SB_LUT4 #(.LUT_INIT(16'h8888)) inst0 (.I0(I[0]), .I1(I[1]), .I2(1'b0), .I3(1'b0), .O(inst0_O));
assign O = inst0_O;
endmodule

module And2x2 (input [1:0] I0, input [1:0] I1, output [1:0] O);
wire  inst0_O;
wire  inst1_O;
And2 inst0 (.I({I1[0],I0[0]}), .O(inst0_O));
And2 inst1 (.I({I1[1],I0[1]}), .O(inst1_O));
assign O = {inst1_O,inst0_O};
endmodule

module Register4CE (input [3:0] I, output [3:0] O, input  CLK, input  CE);
wire  inst0_Q;
wire  inst1_Q;
wire  inst2_Q;
wire  inst3_Q;
SB_DFFE inst0 (.C(CLK), .E(CE), .D(I[0]), .Q(inst0_Q));
SB_DFFE inst1 (.C(CLK), .E(CE), .D(I[1]), .Q(inst1_Q));
SB_DFFE inst2 (.C(CLK), .E(CE), .D(I[2]), .Q(inst2_Q));
SB_DFFE inst3 (.C(CLK), .E(CE), .D(I[3]), .Q(inst3_Q));
assign O = {inst3_Q,inst2_Q,inst1_Q,inst0_Q};
endmodule

module Or2x4 (input [3:0] I0, input [3:0] I1, output [3:0] O);
wire  inst0_O;
wire  inst1_O;
wire  inst2_O;
wire  inst3_O;
Or2 inst0 (.I({I1[0],I0[0]}), .O(inst0_O));
Or2 inst1 (.I({I1[1],I0[1]}), .O(inst1_O));
Or2 inst2 (.I({I1[2],I0[2]}), .O(inst2_O));
Or2 inst3 (.I({I1[3],I0[3]}), .O(inst3_O));
assign O = {inst3_O,inst2_O,inst1_O,inst0_O};
endmodule

module And2x4 (input [3:0] I0, input [3:0] I1, output [3:0] O);
wire  inst0_O;
wire  inst1_O;
wire  inst2_O;
wire  inst3_O;
And2 inst0 (.I({I1[0],I0[0]}), .O(inst0_O));
And2 inst1 (.I({I1[1],I0[1]}), .O(inst1_O));
And2 inst2 (.I({I1[2],I0[2]}), .O(inst2_O));
And2 inst3 (.I({I1[3],I0[3]}), .O(inst3_O));
assign O = {inst3_O,inst2_O,inst1_O,inst0_O};
endmodule

module FullAdder (input  I0, input  I1, input  CIN, output  O, output  COUT);
wire  inst0_O;
wire  inst1_CO;
SB_LUT4 #(.LUT_INIT(16'h9696)) inst0 (.I0(I0), .I1(I1), .I2(CIN), .I3(1'b0), .O(inst0_O));
SB_CARRY inst1 (.I0(I0), .I1(I1), .CI(CIN), .CO(inst1_CO));
assign O = inst0_O;
assign COUT = inst1_CO;
endmodule

module Add4Cout (input [3:0] I0, input [3:0] I1, output [3:0] O, output  COUT);
wire  inst0_O;
wire  inst0_COUT;
wire  inst1_O;
wire  inst1_COUT;
wire  inst2_O;
wire  inst2_COUT;
wire  inst3_O;
wire  inst3_COUT;
FullAdder inst0 (.I0(I0[0]), .I1(I1[0]), .CIN(1'b0), .O(inst0_O), .COUT(inst0_COUT));
FullAdder inst1 (.I0(I0[1]), .I1(I1[1]), .CIN(inst0_COUT), .O(inst1_O), .COUT(inst1_COUT));
FullAdder inst2 (.I0(I0[2]), .I1(I1[2]), .CIN(inst1_COUT), .O(inst2_O), .COUT(inst2_COUT));
FullAdder inst3 (.I0(I0[3]), .I1(I1[3]), .CIN(inst2_COUT), .O(inst3_O), .COUT(inst3_COUT));
assign O = {inst3_O,inst2_O,inst1_O,inst0_O};
assign COUT = inst3_COUT;
endmodule

module Counter (output  cout, output [3:0] O, input  CLK);
wire [1:0] inst0_O;
wire [1:0] inst1_O;
wire [1:0] inst2_O;
wire [1:0] inst3_O;
wire [1:0] inst4_O;
wire [3:0] inst5_O;
wire [3:0] inst6_O;
wire [3:0] inst7_O;
wire [3:0] inst8_O;
wire  inst9_O;
wire  inst10_O;
wire  inst11_O;
wire [3:0] inst12_O;
wire [3:0] inst13_O;
wire [3:0] inst14_O;
wire [3:0] inst15_O;
wire  inst15_COUT;
wire [3:0] inst16_O;
wire  inst16_COUT;
Register2CE_0001 inst0 (.I(inst1_O), .O(inst0_O), .CLK(CLK), .CE(1'b1));
Or2x2 inst1 (.I0(inst3_O), .I1(inst4_O), .O(inst1_O));
__silica_BufferCounter inst2 (.I(inst0_O), .O(inst2_O));
And2x2 inst3 (.I0({inst2_O[0],inst2_O[0]}), .I1({1'b1,1'b0}), .O(inst3_O));
And2x2 inst4 (.I0({inst2_O[1],inst2_O[1]}), .I1({1'b1,1'b0}), .O(inst4_O));
Register4CE inst5 (.I(inst6_O), .O(inst5_O), .CLK(CLK), .CE(1'b1));
Or2x4 inst6 (.I0(inst7_O), .I1(inst8_O), .O(inst6_O));
And2x4 inst7 (.I0({inst2_O[0],inst2_O[0],inst2_O[0],inst2_O[0]}), .I1(inst15_O), .O(inst7_O));
And2x4 inst8 (.I0({inst2_O[1],inst2_O[1],inst2_O[1],inst2_O[1]}), .I1(inst16_O), .O(inst8_O));
Or2 inst9 (.I({inst11_O,inst10_O}), .O(inst9_O));
And2 inst10 (.I({inst15_COUT,inst2_O[0]}), .O(inst10_O));
And2 inst11 (.I({inst16_COUT,inst2_O[1]}), .O(inst11_O));
Or2x4 inst12 (.I0(inst13_O), .I1(inst14_O), .O(inst12_O));
And2x4 inst13 (.I0({inst2_O[0],inst2_O[0],inst2_O[0],inst2_O[0]}), .I1({1'b0,1'b0,1'b0,1'b0}), .O(inst13_O));
And2x4 inst14 (.I0({inst2_O[1],inst2_O[1],inst2_O[1],inst2_O[1]}), .I1(inst5_O), .O(inst14_O));
Add4Cout inst15 (.I0({1'b0,1'b0,1'b0,1'b0}), .I1({1'b0,1'b0,1'b0,1'b1}), .O(inst15_O), .COUT(inst15_COUT));
Add4Cout inst16 (.I0(inst5_O), .I1({1'b0,1'b0,1'b0,1'b1}), .O(inst16_O), .COUT(inst16_COUT));
assign cout = inst9_O;
assign O = inst12_O;
endmodule

module main (output [7:0] J1, input  CLKIN);
wire  inst0_cout;
wire [3:0] inst0_O;
Counter inst0 (.cout(inst0_cout), .O(inst0_O), .CLK(CLKIN));
assign J1 = {1'b0,1'b0,1'b0,1'b0,inst0_O[3],inst0_O[2],inst0_O[1],inst0_O[0]};
endmodule

