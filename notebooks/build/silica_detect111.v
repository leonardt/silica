

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module corebit_or (
  input in0,
  input in1,
  output out
);
  assign out = in0 | in1;

endmodule //corebit_or

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

module coreir_ult #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 < in1;

endmodule //coreir_ult

module coreir_add #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 + in1;

endmodule //coreir_add

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

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

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

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

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

module __silica_BufferDetect111 (
  input [5:0] I,
  output [5:0] O
);
  //All the connections
  assign O[5:0] = I[5:0];

endmodule //__silica_BufferDetect111

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

module SilicaOneHotMux62 (
  input [1:0] I0,
  input [1:0] I1,
  input [1:0] I2,
  input [1:0] I3,
  input [1:0] I4,
  input [1:0] I5,
  output [1:0] O,
  input [5:0] S
);
  //Wire declarations for instance 'inst0' (Module fold_or62)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I3;
  wire [1:0] inst0_O;
  wire [1:0] inst0_I4;
  wire [1:0] inst0_I2;
  wire [1:0] inst0_I1;
  wire [1:0] inst0_I5;
  fold_or62 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .I4(inst0_I4),
    .I5(inst0_I5),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module and2_wrapped)
  wire [1:0] inst1_I0;
  wire [1:0] inst1_I1;
  wire [1:0] inst1_O;
  and2_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module and2_wrapped)
  wire [1:0] inst2_I0;
  wire [1:0] inst2_I1;
  wire [1:0] inst2_O;
  and2_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
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

  //Wire declarations for instance 'inst4' (Module and2_wrapped)
  wire [1:0] inst4_I0;
  wire [1:0] inst4_I1;
  wire [1:0] inst4_O;
  and2_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
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

  //All the connections
  assign inst0_I0[1:0] = inst1_O[1:0];
  assign inst0_I1[1:0] = inst2_O[1:0];
  assign inst0_I2[1:0] = inst3_O[1:0];
  assign inst0_I3[1:0] = inst4_O[1:0];
  assign inst0_I4[1:0] = inst5_O[1:0];
  assign inst0_I5[1:0] = inst6_O[1:0];
  assign O[1:0] = inst0_O[1:0];
  assign inst1_I0[1:0] = I0[1:0];
  assign inst2_I0[1:0] = I1[1:0];
  assign inst3_I0[1:0] = I2[1:0];
  assign inst4_I0[1:0] = I3[1:0];
  assign inst5_I0[1:0] = I4[1:0];
  assign inst6_I0[1:0] = I5[1:0];
  assign inst1_I1[0] = S[0];
  assign inst1_I1[1] = S[0];
  assign inst2_I1[0] = S[1];
  assign inst2_I1[1] = S[1];
  assign inst3_I1[0] = S[2];
  assign inst3_I1[1] = S[2];
  assign inst4_I1[0] = S[3];
  assign inst4_I1[1] = S[3];
  assign inst5_I1[0] = S[4];
  assign inst5_I1[1] = S[4];
  assign inst6_I1[0] = S[5];
  assign inst6_I1[1] = S[5];

endmodule //SilicaOneHotMux62

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

module SilicaOneHotMux6None (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  output  O,
  input [5:0] S
);
  //Wire declarations for instance 'inst0' (Module fold_or6None)
  wire  inst0_I0;
  wire  inst0_I3;
  wire  inst0_O;
  wire  inst0_I4;
  wire  inst0_I2;
  wire  inst0_I1;
  wire  inst0_I5;
  fold_or6None inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .I4(inst0_I4),
    .I5(inst0_I5),
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

  //Wire declarations for instance 'inst2' (Module and_wrapped)
  wire  inst2_I0;
  wire  inst2_I1;
  wire  inst2_O;
  and_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module and_wrapped)
  wire  inst3_I0;
  wire  inst3_I1;
  wire  inst3_O;
  and_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module and_wrapped)
  wire  inst4_I0;
  wire  inst4_I1;
  wire  inst4_O;
  and_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module and_wrapped)
  wire  inst5_I0;
  wire  inst5_I1;
  wire  inst5_O;
  and_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module and_wrapped)
  wire  inst6_I0;
  wire  inst6_I1;
  wire  inst6_O;
  and_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //All the connections
  assign inst0_I0 = inst1_O;
  assign inst0_I1 = inst2_O;
  assign inst0_I2 = inst3_O;
  assign inst0_I3 = inst4_O;
  assign inst0_I4 = inst5_O;
  assign inst0_I5 = inst6_O;
  assign O = inst0_O;
  assign inst1_I0 = I0;
  assign inst1_I1 = S[0];
  assign inst2_I0 = I1;
  assign inst2_I1 = S[1];
  assign inst3_I0 = I2;
  assign inst3_I1 = S[2];
  assign inst4_I0 = I3;
  assign inst4_I1 = S[3];
  assign inst5_I0 = I4;
  assign inst5_I1 = S[4];
  assign inst6_I0 = I5;
  assign inst6_I1 = S[5];

