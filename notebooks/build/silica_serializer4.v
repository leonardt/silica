

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module corebit_or (
  input in0,
  input in1,
  output out
);
  assign out = in0 | in1;

endmodule //corebit_or

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

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

module Or4x16 (
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [3:0] inst0_in;
  wire  inst0_out;
  coreir_orr #(.width(4)) inst0(
    .in(inst0_in),
    .out(inst0_out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [3:0] inst1_in;
  wire  inst1_out;
  coreir_orr #(.width(4)) inst1(
    .in(inst1_in),
    .out(inst1_out)
  );

  //Wire declarations for instance 'inst10' (Module coreir_orr)
  wire [3:0] inst10_in;
  wire  inst10_out;
  coreir_orr #(.width(4)) inst10(
    .in(inst10_in),
    .out(inst10_out)
  );

  //Wire declarations for instance 'inst11' (Module coreir_orr)
  wire [3:0] inst11_in;
  wire  inst11_out;
  coreir_orr #(.width(4)) inst11(
    .in(inst11_in),
    .out(inst11_out)
  );

  //Wire declarations for instance 'inst12' (Module coreir_orr)
  wire [3:0] inst12_in;
  wire  inst12_out;
  coreir_orr #(.width(4)) inst12(
    .in(inst12_in),
    .out(inst12_out)
  );

  //Wire declarations for instance 'inst13' (Module coreir_orr)
  wire [3:0] inst13_in;
  wire  inst13_out;
  coreir_orr #(.width(4)) inst13(
    .in(inst13_in),
    .out(inst13_out)
  );

  //Wire declarations for instance 'inst14' (Module coreir_orr)
  wire [3:0] inst14_in;
  wire  inst14_out;
  coreir_orr #(.width(4)) inst14(
    .in(inst14_in),
    .out(inst14_out)
  );

  //Wire declarations for instance 'inst15' (Module coreir_orr)
  wire [3:0] inst15_in;
  wire  inst15_out;
  coreir_orr #(.width(4)) inst15(
    .in(inst15_in),
    .out(inst15_out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [3:0] inst2_in;
  wire  inst2_out;
  coreir_orr #(.width(4)) inst2(
    .in(inst2_in),
    .out(inst2_out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [3:0] inst3_in;
  wire  inst3_out;
  coreir_orr #(.width(4)) inst3(
    .in(inst3_in),
    .out(inst3_out)
  );

  //Wire declarations for instance 'inst4' (Module coreir_orr)
  wire [3:0] inst4_in;
  wire  inst4_out;
  coreir_orr #(.width(4)) inst4(
    .in(inst4_in),
    .out(inst4_out)
  );

  //Wire declarations for instance 'inst5' (Module coreir_orr)
  wire [3:0] inst5_in;
  wire  inst5_out;
  coreir_orr #(.width(4)) inst5(
    .in(inst5_in),
    .out(inst5_out)
  );

  //Wire declarations for instance 'inst6' (Module coreir_orr)
  wire [3:0] inst6_in;
  wire  inst6_out;
  coreir_orr #(.width(4)) inst6(
    .in(inst6_in),
    .out(inst6_out)
  );

  //Wire declarations for instance 'inst7' (Module coreir_orr)
  wire [3:0] inst7_in;
  wire  inst7_out;
  coreir_orr #(.width(4)) inst7(
    .in(inst7_in),
    .out(inst7_out)
  );

  //Wire declarations for instance 'inst8' (Module coreir_orr)
  wire [3:0] inst8_in;
  wire  inst8_out;
  coreir_orr #(.width(4)) inst8(
    .in(inst8_in),
    .out(inst8_out)
  );

  //Wire declarations for instance 'inst9' (Module coreir_orr)
  wire [3:0] inst9_in;
  wire  inst9_out;
  coreir_orr #(.width(4)) inst9(
    .in(inst9_in),
    .out(inst9_out)
  );

  //All the connections
  assign O[0] = inst0_out;
  assign O[1] = inst1_out;
  assign O[10] = inst10_out;
  assign O[11] = inst11_out;
  assign O[12] = inst12_out;
  assign O[13] = inst13_out;
  assign O[14] = inst14_out;
  assign O[15] = inst15_out;
  assign O[2] = inst2_out;
  assign O[3] = inst3_out;
  assign O[4] = inst4_out;
  assign O[5] = inst5_out;
  assign O[6] = inst6_out;
  assign O[7] = inst7_out;
  assign O[8] = inst8_out;
  assign O[9] = inst9_out;
  assign inst0_in[0] = I0[0];
  assign inst0_in[1] = I1[0];
  assign inst0_in[2] = I2[0];
  assign inst0_in[3] = I3[0];
  assign inst1_in[0] = I0[1];
  assign inst1_in[1] = I1[1];
  assign inst1_in[2] = I2[1];
  assign inst1_in[3] = I3[1];
  assign inst10_in[0] = I0[10];
  assign inst10_in[1] = I1[10];
  assign inst10_in[2] = I2[10];
  assign inst10_in[3] = I3[10];
  assign inst11_in[0] = I0[11];
  assign inst11_in[1] = I1[11];
  assign inst11_in[2] = I2[11];
  assign inst11_in[3] = I3[11];
  assign inst12_in[0] = I0[12];
  assign inst12_in[1] = I1[12];
  assign inst12_in[2] = I2[12];
  assign inst12_in[3] = I3[12];
  assign inst13_in[0] = I0[13];
  assign inst13_in[1] = I1[13];
  assign inst13_in[2] = I2[13];
  assign inst13_in[3] = I3[13];
  assign inst14_in[0] = I0[14];
  assign inst14_in[1] = I1[14];
  assign inst14_in[2] = I2[14];
  assign inst14_in[3] = I3[14];
  assign inst15_in[0] = I0[15];
  assign inst15_in[1] = I1[15];
  assign inst15_in[2] = I2[15];
  assign inst15_in[3] = I3[15];
  assign inst2_in[0] = I0[2];
  assign inst2_in[1] = I1[2];
  assign inst2_in[2] = I2[2];
  assign inst2_in[3] = I3[2];
  assign inst3_in[0] = I0[3];
  assign inst3_in[1] = I1[3];
  assign inst3_in[2] = I2[3];
  assign inst3_in[3] = I3[3];
  assign inst4_in[0] = I0[4];
  assign inst4_in[1] = I1[4];
  assign inst4_in[2] = I2[4];
  assign inst4_in[3] = I3[4];
  assign inst5_in[0] = I0[5];
  assign inst5_in[1] = I1[5];
  assign inst5_in[2] = I2[5];
  assign inst5_in[3] = I3[5];
  assign inst6_in[0] = I0[6];
  assign inst6_in[1] = I1[6];
  assign inst6_in[2] = I2[6];
  assign inst6_in[3] = I3[6];
  assign inst7_in[0] = I0[7];
  assign inst7_in[1] = I1[7];
  assign inst7_in[2] = I2[7];
  assign inst7_in[3] = I3[7];
  assign inst8_in[0] = I0[8];
  assign inst8_in[1] = I1[8];
  assign inst8_in[2] = I2[8];
  assign inst8_in[3] = I3[8];
  assign inst9_in[0] = I0[9];
  assign inst9_in[1] = I1[9];
  assign inst9_in[2] = I2[9];
  assign inst9_in[3] = I3[9];

