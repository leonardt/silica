

module corebit_or (
  input in0,
  input in1,
  output out
);
  assign out = in0 | in1;

endmodule //corebit_or

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module coreir_add #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 + in1;

endmodule //coreir_add

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

module Add2 (
  input [1:0] I0,
  input [1:0] I1,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_add)
  wire [1:0] inst0_in0;
  wire [1:0] inst0_out;
  wire [1:0] inst0_in1;
  coreir_add #(.width(2)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[1:0] = I0[1:0];
  assign inst0_in1[1:0] = I1[1:0];
  assign O[1:0] = inst0_out[1:0];

endmodule //Add2

module or_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_or)
  wire  inst0_in0;
  wire  inst0_out;
  wire  inst0_in1;
  corebit_or inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0 = I0;
  assign inst0_in1 = I1;
  assign O = inst0_out;

endmodule //or_wrapped

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module coreir_reg #(parameter init=1, parameter width=1) (
  input clk,
  input [width-1:0] in,
  output [width-1:0] out
);
reg [width-1:0] outReg=init;
always @(posedge clk) begin
  outReg <= in;
end
assign out = outReg;

endmodule //coreir_reg

module fold_or6None (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  output  O
);
  //Wire declarations for instance 'inst0' (Module or_wrapped)
  wire  inst0_I0;
  wire  inst0_I1;
  wire  inst0_O;
  or_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module or_wrapped)
  wire  inst1_I0;
  wire  inst1_I1;
  wire  inst1_O;
  or_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or_wrapped)
  wire  inst2_I0;
  wire  inst2_I1;
  wire  inst2_O;
  or_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module or_wrapped)
  wire  inst3_I0;
  wire  inst3_I1;
  wire  inst3_O;
  or_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module or_wrapped)
  wire  inst4_I0;
  wire  inst4_I1;
  wire  inst4_O;
  or_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //All the connections
  assign inst0_I0 = I0;
  assign inst0_I1 = I1;
  assign inst1_I0 = inst0_O;
  assign inst1_I1 = I2;
  assign inst2_I0 = inst1_O;
  assign inst2_I1 = I3;
  assign inst3_I0 = inst2_O;
  assign inst3_I1 = I4;
  assign inst4_I0 = inst3_O;
  assign inst4_I1 = I5;
  assign O = inst4_O;

endmodule //fold_or6None

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module coreir_ult #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 < in1;

endmodule //coreir_ult

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module and_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_and)
  wire  inst0_in0;
  wire  inst0_out;
  wire  inst0_in1;
  corebit_and inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0 = I0;
  assign inst0_in1 = I1;
  assign O = inst0_out;

endmodule //and_wrapped

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

module EQ2 (
  input [1:0] I0,
  input [1:0] I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_eq)
  wire [1:0] inst0_in0;
  wire  inst0_out;
  wire [1:0] inst0_in1;
  coreir_eq #(.width(2)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[1:0] = I0[1:0];
  assign inst0_in1[1:0] = I1[1:0];
  assign O = inst0_out;

endmodule //EQ2

module __silica_BufferDetect111 (
  input [5:0] I,
  output [5:0] O
);
  //All the connections
  assign O[5:0] = I[5:0];

endmodule //__silica_BufferDetect111

module and2_wrapped (
  input [1:0] I0,
  input [1:0] I1,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [1:0] inst0_in0;
  wire [1:0] inst0_out;
  wire [1:0] inst0_in1;
  coreir_and #(.width(2)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[1:0] = I0[1:0];
  assign inst0_in1[1:0] = I1[1:0];
  assign O[1:0] = inst0_out[1:0];

endmodule //and2_wrapped

module ULT2 (
  input [1:0] I0,
  input [1:0] I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_ult)
  wire [1:0] inst0_in0;
  wire  inst0_out;
  wire [1:0] inst0_in1;
  coreir_ult #(.width(2)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[1:0] = I0[1:0];
  assign inst0_in1[1:0] = I1[1:0];
  assign O = inst0_out;

endmodule //ULT2

module fold_and3None (
  input  I0,
  input  I1,
  input  I2,
  output  O
);
  //Wire declarations for instance 'inst0' (Module and_wrapped)
  wire  inst0_I0;
  wire  inst0_I1;
  wire  inst0_O;
  and_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module and_wrapped)
  wire  inst1_I0;
  wire  inst1_I1;
  wire  inst1_O;
  and_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //All the connections
  assign inst0_I0 = I0;
  assign inst0_I1 = I1;
  assign inst1_I0 = inst0_O;
  assign inst1_I1 = I2;
  assign O = inst1_O;