endmodule //SilicaOneHotMux6None

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

  //Wire declarations for instance 'inst10' (Module ULT2)
  wire [1:0] inst10_I0;
  wire [1:0] inst10_I1;
  wire  inst10_O;
  ULT2 inst10(
    .I0(inst10_I0),
    .I1(inst10_I1),
    .O(inst10_O)
  );

  //Wire declarations for instance 'inst11' (Module corebit_not)
  wire  inst11_in;
  wire  inst11_out;
  corebit_not inst11(
    .in(inst11_in),
    .out(inst11_out)
  );

  //Wire declarations for instance 'inst12' (Module EQ2)
  wire [1:0] inst12_I0;
  wire [1:0] inst12_I1;
  wire  inst12_O;
  EQ2 inst12(
    .I0(inst12_I0),
    .I1(inst12_I1),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst13' (Module fold_and3None)
  wire  inst13_I0;
  wire  inst13_I1;
  wire  inst13_I2;
  wire  inst13_O;
  fold_and3None inst13(
    .I0(inst13_I0),
    .I1(inst13_I1),
    .I2(inst13_I2),
    .O(inst13_O)
  );

  //Wire declarations for instance 'inst14' (Module corebit_not)
  wire  inst14_in;
  wire  inst14_out;
  corebit_not inst14(
    .in(inst14_in),
    .out(inst14_out)
  );

  //Wire declarations for instance 'inst15' (Module EQ2)
  wire [1:0] inst15_I0;
  wire [1:0] inst15_I1;
  wire  inst15_O;
  EQ2 inst15(
    .I0(inst15_I0),
    .I1(inst15_I1),
    .O(inst15_O)
  );

  //Wire declarations for instance 'inst16' (Module and_wrapped)
  wire  inst16_I0;
  wire  inst16_I1;
  wire  inst16_O;
  and_wrapped inst16(
    .I0(inst16_I0),
    .I1(inst16_I1),
    .O(inst16_O)
  );

  //Wire declarations for instance 'inst17' (Module ULT2)
  wire [1:0] inst17_I0;
  wire [1:0] inst17_I1;
  wire  inst17_O;
  ULT2 inst17(
    .I0(inst17_I0),
    .I1(inst17_I1),
    .O(inst17_O)
  );

  //Wire declarations for instance 'inst18' (Module Add2)
  wire [1:0] inst18_I0;
  wire [1:0] inst18_I1;
  wire [1:0] inst18_O;
  Add2 inst18(
    .I0(inst18_I0),
    .I1(inst18_I1),
    .O(inst18_O)
  );

  //Wire declarations for instance 'inst19' (Module EQ2)
  wire [1:0] inst19_I0;
  wire [1:0] inst19_I1;
  wire  inst19_O;
  EQ2 inst19(
    .I0(inst19_I0),
    .I1(inst19_I1),
    .O(inst19_O)
  );

  //Wire declarations for instance 'inst2' (Module SilicaOneHotMux62)
  wire [1:0] inst2_I0;
  wire [1:0] inst2_I3;
  wire [1:0] inst2_O;
  wire [1:0] inst2_I4;
  wire [1:0] inst2_I2;
  wire [1:0] inst2_I1;
  wire [1:0] inst2_I5;
  wire [5:0] inst2_S;
  SilicaOneHotMux62 inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .I2(inst2_I2),
    .I3(inst2_I3),
    .I4(inst2_I4),
    .I5(inst2_I5),
    .O(inst2_O),
    .S(inst2_S)
  );

  //Wire declarations for instance 'inst20' (Module fold_and3None)
  wire  inst20_I0;
  wire  inst20_I1;
  wire  inst20_I2;
  wire  inst20_O;
  fold_and3None inst20(
    .I0(inst20_I0),
    .I1(inst20_I1),
    .I2(inst20_I2),
    .O(inst20_O)
  );

  //Wire declarations for instance 'inst21' (Module ULT2)
  wire [1:0] inst21_I0;
  wire [1:0] inst21_I1;
  wire  inst21_O;
  ULT2 inst21(
    .I0(inst21_I0),
    .I1(inst21_I1),
    .O(inst21_O)
  );

  //Wire declarations for instance 'inst22' (Module corebit_not)
  wire  inst22_in;
  wire  inst22_out;
  corebit_not inst22(
    .in(inst22_in),
    .out(inst22_out)
  );

  //Wire declarations for instance 'inst23' (Module EQ2)
  wire [1:0] inst23_I0;
  wire [1:0] inst23_I1;
  wire  inst23_O;
  EQ2 inst23(
    .I0(inst23_I0),
    .I1(inst23_I1),
    .O(inst23_O)
  );

  //Wire declarations for instance 'inst24' (Module fold_and3None)
  wire  inst24_I0;
  wire  inst24_I1;
  wire  inst24_I2;
  wire  inst24_O;
  fold_and3None inst24(
    .I0(inst24_I0),
    .I1(inst24_I1),
    .I2(inst24_I2),
    .O(inst24_O)
  );

  //Wire declarations for instance 'inst25' (Module corebit_not)
  wire  inst25_in;
  wire  inst25_out;
  corebit_not inst25(
    .in(inst25_in),
    .out(inst25_out)
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

  //Wire declarations for instance 'inst27' (Module and_wrapped)
  wire  inst27_I0;
  wire  inst27_I1;
  wire  inst27_O;
  and_wrapped inst27(
    .I0(inst27_I0),
    .I1(inst27_I1),
    .O(inst27_O)
  );

  //Wire declarations for instance 'inst3' (Module Register2)
  wire  inst3_CLK;
  wire [1:0] inst3_I;
  wire [1:0] inst3_O;
  Register2 inst3(
    .CLK(inst3_CLK),
    .I(inst3_I),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module SilicaOneHotMux62)
  wire [1:0] inst4_I0;
  wire [1:0] inst4_I3;
  wire [1:0] inst4_O;
  wire [1:0] inst4_I4;
  wire [1:0] inst4_I2;
  wire [1:0] inst4_I1;
  wire [1:0] inst4_I5;
  wire [5:0] inst4_S;
  SilicaOneHotMux62 inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .I2(inst4_I2),
    .I3(inst4_I3),
    .I4(inst4_I4),
    .I5(inst4_I5),
    .O(inst4_O),
    .S(inst4_S)
  );

  //Wire declarations for instance 'inst5' (Module SilicaOneHotMux6None)
  wire  inst5_I0;
  wire  inst5_I3;
  wire  inst5_O;
  wire  inst5_I4;
  wire  inst5_I2;
  wire  inst5_I1;
  wire  inst5_I5;
  wire [5:0] inst5_S;
  SilicaOneHotMux6None inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .I2(inst5_I2),
    .I3(inst5_I3),
    .I4(inst5_I4),
    .I5(inst5_I5),
    .O(inst5_O),
    .S(inst5_S)
  );

  //Wire declarations for instance 'inst6' (Module ULT2)
  wire [1:0] inst6_I0;
  wire [1:0] inst6_I1;
  wire  inst6_O;
  ULT2 inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module Add2)
  wire [1:0] inst7_I0;
  wire [1:0] inst7_I1;
  wire [1:0] inst7_O;
  Add2 inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module EQ2)
  wire [1:0] inst8_I0;
  wire [1:0] inst8_I1;
  wire  inst8_O;
  EQ2 inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst9' (Module fold_and3None)
  wire  inst9_I0;
  wire  inst9_I1;
  wire  inst9_I2;
  wire  inst9_O;
  fold_and3None inst9(
    .I0(inst9_I0),
    .I1(inst9_I1),
    .I2(inst9_I2),
    .O(inst9_O)
  );

  //All the connections
  assign inst15_I0[0] = bit_const_GND_out;
  assign inst15_I0[1] = bit_const_GND_out;
  assign inst18_I1[1] = bit_const_GND_out;
  assign inst2_I0[0] = bit_const_GND_out;
  assign inst2_I1[0] = bit_const_GND_out;
  assign inst2_I2[0] = bit_const_GND_out;
  assign inst2_I3[0] = bit_const_GND_out;
  assign inst2_I4[0] = bit_const_GND_out;
  assign inst2_I5[0] = bit_const_GND_out;
  assign inst26_I0[0] = bit_const_GND_out;
  assign inst26_I0[1] = bit_const_GND_out;
  assign inst4_I2[0] = bit_const_GND_out;
  assign inst4_I2[1] = bit_const_GND_out;
  assign inst4_I5[0] = bit_const_GND_out;
  assign inst4_I5[1] = bit_const_GND_out;
  assign inst7_I1[1] = bit_const_GND_out;
  assign inst10_I1[0] = bit_const_VCC_out;
  assign inst10_I1[1] = bit_const_VCC_out;
  assign inst12_I1[0] = bit_const_VCC_out;
  assign inst12_I1[1] = bit_const_VCC_out;
  assign inst15_I1[0] = bit_const_VCC_out;
  assign inst15_I1[1] = bit_const_VCC_out;
  assign inst17_I1[0] = bit_const_VCC_out;
  assign inst17_I1[1] = bit_const_VCC_out;
  assign inst18_I1[0] = bit_const_VCC_out;
  assign inst19_I1[0] = bit_const_VCC_out;
  assign inst19_I1[1] = bit_const_VCC_out;
  assign inst2_I0[1] = bit_const_VCC_out;
  assign inst2_I1[1] = bit_const_VCC_out;
  assign inst2_I2[1] = bit_const_VCC_out;
  assign inst2_I3[1] = bit_const_VCC_out;
  assign inst2_I4[1] = bit_const_VCC_out;
  assign inst2_I5[1] = bit_const_VCC_out;
  assign inst21_I1[0] = bit_const_VCC_out;
  assign inst21_I1[1] = bit_const_VCC_out;
  assign inst23_I1[0] = bit_const_VCC_out;
  assign inst23_I1[1] = bit_const_VCC_out;
  assign inst26_I1[0] = bit_const_VCC_out;
  assign inst26_I1[1] = bit_const_VCC_out;
  assign inst6_I1[0] = bit_const_VCC_out;
  assign inst6_I1[1] = bit_const_VCC_out;
  assign inst7_I1[0] = bit_const_VCC_out;
  assign inst8_I1[0] = bit_const_VCC_out;
  assign inst8_I1[1] = bit_const_VCC_out;
  assign inst2_S[5:0] = inst0_O[5:0];
  assign inst4_S[5:0] = inst0_O[5:0];
  assign inst5_S[5:0] = inst0_O[5:0];
  assign inst1_CLK = CLK;
  assign inst1_I[1:0] = inst2_O[1:0];
  assign inst10_I0[1:0] = inst3_O[1:0];
  assign inst11_in = inst10_O;
  assign inst13_I2 = inst11_out;
  assign inst12_I0[1:0] = inst3_O[1:0];
  assign inst5_I1 = inst12_O;
  assign inst13_I0 = inst1_O[0];
  assign inst13_I1 = I;
  assign inst0_I[1] = inst13_O;
  assign inst14_in = I;
  assign inst16_I1 = inst14_out;
  assign inst5_I2 = inst15_O;
  assign inst16_I0 = inst1_O[0];
  assign inst0_I[2] = inst16_O;
  assign inst17_I0[1:0] = inst3_O[1:0];
  assign inst20_I2 = inst17_O;
  assign inst18_I0[1:0] = inst3_O[1:0];
  assign inst19_I0[1:0] = inst18_O[1:0];
  assign inst4_I3[1:0] = inst18_O[1:0];
  assign inst5_I3 = inst19_O;
  assign inst20_I0 = inst1_O[1];
  assign inst20_I1 = I;
  assign inst0_I[3] = inst20_O;
  assign inst21_I0[1:0] = inst3_O[1:0];
  assign inst22_in = inst21_O;
  assign inst24_I2 = inst22_out;
  assign inst23_I0[1:0] = inst3_O[1:0];
  assign inst5_I4 = inst23_O;
  assign inst24_I0 = inst1_O[1];
  assign inst24_I1 = I;
  assign inst0_I[4] = inst24_O;
  assign inst25_in = I;
  assign inst27_I1 = inst25_out;
  assign inst5_I5 = inst26_O;
  assign inst27_I0 = inst1_O[1];
  assign inst0_I[5] = inst27_O;
  assign inst3_CLK = CLK;
  assign inst3_I[1:0] = inst4_O[1:0];
  assign inst4_I1[1:0] = inst3_O[1:0];
  assign inst4_I4[1:0] = inst3_O[1:0];
  assign inst6_I0[1:0] = inst3_O[1:0];
  assign inst7_I0[1:0] = inst3_O[1:0];
  assign inst4_I0[1:0] = inst7_O[1:0];
  assign inst5_I0 = inst8_O;
  assign O = inst5_O;
  assign inst9_I2 = inst6_O;
  assign inst8_I0[1:0] = inst7_O[1:0];
  assign inst9_I0 = inst1_O[0];
  assign inst9_I1 = I;
  assign inst0_I[0] = inst9_O;

endmodule //Detect111
