

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module or5_wrapped (
  input [4:0] I0,
  input [4:0] I1,
  output [4:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [4:0] inst0_in0;
  wire [4:0] inst0_out;
  wire [4:0] inst0_in1;
  coreir_or #(.width(5)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[4:0] = I0[4:0];
  assign inst0_in1[4:0] = I1[4:0];
  assign O[4:0] = inst0_out[4:0];

endmodule //or5_wrapped

module or16_wrapped (
  input [15:0] I0,
  input [15:0] I1,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [15:0] inst0_in0;
  wire [15:0] inst0_out;
  wire [15:0] inst0_in1;
  coreir_or #(.width(16)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[15:0] = I0[15:0];
  assign inst0_in1[15:0] = I1[15:0];
  assign O[15:0] = inst0_out[15:0];

endmodule //or16_wrapped

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

module __silica_BufferSerializer4 (
  input [4:0] I,
  output [4:0] O
);
  //All the connections
  assign O[4:0] = I[4:0];

endmodule //__silica_BufferSerializer4

module and5_wrapped (
  input [4:0] I0,
  input [4:0] I1,
  output [4:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [4:0] inst0_in0;
  wire [4:0] inst0_out;
  wire [4:0] inst0_in1;
  coreir_and #(.width(5)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[4:0] = I0[4:0];
  assign inst0_in1[4:0] = I1[4:0];
  assign O[4:0] = inst0_out[4:0];

endmodule //and5_wrapped

module fold_or55 (
  input [4:0] I0,
  input [4:0] I1,
  input [4:0] I2,
  input [4:0] I3,
  input [4:0] I4,
  output [4:0] O
);
  //Wire declarations for instance 'inst0' (Module or5_wrapped)
  wire [4:0] inst0_I0;
  wire [4:0] inst0_I1;
  wire [4:0] inst0_O;
  or5_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module or5_wrapped)
  wire [4:0] inst1_I0;
  wire [4:0] inst1_I1;
  wire [4:0] inst1_O;
  or5_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or5_wrapped)
  wire [4:0] inst2_I0;
  wire [4:0] inst2_I1;
  wire [4:0] inst2_O;
  or5_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module or5_wrapped)
  wire [4:0] inst3_I0;
  wire [4:0] inst3_I1;
  wire [4:0] inst3_O;
  or5_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //All the connections
  assign inst0_I0[4:0] = I0[4:0];
  assign inst0_I1[4:0] = I1[4:0];
  assign inst1_I0[4:0] = inst0_O[4:0];
  assign inst1_I1[4:0] = I2[4:0];
  assign inst2_I0[4:0] = inst1_O[4:0];
  assign inst2_I1[4:0] = I3[4:0];
  assign inst3_I0[4:0] = inst2_O[4:0];
  assign inst3_I1[4:0] = I4[4:0];
  assign O[4:0] = inst3_O[4:0];

endmodule //fold_or55

module and16_wrapped (
  input [15:0] I0,
  input [15:0] I1,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [15:0] inst0_in0;
  wire [15:0] inst0_out;
  wire [15:0] inst0_in1;
  coreir_and #(.width(16)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[15:0] = I0[15:0];
  assign inst0_in1[15:0] = I1[15:0];
  assign O[15:0] = inst0_out[15:0];

endmodule //and16_wrapped

module fold_or516 (
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  input [15:0] I4,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module or16_wrapped)
  wire [15:0] inst0_I0;
  wire [15:0] inst0_I1;
  wire [15:0] inst0_O;
  or16_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module or16_wrapped)
  wire [15:0] inst1_I0;
  wire [15:0] inst1_I1;
  wire [15:0] inst1_O;
  or16_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or16_wrapped)
  wire [15:0] inst2_I0;
  wire [15:0] inst2_I1;
  wire [15:0] inst2_O;
  or16_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module or16_wrapped)
  wire [15:0] inst3_I0;
  wire [15:0] inst3_I1;
  wire [15:0] inst3_O;
  or16_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //All the connections
  assign inst0_I0[15:0] = I0[15:0];
  assign inst0_I1[15:0] = I1[15:0];
  assign inst1_I0[15:0] = inst0_O[15:0];
  assign inst1_I1[15:0] = I2[15:0];
  assign inst2_I0[15:0] = inst1_O[15:0];
  assign inst2_I1[15:0] = I3[15:0];
  assign inst3_I0[15:0] = inst2_O[15:0];
  assign inst3_I1[15:0] = I4[15:0];
  assign O[15:0] = inst3_O[15:0];

endmodule //fold_or516

module reg_U0 #(parameter init=1) (
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

endmodule //reg_U0

module DFF_init1_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U0)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U0 #(.init(1'd1)) inst0(
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
  //Wire declarations for instance 'inst0' (Module reg_U0)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U0 #(.init(1'd0)) inst0(
    .clk(inst0_clk),
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_clk = CLK;
  assign inst0_in[0] = I;
  assign O = inst0_out[0];

endmodule //DFF_init0_has_ceFalse_has_resetFalse