endmodule //fold_and3None

module or2_wrapped (
  input [1:0] I0,
  input [1:0] I1,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [1:0] inst0_in0;
  wire [1:0] inst0_out;
  wire [1:0] inst0_in1;
  coreir_or #(.width(2)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[1:0] = I0[1:0];
  assign inst0_in1[1:0] = I1[1:0];
  assign O[1:0] = inst0_out[1:0];

endmodule //or2_wrapped

module fold_or62 (
  input [1:0] I0,
  input [1:0] I1,
  input [1:0] I2,
  input [1:0] I3,
  input [1:0] I4,
  input [1:0] I5,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module or2_wrapped)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I1;
  wire [1:0] inst0_O;
  or2_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module or2_wrapped)
  wire [1:0] inst1_I0;
  wire [1:0] inst1_I1;
  wire [1:0] inst1_O;
  or2_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or2_wrapped)
  wire [1:0] inst2_I0;
  wire [1:0] inst2_I1;
  wire [1:0] inst2_O;
  or2_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module or2_wrapped)
  wire [1:0] inst3_I0;
  wire [1:0] inst3_I1;
  wire [1:0] inst3_O;
  or2_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module or2_wrapped)
  wire [1:0] inst4_I0;
  wire [1:0] inst4_I1;
  wire [1:0] inst4_O;
  or2_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //All the connections
  assign inst0_I0[1:0] = I0[1:0];
  assign inst0_I1[1:0] = I1[1:0];
  assign inst1_I0[1:0] = inst0_O[1:0];
  assign inst1_I1[1:0] = I2[1:0];
  assign inst2_I0[1:0] = inst1_O[1:0];
  assign inst2_I1[1:0] = I3[1:0];
  assign inst3_I0[1:0] = inst2_O[1:0];
  assign inst3_I1[1:0] = I4[1:0];
  assign inst4_I0[1:0] = inst3_O[1:0];
  assign inst4_I1[1:0] = I5[1:0];
  assign O[1:0] = inst4_O[1:0];

endmodule //fold_or62

module reg_U1 #(parameter init=1) (
  input  clk,
  input [0:0] in,
  output [0:0] out
);
  //Wire declarations for instance 'reg0' (Module coreir_reg)
  wire  reg0_clk;
  wire [0:0] reg0_in;
  wire [0:0] reg0_out;
  coreir_reg #(.init(init),.width(1)) reg0(
    .clk(reg0_clk),
    .in(reg0_in),
    .out(reg0_out)
  );

  //All the connections
  assign reg0_clk = clk;
  assign reg0_in[0:0] = in[0:0];
  assign out[0:0] = reg0_out[0:0];

endmodule //reg_U1

module DFF_init1_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U1)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U1 #(.init(1'd1)) inst0(
    .clk(inst0_clk),
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_clk = CLK;
  assign inst0_in[0] = I;
  assign O = inst0_out[0];

endmodule //DFF_init1_has_ceFalse_has_resetFalse

module DFF_init0_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U1)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U1 #(.init(1'd0)) inst0(
    .clk(inst0_clk),
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_clk = CLK;
  assign inst0_in[0] = I;
  assign O = inst0_out[0];

endmodule //DFF_init0_has_ceFalse_has_resetFalse

module Register2_0001 (
  input  CLK,
  input [1:0] I,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init1_has_ceFalse_has_resetFalse)
  wire  inst0_CLK;
  wire  inst0_I;
  wire  inst0_O;
  DFF_init1_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0_CLK),
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1_CLK;
  wire  inst1_I;
  wire  inst1_O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //All the connections
  assign inst0_CLK = CLK;
  assign inst0_I = I[0];
  assign O[0] = inst0_O;
  assign inst1_CLK = CLK;
  assign inst1_I = I[1];
  assign O[1] = inst1_O;

endmodule //Register2_0001

module Register2 (
  input  CLK,
  input [1:0] I,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst0_CLK;
  wire  inst0_I;
  wire  inst0_O;
  DFF_init0_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0_CLK),
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1_CLK;
  wire  inst1_I;
  wire  inst1_O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //All the connections
  assign inst0_CLK = CLK;
  assign inst0_I = I[0];
  assign O[0] = inst0_O;
  assign inst1_CLK = CLK;
  assign inst1_I = I[1];
  assign O[1] = inst1_O;