endmodule //Or4x16

module __silica_BufferSerializer4 (
  input [3:0] I,
  output [3:0] O
);
  //All the connections
  assign O[3:0] = I[3:0];

endmodule //__silica_BufferSerializer4

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

module SilicaOneHotMux416 (
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  output [15:0] O,
  input [3:0] S
);
  //Wire declarations for instance 'inst0' (Module Or4x16)
  wire [15:0] inst0_I0;
  wire [15:0] inst0_I1;
  wire [15:0] inst0_I2;
  wire [15:0] inst0_I3;
  wire [15:0] inst0_O;
  Or4x16 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module and16_wrapped)
  wire [15:0] inst1_I0;
  wire [15:0] inst1_I1;
  wire [15:0] inst1_O;
  and16_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module and16_wrapped)
  wire [15:0] inst2_I0;
  wire [15:0] inst2_I1;
  wire [15:0] inst2_O;
  and16_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module and16_wrapped)
  wire [15:0] inst3_I0;
  wire [15:0] inst3_I1;
  wire [15:0] inst3_O;
  and16_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module and16_wrapped)
  wire [15:0] inst4_I0;
  wire [15:0] inst4_I1;
  wire [15:0] inst4_O;
  and16_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //All the connections
  assign inst0_I0[15:0] = inst1_O[15:0];
  assign inst0_I1[15:0] = inst2_O[15:0];
  assign inst0_I2[15:0] = inst3_O[15:0];
  assign inst0_I3[15:0] = inst4_O[15:0];
  assign O[15:0] = inst0_O[15:0];
  assign inst1_I0[15:0] = I0[15:0];
  assign inst2_I0[15:0] = I1[15:0];
  assign inst3_I0[15:0] = I2[15:0];
  assign inst4_I0[15:0] = I3[15:0];
  assign inst1_I1[0] = S[0];
  assign inst1_I1[1] = S[0];
  assign inst1_I1[10] = S[0];
  assign inst1_I1[11] = S[0];
  assign inst1_I1[12] = S[0];
  assign inst1_I1[13] = S[0];
  assign inst1_I1[14] = S[0];
  assign inst1_I1[15] = S[0];
  assign inst1_I1[2] = S[0];
  assign inst1_I1[3] = S[0];
  assign inst1_I1[4] = S[0];
  assign inst1_I1[5] = S[0];
  assign inst1_I1[6] = S[0];
  assign inst1_I1[7] = S[0];
  assign inst1_I1[8] = S[0];
  assign inst1_I1[9] = S[0];
  assign inst2_I1[0] = S[1];
  assign inst2_I1[1] = S[1];
  assign inst2_I1[10] = S[1];
  assign inst2_I1[11] = S[1];
  assign inst2_I1[12] = S[1];
  assign inst2_I1[13] = S[1];
  assign inst2_I1[14] = S[1];
  assign inst2_I1[15] = S[1];
  assign inst2_I1[2] = S[1];
  assign inst2_I1[3] = S[1];
  assign inst2_I1[4] = S[1];
  assign inst2_I1[5] = S[1];
  assign inst2_I1[6] = S[1];
  assign inst2_I1[7] = S[1];
  assign inst2_I1[8] = S[1];
  assign inst2_I1[9] = S[1];
  assign inst3_I1[0] = S[2];
  assign inst3_I1[1] = S[2];
  assign inst3_I1[10] = S[2];
  assign inst3_I1[11] = S[2];
  assign inst3_I1[12] = S[2];
  assign inst3_I1[13] = S[2];
  assign inst3_I1[14] = S[2];
  assign inst3_I1[15] = S[2];
  assign inst3_I1[2] = S[2];
  assign inst3_I1[3] = S[2];
  assign inst3_I1[4] = S[2];
  assign inst3_I1[5] = S[2];
  assign inst3_I1[6] = S[2];
  assign inst3_I1[7] = S[2];
  assign inst3_I1[8] = S[2];
  assign inst3_I1[9] = S[2];
  assign inst4_I1[0] = S[3];
  assign inst4_I1[1] = S[3];
  assign inst4_I1[10] = S[3];
  assign inst4_I1[11] = S[3];
  assign inst4_I1[12] = S[3];
  assign inst4_I1[13] = S[3];
  assign inst4_I1[14] = S[3];
  assign inst4_I1[15] = S[3];
  assign inst4_I1[2] = S[3];
  assign inst4_I1[3] = S[3];
  assign inst4_I1[4] = S[3];
  assign inst4_I1[5] = S[3];
  assign inst4_I1[6] = S[3];
  assign inst4_I1[7] = S[3];
  assign inst4_I1[8] = S[3];
  assign inst4_I1[9] = S[3];