module Register5_0001 (
  input  CLK,
  input [4:0] I,
  output [4:0] O
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

  //Wire declarations for instance 'inst2' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst2_CLK;
  wire  inst2_I;
  wire  inst2_O;
  DFF_init0_has_ceFalse_has_resetFalse inst2(
    .CLK(inst2_CLK),
    .I(inst2_I),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst3_CLK;
  wire  inst3_I;
  wire  inst3_O;
  DFF_init0_has_ceFalse_has_resetFalse inst3(
    .CLK(inst3_CLK),
    .I(inst3_I),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst4_CLK;
  wire  inst4_I;
  wire  inst4_O;
  DFF_init0_has_ceFalse_has_resetFalse inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //All the connections
  assign inst0_CLK = CLK;
  assign inst0_I = I[0];
  assign O[0] = inst0_O;
  assign inst1_CLK = CLK;
  assign inst1_I = I[1];
  assign O[1] = inst1_O;
  assign inst2_CLK = CLK;
  assign inst2_I = I[2];
  assign O[2] = inst2_O;
  assign inst3_CLK = CLK;
  assign inst3_I = I[3];
  assign O[3] = inst3_O;
  assign inst4_CLK = CLK;
  assign inst4_I = I[4];
  assign O[4] = inst4_O;

endmodule //Register5_0001

module Register16 (
  input  CLK,
  input [15:0] I,
  output [15:0] O
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

  //Wire declarations for instance 'inst10' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst10_CLK;
  wire  inst10_I;
  wire  inst10_O;
  DFF_init0_has_ceFalse_has_resetFalse inst10(
    .CLK(inst10_CLK),
    .I(inst10_I),
    .O(inst10_O)
  );

  //Wire declarations for instance 'inst11' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst11_CLK;
  wire  inst11_I;
  wire  inst11_O;
  DFF_init0_has_ceFalse_has_resetFalse inst11(
    .CLK(inst11_CLK),
    .I(inst11_I),
    .O(inst11_O)
  );

  //Wire declarations for instance 'inst12' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst12_CLK;
  wire  inst12_I;
  wire  inst12_O;
  DFF_init0_has_ceFalse_has_resetFalse inst12(
    .CLK(inst12_CLK),
    .I(inst12_I),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst13' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst13_CLK;
  wire  inst13_I;
  wire  inst13_O;
  DFF_init0_has_ceFalse_has_resetFalse inst13(
    .CLK(inst13_CLK),
    .I(inst13_I),
    .O(inst13_O)
  );

  //Wire declarations for instance 'inst14' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst14_CLK;
  wire  inst14_I;
  wire  inst14_O;
  DFF_init0_has_ceFalse_has_resetFalse inst14(
    .CLK(inst14_CLK),
    .I(inst14_I),
    .O(inst14_O)
  );

  //Wire declarations for instance 'inst15' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst15_CLK;
  wire  inst15_I;
  wire  inst15_O;
  DFF_init0_has_ceFalse_has_resetFalse inst15(
    .CLK(inst15_CLK),
    .I(inst15_I),
    .O(inst15_O)
  );

  //Wire declarations for instance 'inst2' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst2_CLK;
  wire  inst2_I;
  wire  inst2_O;
  DFF_init0_has_ceFalse_has_resetFalse inst2(
    .CLK(inst2_CLK),
    .I(inst2_I),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst3_CLK;
  wire  inst3_I;
  wire  inst3_O;
  DFF_init0_has_ceFalse_has_resetFalse inst3(
    .CLK(inst3_CLK),
    .I(inst3_I),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst4_CLK;
  wire  inst4_I;
  wire  inst4_O;
  DFF_init0_has_ceFalse_has_resetFalse inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst5_CLK;
  wire  inst5_I;
  wire  inst5_O;
  DFF_init0_has_ceFalse_has_resetFalse inst5(
    .CLK(inst5_CLK),
    .I(inst5_I),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst6_CLK;
  wire  inst6_I;
  wire  inst6_O;
  DFF_init0_has_ceFalse_has_resetFalse inst6(
    .CLK(inst6_CLK),
    .I(inst6_I),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst7_CLK;
  wire  inst7_I;
  wire  inst7_O;
  DFF_init0_has_ceFalse_has_resetFalse inst7(
    .CLK(inst7_CLK),
    .I(inst7_I),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst8_CLK;
  wire  inst8_I;
  wire  inst8_O;
  DFF_init0_has_ceFalse_has_resetFalse inst8(
    .CLK(inst8_CLK),
    .I(inst8_I),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst9' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst9_CLK;
  wire  inst9_I;
  wire  inst9_O;
  DFF_init0_has_ceFalse_has_resetFalse inst9(
    .CLK(inst9_CLK),
    .I(inst9_I),
    .O(inst9_O)
  );

  //All the connections
  assign inst0_CLK = CLK;
  assign inst0_I = I[0];
  assign O[0] = inst0_O;
  assign inst1_CLK = CLK;
  assign inst1_I = I[1];
  assign O[1] = inst1_O;
  assign inst10_CLK = CLK;
  assign inst10_I = I[10];
  assign O[10] = inst10_O;
  assign inst11_CLK = CLK;
  assign inst11_I = I[11];
  assign O[11] = inst11_O;
  assign inst12_CLK = CLK;
  assign inst12_I = I[12];
  assign O[12] = inst12_O;
  assign inst13_CLK = CLK;
  assign inst13_I = I[13];
  assign O[13] = inst13_O;
  assign inst14_CLK = CLK;
  assign inst14_I = I[14];
  assign O[14] = inst14_O;
  assign inst15_CLK = CLK;
  assign inst15_I = I[15];
  assign O[15] = inst15_O;
  assign inst2_CLK = CLK;
  assign inst2_I = I[2];
  assign O[2] = inst2_O;
  assign inst3_CLK = CLK;
  assign inst3_I = I[3];
  assign O[3] = inst3_O;
  assign inst4_CLK = CLK;
  assign inst4_I = I[4];
  assign O[4] = inst4_O;
  assign inst5_CLK = CLK;
  assign inst5_I = I[5];
  assign O[5] = inst5_O;
  assign inst6_CLK = CLK;
  assign inst6_I = I[6];
  assign O[6] = inst6_O;
  assign inst7_CLK = CLK;
  assign inst7_I = I[7];
  assign O[7] = inst7_O;
  assign inst8_CLK = CLK;
  assign inst8_I = I[8];
  assign O[8] = inst8_O;
  assign inst9_CLK = CLK;
  assign inst9_I = I[9];
  assign O[9] = inst9_O;

endmodule //Register16

module Serializer4 (
  input  CLK,
  input [15:0] I_0,
  input [15:0] I_1,
  input [15:0] I_2,
  input [15:0] I_3,
  output [15:0] O
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

  //Wire declarations for instance 'inst0' (Module __silica_BufferSerializer4)
  wire [4:0] inst0_I;
  wire [4:0] inst0_O;
  __silica_BufferSerializer4 inst0(
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module Register5_0001)
  wire  inst1_CLK;
  wire [4:0] inst1_I;
  wire [4:0] inst1_O;
  Register5_0001 inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst10' (Module Register16)
  wire  inst10_CLK;
  wire [15:0] inst10_I;
  wire [15:0] inst10_O;
  Register16 inst10(
    .CLK(inst10_CLK),
    .I(inst10_I),
    .O(inst10_O)
  );

  //Wire declarations for instance 'inst11' (Module fold_or516)
  wire [15:0] inst11_I0;
  wire [15:0] inst11_I3;
  wire [15:0] inst11_O;
  wire [15:0] inst11_I4;
  wire [15:0] inst11_I2;
  wire [15:0] inst11_I1;
  fold_or516 inst11(
    .I0(inst11_I0),
    .I1(inst11_I1),
    .I2(inst11_I2),
    .I3(inst11_I3),
    .I4(inst11_I4),
    .O(inst11_O)
  );

  //Wire declarations for instance 'inst12' (Module fold_or516)
  wire [15:0] inst12_I0;
  wire [15:0] inst12_I3;
  wire [15:0] inst12_O;
  wire [15:0] inst12_I4;
  wire [15:0] inst12_I2;
  wire [15:0] inst12_I1;
  fold_or516 inst12(
    .I0(inst12_I0),
    .I1(inst12_I1),
    .I2(inst12_I2),
    .I3(inst12_I3),
    .I4(inst12_I4),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst13' (Module fold_or516)
  wire [15:0] inst13_I0;
  wire [15:0] inst13_I3;
  wire [15:0] inst13_O;
  wire [15:0] inst13_I4;
  wire [15:0] inst13_I2;
  wire [15:0] inst13_I1;
  fold_or516 inst13(
    .I0(inst13_I0),
    .I1(inst13_I1),
    .I2(inst13_I2),
    .I3(inst13_I3),
    .I4(inst13_I4),
    .O(inst13_O)
  );

  //Wire declarations for instance 'inst14' (Module and16_wrapped)
  wire [15:0] inst14_I0;
  wire [15:0] inst14_I1;
  wire [15:0] inst14_O;
  and16_wrapped inst14(
    .I0(inst14_I0),
    .I1(inst14_I1),
    .O(inst14_O)
  );

  //Wire declarations for instance 'inst15' (Module and16_wrapped)
  wire [15:0] inst15_I0;
  wire [15:0] inst15_I1;
  wire [15:0] inst15_O;
  and16_wrapped inst15(
    .I0(inst15_I0),
    .I1(inst15_I1),
    .O(inst15_O)
  );

  //Wire declarations for instance 'inst16' (Module and16_wrapped)
  wire [15:0] inst16_I0;
  wire [15:0] inst16_I1;
  wire [15:0] inst16_O;
  and16_wrapped inst16(
    .I0(inst16_I0),
    .I1(inst16_I1),
    .O(inst16_O)
  );

  //Wire declarations for instance 'inst17' (Module and16_wrapped)
  wire [15:0] inst17_I0;
  wire [15:0] inst17_I1;
  wire [15:0] inst17_O;
  and16_wrapped inst17(
    .I0(inst17_I0),
    .I1(inst17_I1),
    .O(inst17_O)
  );

  //Wire declarations for instance 'inst18' (Module and16_wrapped)
  wire [15:0] inst18_I0;
  wire [15:0] inst18_I1;
  wire [15:0] inst18_O;
  and16_wrapped inst18(
    .I0(inst18_I0),
    .I1(inst18_I1),
    .O(inst18_O)
  );

  //Wire declarations for instance 'inst19' (Module and16_wrapped)
  wire [15:0] inst19_I0;
  wire [15:0] inst19_I1;
  wire [15:0] inst19_O;
  and16_wrapped inst19(
    .I0(inst19_I0),
    .I1(inst19_I1),
    .O(inst19_O)
  );

  //Wire declarations for instance 'inst2' (Module fold_or55)
  wire [4:0] inst2_I0;
  wire [4:0] inst2_I3;
  wire [4:0] inst2_O;
  wire [4:0] inst2_I4;
  wire [4:0] inst2_I2;
  wire [4:0] inst2_I1;
  fold_or55 inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .I2(inst2_I2),
    .I3(inst2_I3),
    .I4(inst2_I4),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst20' (Module and16_wrapped)
  wire [15:0] inst20_I0;
  wire [15:0] inst20_I1;
  wire [15:0] inst20_O;
  and16_wrapped inst20(
    .I0(inst20_I0),
    .I1(inst20_I1),
    .O(inst20_O)
  );

  //Wire declarations for instance 'inst21' (Module and16_wrapped)
  wire [15:0] inst21_I0;
  wire [15:0] inst21_I1;
  wire [15:0] inst21_O;
  and16_wrapped inst21(
    .I0(inst21_I0),
    .I1(inst21_I1),
    .O(inst21_O)
  );

  //Wire declarations for instance 'inst22' (Module and16_wrapped)
  wire [15:0] inst22_I0;
  wire [15:0] inst22_I1;
  wire [15:0] inst22_O;
  and16_wrapped inst22(
    .I0(inst22_I0),
    .I1(inst22_I1),
    .O(inst22_O)
  );

  //Wire declarations for instance 'inst23' (Module and16_wrapped)
  wire [15:0] inst23_I0;
  wire [15:0] inst23_I1;
  wire [15:0] inst23_O;
  and16_wrapped inst23(
    .I0(inst23_I0),
    .I1(inst23_I1),
    .O(inst23_O)
  );

  //Wire declarations for instance 'inst24' (Module and16_wrapped)
  wire [15:0] inst24_I0;
  wire [15:0] inst24_I1;
  wire [15:0] inst24_O;
  and16_wrapped inst24(
    .I0(inst24_I0),
    .I1(inst24_I1),
    .O(inst24_O)
  );

  //Wire declarations for instance 'inst25' (Module and16_wrapped)
  wire [15:0] inst25_I0;
  wire [15:0] inst25_I1;
  wire [15:0] inst25_O;
  and16_wrapped inst25(
    .I0(inst25_I0),
    .I1(inst25_I1),
    .O(inst25_O)
  );

  //Wire declarations for instance 'inst26' (Module and16_wrapped)
  wire [15:0] inst26_I0;
  wire [15:0] inst26_I1;
  wire [15:0] inst26_O;
  and16_wrapped inst26(
    .I0(inst26_I0),
    .I1(inst26_I1),
    .O(inst26_O)
  );

  //Wire declarations for instance 'inst27' (Module and16_wrapped)
  wire [15:0] inst27_I0;
  wire [15:0] inst27_I1;
  wire [15:0] inst27_O;
  and16_wrapped inst27(
    .I0(inst27_I0),
    .I1(inst27_I1),
    .O(inst27_O)
  );

  //Wire declarations for instance 'inst28' (Module and16_wrapped)
  wire [15:0] inst28_I0;
  wire [15:0] inst28_I1;
  wire [15:0] inst28_O;
  and16_wrapped inst28(
    .I0(inst28_I0),
    .I1(inst28_I1),
    .O(inst28_O)
  );

  //Wire declarations for instance 'inst29' (Module fold_or516)
  wire [15:0] inst29_I0;
  wire [15:0] inst29_I3;
  wire [15:0] inst29_O;
  wire [15:0] inst29_I4;
  wire [15:0] inst29_I2;
  wire [15:0] inst29_I1;
  fold_or516 inst29(
    .I0(inst29_I0),
    .I1(inst29_I1),
    .I2(inst29_I2),
    .I3(inst29_I3),
    .I4(inst29_I4),
    .O(inst29_O)
  );

  //Wire declarations for instance 'inst3' (Module and5_wrapped)
  wire [4:0] inst3_I0;
  wire [4:0] inst3_I1;
  wire [4:0] inst3_O;
  and5_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst30' (Module and16_wrapped)
  wire [15:0] inst30_I0;
  wire [15:0] inst30_I1;
  wire [15:0] inst30_O;
  and16_wrapped inst30(
    .I0(inst30_I0),
    .I1(inst30_I1),
    .O(inst30_O)
  );

  //Wire declarations for instance 'inst31' (Module and16_wrapped)
  wire [15:0] inst31_I0;
  wire [15:0] inst31_I1;
  wire [15:0] inst31_O;
  and16_wrapped inst31(
    .I0(inst31_I0),
    .I1(inst31_I1),
    .O(inst31_O)
  );

  //Wire declarations for instance 'inst32' (Module and16_wrapped)
  wire [15:0] inst32_I0;
  wire [15:0] inst32_I1;
  wire [15:0] inst32_O;
  and16_wrapped inst32(
    .I0(inst32_I0),
    .I1(inst32_I1),
    .O(inst32_O)
  );

  //Wire declarations for instance 'inst33' (Module and16_wrapped)
  wire [15:0] inst33_I0;
  wire [15:0] inst33_I1;
  wire [15:0] inst33_O;
  and16_wrapped inst33(
    .I0(inst33_I0),
    .I1(inst33_I1),
    .O(inst33_O)
  );

  //Wire declarations for instance 'inst34' (Module and16_wrapped)
  wire [15:0] inst34_I0;
  wire [15:0] inst34_I1;
  wire [15:0] inst34_O;
  and16_wrapped inst34(
    .I0(inst34_I0),
    .I1(inst34_I1),
    .O(inst34_O)
  );

  //Wire declarations for instance 'inst4' (Module and5_wrapped)
  wire [4:0] inst4_I0;
  wire [4:0] inst4_I1;
  wire [4:0] inst4_O;
  and5_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module and5_wrapped)
  wire [4:0] inst5_I0;
  wire [4:0] inst5_I1;
  wire [4:0] inst5_O;
  and5_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module and5_wrapped)
  wire [4:0] inst6_I0;
  wire [4:0] inst6_I1;
  wire [4:0] inst6_O;
  and5_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module and5_wrapped)
  wire [4:0] inst7_I0;
  wire [4:0] inst7_I1;
  wire [4:0] inst7_O;
  and5_wrapped inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module Register16)
  wire  inst8_CLK;
  wire [15:0] inst8_I;
  wire [15:0] inst8_O;
  Register16 inst8(
    .CLK(inst8_CLK),
    .I(inst8_I),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst9' (Module Register16)
  wire  inst9_CLK;
  wire [15:0] inst9_I;
  wire [15:0] inst9_O;
  Register16 inst9(
    .CLK(inst9_CLK),
    .I(inst9_I),
    .O(inst9_O)
  );

  //All the connections
  assign inst3_I1[0] = bit_const_GND_out;
  assign inst3_I1[2] = bit_const_GND_out;
  assign inst3_I1[3] = bit_const_GND_out;
  assign inst3_I1[4] = bit_const_GND_out;
  assign inst4_I1[0] = bit_const_GND_out;
  assign inst4_I1[1] = bit_const_GND_out;
  assign inst4_I1[3] = bit_const_GND_out;
  assign inst4_I1[4] = bit_const_GND_out;
  assign inst5_I1[0] = bit_const_GND_out;
  assign inst5_I1[1] = bit_const_GND_out;
  assign inst5_I1[2] = bit_const_GND_out;
  assign inst5_I1[4] = bit_const_GND_out;
  assign inst6_I1[0] = bit_const_GND_out;
  assign inst6_I1[1] = bit_const_GND_out;
  assign inst6_I1[2] = bit_const_GND_out;
  assign inst6_I1[3] = bit_const_GND_out;
  assign inst7_I1[0] = bit_const_GND_out;
  assign inst7_I1[2] = bit_const_GND_out;
  assign inst7_I1[3] = bit_const_GND_out;
  assign inst7_I1[4] = bit_const_GND_out;
  assign inst3_I1[1] = bit_const_VCC_out;
  assign inst4_I1[2] = bit_const_VCC_out;
  assign inst5_I1[3] = bit_const_VCC_out;
  assign inst6_I1[4] = bit_const_VCC_out;
  assign inst7_I1[1] = bit_const_VCC_out;
  assign inst0_I[4:0] = inst1_O[4:0];
  assign inst1_CLK = CLK;
  assign inst1_I[4:0] = inst2_O[4:0];
  assign inst10_CLK = CLK;
  assign inst10_I[15:0] = inst13_O[15:0];
  assign inst19_I1[15:0] = inst10_O[15:0];
  assign inst22_I1[15:0] = inst10_O[15:0];
  assign inst25_I1[15:0] = inst10_O[15:0];
  assign inst33_I1[15:0] = inst10_O[15:0];
  assign inst11_I0[15:0] = inst14_O[15:0];
  assign inst11_I1[15:0] = inst17_O[15:0];
  assign inst11_I2[15:0] = inst20_O[15:0];
  assign inst11_I3[15:0] = inst23_O[15:0];
  assign inst11_I4[15:0] = inst26_O[15:0];
  assign inst8_I[15:0] = inst11_O[15:0];
  assign inst12_I0[15:0] = inst15_O[15:0];
  assign inst12_I1[15:0] = inst18_O[15:0];
  assign inst12_I2[15:0] = inst21_O[15:0];
  assign inst12_I3[15:0] = inst24_O[15:0];
  assign inst12_I4[15:0] = inst27_O[15:0];
  assign inst9_I[15:0] = inst12_O[15:0];
  assign inst13_I0[15:0] = inst16_O[15:0];
  assign inst13_I1[15:0] = inst19_O[15:0];
  assign inst13_I2[15:0] = inst22_O[15:0];
  assign inst13_I3[15:0] = inst25_O[15:0];
  assign inst13_I4[15:0] = inst28_O[15:0];
  assign inst14_I1[15:0] = I_1[15:0];
  assign inst15_I1[15:0] = I_2[15:0];
  assign inst16_I1[15:0] = I_3[15:0];
  assign inst17_I1[15:0] = inst8_O[15:0];
  assign inst18_I1[15:0] = inst9_O[15:0];
  assign inst2_I0[4:0] = inst3_O[4:0];
  assign inst2_I1[4:0] = inst4_O[4:0];
  assign inst2_I2[4:0] = inst5_O[4:0];
  assign inst2_I3[4:0] = inst6_O[4:0];
  assign inst2_I4[4:0] = inst7_O[4:0];
  assign inst20_I1[15:0] = inst8_O[15:0];
  assign inst21_I1[15:0] = inst9_O[15:0];
  assign inst23_I1[15:0] = inst8_O[15:0];
  assign inst24_I1[15:0] = inst9_O[15:0];
  assign inst26_I1[15:0] = I_1[15:0];
  assign inst27_I1[15:0] = I_2[15:0];
  assign inst28_I1[15:0] = I_3[15:0];
  assign inst29_I0[15:0] = inst30_O[15:0];
  assign inst29_I1[15:0] = inst31_O[15:0];
  assign inst29_I2[15:0] = inst32_O[15:0];
  assign inst29_I3[15:0] = inst33_O[15:0];
  assign inst29_I4[15:0] = inst34_O[15:0];
  assign O[15:0] = inst29_O[15:0];
  assign inst30_I1[15:0] = I_0[15:0];
  assign inst31_I1[15:0] = inst8_O[15:0];
  assign inst32_I1[15:0] = inst9_O[15:0];
  assign inst34_I1[15:0] = I_0[15:0];
  assign inst8_CLK = CLK;
  assign inst9_CLK = CLK;
  assign inst14_I0[0] = inst0_O[0];
  assign inst14_I0[1] = inst0_O[0];
  assign inst14_I0[10] = inst0_O[0];
  assign inst14_I0[11] = inst0_O[0];
  assign inst14_I0[12] = inst0_O[0];
  assign inst14_I0[13] = inst0_O[0];
  assign inst14_I0[14] = inst0_O[0];
  assign inst14_I0[15] = inst0_O[0];
  assign inst14_I0[2] = inst0_O[0];
  assign inst14_I0[3] = inst0_O[0];
  assign inst14_I0[4] = inst0_O[0];
  assign inst14_I0[5] = inst0_O[0];
  assign inst14_I0[6] = inst0_O[0];
  assign inst14_I0[7] = inst0_O[0];
  assign inst14_I0[8] = inst0_O[0];
  assign inst14_I0[9] = inst0_O[0];
  assign inst15_I0[0] = inst0_O[0];
  assign inst15_I0[1] = inst0_O[0];
  assign inst15_I0[10] = inst0_O[0];
  assign inst15_I0[11] = inst0_O[0];
  assign inst15_I0[12] = inst0_O[0];
  assign inst15_I0[13] = inst0_O[0];
  assign inst15_I0[14] = inst0_O[0];
  assign inst15_I0[15] = inst0_O[0];
  assign inst15_I0[2] = inst0_O[0];
  assign inst15_I0[3] = inst0_O[0];
  assign inst15_I0[4] = inst0_O[0];
  assign inst15_I0[5] = inst0_O[0];
  assign inst15_I0[6] = inst0_O[0];
  assign inst15_I0[7] = inst0_O[0];
  assign inst15_I0[8] = inst0_O[0];
  assign inst15_I0[9] = inst0_O[0];
  assign inst16_I0[0] = inst0_O[0];
  assign inst16_I0[1] = inst0_O[0];
  assign inst16_I0[10] = inst0_O[0];
  assign inst16_I0[11] = inst0_O[0];
  assign inst16_I0[12] = inst0_O[0];
  assign inst16_I0[13] = inst0_O[0];
  assign inst16_I0[14] = inst0_O[0];
  assign inst16_I0[15] = inst0_O[0];
  assign inst16_I0[2] = inst0_O[0];
  assign inst16_I0[3] = inst0_O[0];
  assign inst16_I0[4] = inst0_O[0];
  assign inst16_I0[5] = inst0_O[0];
  assign inst16_I0[6] = inst0_O[0];
  assign inst16_I0[7] = inst0_O[0];
  assign inst16_I0[8] = inst0_O[0];
  assign inst16_I0[9] = inst0_O[0];
  assign inst3_I0[0] = inst0_O[0];
  assign inst3_I0[1] = inst0_O[0];
  assign inst3_I0[2] = inst0_O[0];
  assign inst3_I0[3] = inst0_O[0];
  assign inst3_I0[4] = inst0_O[0];
  assign inst30_I0[0] = inst0_O[0];
  assign inst30_I0[1] = inst0_O[0];
  assign inst30_I0[10] = inst0_O[0];
  assign inst30_I0[11] = inst0_O[0];
  assign inst30_I0[12] = inst0_O[0];
  assign inst30_I0[13] = inst0_O[0];
  assign inst30_I0[14] = inst0_O[0];
  assign inst30_I0[15] = inst0_O[0];
  assign inst30_I0[2] = inst0_O[0];
  assign inst30_I0[3] = inst0_O[0];
  assign inst30_I0[4] = inst0_O[0];
  assign inst30_I0[5] = inst0_O[0];
  assign inst30_I0[6] = inst0_O[0];
  assign inst30_I0[7] = inst0_O[0];
  assign inst30_I0[8] = inst0_O[0];
  assign inst30_I0[9] = inst0_O[0];
  assign inst17_I0[0] = inst0_O[1];
  assign inst17_I0[1] = inst0_O[1];
  assign inst17_I0[10] = inst0_O[1];
  assign inst17_I0[11] = inst0_O[1];
  assign inst17_I0[12] = inst0_O[1];
  assign inst17_I0[13] = inst0_O[1];
  assign inst17_I0[14] = inst0_O[1];
  assign inst17_I0[15] = inst0_O[1];
  assign inst17_I0[2] = inst0_O[1];
  assign inst17_I0[3] = inst0_O[1];
  assign inst17_I0[4] = inst0_O[1];
  assign inst17_I0[5] = inst0_O[1];
  assign inst17_I0[6] = inst0_O[1];
  assign inst17_I0[7] = inst0_O[1];
  assign inst17_I0[8] = inst0_O[1];
  assign inst17_I0[9] = inst0_O[1];
  assign inst18_I0[0] = inst0_O[1];
  assign inst18_I0[1] = inst0_O[1];
  assign inst18_I0[10] = inst0_O[1];
  assign inst18_I0[11] = inst0_O[1];
  assign inst18_I0[12] = inst0_O[1];
  assign inst18_I0[13] = inst0_O[1];
  assign inst18_I0[14] = inst0_O[1];
  assign inst18_I0[15] = inst0_O[1];
  assign inst18_I0[2] = inst0_O[1];
  assign inst18_I0[3] = inst0_O[1];
  assign inst18_I0[4] = inst0_O[1];
  assign inst18_I0[5] = inst0_O[1];
  assign inst18_I0[6] = inst0_O[1];
  assign inst18_I0[7] = inst0_O[1];
  assign inst18_I0[8] = inst0_O[1];
  assign inst18_I0[9] = inst0_O[1];
  assign inst19_I0[0] = inst0_O[1];
  assign inst19_I0[1] = inst0_O[1];
  assign inst19_I0[10] = inst0_O[1];
  assign inst19_I0[11] = inst0_O[1];
  assign inst19_I0[12] = inst0_O[1];
  assign inst19_I0[13] = inst0_O[1];
  assign inst19_I0[14] = inst0_O[1];
  assign inst19_I0[15] = inst0_O[1];
  assign inst19_I0[2] = inst0_O[1];
  assign inst19_I0[3] = inst0_O[1];
  assign inst19_I0[4] = inst0_O[1];
  assign inst19_I0[5] = inst0_O[1];
  assign inst19_I0[6] = inst0_O[1];
  assign inst19_I0[7] = inst0_O[1];
  assign inst19_I0[8] = inst0_O[1];
  assign inst19_I0[9] = inst0_O[1];
  assign inst31_I0[0] = inst0_O[1];
  assign inst31_I0[1] = inst0_O[1];
  assign inst31_I0[10] = inst0_O[1];
  assign inst31_I0[11] = inst0_O[1];
  assign inst31_I0[12] = inst0_O[1];
  assign inst31_I0[13] = inst0_O[1];
  assign inst31_I0[14] = inst0_O[1];
  assign inst31_I0[15] = inst0_O[1];
  assign inst31_I0[2] = inst0_O[1];
  assign inst31_I0[3] = inst0_O[1];
  assign inst31_I0[4] = inst0_O[1];
  assign inst31_I0[5] = inst0_O[1];
  assign inst31_I0[6] = inst0_O[1];
  assign inst31_I0[7] = inst0_O[1];
  assign inst31_I0[8] = inst0_O[1];
  assign inst31_I0[9] = inst0_O[1];
  assign inst4_I0[0] = inst0_O[1];
  assign inst4_I0[1] = inst0_O[1];
  assign inst4_I0[2] = inst0_O[1];
  assign inst4_I0[3] = inst0_O[1];
  assign inst4_I0[4] = inst0_O[1];
  assign inst20_I0[0] = inst0_O[2];
  assign inst20_I0[1] = inst0_O[2];
  assign inst20_I0[10] = inst0_O[2];
  assign inst20_I0[11] = inst0_O[2];
  assign inst20_I0[12] = inst0_O[2];
  assign inst20_I0[13] = inst0_O[2];
  assign inst20_I0[14] = inst0_O[2];
  assign inst20_I0[15] = inst0_O[2];
  assign inst20_I0[2] = inst0_O[2];
  assign inst20_I0[3] = inst0_O[2];
  assign inst20_I0[4] = inst0_O[2];
  assign inst20_I0[5] = inst0_O[2];
  assign inst20_I0[6] = inst0_O[2];
  assign inst20_I0[7] = inst0_O[2];
  assign inst20_I0[8] = inst0_O[2];
  assign inst20_I0[9] = inst0_O[2];
  assign inst21_I0[0] = inst0_O[2];
  assign inst21_I0[1] = inst0_O[2];
  assign inst21_I0[10] = inst0_O[2];
  assign inst21_I0[11] = inst0_O[2];
  assign inst21_I0[12] = inst0_O[2];
  assign inst21_I0[13] = inst0_O[2];
  assign inst21_I0[14] = inst0_O[2];
  assign inst21_I0[15] = inst0_O[2];
  assign inst21_I0[2] = inst0_O[2];
  assign inst21_I0[3] = inst0_O[2];
  assign inst21_I0[4] = inst0_O[2];
  assign inst21_I0[5] = inst0_O[2];
  assign inst21_I0[6] = inst0_O[2];
  assign inst21_I0[7] = inst0_O[2];
  assign inst21_I0[8] = inst0_O[2];
  assign inst21_I0[9] = inst0_O[2];
  assign inst22_I0[0] = inst0_O[2];
  assign inst22_I0[1] = inst0_O[2];
  assign inst22_I0[10] = inst0_O[2];
  assign inst22_I0[11] = inst0_O[2];
  assign inst22_I0[12] = inst0_O[2];
  assign inst22_I0[13] = inst0_O[2];
  assign inst22_I0[14] = inst0_O[2];
  assign inst22_I0[15] = inst0_O[2];
  assign inst22_I0[2] = inst0_O[2];
  assign inst22_I0[3] = inst0_O[2];
  assign inst22_I0[4] = inst0_O[2];
  assign inst22_I0[5] = inst0_O[2];
  assign inst22_I0[6] = inst0_O[2];
  assign inst22_I0[7] = inst0_O[2];
  assign inst22_I0[8] = inst0_O[2];
  assign inst22_I0[9] = inst0_O[2];
  assign inst32_I0[0] = inst0_O[2];
  assign inst32_I0[1] = inst0_O[2];
  assign inst32_I0[10] = inst0_O[2];
  assign inst32_I0[11] = inst0_O[2];
  assign inst32_I0[12] = inst0_O[2];
  assign inst32_I0[13] = inst0_O[2];
  assign inst32_I0[14] = inst0_O[2];
  assign inst32_I0[15] = inst0_O[2];
  assign inst32_I0[2] = inst0_O[2];
  assign inst32_I0[3] = inst0_O[2];
  assign inst32_I0[4] = inst0_O[2];
  assign inst32_I0[5] = inst0_O[2];
  assign inst32_I0[6] = inst0_O[2];
  assign inst32_I0[7] = inst0_O[2];
  assign inst32_I0[8] = inst0_O[2];
  assign inst32_I0[9] = inst0_O[2];
  assign inst5_I0[0] = inst0_O[2];
  assign inst5_I0[1] = inst0_O[2];
  assign inst5_I0[2] = inst0_O[2];
  assign inst5_I0[3] = inst0_O[2];
  assign inst5_I0[4] = inst0_O[2];
  assign inst23_I0[0] = inst0_O[3];
  assign inst23_I0[1] = inst0_O[3];
  assign inst23_I0[10] = inst0_O[3];
  assign inst23_I0[11] = inst0_O[3];
  assign inst23_I0[12] = inst0_O[3];
  assign inst23_I0[13] = inst0_O[3];
  assign inst23_I0[14] = inst0_O[3];
  assign inst23_I0[15] = inst0_O[3];
  assign inst23_I0[2] = inst0_O[3];
  assign inst23_I0[3] = inst0_O[3];
  assign inst23_I0[4] = inst0_O[3];
  assign inst23_I0[5] = inst0_O[3];
  assign inst23_I0[6] = inst0_O[3];
  assign inst23_I0[7] = inst0_O[3];
  assign inst23_I0[8] = inst0_O[3];
  assign inst23_I0[9] = inst0_O[3];
  assign inst24_I0[0] = inst0_O[3];
  assign inst24_I0[1] = inst0_O[3];
  assign inst24_I0[10] = inst0_O[3];
  assign inst24_I0[11] = inst0_O[3];
  assign inst24_I0[12] = inst0_O[3];
  assign inst24_I0[13] = inst0_O[3];
  assign inst24_I0[14] = inst0_O[3];
  assign inst24_I0[15] = inst0_O[3];
  assign inst24_I0[2] = inst0_O[3];
  assign inst24_I0[3] = inst0_O[3];
  assign inst24_I0[4] = inst0_O[3];
  assign inst24_I0[5] = inst0_O[3];
  assign inst24_I0[6] = inst0_O[3];
  assign inst24_I0[7] = inst0_O[3];
  assign inst24_I0[8] = inst0_O[3];
  assign inst24_I0[9] = inst0_O[3];
  assign inst25_I0[0] = inst0_O[3];
  assign inst25_I0[1] = inst0_O[3];
  assign inst25_I0[10] = inst0_O[3];
  assign inst25_I0[11] = inst0_O[3];
  assign inst25_I0[12] = inst0_O[3];
  assign inst25_I0[13] = inst0_O[3];
  assign inst25_I0[14] = inst0_O[3];
  assign inst25_I0[15] = inst0_O[3];
  assign inst25_I0[2] = inst0_O[3];
  assign inst25_I0[3] = inst0_O[3];
  assign inst25_I0[4] = inst0_O[3];
  assign inst25_I0[5] = inst0_O[3];
  assign inst25_I0[6] = inst0_O[3];
  assign inst25_I0[7] = inst0_O[3];
  assign inst25_I0[8] = inst0_O[3];
  assign inst25_I0[9] = inst0_O[3];
  assign inst33_I0[0] = inst0_O[3];
  assign inst33_I0[1] = inst0_O[3];
  assign inst33_I0[10] = inst0_O[3];
  assign inst33_I0[11] = inst0_O[3];
  assign inst33_I0[12] = inst0_O[3];
  assign inst33_I0[13] = inst0_O[3];
  assign inst33_I0[14] = inst0_O[3];
  assign inst33_I0[15] = inst0_O[3];
  assign inst33_I0[2] = inst0_O[3];
  assign inst33_I0[3] = inst0_O[3];
  assign inst33_I0[4] = inst0_O[3];
  assign inst33_I0[5] = inst0_O[3];
  assign inst33_I0[6] = inst0_O[3];
  assign inst33_I0[7] = inst0_O[3];
  assign inst33_I0[8] = inst0_O[3];
  assign inst33_I0[9] = inst0_O[3];
  assign inst6_I0[0] = inst0_O[3];
  assign inst6_I0[1] = inst0_O[3];
  assign inst6_I0[2] = inst0_O[3];
  assign inst6_I0[3] = inst0_O[3];
  assign inst6_I0[4] = inst0_O[3];
  assign inst26_I0[0] = inst0_O[4];
  assign inst26_I0[1] = inst0_O[4];
  assign inst26_I0[10] = inst0_O[4];
  assign inst26_I0[11] = inst0_O[4];
  assign inst26_I0[12] = inst0_O[4];
  assign inst26_I0[13] = inst0_O[4];
  assign inst26_I0[14] = inst0_O[4];
  assign inst26_I0[15] = inst0_O[4];
  assign inst26_I0[2] = inst0_O[4];
  assign inst26_I0[3] = inst0_O[4];
  assign inst26_I0[4] = inst0_O[4];
  assign inst26_I0[5] = inst0_O[4];
  assign inst26_I0[6] = inst0_O[4];
  assign inst26_I0[7] = inst0_O[4];
  assign inst26_I0[8] = inst0_O[4];
  assign inst26_I0[9] = inst0_O[4];
  assign inst27_I0[0] = inst0_O[4];
  assign inst27_I0[1] = inst0_O[4];
  assign inst27_I0[10] = inst0_O[4];
  assign inst27_I0[11] = inst0_O[4];
  assign inst27_I0[12] = inst0_O[4];
  assign inst27_I0[13] = inst0_O[4];
  assign inst27_I0[14] = inst0_O[4];
  assign inst27_I0[15] = inst0_O[4];
  assign inst27_I0[2] = inst0_O[4];
  assign inst27_I0[3] = inst0_O[4];
  assign inst27_I0[4] = inst0_O[4];
  assign inst27_I0[5] = inst0_O[4];
  assign inst27_I0[6] = inst0_O[4];
  assign inst27_I0[7] = inst0_O[4];
  assign inst27_I0[8] = inst0_O[4];
  assign inst27_I0[9] = inst0_O[4];
  assign inst28_I0[0] = inst0_O[4];
  assign inst28_I0[1] = inst0_O[4];
  assign inst28_I0[10] = inst0_O[4];
  assign inst28_I0[11] = inst0_O[4];
  assign inst28_I0[12] = inst0_O[4];
  assign inst28_I0[13] = inst0_O[4];
  assign inst28_I0[14] = inst0_O[4];
  assign inst28_I0[15] = inst0_O[4];
  assign inst28_I0[2] = inst0_O[4];
  assign inst28_I0[3] = inst0_O[4];
  assign inst28_I0[4] = inst0_O[4];
  assign inst28_I0[5] = inst0_O[4];
  assign inst28_I0[6] = inst0_O[4];
  assign inst28_I0[7] = inst0_O[4];
  assign inst28_I0[8] = inst0_O[4];
  assign inst28_I0[9] = inst0_O[4];
  assign inst34_I0[0] = inst0_O[4];
  assign inst34_I0[1] = inst0_O[4];
  assign inst34_I0[10] = inst0_O[4];
  assign inst34_I0[11] = inst0_O[4];
  assign inst34_I0[12] = inst0_O[4];
  assign inst34_I0[13] = inst0_O[4];
  assign inst34_I0[14] = inst0_O[4];
  assign inst34_I0[15] = inst0_O[4];
  assign inst34_I0[2] = inst0_O[4];
  assign inst34_I0[3] = inst0_O[4];
  assign inst34_I0[4] = inst0_O[4];
  assign inst34_I0[5] = inst0_O[4];
  assign inst34_I0[6] = inst0_O[4];
  assign inst34_I0[7] = inst0_O[4];
  assign inst34_I0[8] = inst0_O[4];
  assign inst34_I0[9] = inst0_O[4];
  assign inst7_I0[0] = inst0_O[4];
  assign inst7_I0[1] = inst0_O[4];
  assign inst7_I0[2] = inst0_O[4];
  assign inst7_I0[3] = inst0_O[4];
  assign inst7_I0[4] = inst0_O[4];

endmodule //Serializer4