endmodule //Register2

module Detect111 (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND_out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND_out)
  );

  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC_out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC_out)
  );

  //Wire declarations for instance 'inst0' (Module __silica_BufferDetect111)
  wire [5:0] inst0_I;
  wire [5:0] inst0_O;
  __silica_BufferDetect111 inst0(
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module Register2_0001)
  wire  inst1_CLK;
  wire [1:0] inst1_I;
  wire [1:0] inst1_O;
  Register2_0001 inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst10' (Module fold_or62)
  wire [1:0] inst10_I0;
  wire [1:0] inst10_I3;
  wire [1:0] inst10_O;
  wire [1:0] inst10_I4;
  wire [1:0] inst10_I2;
  wire [1:0] inst10_I1;
  wire [1:0] inst10_I5;
  fold_or62 inst10(
    .I0(inst10_I0),
    .I1(inst10_I1),
    .I2(inst10_I2),
    .I3(inst10_I3),
    .I4(inst10_I4),
    .I5(inst10_I5),
    .O(inst10_O)
  );

  //Wire declarations for instance 'inst11' (Module and2_wrapped)
  wire [1:0] inst11_I0;
  wire [1:0] inst11_I1;
  wire [1:0] inst11_O;
  and2_wrapped inst11(
    .I0(inst11_I0),
    .I1(inst11_I1),
    .O(inst11_O)
  );

  //Wire declarations for instance 'inst12' (Module and2_wrapped)
  wire [1:0] inst12_I0;
  wire [1:0] inst12_I1;
  wire [1:0] inst12_O;
  and2_wrapped inst12(
    .I0(inst12_I0),
    .I1(inst12_I1),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst13' (Module and2_wrapped)
  wire [1:0] inst13_I0;
  wire [1:0] inst13_I1;
  wire [1:0] inst13_O;
  and2_wrapped inst13(
    .I0(inst13_I0),
    .I1(inst13_I1),
    .O(inst13_O)
  );

  //Wire declarations for instance 'inst14' (Module and2_wrapped)
  wire [1:0] inst14_I0;
  wire [1:0] inst14_I1;
  wire [1:0] inst14_O;
  and2_wrapped inst14(
    .I0(inst14_I0),
    .I1(inst14_I1),
    .O(inst14_O)
  );

  //Wire declarations for instance 'inst15' (Module and2_wrapped)
  wire [1:0] inst15_I0;
  wire [1:0] inst15_I1;
  wire [1:0] inst15_O;
  and2_wrapped inst15(
    .I0(inst15_I0),
    .I1(inst15_I1),
    .O(inst15_O)
  );

  //Wire declarations for instance 'inst16' (Module and2_wrapped)
  wire [1:0] inst16_I0;
  wire [1:0] inst16_I1;
  wire [1:0] inst16_O;
  and2_wrapped inst16(
    .I0(inst16_I0),
    .I1(inst16_I1),
    .O(inst16_O)
  );

  //Wire declarations for instance 'inst17' (Module fold_or6None)
  wire  inst17_I0;
  wire  inst17_I3;
  wire  inst17_O;
  wire  inst17_I4;
  wire  inst17_I2;
  wire  inst17_I1;
  wire  inst17_I5;
  fold_or6None inst17(
    .I0(inst17_I0),
    .I1(inst17_I1),
    .I2(inst17_I2),
    .I3(inst17_I3),
    .I4(inst17_I4),
    .I5(inst17_I5),
    .O(inst17_O)
  );

  //Wire declarations for instance 'inst18' (Module and_wrapped)
  wire  inst18_I0;
  wire  inst18_I1;
  wire  inst18_O;
  and_wrapped inst18(
    .I0(inst18_I0),
    .I1(inst18_I1),
    .O(inst18_O)
  );

  //Wire declarations for instance 'inst19' (Module and_wrapped)
  wire  inst19_I0;
  wire  inst19_I1;
  wire  inst19_O;
  and_wrapped inst19(
    .I0(inst19_I0),
    .I1(inst19_I1),
    .O(inst19_O)
  );

  //Wire declarations for instance 'inst2' (Module fold_or62)
  wire [1:0] inst2_I0;
  wire [1:0] inst2_I3;
  wire [1:0] inst2_O;
  wire [1:0] inst2_I4;
  wire [1:0] inst2_I2;
  wire [1:0] inst2_I1;
  wire [1:0] inst2_I5;
  fold_or62 inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .I2(inst2_I2),
    .I3(inst2_I3),
    .I4(inst2_I4),
    .I5(inst2_I5),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst20' (Module and_wrapped)
  wire  inst20_I0;
  wire  inst20_I1;
  wire  inst20_O;
  and_wrapped inst20(
    .I0(inst20_I0),
    .I1(inst20_I1),
    .O(inst20_O)
  );

  //Wire declarations for instance 'inst21' (Module and_wrapped)
  wire  inst21_I0;
  wire  inst21_I1;
  wire  inst21_O;
  and_wrapped inst21(
    .I0(inst21_I0),
    .I1(inst21_I1),
    .O(inst21_O)
  );

  //Wire declarations for instance 'inst22' (Module and_wrapped)
  wire  inst22_I0;
  wire  inst22_I1;
  wire  inst22_O;
  and_wrapped inst22(
    .I0(inst22_I0),
    .I1(inst22_I1),
    .O(inst22_O)
  );

  //Wire declarations for instance 'inst23' (Module and_wrapped)
  wire  inst23_I0;
  wire  inst23_I1;
  wire  inst23_O;
  and_wrapped inst23(
    .I0(inst23_I0),
    .I1(inst23_I1),
    .O(inst23_O)
  );

  //Wire declarations for instance 'inst24' (Module ULT2)
  wire [1:0] inst24_I0;
  wire [1:0] inst24_I1;
  wire  inst24_O;
  ULT2 inst24(
    .I0(inst24_I0),
    .I1(inst24_I1),
    .O(inst24_O)
  );

  //Wire declarations for instance 'inst25' (Module Add2)
  wire [1:0] inst25_I0;
  wire [1:0] inst25_I1;
  wire [1:0] inst25_O;
  Add2 inst25(
    .I0(inst25_I0),
    .I1(inst25_I1),
    .O(inst25_O)
  );

  //Wire declarations for instance 'inst26' (Module EQ2)
  wire [1:0] inst26_I0;
  wire [1:0] inst26_I1;
  wire  inst26_O;
  EQ2 inst26(
    .I0(inst26_I0),
    .I1(inst26_I1),
    .O(inst26_O)
  );

  //Wire declarations for instance 'inst27' (Module fold_and3None)
  wire  inst27_I0;
  wire  inst27_I1;
  wire  inst27_I2;
  wire  inst27_O;
  fold_and3None inst27(
    .I0(inst27_I0),
    .I1(inst27_I1),
    .I2(inst27_I2),
    .O(inst27_O)
  );

  //Wire declarations for instance 'inst28' (Module ULT2)
  wire [1:0] inst28_I0;
  wire [1:0] inst28_I1;
  wire  inst28_O;
  ULT2 inst28(
    .I0(inst28_I0),
    .I1(inst28_I1),
    .O(inst28_O)
  );

  //Wire declarations for instance 'inst29' (Module corebit_not)
  wire  inst29_in;
  wire  inst29_out;
  corebit_not inst29(
    .in(inst29_in),
    .out(inst29_out)
  );

  //Wire declarations for instance 'inst3' (Module and2_wrapped)
  wire [1:0] inst3_I0;
  wire [1:0] inst3_I1;
  wire [1:0] inst3_O;
  and2_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst30' (Module EQ2)
  wire [1:0] inst30_I0;
  wire [1:0] inst30_I1;
  wire  inst30_O;
  EQ2 inst30(
    .I0(inst30_I0),
    .I1(inst30_I1),
    .O(inst30_O)
  );

  //Wire declarations for instance 'inst31' (Module fold_and3None)
  wire  inst31_I0;
  wire  inst31_I1;
  wire  inst31_I2;
  wire  inst31_O;
  fold_and3None inst31(
    .I0(inst31_I0),
    .I1(inst31_I1),
    .I2(inst31_I2),
    .O(inst31_O)
  );

  //Wire declarations for instance 'inst32' (Module corebit_not)
  wire  inst32_in;
  wire  inst32_out;
  corebit_not inst32(
    .in(inst32_in),
    .out(inst32_out)
  );

  //Wire declarations for instance 'inst33' (Module EQ2)
  wire [1:0] inst33_I0;
  wire [1:0] inst33_I1;
  wire  inst33_O;
  EQ2 inst33(
    .I0(inst33_I0),
    .I1(inst33_I1),
    .O(inst33_O)
  );

  //Wire declarations for instance 'inst34' (Module and_wrapped)
  wire  inst34_I0;
  wire  inst34_I1;
  wire  inst34_O;
  and_wrapped inst34(
    .I0(inst34_I0),
    .I1(inst34_I1),
    .O(inst34_O)
  );

  //Wire declarations for instance 'inst35' (Module ULT2)
  wire [1:0] inst35_I0;
  wire [1:0] inst35_I1;
  wire  inst35_O;
  ULT2 inst35(
    .I0(inst35_I0),
    .I1(inst35_I1),
    .O(inst35_O)
  );

  //Wire declarations for instance 'inst36' (Module Add2)
  wire [1:0] inst36_I0;
  wire [1:0] inst36_I1;
  wire [1:0] inst36_O;
  Add2 inst36(
    .I0(inst36_I0),
    .I1(inst36_I1),
    .O(inst36_O)
  );

  //Wire declarations for instance 'inst37' (Module EQ2)
  wire [1:0] inst37_I0;
  wire [1:0] inst37_I1;
  wire  inst37_O;
  EQ2 inst37(
    .I0(inst37_I0),
    .I1(inst37_I1),
    .O(inst37_O)
  );

  //Wire declarations for instance 'inst38' (Module fold_and3None)
  wire  inst38_I0;
  wire  inst38_I1;
  wire  inst38_I2;
  wire  inst38_O;
  fold_and3None inst38(
    .I0(inst38_I0),
    .I1(inst38_I1),
    .I2(inst38_I2),
    .O(inst38_O)
  );

  //Wire declarations for instance 'inst39' (Module ULT2)
  wire [1:0] inst39_I0;
  wire [1:0] inst39_I1;
  wire  inst39_O;
  ULT2 inst39(
    .I0(inst39_I0),
    .I1(inst39_I1),
    .O(inst39_O)
  );

  //Wire declarations for instance 'inst4' (Module and2_wrapped)
  wire [1:0] inst4_I0;
  wire [1:0] inst4_I1;
  wire [1:0] inst4_O;
  and2_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst40' (Module corebit_not)
  wire  inst40_in;
  wire  inst40_out;
  corebit_not inst40(
    .in(inst40_in),
    .out(inst40_out)
  );

  //Wire declarations for instance 'inst41' (Module EQ2)
  wire [1:0] inst41_I0;
  wire [1:0] inst41_I1;
  wire  inst41_O;
  EQ2 inst41(
    .I0(inst41_I0),
    .I1(inst41_I1),
    .O(inst41_O)
  );

  //Wire declarations for instance 'inst42' (Module fold_and3None)
  wire  inst42_I0;
  wire  inst42_I1;
  wire  inst42_I2;
  wire  inst42_O;
  fold_and3None inst42(
    .I0(inst42_I0),
    .I1(inst42_I1),
    .I2(inst42_I2),
    .O(inst42_O)
  );

  //Wire declarations for instance 'inst43' (Module corebit_not)
  wire  inst43_in;
  wire  inst43_out;
  corebit_not inst43(
    .in(inst43_in),
    .out(inst43_out)
  );

  //Wire declarations for instance 'inst44' (Module EQ2)
  wire [1:0] inst44_I0;
  wire [1:0] inst44_I1;
  wire  inst44_O;
  EQ2 inst44(
    .I0(inst44_I0),
    .I1(inst44_I1),
    .O(inst44_O)
  );

  //Wire declarations for instance 'inst45' (Module and_wrapped)
  wire  inst45_I0;
  wire  inst45_I1;
  wire  inst45_O;
  and_wrapped inst45(
    .I0(inst45_I0),
    .I1(inst45_I1),
    .O(inst45_O)
  );

  //Wire declarations for instance 'inst5' (Module and2_wrapped)
  wire [1:0] inst5_I0;
  wire [1:0] inst5_I1;
  wire [1:0] inst5_O;
  and2_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module and2_wrapped)
  wire [1:0] inst6_I0;
  wire [1:0] inst6_I1;
  wire [1:0] inst6_O;
  and2_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module and2_wrapped)
  wire [1:0] inst7_I0;
  wire [1:0] inst7_I1;
  wire [1:0] inst7_O;
  and2_wrapped inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module and2_wrapped)
  wire [1:0] inst8_I0;
  wire [1:0] inst8_I1;
  wire [1:0] inst8_O;
  and2_wrapped inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst9' (Module Register2)
  wire  inst9_CLK;
  wire [1:0] inst9_I;
  wire [1:0] inst9_O;
  Register2 inst9(
    .CLK(inst9_CLK),
    .I(inst9_I),
    .O(inst9_O)
  );

  //All the connections
  assign inst13_I1[0] = bit_const_GND_out;
  assign inst13_I1[1] = bit_const_GND_out;
  assign inst16_I1[0] = bit_const_GND_out;
  assign inst16_I1[1] = bit_const_GND_out;
  assign inst25_I1[1] = bit_const_GND_out;
  assign inst3_I1[0] = bit_const_GND_out;
  assign inst33_I0[0] = bit_const_GND_out;
  assign inst33_I0[1] = bit_const_GND_out;
  assign inst36_I1[1] = bit_const_GND_out;
  assign inst4_I1[0] = bit_const_GND_out;
  assign inst44_I0[0] = bit_const_GND_out;
  assign inst44_I0[1] = bit_const_GND_out;
  assign inst5_I1[0] = bit_const_GND_out;
  assign inst6_I1[0] = bit_const_GND_out;
  assign inst7_I1[0] = bit_const_GND_out;
  assign inst8_I1[0] = bit_const_GND_out;
  assign inst24_I1[0] = bit_const_VCC_out;
  assign inst24_I1[1] = bit_const_VCC_out;
  assign inst25_I1[0] = bit_const_VCC_out;
  assign inst26_I1[0] = bit_const_VCC_out;
  assign inst26_I1[1] = bit_const_VCC_out;
  assign inst28_I1[0] = bit_const_VCC_out;
  assign inst28_I1[1] = bit_const_VCC_out;
  assign inst3_I1[1] = bit_const_VCC_out;
  assign inst30_I1[0] = bit_const_VCC_out;
  assign inst30_I1[1] = bit_const_VCC_out;
  assign inst33_I1[0] = bit_const_VCC_out;
  assign inst33_I1[1] = bit_const_VCC_out;
  assign inst35_I1[0] = bit_const_VCC_out;
  assign inst35_I1[1] = bit_const_VCC_out;
  assign inst36_I1[0] = bit_const_VCC_out;
  assign inst37_I1[0] = bit_const_VCC_out;
  assign inst37_I1[1] = bit_const_VCC_out;
  assign inst39_I1[0] = bit_const_VCC_out;
  assign inst39_I1[1] = bit_const_VCC_out;
  assign inst4_I1[1] = bit_const_VCC_out;
  assign inst41_I1[0] = bit_const_VCC_out;
  assign inst41_I1[1] = bit_const_VCC_out;
  assign inst44_I1[0] = bit_const_VCC_out;
  assign inst44_I1[1] = bit_const_VCC_out;
  assign inst5_I1[1] = bit_const_VCC_out;
  assign inst6_I1[1] = bit_const_VCC_out;
  assign inst7_I1[1] = bit_const_VCC_out;
  assign inst8_I1[1] = bit_const_VCC_out;
  assign inst1_CLK = CLK;
  assign inst1_I[1:0] = inst2_O[1:0];
  assign inst10_I0[1:0] = inst11_O[1:0];
  assign inst10_I1[1:0] = inst12_O[1:0];
  assign inst10_I2[1:0] = inst13_O[1:0];
  assign inst10_I3[1:0] = inst14_O[1:0];
  assign inst10_I4[1:0] = inst15_O[1:0];
  assign inst10_I5[1:0] = inst16_O[1:0];
  assign inst9_I[1:0] = inst10_O[1:0];
  assign inst11_I1[1:0] = inst25_O[1:0];
  assign inst12_I1[1:0] = inst9_O[1:0];
  assign inst14_I1[1:0] = inst36_O[1:0];
  assign inst15_I1[1:0] = inst9_O[1:0];
  assign inst17_I0 = inst18_O;
  assign inst17_I1 = inst19_O;
  assign inst17_I2 = inst20_O;
  assign inst17_I3 = inst21_O;
  assign inst17_I4 = inst22_O;
  assign inst17_I5 = inst23_O;
  assign O = inst17_O;
  assign inst18_I0 = inst0_O[0];
  assign inst18_I1 = inst26_O;
  assign inst19_I0 = inst0_O[1];
  assign inst19_I1 = inst30_O;
  assign inst2_I0[1:0] = inst3_O[1:0];
  assign inst2_I1[1:0] = inst4_O[1:0];
  assign inst2_I2[1:0] = inst5_O[1:0];
  assign inst2_I3[1:0] = inst6_O[1:0];
  assign inst2_I4[1:0] = inst7_O[1:0];
  assign inst2_I5[1:0] = inst8_O[1:0];
  assign inst20_I0 = inst0_O[2];
  assign inst20_I1 = inst33_O;
  assign inst21_I0 = inst0_O[3];
  assign inst21_I1 = inst37_O;
  assign inst22_I0 = inst0_O[4];
  assign inst22_I1 = inst41_O;
  assign inst23_I0 = inst0_O[5];
  assign inst23_I1 = inst44_O;
  assign inst24_I0[1:0] = inst9_O[1:0];
  assign inst27_I2 = inst24_O;
  assign inst25_I0[1:0] = inst9_O[1:0];
  assign inst26_I0[1:0] = inst25_O[1:0];
  assign inst27_I0 = inst1_O[0];
  assign inst27_I1 = I;
  assign inst0_I[0] = inst27_O;
  assign inst28_I0[1:0] = inst9_O[1:0];
  assign inst29_in = inst28_O;
  assign inst31_I2 = inst29_out;
  assign inst30_I0[1:0] = inst9_O[1:0];
  assign inst31_I0 = inst1_O[0];
  assign inst31_I1 = I;
  assign inst0_I[1] = inst31_O;
  assign inst32_in = I;
  assign inst34_I1 = inst32_out;
  assign inst34_I0 = inst1_O[0];
  assign inst0_I[2] = inst34_O;
  assign inst35_I0[1:0] = inst9_O[1:0];
  assign inst38_I2 = inst35_O;
  assign inst36_I0[1:0] = inst9_O[1:0];
  assign inst37_I0[1:0] = inst36_O[1:0];
  assign inst38_I0 = inst1_O[1];
  assign inst38_I1 = I;
  assign inst0_I[3] = inst38_O;
  assign inst39_I0[1:0] = inst9_O[1:0];
  assign inst40_in = inst39_O;
  assign inst42_I2 = inst40_out;
  assign inst41_I0[1:0] = inst9_O[1:0];
  assign inst42_I0 = inst1_O[1];
  assign inst42_I1 = I;
  assign inst0_I[4] = inst42_O;
  assign inst43_in = I;
  assign inst45_I1 = inst43_out;
  assign inst45_I0 = inst1_O[1];
  assign inst0_I[5] = inst45_O;
  assign inst9_CLK = CLK;
  assign inst11_I0[0] = inst0_O[0];
  assign inst11_I0[1] = inst0_O[0];
  assign inst3_I0[0] = inst0_O[0];
  assign inst3_I0[1] = inst0_O[0];
  assign inst12_I0[0] = inst0_O[1];
  assign inst12_I0[1] = inst0_O[1];
  assign inst4_I0[0] = inst0_O[1];
  assign inst4_I0[1] = inst0_O[1];
  assign inst13_I0[0] = inst0_O[2];
  assign inst13_I0[1] = inst0_O[2];
  assign inst5_I0[0] = inst0_O[2];
  assign inst5_I0[1] = inst0_O[2];
  assign inst14_I0[0] = inst0_O[3];
  assign inst14_I0[1] = inst0_O[3];
  assign inst6_I0[0] = inst0_O[3];
  assign inst6_I0[1] = inst0_O[3];
  assign inst15_I0[0] = inst0_O[4];
  assign inst15_I0[1] = inst0_O[4];
  assign inst7_I0[0] = inst0_O[4];
  assign inst7_I0[1] = inst0_O[4];
  assign inst16_I0[0] = inst0_O[5];
  assign inst16_I0[1] = inst0_O[5];
  assign inst8_I0[0] = inst0_O[5];
  assign inst8_I0[1] = inst0_O[5];

endmodule //Detect111