endmodule //SilicaOneHotMux416

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

  //Wire declarations for instance 'inst0' (Module __silica_BufferSerializer4)
  wire [3:0] inst0_I;
  wire [3:0] inst0_O;
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

  //Wire declarations for instance 'inst10' (Module or_wrapped)
  wire  inst10_I0;
  wire  inst10_I1;
  wire  inst10_O;
  or_wrapped inst10(
    .I0(inst10_I0),
    .I1(inst10_I1),
    .O(inst10_O)
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

  //Wire declarations for instance 'inst3' (Module Register16)
  wire  inst3_CLK;
  wire [15:0] inst3_I;
  wire [15:0] inst3_O;
  Register16 inst3(
    .CLK(inst3_CLK),
    .I(inst3_I),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module Register16)
  wire  inst4_CLK;
  wire [15:0] inst4_I;
  wire [15:0] inst4_O;
  Register16 inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module Register16)
  wire  inst5_CLK;
  wire [15:0] inst5_I;
  wire [15:0] inst5_O;
  Register16 inst5(
    .CLK(inst5_CLK),
    .I(inst5_I),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module SilicaOneHotMux416)
  wire [15:0] inst6_I0;
  wire [15:0] inst6_I1;
  wire [15:0] inst6_I2;
  wire [15:0] inst6_I3;
  wire [15:0] inst6_O;
  wire [3:0] inst6_S;
  SilicaOneHotMux416 inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .I2(inst6_I2),
    .I3(inst6_I3),
    .O(inst6_O),
    .S(inst6_S)
  );

  //Wire declarations for instance 'inst7' (Module SilicaOneHotMux416)
  wire [15:0] inst7_I0;
  wire [15:0] inst7_I1;
  wire [15:0] inst7_I2;
  wire [15:0] inst7_I3;
  wire [15:0] inst7_O;
  wire [3:0] inst7_S;
  SilicaOneHotMux416 inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .I2(inst7_I2),
    .I3(inst7_I3),
    .O(inst7_O),
    .S(inst7_S)
  );

  //Wire declarations for instance 'inst8' (Module SilicaOneHotMux416)
  wire [15:0] inst8_I0;
  wire [15:0] inst8_I1;
  wire [15:0] inst8_I2;
  wire [15:0] inst8_I3;
  wire [15:0] inst8_O;
  wire [3:0] inst8_S;
  SilicaOneHotMux416 inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .I2(inst8_I2),
    .I3(inst8_I3),
    .O(inst8_O),
    .S(inst8_S)
  );

  //Wire declarations for instance 'inst9' (Module SilicaOneHotMux416)
  wire [15:0] inst9_I0;
  wire [15:0] inst9_I1;
  wire [15:0] inst9_I2;
  wire [15:0] inst9_I3;
  wire [15:0] inst9_O;
  wire [3:0] inst9_S;
  SilicaOneHotMux416 inst9(
    .I0(inst9_I0),
    .I1(inst9_I1),
    .I2(inst9_I2),
    .I3(inst9_I3),
    .O(inst9_O),
    .S(inst9_S)
  );

  //All the connections
  assign inst1_I[0] = bit_const_GND_out;
  assign inst6_S[3:0] = inst0_O[3:0];
  assign inst7_S[3:0] = inst0_O[3:0];
  assign inst8_S[3:0] = inst0_O[3:0];
  assign inst9_S[3:0] = inst0_O[3:0];
  assign inst1_CLK = CLK;
  assign inst10_I0 = inst1_O[0];
  assign inst10_I1 = inst1_O[4];
  assign inst0_I[0] = inst10_O;
  assign inst2_I0 = inst1_O[0];
  assign inst2_I1 = inst1_O[4];
  assign inst1_I[1] = inst2_O;
  assign inst3_CLK = CLK;
  assign inst3_I[15:0] = inst6_O[15:0];
  assign inst6_I1[15:0] = inst3_O[15:0];
  assign inst6_I2[15:0] = inst3_O[15:0];
  assign inst6_I3[15:0] = inst3_O[15:0];
  assign inst9_I1[15:0] = inst3_O[15:0];
  assign inst4_CLK = CLK;
  assign inst4_I[15:0] = inst7_O[15:0];
  assign inst7_I1[15:0] = inst4_O[15:0];
  assign inst7_I2[15:0] = inst4_O[15:0];
  assign inst7_I3[15:0] = inst4_O[15:0];
  assign inst9_I2[15:0] = inst4_O[15:0];
  assign inst5_CLK = CLK;
  assign inst5_I[15:0] = inst8_O[15:0];
  assign inst8_I1[15:0] = inst5_O[15:0];
  assign inst8_I2[15:0] = inst5_O[15:0];
  assign inst8_I3[15:0] = inst5_O[15:0];
  assign inst9_I3[15:0] = inst5_O[15:0];
  assign inst6_I0[15:0] = I_1[15:0];
  assign inst7_I0[15:0] = I_2[15:0];
  assign inst8_I0[15:0] = I_3[15:0];
  assign inst9_I0[15:0] = I_0[15:0];
  assign O[15:0] = inst9_O[15:0];
  assign inst0_I[1] = inst1_O[1];
  assign inst0_I[2] = inst1_O[2];
  assign inst0_I[3] = inst1_O[3];
  assign inst1_I[2] = inst1_O[1];
  assign inst1_I[3] = inst1_O[2];
  assign inst1_I[4] = inst1_O[3];

endmodule //Serializer4
