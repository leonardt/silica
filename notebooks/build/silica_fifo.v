

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

module corebit_mux (
  input in0,
  input in1,
  input sel,
  output out
);
  assign out = sel ? in1 : in0;

endmodule //corebit_mux

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

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

module coreir_andr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = &in;

endmodule //coreir_andr

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

module And3xNone (
  input  I0,
  input  I1,
  input  I2,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_andr)
  wire [2:0] inst0_in;
  wire  inst0_out;
  coreir_andr #(.width(3)) inst0(
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign O = inst0_out;
  assign inst0_in[0] = I0;
  assign inst0_in[1] = I1;
  assign inst0_in[2] = I2;

endmodule //And3xNone

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

module Decode22 (
  input [1:0] I,
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

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I1;
  wire  inst0_O;
  EQ2 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //All the connections
  assign inst0_I1[0] = bit_const_GND_out;
  assign inst0_I1[1] = bit_const_VCC_out;
  assign inst0_I0[1:0] = I[1:0];
  assign O = inst0_O;

endmodule //Decode22

module Decode02 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND_out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND_out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I1;
  wire  inst0_O;
  EQ2 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //All the connections
  assign inst0_I1[0] = bit_const_GND_out;
  assign inst0_I1[1] = bit_const_GND_out;
  assign inst0_I0[1:0] = I[1:0];
  assign O = inst0_O;

endmodule //Decode02

module Decode12 (
  input [1:0] I,
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

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I1;
  wire  inst0_O;
  EQ2 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //All the connections
  assign inst0_I1[1] = bit_const_GND_out;
  assign inst0_I1[0] = bit_const_VCC_out;
  assign inst0_I0[1:0] = I[1:0];
  assign O = inst0_O;

endmodule //Decode12

module Decode32 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC_out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC_out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I1;
  wire  inst0_O;
  EQ2 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //All the connections
  assign inst0_I1[0] = bit_const_VCC_out;
  assign inst0_I1[1] = bit_const_VCC_out;
  assign inst0_I0[1:0] = I[1:0];
  assign O = inst0_O;

endmodule //Decode32

module Decoder2 (
  input [1:0] I,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module Decode02)
  wire [1:0] inst0_I;
  wire  inst0_O;
  Decode02 inst0(
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module Decode12)
  wire [1:0] inst1_I;
  wire  inst1_O;
  Decode12 inst1(
    .I(inst1_I),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module Decode22)
  wire [1:0] inst2_I;
  wire  inst2_O;
  Decode22 inst2(
    .I(inst2_I),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module Decode32)
  wire [1:0] inst3_I;
  wire  inst3_O;
  Decode32 inst3(
    .I(inst3_I),
    .O(inst3_O)
  );

  //All the connections
  assign inst0_I[1:0] = I[1:0];
  assign O[0] = inst0_O;
  assign inst1_I[1:0] = I[1:0];
  assign O[1] = inst1_O;
  assign inst2_I[1:0] = I[1:0];
  assign O[2] = inst2_O;
  assign inst3_I[1:0] = I[1:0];
  assign O[3] = inst3_O;

endmodule //Decoder2

module and4_wrapped (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [3:0] inst0_in0;
  wire [3:0] inst0_out;
  wire [3:0] inst0_in1;
  coreir_and #(.width(4)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[3:0] = I0[3:0];
  assign inst0_in1[3:0] = I1[3:0];
  assign O[3:0] = inst0_out[3:0];

endmodule //and4_wrapped

module _Mux2 (
  input [1:0] I,
  output  O,
  input  S
);
  //Wire declarations for instance 'inst0' (Module corebit_mux)
  wire  inst0_in0;
  wire  inst0_out;
  wire  inst0_in1;
  wire  inst0_sel;
  corebit_mux inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out),
    .sel(inst0_sel)
  );

  //All the connections
  assign inst0_in0 = I[0];
  assign inst0_in1 = I[1];
  assign O = inst0_out;
  assign inst0_sel = S;

endmodule //_Mux2

module Or8x2 (
  input [1:0] I0,
  input [1:0] I1,
  input [1:0] I2,
  input [1:0] I3,
  input [1:0] I4,
  input [1:0] I5,
  input [1:0] I6,
  input [1:0] I7,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [7:0] inst0_in;
  wire  inst0_out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0_in),
    .out(inst0_out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [7:0] inst1_in;
  wire  inst1_out;
  coreir_orr #(.width(8)) inst1(
    .in(inst1_in),
    .out(inst1_out)
  );

  //All the connections
  assign O[0] = inst0_out;
  assign O[1] = inst1_out;
  assign inst0_in[0] = I0[0];
  assign inst0_in[1] = I1[0];
  assign inst0_in[2] = I2[0];
  assign inst0_in[3] = I3[0];
  assign inst0_in[4] = I4[0];
  assign inst0_in[5] = I5[0];
  assign inst0_in[6] = I6[0];
  assign inst0_in[7] = I7[0];
  assign inst1_in[0] = I0[1];
  assign inst1_in[1] = I1[1];
  assign inst1_in[2] = I2[1];
  assign inst1_in[3] = I3[1];
  assign inst1_in[4] = I4[1];
  assign inst1_in[5] = I5[1];
  assign inst1_in[6] = I6[1];
  assign inst1_in[7] = I7[1];

endmodule //Or8x2

module Or8x4 (
  input [3:0] I0,
  input [3:0] I1,
  input [3:0] I2,
  input [3:0] I3,
  input [3:0] I4,
  input [3:0] I5,
  input [3:0] I6,
  input [3:0] I7,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [7:0] inst0_in;
  wire  inst0_out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0_in),
    .out(inst0_out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [7:0] inst1_in;
  wire  inst1_out;
  coreir_orr #(.width(8)) inst1(
    .in(inst1_in),
    .out(inst1_out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [7:0] inst2_in;
  wire  inst2_out;
  coreir_orr #(.width(8)) inst2(
    .in(inst2_in),
    .out(inst2_out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [7:0] inst3_in;
  wire  inst3_out;
  coreir_orr #(.width(8)) inst3(
    .in(inst3_in),
    .out(inst3_out)
  );

  //All the connections
  assign O[0] = inst0_out;
  assign O[1] = inst1_out;
  assign O[2] = inst2_out;
  assign O[3] = inst3_out;
  assign inst0_in[0] = I0[0];
  assign inst0_in[1] = I1[0];
  assign inst0_in[2] = I2[0];
  assign inst0_in[3] = I3[0];
  assign inst0_in[4] = I4[0];
  assign inst0_in[5] = I5[0];
  assign inst0_in[6] = I6[0];
  assign inst0_in[7] = I7[0];
  assign inst1_in[0] = I0[1];
  assign inst1_in[1] = I1[1];
  assign inst1_in[2] = I2[1];
  assign inst1_in[3] = I3[1];
  assign inst1_in[4] = I4[1];
  assign inst1_in[5] = I5[1];
  assign inst1_in[6] = I6[1];
  assign inst1_in[7] = I7[1];
  assign inst2_in[0] = I0[2];
  assign inst2_in[1] = I1[2];
  assign inst2_in[2] = I2[2];
  assign inst2_in[3] = I3[2];
  assign inst2_in[4] = I4[2];
  assign inst2_in[5] = I5[2];
  assign inst2_in[6] = I6[2];
  assign inst2_in[7] = I7[2];
  assign inst3_in[0] = I0[3];
  assign inst3_in[1] = I1[3];
  assign inst3_in[2] = I2[3];
  assign inst3_in[3] = I3[3];
  assign inst3_in[4] = I4[3];
  assign inst3_in[5] = I5[3];
  assign inst3_in[6] = I6[3];
  assign inst3_in[7] = I7[3];

endmodule //Or8x4

module SilicaOneHotMux84 (
  input [3:0] I0,
  input [3:0] I1,
  input [3:0] I2,
  input [3:0] I3,
  input [3:0] I4,
  input [3:0] I5,
  input [3:0] I6,
  input [3:0] I7,
  output [3:0] O,
  input [7:0] S
);
  //Wire declarations for instance 'inst0' (Module Or8x4)
  wire [3:0] inst0_I0;
  wire [3:0] inst0_I3;
  wire [3:0] inst0_O;
  wire [3:0] inst0_I4;
  wire [3:0] inst0_I2;
  wire [3:0] inst0_I1;
  wire [3:0] inst0_I7;
  wire [3:0] inst0_I5;
  wire [3:0] inst0_I6;
  Or8x4 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .I4(inst0_I4),
    .I5(inst0_I5),
    .I6(inst0_I6),
    .I7(inst0_I7),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module and4_wrapped)
  wire [3:0] inst1_I0;
  wire [3:0] inst1_I1;
  wire [3:0] inst1_O;
  and4_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module and4_wrapped)
  wire [3:0] inst2_I0;
  wire [3:0] inst2_I1;
  wire [3:0] inst2_O;
  and4_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module and4_wrapped)
  wire [3:0] inst3_I0;
  wire [3:0] inst3_I1;
  wire [3:0] inst3_O;
  and4_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module and4_wrapped)
  wire [3:0] inst4_I0;
  wire [3:0] inst4_I1;
  wire [3:0] inst4_O;
  and4_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module and4_wrapped)
  wire [3:0] inst5_I0;
  wire [3:0] inst5_I1;
  wire [3:0] inst5_O;
  and4_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module and4_wrapped)
  wire [3:0] inst6_I0;
  wire [3:0] inst6_I1;
  wire [3:0] inst6_O;
  and4_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module and4_wrapped)
  wire [3:0] inst7_I0;
  wire [3:0] inst7_I1;
  wire [3:0] inst7_O;
  and4_wrapped inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module and4_wrapped)
  wire [3:0] inst8_I0;
  wire [3:0] inst8_I1;
  wire [3:0] inst8_O;
  and4_wrapped inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .O(inst8_O)
  );

  //All the connections
  assign inst0_I0[3:0] = inst1_O[3:0];
  assign inst0_I1[3:0] = inst2_O[3:0];
  assign inst0_I2[3:0] = inst3_O[3:0];
  assign inst0_I3[3:0] = inst4_O[3:0];
  assign inst0_I4[3:0] = inst5_O[3:0];
  assign inst0_I5[3:0] = inst6_O[3:0];
  assign inst0_I6[3:0] = inst7_O[3:0];
  assign inst0_I7[3:0] = inst8_O[3:0];
  assign O[3:0] = inst0_O[3:0];
  assign inst1_I0[3:0] = I0[3:0];
  assign inst2_I0[3:0] = I1[3:0];
  assign inst3_I0[3:0] = I2[3:0];
  assign inst4_I0[3:0] = I3[3:0];
  assign inst5_I0[3:0] = I4[3:0];
  assign inst6_I0[3:0] = I5[3:0];
  assign inst7_I0[3:0] = I6[3:0];
  assign inst8_I0[3:0] = I7[3:0];
  assign inst1_I1[0] = S[0];
  assign inst1_I1[1] = S[0];
  assign inst1_I1[2] = S[0];
  assign inst1_I1[3] = S[0];
  assign inst2_I1[0] = S[1];
  assign inst2_I1[1] = S[1];
  assign inst2_I1[2] = S[1];
  assign inst2_I1[3] = S[1];
  assign inst3_I1[0] = S[2];
  assign inst3_I1[1] = S[2];
  assign inst3_I1[2] = S[2];
  assign inst3_I1[3] = S[2];
  assign inst4_I1[0] = S[3];
  assign inst4_I1[1] = S[3];
  assign inst4_I1[2] = S[3];
  assign inst4_I1[3] = S[3];
  assign inst5_I1[0] = S[4];
  assign inst5_I1[1] = S[4];
  assign inst5_I1[2] = S[4];
  assign inst5_I1[3] = S[4];
  assign inst6_I1[0] = S[5];
  assign inst6_I1[1] = S[5];
  assign inst6_I1[2] = S[5];
  assign inst6_I1[3] = S[5];
  assign inst7_I1[0] = S[6];
  assign inst7_I1[1] = S[6];
  assign inst7_I1[2] = S[6];
  assign inst7_I1[3] = S[6];
  assign inst8_I1[0] = S[7];
  assign inst8_I1[1] = S[7];
  assign inst8_I1[2] = S[7];
  assign inst8_I1[3] = S[7];

endmodule //SilicaOneHotMux84

module _Mux4 (
  input [3:0] I,
  output  O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module _Mux2)
  wire [1:0] inst0_I;
  wire  inst0_S;
  wire  inst0_O;
  _Mux2 inst0(
    .I(inst0_I),
    .O(inst0_O),
    .S(inst0_S)
  );

  //Wire declarations for instance 'inst1' (Module _Mux2)
  wire [1:0] inst1_I;
  wire  inst1_S;
  wire  inst1_O;
  _Mux2 inst1(
    .I(inst1_I),
    .O(inst1_O),
    .S(inst1_S)
  );

  //Wire declarations for instance 'inst2' (Module _Mux2)
  wire [1:0] inst2_I;
  wire  inst2_S;
  wire  inst2_O;
  _Mux2 inst2(
    .I(inst2_I),
    .O(inst2_O),
    .S(inst2_S)
  );

  //All the connections
  assign inst2_I[0] = inst0_O;
  assign inst0_S = S[0];
  assign inst2_I[1] = inst1_O;
  assign inst1_S = S[0];
  assign O = inst2_O;
  assign inst2_S = S[1];
  assign inst0_I[0] = I[0];
  assign inst0_I[1] = I[1];
  assign inst1_I[0] = I[2];
  assign inst1_I[1] = I[3];

endmodule //_Mux4

module Mux4x4 (
  input [3:0] I0,
  input [3:0] I1,
  input [3:0] I2,
  input [3:0] I3,
  output [3:0] O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module _Mux4)
  wire [3:0] inst0_I;
  wire [1:0] inst0_S;
  wire  inst0_O;
  _Mux4 inst0(
    .I(inst0_I),
    .O(inst0_O),
    .S(inst0_S)
  );

  //Wire declarations for instance 'inst1' (Module _Mux4)
  wire [3:0] inst1_I;
  wire [1:0] inst1_S;
  wire  inst1_O;
  _Mux4 inst1(
    .I(inst1_I),
    .O(inst1_O),
    .S(inst1_S)
  );

  //Wire declarations for instance 'inst2' (Module _Mux4)
  wire [3:0] inst2_I;
  wire [1:0] inst2_S;
  wire  inst2_O;
  _Mux4 inst2(
    .I(inst2_I),
    .O(inst2_O),
    .S(inst2_S)
  );

  //Wire declarations for instance 'inst3' (Module _Mux4)
  wire [3:0] inst3_I;
  wire [1:0] inst3_S;
  wire  inst3_O;
  _Mux4 inst3(
    .I(inst3_I),
    .O(inst3_O),
    .S(inst3_S)
  );

  //All the connections
  assign O[0] = inst0_O;
  assign inst0_S[1:0] = S[1:0];
  assign O[1] = inst1_O;
  assign inst1_S[1:0] = S[1:0];
  assign O[2] = inst2_O;
  assign inst2_S[1:0] = S[1:0];
  assign O[3] = inst3_O;
  assign inst3_S[1:0] = S[1:0];
  assign inst0_I[0] = I0[0];
  assign inst0_I[1] = I1[0];
  assign inst0_I[2] = I2[0];
  assign inst0_I[3] = I3[0];
  assign inst1_I[0] = I0[1];
  assign inst1_I[1] = I1[1];
  assign inst1_I[2] = I2[1];
  assign inst1_I[3] = I3[1];
  assign inst2_I[0] = I0[2];
  assign inst2_I[1] = I1[2];
  assign inst2_I[2] = I2[2];
  assign inst2_I[3] = I3[2];
  assign inst3_I[0] = I0[3];
  assign inst3_I[1] = I1[3];
  assign inst3_I[2] = I2[3];
  assign inst3_I[3] = I3[3];

endmodule //Mux4x4

module Or8xNone (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  input  I6,
  input  I7,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [7:0] inst0_in;
  wire  inst0_out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign O = inst0_out;
  assign inst0_in[0] = I0;
  assign inst0_in[1] = I1;
  assign inst0_in[2] = I2;
  assign inst0_in[3] = I3;
  assign inst0_in[4] = I4;
  assign inst0_in[5] = I5;
  assign inst0_in[6] = I6;
  assign inst0_in[7] = I7;

endmodule //Or8xNone

module __silica_BufferFifo (
  input [7:0] I,
  output [7:0] O
);
  //All the connections
  assign O[7:0] = I[7:0];

endmodule //__silica_BufferFifo

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

module SilicaOneHotMux82 (
  input [1:0] I0,
  input [1:0] I1,
  input [1:0] I2,
  input [1:0] I3,
  input [1:0] I4,
  input [1:0] I5,
  input [1:0] I6,
  input [1:0] I7,
  output [1:0] O,
  input [7:0] S
);
  //Wire declarations for instance 'inst0' (Module Or8x2)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I3;
  wire [1:0] inst0_O;
  wire [1:0] inst0_I4;
  wire [1:0] inst0_I2;
  wire [1:0] inst0_I1;
  wire [1:0] inst0_I7;
  wire [1:0] inst0_I5;
  wire [1:0] inst0_I6;
  Or8x2 inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .I4(inst0_I4),
    .I5(inst0_I5),
    .I6(inst0_I6),
    .I7(inst0_I7),
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

  //All the connections
  assign inst0_I0[1:0] = inst1_O[1:0];
  assign inst0_I1[1:0] = inst2_O[1:0];
  assign inst0_I2[1:0] = inst3_O[1:0];
  assign inst0_I3[1:0] = inst4_O[1:0];
  assign inst0_I4[1:0] = inst5_O[1:0];
  assign inst0_I5[1:0] = inst6_O[1:0];
  assign inst0_I6[1:0] = inst7_O[1:0];
  assign inst0_I7[1:0] = inst8_O[1:0];
  assign O[1:0] = inst0_O[1:0];
  assign inst1_I0[1:0] = I0[1:0];
  assign inst2_I0[1:0] = I1[1:0];
  assign inst3_I0[1:0] = I2[1:0];
  assign inst4_I0[1:0] = I3[1:0];
  assign inst5_I0[1:0] = I4[1:0];
  assign inst6_I0[1:0] = I5[1:0];
  assign inst7_I0[1:0] = I6[1:0];
  assign inst8_I0[1:0] = I7[1:0];
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
  assign inst7_I1[0] = S[6];
  assign inst7_I1[1] = S[6];
  assign inst8_I1[0] = S[7];
  assign inst8_I1[1] = S[7];

endmodule //SilicaOneHotMux82

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

module SilicaOneHotMux8None (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  input  I6,
  input  I7,
  output  O,
  input [7:0] S
);
  //Wire declarations for instance 'inst0' (Module Or8xNone)
  wire  inst0_I0;
  wire  inst0_I3;
  wire  inst0_O;
  wire  inst0_I4;
  wire  inst0_I2;
  wire  inst0_I1;
  wire  inst0_I7;
  wire  inst0_I5;
  wire  inst0_I6;
  Or8xNone inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .I2(inst0_I2),
    .I3(inst0_I3),
    .I4(inst0_I4),
    .I5(inst0_I5),
    .I6(inst0_I6),
    .I7(inst0_I7),
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

  //Wire declarations for instance 'inst7' (Module and_wrapped)
  wire  inst7_I0;
  wire  inst7_I1;
  wire  inst7_O;
  and_wrapped inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module and_wrapped)
  wire  inst8_I0;
  wire  inst8_I1;
  wire  inst8_O;
  and_wrapped inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .O(inst8_O)
  );

  //All the connections
  assign inst0_I0 = inst1_O;
  assign inst0_I1 = inst2_O;
  assign inst0_I2 = inst3_O;
  assign inst0_I3 = inst4_O;
  assign inst0_I4 = inst5_O;
  assign inst0_I5 = inst6_O;
  assign inst0_I6 = inst7_O;
  assign inst0_I7 = inst8_O;
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
  assign inst7_I0 = I6;
  assign inst7_I1 = S[6];
  assign inst8_I0 = I7;
  assign inst8_I1 = S[7];

endmodule //SilicaOneHotMux8None

module or4_wrapped (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [3:0] inst0_in0;
  wire [3:0] inst0_out;
  wire [3:0] inst0_in1;
  coreir_or #(.width(4)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[3:0] = I0[3:0];
  assign inst0_in1[3:0] = I1[3:0];
  assign O[3:0] = inst0_out[3:0];

endmodule //or4_wrapped

module SilicaOneHotMux24 (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module or4_wrapped)
  wire [3:0] inst0_I0;
  wire [3:0] inst0_I1;
  wire [3:0] inst0_O;
  or4_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module and4_wrapped)
  wire [3:0] inst1_I0;
  wire [3:0] inst1_I1;
  wire [3:0] inst1_O;
  and4_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module and4_wrapped)
  wire [3:0] inst2_I0;
  wire [3:0] inst2_I1;
  wire [3:0] inst2_O;
  and4_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //All the connections
  assign inst0_I0[3:0] = inst1_O[3:0];
  assign inst0_I1[3:0] = inst2_O[3:0];
  assign O[3:0] = inst0_O[3:0];
  assign inst1_I0[3:0] = I0[3:0];
  assign inst2_I0[3:0] = I1[3:0];
  assign inst1_I1[0] = S[0];
  assign inst1_I1[1] = S[0];
  assign inst1_I1[2] = S[0];
  assign inst1_I1[3] = S[0];
  assign inst2_I1[0] = S[1];
  assign inst2_I1[1] = S[1];
  assign inst2_I1[2] = S[1];
  assign inst2_I1[3] = S[1];

endmodule //SilicaOneHotMux24

module reg_U2 #(parameter init=1) (
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

endmodule //reg_U2

module DFF_init1_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U2)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U2 #(.init(1'd1)) inst0(
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
  //Wire declarations for instance 'inst0' (Module reg_U2)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U2 #(.init(1'd0)) inst0(
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

module Register4 (
  input  CLK,
  input [3:0] I,
  output [3:0] O
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

endmodule //Register4

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

module Fifo (
  input  CLK,
  output  empty,
  output  full,
  output [3:0] rdata,
  input  ren,
  input [3:0] wdata,
  input  wen
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

  //Wire declarations for instance 'inst0' (Module __silica_BufferFifo)
  wire [7:0] inst0_I;
  wire [7:0] inst0_O;
  __silica_BufferFifo inst0(
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

  //Wire declarations for instance 'inst10' (Module SilicaOneHotMux84)
  wire [3:0] inst10_I0;
  wire [3:0] inst10_I3;
  wire [3:0] inst10_O;
  wire [3:0] inst10_I4;
  wire [3:0] inst10_I2;
  wire [3:0] inst10_I1;
  wire [3:0] inst10_I7;
  wire [3:0] inst10_I5;
  wire [3:0] inst10_I6;
  wire [7:0] inst10_S;
  SilicaOneHotMux84 inst10(
    .I0(inst10_I0),
    .I1(inst10_I1),
    .I2(inst10_I2),
    .I3(inst10_I3),
    .I4(inst10_I4),
    .I5(inst10_I5),
    .I6(inst10_I6),
    .I7(inst10_I7),
    .O(inst10_O),
    .S(inst10_S)
  );

  //Wire declarations for instance 'inst100' (Module corebit_not)
  wire  inst100_in;
  wire  inst100_out;
  corebit_not inst100(
    .in(inst100_in),
    .out(inst100_out)
  );

  //Wire declarations for instance 'inst101' (Module SilicaOneHotMux24)
  wire [3:0] inst101_I0;
  wire [3:0] inst101_I1;
  wire [3:0] inst101_O;
  wire [1:0] inst101_S;
  SilicaOneHotMux24 inst101(
    .I0(inst101_I0),
    .I1(inst101_I1),
    .O(inst101_O),
    .S(inst101_S)
  );

  //Wire declarations for instance 'inst102' (Module corebit_not)
  wire  inst102_in;
  wire  inst102_out;
  corebit_not inst102(
    .in(inst102_in),
    .out(inst102_out)
  );

  //Wire declarations for instance 'inst103' (Module SilicaOneHotMux24)
  wire [3:0] inst103_I0;
  wire [3:0] inst103_I1;
  wire [3:0] inst103_O;
  wire [1:0] inst103_S;
  SilicaOneHotMux24 inst103(
    .I0(inst103_I0),
    .I1(inst103_I1),
    .O(inst103_O),
    .S(inst103_S)
  );

  //Wire declarations for instance 'inst104' (Module corebit_not)
  wire  inst104_in;
  wire  inst104_out;
  corebit_not inst104(
    .in(inst104_in),
    .out(inst104_out)
  );

  //Wire declarations for instance 'inst105' (Module Add2)
  wire [1:0] inst105_I0;
  wire [1:0] inst105_I1;
  wire [1:0] inst105_O;
  Add2 inst105(
    .I0(inst105_I0),
    .I1(inst105_I1),
    .O(inst105_O)
  );

  //Wire declarations for instance 'inst106' (Module EQ2)
  wire [1:0] inst106_I0;
  wire [1:0] inst106_I1;
  wire  inst106_O;
  EQ2 inst106(
    .I0(inst106_I0),
    .I1(inst106_I1),
    .O(inst106_O)
  );

  //Wire declarations for instance 'inst107' (Module Mux4x4)
  wire [3:0] inst107_I0;
  wire [3:0] inst107_I1;
  wire [3:0] inst107_I2;
  wire [3:0] inst107_I3;
  wire [3:0] inst107_O;
  wire [1:0] inst107_S;
  Mux4x4 inst107(
    .I0(inst107_I0),
    .I1(inst107_I1),
    .I2(inst107_I2),
    .I3(inst107_I3),
    .O(inst107_O),
    .S(inst107_S)
  );

  //Wire declarations for instance 'inst108' (Module corebit_not)
  wire  inst108_in;
  wire  inst108_out;
  corebit_not inst108(
    .in(inst108_in),
    .out(inst108_out)
  );

  //Wire declarations for instance 'inst109' (Module and_wrapped)
  wire  inst109_I0;
  wire  inst109_I1;
  wire  inst109_O;
  and_wrapped inst109(
    .I0(inst109_I0),
    .I1(inst109_I1),
    .O(inst109_O)
  );

  //Wire declarations for instance 'inst11' (Module SilicaOneHotMux84)
  wire [3:0] inst11_I0;
  wire [3:0] inst11_I3;
  wire [3:0] inst11_O;
  wire [3:0] inst11_I4;
  wire [3:0] inst11_I2;
  wire [3:0] inst11_I1;
  wire [3:0] inst11_I7;
  wire [3:0] inst11_I5;
  wire [3:0] inst11_I6;
  wire [7:0] inst11_S;
  SilicaOneHotMux84 inst11(
    .I0(inst11_I0),
    .I1(inst11_I1),
    .I2(inst11_I2),
    .I3(inst11_I3),
    .I4(inst11_I4),
    .I5(inst11_I5),
    .I6(inst11_I6),
    .I7(inst11_I7),
    .O(inst11_O),
    .S(inst11_S)
  );

  //Wire declarations for instance 'inst110' (Module corebit_not)
  wire  inst110_in;
  wire  inst110_out;
  corebit_not inst110(
    .in(inst110_in),
    .out(inst110_out)
  );

  //Wire declarations for instance 'inst111' (Module And3xNone)
  wire  inst111_I0;
  wire  inst111_I1;
  wire  inst111_I2;
  wire  inst111_O;
  And3xNone inst111(
    .I0(inst111_I0),
    .I1(inst111_I1),
    .I2(inst111_I2),
    .O(inst111_O)
  );

  //Wire declarations for instance 'inst112' (Module corebit_not)
  wire  inst112_in;
  wire  inst112_out;
  corebit_not inst112(
    .in(inst112_in),
    .out(inst112_out)
  );

  //Wire declarations for instance 'inst113' (Module and_wrapped)
  wire  inst113_I0;
  wire  inst113_I1;
  wire  inst113_O;
  and_wrapped inst113(
    .I0(inst113_I0),
    .I1(inst113_I1),
    .O(inst113_O)
  );

  //Wire declarations for instance 'inst114' (Module corebit_not)
  wire  inst114_in;
  wire  inst114_out;
  corebit_not inst114(
    .in(inst114_in),
    .out(inst114_out)
  );

  //Wire declarations for instance 'inst115' (Module Mux4x4)
  wire [3:0] inst115_I0;
  wire [3:0] inst115_I1;
  wire [3:0] inst115_I2;
  wire [3:0] inst115_I3;
  wire [3:0] inst115_O;
  wire [1:0] inst115_S;
  Mux4x4 inst115(
    .I0(inst115_I0),
    .I1(inst115_I1),
    .I2(inst115_I2),
    .I3(inst115_I3),
    .O(inst115_O),
    .S(inst115_S)
  );

  //Wire declarations for instance 'inst116' (Module corebit_not)
  wire  inst116_in;
  wire  inst116_out;
  corebit_not inst116(
    .in(inst116_in),
    .out(inst116_out)
  );

  //Wire declarations for instance 'inst117' (Module and_wrapped)
  wire  inst117_I0;
  wire  inst117_I1;
  wire  inst117_O;
  and_wrapped inst117(
    .I0(inst117_I0),
    .I1(inst117_I1),
    .O(inst117_O)
  );

  //Wire declarations for instance 'inst118' (Module Add2)
  wire [1:0] inst118_I0;
  wire [1:0] inst118_I1;
  wire [1:0] inst118_O;
  Add2 inst118(
    .I0(inst118_I0),
    .I1(inst118_I1),
    .O(inst118_O)
  );

  //Wire declarations for instance 'inst119' (Module EQ2)
  wire [1:0] inst119_I0;
  wire [1:0] inst119_I1;
  wire  inst119_O;
  EQ2 inst119(
    .I0(inst119_I0),
    .I1(inst119_I1),
    .O(inst119_O)
  );

  //Wire declarations for instance 'inst12' (Module Register2)
  wire  inst12_CLK;
  wire [1:0] inst12_I;
  wire [1:0] inst12_O;
  Register2 inst12(
    .CLK(inst12_CLK),
    .I(inst12_I),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst120' (Module And3xNone)
  wire  inst120_I0;
  wire  inst120_I1;
  wire  inst120_I2;
  wire  inst120_O;
  And3xNone inst120(
    .I0(inst120_I0),
    .I1(inst120_I1),
    .I2(inst120_I2),
    .O(inst120_O)
  );

  //Wire declarations for instance 'inst121' (Module corebit_not)
  wire  inst121_in;
  wire  inst121_out;
  corebit_not inst121(
    .in(inst121_in),
    .out(inst121_out)
  );

  //Wire declarations for instance 'inst122' (Module and_wrapped)
  wire  inst122_I0;
  wire  inst122_I1;
  wire  inst122_O;
  and_wrapped inst122(
    .I0(inst122_I0),
    .I1(inst122_I1),
    .O(inst122_O)
  );

  //Wire declarations for instance 'inst123' (Module corebit_not)
  wire  inst123_in;
  wire  inst123_out;
  corebit_not inst123(
    .in(inst123_in),
    .out(inst123_out)
  );

  //Wire declarations for instance 'inst124' (Module Mux4x4)
  wire [3:0] inst124_I0;
  wire [3:0] inst124_I1;
  wire [3:0] inst124_I2;
  wire [3:0] inst124_I3;
  wire [3:0] inst124_O;
  wire [1:0] inst124_S;
  Mux4x4 inst124(
    .I0(inst124_I0),
    .I1(inst124_I1),
    .I2(inst124_I2),
    .I3(inst124_I3),
    .O(inst124_O),
    .S(inst124_S)
  );

  //Wire declarations for instance 'inst125' (Module corebit_not)
  wire  inst125_in;
  wire  inst125_out;
  corebit_not inst125(
    .in(inst125_in),
    .out(inst125_out)
  );

  //Wire declarations for instance 'inst126' (Module and_wrapped)
  wire  inst126_I0;
  wire  inst126_I1;
  wire  inst126_O;
  and_wrapped inst126(
    .I0(inst126_I0),
    .I1(inst126_I1),
    .O(inst126_O)
  );

  //Wire declarations for instance 'inst127' (Module corebit_not)
  wire  inst127_in;
  wire  inst127_out;
  corebit_not inst127(
    .in(inst127_in),
    .out(inst127_out)
  );

  //Wire declarations for instance 'inst128' (Module And3xNone)
  wire  inst128_I0;
  wire  inst128_I1;
  wire  inst128_I2;
  wire  inst128_O;
  And3xNone inst128(
    .I0(inst128_I0),
    .I1(inst128_I1),
    .I2(inst128_I2),
    .O(inst128_O)
  );

  //Wire declarations for instance 'inst13' (Module SilicaOneHotMux82)
  wire [1:0] inst13_I0;
  wire [1:0] inst13_I3;
  wire [1:0] inst13_O;
  wire [1:0] inst13_I4;
  wire [1:0] inst13_I2;
  wire [1:0] inst13_I1;
  wire [1:0] inst13_I7;
  wire [1:0] inst13_I5;
  wire [1:0] inst13_I6;
  wire [7:0] inst13_S;
  SilicaOneHotMux82 inst13(
    .I0(inst13_I0),
    .I1(inst13_I1),
    .I2(inst13_I2),
    .I3(inst13_I3),
    .I4(inst13_I4),
    .I5(inst13_I5),
    .I6(inst13_I6),
    .I7(inst13_I7),
    .O(inst13_O),
    .S(inst13_S)
  );

  //Wire declarations for instance 'inst15' (Module SilicaOneHotMux8None)
  wire  inst15_I0;
  wire  inst15_I3;
  wire  inst15_O;
  wire  inst15_I4;
  wire  inst15_I2;
  wire  inst15_I1;
  wire  inst15_I7;
  wire  inst15_I5;
  wire  inst15_I6;
  wire [7:0] inst15_S;
  SilicaOneHotMux8None inst15(
    .I0(inst15_I0),
    .I1(inst15_I1),
    .I2(inst15_I2),
    .I3(inst15_I3),
    .I4(inst15_I4),
    .I5(inst15_I5),
    .I6(inst15_I6),
    .I7(inst15_I7),
    .O(inst15_O),
    .S(inst15_S)
  );

  //Wire declarations for instance 'inst16' (Module Register2)
  wire  inst16_CLK;
  wire [1:0] inst16_I;
  wire [1:0] inst16_O;
  Register2 inst16(
    .CLK(inst16_CLK),
    .I(inst16_I),
    .O(inst16_O)
  );

  //Wire declarations for instance 'inst17' (Module SilicaOneHotMux82)
  wire [1:0] inst17_I0;
  wire [1:0] inst17_I3;
  wire [1:0] inst17_O;
  wire [1:0] inst17_I4;
  wire [1:0] inst17_I2;
  wire [1:0] inst17_I1;
  wire [1:0] inst17_I7;
  wire [1:0] inst17_I5;
  wire [1:0] inst17_I6;
  wire [7:0] inst17_S;
  SilicaOneHotMux82 inst17(
    .I0(inst17_I0),
    .I1(inst17_I1),
    .I2(inst17_I2),
    .I3(inst17_I3),
    .I4(inst17_I4),
    .I5(inst17_I5),
    .I6(inst17_I6),
    .I7(inst17_I7),
    .O(inst17_O),
    .S(inst17_S)
  );

  //Wire declarations for instance 'inst18' (Module SilicaOneHotMux8None)
  wire  inst18_I0;
  wire  inst18_I3;
  wire  inst18_O;
  wire  inst18_I4;
  wire  inst18_I2;
  wire  inst18_I1;
  wire  inst18_I7;
  wire  inst18_I5;
  wire  inst18_I6;
  wire [7:0] inst18_S;
  SilicaOneHotMux8None inst18(
    .I0(inst18_I0),
    .I1(inst18_I1),
    .I2(inst18_I2),
    .I3(inst18_I3),
    .I4(inst18_I4),
    .I5(inst18_I5),
    .I6(inst18_I6),
    .I7(inst18_I7),
    .O(inst18_O),
    .S(inst18_S)
  );

  //Wire declarations for instance 'inst19' (Module SilicaOneHotMux84)
  wire [3:0] inst19_I0;
  wire [3:0] inst19_I3;
  wire [3:0] inst19_O;
  wire [3:0] inst19_I4;
  wire [3:0] inst19_I2;
  wire [3:0] inst19_I1;
  wire [3:0] inst19_I7;
  wire [3:0] inst19_I5;
  wire [3:0] inst19_I6;
  wire [7:0] inst19_S;
  SilicaOneHotMux84 inst19(
    .I0(inst19_I0),
    .I1(inst19_I1),
    .I2(inst19_I2),
    .I3(inst19_I3),
    .I4(inst19_I4),
    .I5(inst19_I5),
    .I6(inst19_I6),
    .I7(inst19_I7),
    .O(inst19_O),
    .S(inst19_S)
  );

  //Wire declarations for instance 'inst20' (Module SilicaOneHotMux8None)
  wire  inst20_I0;
  wire  inst20_I3;
  wire  inst20_O;
  wire  inst20_I4;
  wire  inst20_I2;
  wire  inst20_I1;
  wire  inst20_I7;
  wire  inst20_I5;
  wire  inst20_I6;
  wire [7:0] inst20_S;
  SilicaOneHotMux8None inst20(
    .I0(inst20_I0),
    .I1(inst20_I1),
    .I2(inst20_I2),
    .I3(inst20_I3),
    .I4(inst20_I4),
    .I5(inst20_I5),
    .I6(inst20_I6),
    .I7(inst20_I7),
    .O(inst20_O),
    .S(inst20_S)
  );

  //Wire declarations for instance 'inst21' (Module corebit_not)
  wire  inst21_in;
  wire  inst21_out;
  corebit_not inst21(
    .in(inst21_in),
    .out(inst21_out)
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

  //Wire declarations for instance 'inst23' (Module Decoder2)
  wire [1:0] inst23_I;
  wire [3:0] inst23_O;
  Decoder2 inst23(
    .I(inst23_I),
    .O(inst23_O)
  );

  //Wire declarations for instance 'inst24' (Module SilicaOneHotMux24)
  wire [3:0] inst24_I0;
  wire [3:0] inst24_I1;
  wire [3:0] inst24_O;
  wire [1:0] inst24_S;
  SilicaOneHotMux24 inst24(
    .I0(inst24_I0),
    .I1(inst24_I1),
    .O(inst24_O),
    .S(inst24_S)
  );

  //Wire declarations for instance 'inst25' (Module corebit_not)
  wire  inst25_in;
  wire  inst25_out;
  corebit_not inst25(
    .in(inst25_in),
    .out(inst25_out)
  );

  //Wire declarations for instance 'inst26' (Module SilicaOneHotMux24)
  wire [3:0] inst26_I0;
  wire [3:0] inst26_I1;
  wire [3:0] inst26_O;
  wire [1:0] inst26_S;
  SilicaOneHotMux24 inst26(
    .I0(inst26_I0),
    .I1(inst26_I1),
    .O(inst26_O),
    .S(inst26_S)
  );

  //Wire declarations for instance 'inst27' (Module corebit_not)
  wire  inst27_in;
  wire  inst27_out;
  corebit_not inst27(
    .in(inst27_in),
    .out(inst27_out)
  );

  //Wire declarations for instance 'inst28' (Module SilicaOneHotMux24)
  wire [3:0] inst28_I0;
  wire [3:0] inst28_I1;
  wire [3:0] inst28_O;
  wire [1:0] inst28_S;
  SilicaOneHotMux24 inst28(
    .I0(inst28_I0),
    .I1(inst28_I1),
    .O(inst28_O),
    .S(inst28_S)
  );

  //Wire declarations for instance 'inst29' (Module corebit_not)
  wire  inst29_in;
  wire  inst29_out;
  corebit_not inst29(
    .in(inst29_in),
    .out(inst29_out)
  );

  //Wire declarations for instance 'inst3' (Module SilicaOneHotMux8None)
  wire  inst3_I0;
  wire  inst3_I3;
  wire  inst3_O;
  wire  inst3_I4;
  wire  inst3_I2;
  wire  inst3_I1;
  wire  inst3_I7;
  wire  inst3_I5;
  wire  inst3_I6;
  wire [7:0] inst3_S;
  SilicaOneHotMux8None inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .I2(inst3_I2),
    .I3(inst3_I3),
    .I4(inst3_I4),
    .I5(inst3_I5),
    .I6(inst3_I6),
    .I7(inst3_I7),
    .O(inst3_O),
    .S(inst3_S)
  );

  //Wire declarations for instance 'inst30' (Module SilicaOneHotMux24)
  wire [3:0] inst30_I0;
  wire [3:0] inst30_I1;
  wire [3:0] inst30_O;
  wire [1:0] inst30_S;
  SilicaOneHotMux24 inst30(
    .I0(inst30_I0),
    .I1(inst30_I1),
    .O(inst30_O),
    .S(inst30_S)
  );

  //Wire declarations for instance 'inst31' (Module corebit_not)
  wire  inst31_in;
  wire  inst31_out;
  corebit_not inst31(
    .in(inst31_in),
    .out(inst31_out)
  );

  //Wire declarations for instance 'inst32' (Module Add2)
  wire [1:0] inst32_I0;
  wire [1:0] inst32_I1;
  wire [1:0] inst32_O;
  Add2 inst32(
    .I0(inst32_I0),
    .I1(inst32_I1),
    .O(inst32_O)
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

  //Wire declarations for instance 'inst34' (Module Mux4x4)
  wire [3:0] inst34_I0;
  wire [3:0] inst34_I1;
  wire [3:0] inst34_I2;
  wire [3:0] inst34_I3;
  wire [3:0] inst34_O;
  wire [1:0] inst34_S;
  Mux4x4 inst34(
    .I0(inst34_I0),
    .I1(inst34_I1),
    .I2(inst34_I2),
    .I3(inst34_I3),
    .O(inst34_O),
    .S(inst34_S)
  );

  //Wire declarations for instance 'inst35' (Module corebit_not)
  wire  inst35_in;
  wire  inst35_out;
  corebit_not inst35(
    .in(inst35_in),
    .out(inst35_out)
  );

  //Wire declarations for instance 'inst36' (Module and_wrapped)
  wire  inst36_I0;
  wire  inst36_I1;
  wire  inst36_O;
  and_wrapped inst36(
    .I0(inst36_I0),
    .I1(inst36_I1),
    .O(inst36_O)
  );

  //Wire declarations for instance 'inst37' (Module Add2)
  wire [1:0] inst37_I0;
  wire [1:0] inst37_I1;
  wire [1:0] inst37_O;
  Add2 inst37(
    .I0(inst37_I0),
    .I1(inst37_I1),
    .O(inst37_O)
  );

  //Wire declarations for instance 'inst38' (Module EQ2)
  wire [1:0] inst38_I0;
  wire [1:0] inst38_I1;
  wire  inst38_O;
  EQ2 inst38(
    .I0(inst38_I0),
    .I1(inst38_I1),
    .O(inst38_O)
  );

  //Wire declarations for instance 'inst39' (Module And3xNone)
  wire  inst39_I0;
  wire  inst39_I1;
  wire  inst39_I2;
  wire  inst39_O;
  And3xNone inst39(
    .I0(inst39_I0),
    .I1(inst39_I1),
    .I2(inst39_I2),
    .O(inst39_O)
  );

  //Wire declarations for instance 'inst4' (Module Register4)
  wire  inst4_CLK;
  wire [3:0] inst4_I;
  wire [3:0] inst4_O;
  Register4 inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst40' (Module corebit_not)
  wire  inst40_in;
  wire  inst40_out;
  corebit_not inst40(
    .in(inst40_in),
    .out(inst40_out)
  );

  //Wire declarations for instance 'inst41' (Module and_wrapped)
  wire  inst41_I0;
  wire  inst41_I1;
  wire  inst41_O;
  and_wrapped inst41(
    .I0(inst41_I0),
    .I1(inst41_I1),
    .O(inst41_O)
  );

  //Wire declarations for instance 'inst42' (Module Decoder2)
  wire [1:0] inst42_I;
  wire [3:0] inst42_O;
  Decoder2 inst42(
    .I(inst42_I),
    .O(inst42_O)
  );

  //Wire declarations for instance 'inst43' (Module SilicaOneHotMux24)
  wire [3:0] inst43_I0;
  wire [3:0] inst43_I1;
  wire [3:0] inst43_O;
  wire [1:0] inst43_S;
  SilicaOneHotMux24 inst43(
    .I0(inst43_I0),
    .I1(inst43_I1),
    .O(inst43_O),
    .S(inst43_S)
  );

  //Wire declarations for instance 'inst44' (Module corebit_not)
  wire  inst44_in;
  wire  inst44_out;
  corebit_not inst44(
    .in(inst44_in),
    .out(inst44_out)
  );

  //Wire declarations for instance 'inst45' (Module SilicaOneHotMux24)
  wire [3:0] inst45_I0;
  wire [3:0] inst45_I1;
  wire [3:0] inst45_O;
  wire [1:0] inst45_S;
  SilicaOneHotMux24 inst45(
    .I0(inst45_I0),
    .I1(inst45_I1),
    .O(inst45_O),
    .S(inst45_S)
  );

  //Wire declarations for instance 'inst46' (Module corebit_not)
  wire  inst46_in;
  wire  inst46_out;
  corebit_not inst46(
    .in(inst46_in),
    .out(inst46_out)
  );

  //Wire declarations for instance 'inst47' (Module SilicaOneHotMux24)
  wire [3:0] inst47_I0;
  wire [3:0] inst47_I1;
  wire [3:0] inst47_O;
  wire [1:0] inst47_S;
  SilicaOneHotMux24 inst47(
    .I0(inst47_I0),
    .I1(inst47_I1),
    .O(inst47_O),
    .S(inst47_S)
  );

  //Wire declarations for instance 'inst48' (Module corebit_not)
  wire  inst48_in;
  wire  inst48_out;
  corebit_not inst48(
    .in(inst48_in),
    .out(inst48_out)
  );

  //Wire declarations for instance 'inst49' (Module SilicaOneHotMux24)
  wire [3:0] inst49_I0;
  wire [3:0] inst49_I1;
  wire [3:0] inst49_O;
  wire [1:0] inst49_S;
  SilicaOneHotMux24 inst49(
    .I0(inst49_I0),
    .I1(inst49_I1),
    .O(inst49_O),
    .S(inst49_S)
  );

  //Wire declarations for instance 'inst5' (Module Register4)
  wire  inst5_CLK;
  wire [3:0] inst5_I;
  wire [3:0] inst5_O;
  Register4 inst5(
    .CLK(inst5_CLK),
    .I(inst5_I),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst50' (Module corebit_not)
  wire  inst50_in;
  wire  inst50_out;
  corebit_not inst50(
    .in(inst50_in),
    .out(inst50_out)
  );

  //Wire declarations for instance 'inst51' (Module Add2)
  wire [1:0] inst51_I0;
  wire [1:0] inst51_I1;
  wire [1:0] inst51_O;
  Add2 inst51(
    .I0(inst51_I0),
    .I1(inst51_I1),
    .O(inst51_O)
  );

  //Wire declarations for instance 'inst52' (Module EQ2)
  wire [1:0] inst52_I0;
  wire [1:0] inst52_I1;
  wire  inst52_O;
  EQ2 inst52(
    .I0(inst52_I0),
    .I1(inst52_I1),
    .O(inst52_O)
  );

  //Wire declarations for instance 'inst53' (Module Mux4x4)
  wire [3:0] inst53_I0;
  wire [3:0] inst53_I1;
  wire [3:0] inst53_I2;
  wire [3:0] inst53_I3;
  wire [3:0] inst53_O;
  wire [1:0] inst53_S;
  Mux4x4 inst53(
    .I0(inst53_I0),
    .I1(inst53_I1),
    .I2(inst53_I2),
    .I3(inst53_I3),
    .O(inst53_O),
    .S(inst53_S)
  );

  //Wire declarations for instance 'inst54' (Module corebit_not)
  wire  inst54_in;
  wire  inst54_out;
  corebit_not inst54(
    .in(inst54_in),
    .out(inst54_out)
  );

  //Wire declarations for instance 'inst55' (Module and_wrapped)
  wire  inst55_I0;
  wire  inst55_I1;
  wire  inst55_O;
  and_wrapped inst55(
    .I0(inst55_I0),
    .I1(inst55_I1),
    .O(inst55_O)
  );

  //Wire declarations for instance 'inst56' (Module corebit_not)
  wire  inst56_in;
  wire  inst56_out;
  corebit_not inst56(
    .in(inst56_in),
    .out(inst56_out)
  );

  //Wire declarations for instance 'inst57' (Module And3xNone)
  wire  inst57_I0;
  wire  inst57_I1;
  wire  inst57_I2;
  wire  inst57_O;
  And3xNone inst57(
    .I0(inst57_I0),
    .I1(inst57_I1),
    .I2(inst57_I2),
    .O(inst57_O)
  );

  //Wire declarations for instance 'inst58' (Module corebit_not)
  wire  inst58_in;
  wire  inst58_out;
  corebit_not inst58(
    .in(inst58_in),
    .out(inst58_out)
  );

  //Wire declarations for instance 'inst59' (Module and_wrapped)
  wire  inst59_I0;
  wire  inst59_I1;
  wire  inst59_O;
  and_wrapped inst59(
    .I0(inst59_I0),
    .I1(inst59_I1),
    .O(inst59_O)
  );

  //Wire declarations for instance 'inst6' (Module Register4)
  wire  inst6_CLK;
  wire [3:0] inst6_I;
  wire [3:0] inst6_O;
  Register4 inst6(
    .CLK(inst6_CLK),
    .I(inst6_I),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst60' (Module corebit_not)
  wire  inst60_in;
  wire  inst60_out;
  corebit_not inst60(
    .in(inst60_in),
    .out(inst60_out)
  );

  //Wire declarations for instance 'inst61' (Module Mux4x4)
  wire [3:0] inst61_I0;
  wire [3:0] inst61_I1;
  wire [3:0] inst61_I2;
  wire [3:0] inst61_I3;
  wire [3:0] inst61_O;
  wire [1:0] inst61_S;
  Mux4x4 inst61(
    .I0(inst61_I0),
    .I1(inst61_I1),
    .I2(inst61_I2),
    .I3(inst61_I3),
    .O(inst61_O),
    .S(inst61_S)
  );

  //Wire declarations for instance 'inst62' (Module corebit_not)
  wire  inst62_in;
  wire  inst62_out;
  corebit_not inst62(
    .in(inst62_in),
    .out(inst62_out)
  );

  //Wire declarations for instance 'inst63' (Module and_wrapped)
  wire  inst63_I0;
  wire  inst63_I1;
  wire  inst63_O;
  and_wrapped inst63(
    .I0(inst63_I0),
    .I1(inst63_I1),
    .O(inst63_O)
  );

  //Wire declarations for instance 'inst64' (Module Add2)
  wire [1:0] inst64_I0;
  wire [1:0] inst64_I1;
  wire [1:0] inst64_O;
  Add2 inst64(
    .I0(inst64_I0),
    .I1(inst64_I1),
    .O(inst64_O)
  );

  //Wire declarations for instance 'inst65' (Module EQ2)
  wire [1:0] inst65_I0;
  wire [1:0] inst65_I1;
  wire  inst65_O;
  EQ2 inst65(
    .I0(inst65_I0),
    .I1(inst65_I1),
    .O(inst65_O)
  );

  //Wire declarations for instance 'inst66' (Module And3xNone)
  wire  inst66_I0;
  wire  inst66_I1;
  wire  inst66_I2;
  wire  inst66_O;
  And3xNone inst66(
    .I0(inst66_I0),
    .I1(inst66_I1),
    .I2(inst66_I2),
    .O(inst66_O)
  );

  //Wire declarations for instance 'inst67' (Module corebit_not)
  wire  inst67_in;
  wire  inst67_out;
  corebit_not inst67(
    .in(inst67_in),
    .out(inst67_out)
  );

  //Wire declarations for instance 'inst68' (Module and_wrapped)
  wire  inst68_I0;
  wire  inst68_I1;
  wire  inst68_O;
  and_wrapped inst68(
    .I0(inst68_I0),
    .I1(inst68_I1),
    .O(inst68_O)
  );

  //Wire declarations for instance 'inst69' (Module corebit_not)
  wire  inst69_in;
  wire  inst69_out;
  corebit_not inst69(
    .in(inst69_in),
    .out(inst69_out)
  );

  //Wire declarations for instance 'inst7' (Module Register4)
  wire  inst7_CLK;
  wire [3:0] inst7_I;
  wire [3:0] inst7_O;
  Register4 inst7(
    .CLK(inst7_CLK),
    .I(inst7_I),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst70' (Module Mux4x4)
  wire [3:0] inst70_I0;
  wire [3:0] inst70_I1;
  wire [3:0] inst70_I2;
  wire [3:0] inst70_I3;
  wire [3:0] inst70_O;
  wire [1:0] inst70_S;
  Mux4x4 inst70(
    .I0(inst70_I0),
    .I1(inst70_I1),
    .I2(inst70_I2),
    .I3(inst70_I3),
    .O(inst70_O),
    .S(inst70_S)
  );

  //Wire declarations for instance 'inst71' (Module corebit_not)
  wire  inst71_in;
  wire  inst71_out;
  corebit_not inst71(
    .in(inst71_in),
    .out(inst71_out)
  );

  //Wire declarations for instance 'inst72' (Module and_wrapped)
  wire  inst72_I0;
  wire  inst72_I1;
  wire  inst72_O;
  and_wrapped inst72(
    .I0(inst72_I0),
    .I1(inst72_I1),
    .O(inst72_O)
  );

  //Wire declarations for instance 'inst73' (Module corebit_not)
  wire  inst73_in;
  wire  inst73_out;
  corebit_not inst73(
    .in(inst73_in),
    .out(inst73_out)
  );

  //Wire declarations for instance 'inst74' (Module And3xNone)
  wire  inst74_I0;
  wire  inst74_I1;
  wire  inst74_I2;
  wire  inst74_O;
  And3xNone inst74(
    .I0(inst74_I0),
    .I1(inst74_I1),
    .I2(inst74_I2),
    .O(inst74_O)
  );

  //Wire declarations for instance 'inst75' (Module corebit_not)
  wire  inst75_in;
  wire  inst75_out;
  corebit_not inst75(
    .in(inst75_in),
    .out(inst75_out)
  );

  //Wire declarations for instance 'inst76' (Module and_wrapped)
  wire  inst76_I0;
  wire  inst76_I1;
  wire  inst76_O;
  and_wrapped inst76(
    .I0(inst76_I0),
    .I1(inst76_I1),
    .O(inst76_O)
  );

  //Wire declarations for instance 'inst77' (Module Decoder2)
  wire [1:0] inst77_I;
  wire [3:0] inst77_O;
  Decoder2 inst77(
    .I(inst77_I),
    .O(inst77_O)
  );

  //Wire declarations for instance 'inst78' (Module SilicaOneHotMux24)
  wire [3:0] inst78_I0;
  wire [3:0] inst78_I1;
  wire [3:0] inst78_O;
  wire [1:0] inst78_S;
  SilicaOneHotMux24 inst78(
    .I0(inst78_I0),
    .I1(inst78_I1),
    .O(inst78_O),
    .S(inst78_S)
  );

  //Wire declarations for instance 'inst79' (Module corebit_not)
  wire  inst79_in;
  wire  inst79_out;
  corebit_not inst79(
    .in(inst79_in),
    .out(inst79_out)
  );

  //Wire declarations for instance 'inst8' (Module SilicaOneHotMux84)
  wire [3:0] inst8_I0;
  wire [3:0] inst8_I3;
  wire [3:0] inst8_O;
  wire [3:0] inst8_I4;
  wire [3:0] inst8_I2;
  wire [3:0] inst8_I1;
  wire [3:0] inst8_I7;
  wire [3:0] inst8_I5;
  wire [3:0] inst8_I6;
  wire [7:0] inst8_S;
  SilicaOneHotMux84 inst8(
    .I0(inst8_I0),
    .I1(inst8_I1),
    .I2(inst8_I2),
    .I3(inst8_I3),
    .I4(inst8_I4),
    .I5(inst8_I5),
    .I6(inst8_I6),
    .I7(inst8_I7),
    .O(inst8_O),
    .S(inst8_S)
  );

  //Wire declarations for instance 'inst80' (Module SilicaOneHotMux24)
  wire [3:0] inst80_I0;
  wire [3:0] inst80_I1;
  wire [3:0] inst80_O;
  wire [1:0] inst80_S;
  SilicaOneHotMux24 inst80(
    .I0(inst80_I0),
    .I1(inst80_I1),
    .O(inst80_O),
    .S(inst80_S)
  );

  //Wire declarations for instance 'inst81' (Module corebit_not)
  wire  inst81_in;
  wire  inst81_out;
  corebit_not inst81(
    .in(inst81_in),
    .out(inst81_out)
  );

  //Wire declarations for instance 'inst82' (Module SilicaOneHotMux24)
  wire [3:0] inst82_I0;
  wire [3:0] inst82_I1;
  wire [3:0] inst82_O;
  wire [1:0] inst82_S;
  SilicaOneHotMux24 inst82(
    .I0(inst82_I0),
    .I1(inst82_I1),
    .O(inst82_O),
    .S(inst82_S)
  );

  //Wire declarations for instance 'inst83' (Module corebit_not)
  wire  inst83_in;
  wire  inst83_out;
  corebit_not inst83(
    .in(inst83_in),
    .out(inst83_out)
  );

  //Wire declarations for instance 'inst84' (Module SilicaOneHotMux24)
  wire [3:0] inst84_I0;
  wire [3:0] inst84_I1;
  wire [3:0] inst84_O;
  wire [1:0] inst84_S;
  SilicaOneHotMux24 inst84(
    .I0(inst84_I0),
    .I1(inst84_I1),
    .O(inst84_O),
    .S(inst84_S)
  );

  //Wire declarations for instance 'inst85' (Module corebit_not)
  wire  inst85_in;
  wire  inst85_out;
  corebit_not inst85(
    .in(inst85_in),
    .out(inst85_out)
  );

  //Wire declarations for instance 'inst86' (Module Add2)
  wire [1:0] inst86_I0;
  wire [1:0] inst86_I1;
  wire [1:0] inst86_O;
  Add2 inst86(
    .I0(inst86_I0),
    .I1(inst86_I1),
    .O(inst86_O)
  );

  //Wire declarations for instance 'inst87' (Module EQ2)
  wire [1:0] inst87_I0;
  wire [1:0] inst87_I1;
  wire  inst87_O;
  EQ2 inst87(
    .I0(inst87_I0),
    .I1(inst87_I1),
    .O(inst87_O)
  );

  //Wire declarations for instance 'inst88' (Module Mux4x4)
  wire [3:0] inst88_I0;
  wire [3:0] inst88_I1;
  wire [3:0] inst88_I2;
  wire [3:0] inst88_I3;
  wire [3:0] inst88_O;
  wire [1:0] inst88_S;
  Mux4x4 inst88(
    .I0(inst88_I0),
    .I1(inst88_I1),
    .I2(inst88_I2),
    .I3(inst88_I3),
    .O(inst88_O),
    .S(inst88_S)
  );

  //Wire declarations for instance 'inst89' (Module corebit_not)
  wire  inst89_in;
  wire  inst89_out;
  corebit_not inst89(
    .in(inst89_in),
    .out(inst89_out)
  );

  //Wire declarations for instance 'inst9' (Module SilicaOneHotMux84)
  wire [3:0] inst9_I0;
  wire [3:0] inst9_I3;
  wire [3:0] inst9_O;
  wire [3:0] inst9_I4;
  wire [3:0] inst9_I2;
  wire [3:0] inst9_I1;
  wire [3:0] inst9_I7;
  wire [3:0] inst9_I5;
  wire [3:0] inst9_I6;
  wire [7:0] inst9_S;
  SilicaOneHotMux84 inst9(
    .I0(inst9_I0),
    .I1(inst9_I1),
    .I2(inst9_I2),
    .I3(inst9_I3),
    .I4(inst9_I4),
    .I5(inst9_I5),
    .I6(inst9_I6),
    .I7(inst9_I7),
    .O(inst9_O),
    .S(inst9_S)
  );

  //Wire declarations for instance 'inst90' (Module and_wrapped)
  wire  inst90_I0;
  wire  inst90_I1;
  wire  inst90_O;
  and_wrapped inst90(
    .I0(inst90_I0),
    .I1(inst90_I1),
    .O(inst90_O)
  );

  //Wire declarations for instance 'inst91' (Module Add2)
  wire [1:0] inst91_I0;
  wire [1:0] inst91_I1;
  wire [1:0] inst91_O;
  Add2 inst91(
    .I0(inst91_I0),
    .I1(inst91_I1),
    .O(inst91_O)
  );

  //Wire declarations for instance 'inst92' (Module EQ2)
  wire [1:0] inst92_I0;
  wire [1:0] inst92_I1;
  wire  inst92_O;
  EQ2 inst92(
    .I0(inst92_I0),
    .I1(inst92_I1),
    .O(inst92_O)
  );

  //Wire declarations for instance 'inst93' (Module And3xNone)
  wire  inst93_I0;
  wire  inst93_I1;
  wire  inst93_I2;
  wire  inst93_O;
  And3xNone inst93(
    .I0(inst93_I0),
    .I1(inst93_I1),
    .I2(inst93_I2),
    .O(inst93_O)
  );

  //Wire declarations for instance 'inst94' (Module corebit_not)
  wire  inst94_in;
  wire  inst94_out;
  corebit_not inst94(
    .in(inst94_in),
    .out(inst94_out)
  );

  //Wire declarations for instance 'inst95' (Module and_wrapped)
  wire  inst95_I0;
  wire  inst95_I1;
  wire  inst95_O;
  and_wrapped inst95(
    .I0(inst95_I0),
    .I1(inst95_I1),
    .O(inst95_O)
  );

  //Wire declarations for instance 'inst96' (Module Decoder2)
  wire [1:0] inst96_I;
  wire [3:0] inst96_O;
  Decoder2 inst96(
    .I(inst96_I),
    .O(inst96_O)
  );

  //Wire declarations for instance 'inst97' (Module SilicaOneHotMux24)
  wire [3:0] inst97_I0;
  wire [3:0] inst97_I1;
  wire [3:0] inst97_O;
  wire [1:0] inst97_S;
  SilicaOneHotMux24 inst97(
    .I0(inst97_I0),
    .I1(inst97_I1),
    .O(inst97_O),
    .S(inst97_S)
  );

  //Wire declarations for instance 'inst98' (Module corebit_not)
  wire  inst98_in;
  wire  inst98_out;
  corebit_not inst98(
    .in(inst98_in),
    .out(inst98_out)
  );

  //Wire declarations for instance 'inst99' (Module SilicaOneHotMux24)
  wire [3:0] inst99_I0;
  wire [3:0] inst99_I1;
  wire [3:0] inst99_O;
  wire [1:0] inst99_S;
  SilicaOneHotMux24 inst99(
    .I0(inst99_I0),
    .I1(inst99_I1),
    .O(inst99_O),
    .S(inst99_S)
  );

  //Wire declarations for instance 'prev_empty' (Module DFF_init1_has_ceFalse_has_resetFalse)
  wire  prev_empty_CLK;
  wire  prev_empty_I;
  wire  prev_empty_O;
  DFF_init1_has_ceFalse_has_resetFalse prev_empty(
    .CLK(prev_empty_CLK),
    .I(prev_empty_I),
    .O(prev_empty_O)
  );

  //Wire declarations for instance 'prev_full' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  prev_full_CLK;
  wire  prev_full_I;
  wire  prev_full_O;
  DFF_init0_has_ceFalse_has_resetFalse prev_full(
    .CLK(prev_full_CLK),
    .I(prev_full_I),
    .O(prev_full_O)
  );

  //All the connections
  assign inst15_I1 = bit_const_GND_out;
  assign inst15_I5 = bit_const_GND_out;
  assign inst18_I0 = bit_const_GND_out;
  assign inst18_I2 = bit_const_GND_out;
  assign inst18_I4 = bit_const_GND_out;
  assign inst18_I6 = bit_const_GND_out;
  assign inst20_I1 = bit_const_GND_out;
  assign inst20_I5 = bit_const_GND_out;
  assign inst3_I0 = bit_const_GND_out;
  assign inst3_I2 = bit_const_GND_out;
  assign inst3_I4 = bit_const_GND_out;
  assign inst3_I6 = bit_const_GND_out;
  assign inst1_I[0] = bit_const_GND_out;
  assign inst105_I1[1] = bit_const_GND_out;
  assign inst118_I1[1] = bit_const_GND_out;
  assign inst32_I1[1] = bit_const_GND_out;
  assign inst37_I1[1] = bit_const_GND_out;
  assign inst51_I1[1] = bit_const_GND_out;
  assign inst64_I1[1] = bit_const_GND_out;
  assign inst86_I1[1] = bit_const_GND_out;
  assign inst91_I1[1] = bit_const_GND_out;
  assign inst1_I[1] = bit_const_VCC_out;
  assign inst105_I1[0] = bit_const_VCC_out;
  assign inst118_I1[0] = bit_const_VCC_out;
  assign inst32_I1[0] = bit_const_VCC_out;
  assign inst37_I1[0] = bit_const_VCC_out;
  assign inst51_I1[0] = bit_const_VCC_out;
  assign inst64_I1[0] = bit_const_VCC_out;
  assign inst86_I1[0] = bit_const_VCC_out;
  assign inst91_I1[0] = bit_const_VCC_out;
  assign inst10_S[7:0] = inst0_O[7:0];
  assign inst11_S[7:0] = inst0_O[7:0];
  assign inst13_S[7:0] = inst0_O[7:0];
  assign inst15_S[7:0] = inst0_O[7:0];
  assign inst17_S[7:0] = inst0_O[7:0];
  assign inst18_S[7:0] = inst0_O[7:0];
  assign inst19_S[7:0] = inst0_O[7:0];
  assign inst20_S[7:0] = inst0_O[7:0];
  assign inst3_S[7:0] = inst0_O[7:0];
  assign inst8_S[7:0] = inst0_O[7:0];
  assign inst9_S[7:0] = inst0_O[7:0];
  assign inst1_CLK = CLK;
  assign inst10_I0[3:0] = inst28_O[3:0];
  assign inst10_I1[3:0] = inst47_O[3:0];
  assign inst10_I2[3:0] = inst6_O[3:0];
  assign inst10_I3[3:0] = inst6_O[3:0];
  assign inst10_I4[3:0] = inst82_O[3:0];
  assign inst10_I5[3:0] = inst101_O[3:0];
  assign inst10_I6[3:0] = inst6_O[3:0];
  assign inst10_I7[3:0] = inst6_O[3:0];
  assign inst6_I[3:0] = inst10_O[3:0];
  assign inst100_in = inst96_O[1];
  assign inst99_S[0] = inst100_out;
  assign inst101_I0[3:0] = inst6_O[3:0];
  assign inst101_I1[3:0] = wdata[3:0];
  assign inst107_I2[3:0] = inst101_O[3:0];
  assign inst102_in = inst96_O[2];
  assign inst101_S[0] = inst102_out;
  assign inst103_I0[3:0] = inst7_O[3:0];
  assign inst103_I1[3:0] = wdata[3:0];
  assign inst107_I3[3:0] = inst103_O[3:0];
  assign inst11_I5[3:0] = inst103_O[3:0];
  assign inst104_in = inst96_O[3];
  assign inst103_S[0] = inst104_out;
  assign inst105_I0[1:0] = inst16_O[1:0];
  assign inst106_I1[1:0] = inst105_O[1:0];
  assign inst17_I5[1:0] = inst105_O[1:0];
  assign inst106_I0[1:0] = inst12_O[1:0];
  assign inst18_I5 = inst106_O;
  assign inst3_I5 = inst106_O;
  assign inst107_I0[3:0] = inst97_O[3:0];
  assign inst107_I1[3:0] = inst99_O[3:0];
  assign inst19_I5[3:0] = inst107_O[3:0];
  assign inst107_S[1:0] = inst12_O[1:0];
  assign inst108_in = prev_empty_O;
  assign inst109_I1 = inst108_out;
  assign inst109_I0 = ren;
  assign inst110_in = inst109_O;
  assign inst11_I0[3:0] = inst30_O[3:0];
  assign inst11_I1[3:0] = inst49_O[3:0];
  assign inst11_I2[3:0] = inst7_O[3:0];
  assign inst11_I3[3:0] = inst7_O[3:0];
  assign inst11_I4[3:0] = inst84_O[3:0];
  assign inst11_I6[3:0] = inst7_O[3:0];
  assign inst11_I7[3:0] = inst7_O[3:0];
  assign inst7_I[3:0] = inst11_O[3:0];
  assign inst111_I2 = inst110_out;
  assign inst111_I0 = inst1_O[1];
  assign inst111_I1 = inst95_O;
  assign inst0_I[5] = inst111_O;
  assign inst112_in = prev_full_O;
  assign inst113_I1 = inst112_out;
  assign inst113_I0 = wen;
  assign inst114_in = inst113_O;
  assign inst120_I1 = inst114_out;
  assign inst115_I0[3:0] = inst4_O[3:0];
  assign inst115_I1[3:0] = inst5_O[3:0];
  assign inst115_I2[3:0] = inst6_O[3:0];
  assign inst115_I3[3:0] = inst7_O[3:0];
  assign inst19_I6[3:0] = inst115_O[3:0];
  assign inst115_S[1:0] = inst12_O[1:0];
  assign inst116_in = prev_empty_O;
  assign inst117_I1 = inst116_out;
  assign inst117_I0 = ren;
  assign inst120_I2 = inst117_O;
  assign inst118_I0[1:0] = inst12_O[1:0];
  assign inst119_I0[1:0] = inst118_O[1:0];
  assign inst13_I6[1:0] = inst118_O[1:0];
  assign inst119_I1[1:0] = inst16_O[1:0];
  assign inst15_I6 = inst119_O;
  assign inst20_I6 = inst119_O;
  assign inst12_CLK = CLK;
  assign inst12_I[1:0] = inst13_O[1:0];
  assign inst124_S[1:0] = inst12_O[1:0];
  assign inst13_I1[1:0] = inst12_O[1:0];
  assign inst13_I3[1:0] = inst12_O[1:0];
  assign inst13_I5[1:0] = inst12_O[1:0];
  assign inst13_I7[1:0] = inst12_O[1:0];
  assign inst33_I0[1:0] = inst12_O[1:0];
  assign inst34_S[1:0] = inst12_O[1:0];
  assign inst37_I0[1:0] = inst12_O[1:0];
  assign inst52_I0[1:0] = inst12_O[1:0];
  assign inst53_S[1:0] = inst12_O[1:0];
  assign inst61_S[1:0] = inst12_O[1:0];
  assign inst64_I0[1:0] = inst12_O[1:0];
  assign inst70_S[1:0] = inst12_O[1:0];
  assign inst87_I0[1:0] = inst12_O[1:0];
  assign inst88_S[1:0] = inst12_O[1:0];
  assign inst91_I0[1:0] = inst12_O[1:0];
  assign inst120_I0 = inst1_O[1];
  assign inst0_I[6] = inst120_O;
  assign inst121_in = prev_full_O;
  assign inst122_I1 = inst121_out;
  assign inst122_I0 = wen;
  assign inst123_in = inst122_O;
  assign inst128_I1 = inst123_out;
  assign inst124_I0[3:0] = inst4_O[3:0];
  assign inst124_I1[3:0] = inst5_O[3:0];
  assign inst124_I2[3:0] = inst6_O[3:0];
  assign inst124_I3[3:0] = inst7_O[3:0];
  assign inst19_I7[3:0] = inst124_O[3:0];
  assign inst125_in = prev_empty_O;
  assign inst126_I1 = inst125_out;
  assign inst126_I0 = ren;
  assign inst127_in = inst126_O;
  assign inst128_I2 = inst127_out;
  assign inst128_I0 = inst1_O[1];
  assign inst0_I[7] = inst128_O;
  assign inst13_I0[1:0] = inst37_O[1:0];
  assign inst13_I2[1:0] = inst64_O[1:0];
  assign inst13_I4[1:0] = inst91_O[1:0];
  assign inst15_I0 = inst38_O;
  assign inst15_I2 = inst65_O;
  assign inst15_I3 = prev_empty_O;
  assign inst15_I4 = inst92_O;
  assign inst15_I7 = prev_empty_O;
  assign prev_empty_I = inst15_O;
  assign inst16_CLK = CLK;
  assign inst16_I[1:0] = inst17_O[1:0];
  assign inst17_I2[1:0] = inst16_O[1:0];
  assign inst17_I3[1:0] = inst16_O[1:0];
  assign inst17_I6[1:0] = inst16_O[1:0];
  assign inst17_I7[1:0] = inst16_O[1:0];
  assign inst23_I[1:0] = inst16_O[1:0];
  assign inst32_I0[1:0] = inst16_O[1:0];
  assign inst42_I[1:0] = inst16_O[1:0];
  assign inst51_I0[1:0] = inst16_O[1:0];
  assign inst65_I1[1:0] = inst16_O[1:0];
  assign inst77_I[1:0] = inst16_O[1:0];
  assign inst86_I0[1:0] = inst16_O[1:0];
  assign inst96_I[1:0] = inst16_O[1:0];
  assign inst17_I0[1:0] = inst32_O[1:0];
  assign inst17_I1[1:0] = inst51_O[1:0];
  assign inst17_I4[1:0] = inst86_O[1:0];
  assign inst18_I1 = inst52_O;
  assign inst18_I3 = prev_full_O;
  assign inst18_I7 = prev_full_O;
  assign full = inst18_O;
  assign inst19_I0[3:0] = inst34_O[3:0];
  assign inst19_I1[3:0] = inst53_O[3:0];
  assign inst19_I2[3:0] = inst61_O[3:0];
  assign inst19_I3[3:0] = inst70_O[3:0];
  assign inst19_I4[3:0] = inst88_O[3:0];
  assign rdata[3:0] = inst19_O[3:0];
  assign inst20_I0 = inst38_O;
  assign inst20_I2 = inst65_O;
  assign inst20_I3 = prev_empty_O;
  assign inst20_I4 = inst92_O;
  assign inst20_I7 = prev_empty_O;
  assign empty = inst20_O;
  assign inst21_in = prev_full_O;
  assign inst22_I1 = inst21_out;
  assign inst22_I0 = wen;
  assign inst39_I1 = inst22_O;
  assign inst24_I0[3:0] = inst4_O[3:0];
  assign inst24_I1[3:0] = wdata[3:0];
  assign inst34_I0[3:0] = inst24_O[3:0];
  assign inst8_I0[3:0] = inst24_O[3:0];
  assign inst25_in = inst23_O[0];
  assign inst24_S[0] = inst25_out;
  assign inst26_I0[3:0] = inst5_O[3:0];
  assign inst26_I1[3:0] = wdata[3:0];
  assign inst34_I1[3:0] = inst26_O[3:0];
  assign inst9_I0[3:0] = inst26_O[3:0];
  assign inst27_in = inst23_O[1];
  assign inst26_S[0] = inst27_out;
  assign inst28_I0[3:0] = inst6_O[3:0];
  assign inst28_I1[3:0] = wdata[3:0];
  assign inst34_I2[3:0] = inst28_O[3:0];
  assign inst29_in = inst23_O[2];
  assign inst28_S[0] = inst29_out;
  assign inst3_I1 = inst52_O;
  assign inst3_I3 = prev_full_O;
  assign inst3_I7 = prev_full_O;
  assign prev_full_I = inst3_O;
  assign inst30_I0[3:0] = inst7_O[3:0];
  assign inst30_I1[3:0] = wdata[3:0];
  assign inst34_I3[3:0] = inst30_O[3:0];
  assign inst31_in = inst23_O[3];
  assign inst30_S[0] = inst31_out;
  assign inst33_I1[1:0] = inst32_O[1:0];
  assign inst38_I1[1:0] = inst32_O[1:0];
  assign inst35_in = prev_empty_O;
  assign inst36_I1 = inst35_out;
  assign inst36_I0 = ren;
  assign inst39_I2 = inst36_O;
  assign inst38_I0[1:0] = inst37_O[1:0];
  assign inst39_I0 = inst1_O[0];
  assign inst0_I[0] = inst39_O;
  assign inst4_CLK = CLK;
  assign inst4_I[3:0] = inst8_O[3:0];
  assign inst43_I0[3:0] = inst4_O[3:0];
  assign inst61_I0[3:0] = inst4_O[3:0];
  assign inst70_I0[3:0] = inst4_O[3:0];
  assign inst78_I0[3:0] = inst4_O[3:0];
  assign inst8_I2[3:0] = inst4_O[3:0];
  assign inst8_I3[3:0] = inst4_O[3:0];
  assign inst8_I6[3:0] = inst4_O[3:0];
  assign inst8_I7[3:0] = inst4_O[3:0];
  assign inst97_I0[3:0] = inst4_O[3:0];
  assign inst40_in = prev_full_O;
  assign inst41_I1 = inst40_out;
  assign inst41_I0 = wen;
  assign inst57_I1 = inst41_O;
  assign inst43_I1[3:0] = wdata[3:0];
  assign inst53_I0[3:0] = inst43_O[3:0];
  assign inst8_I1[3:0] = inst43_O[3:0];
  assign inst44_in = inst42_O[0];
  assign inst43_S[0] = inst44_out;
  assign inst45_I0[3:0] = inst5_O[3:0];
  assign inst45_I1[3:0] = wdata[3:0];
  assign inst53_I1[3:0] = inst45_O[3:0];
  assign inst9_I1[3:0] = inst45_O[3:0];
  assign inst46_in = inst42_O[1];
  assign inst45_S[0] = inst46_out;
  assign inst47_I0[3:0] = inst6_O[3:0];
  assign inst47_I1[3:0] = wdata[3:0];
  assign inst53_I2[3:0] = inst47_O[3:0];
  assign inst48_in = inst42_O[2];
  assign inst47_S[0] = inst48_out;
  assign inst49_I0[3:0] = inst7_O[3:0];
  assign inst49_I1[3:0] = wdata[3:0];
  assign inst53_I3[3:0] = inst49_O[3:0];
  assign inst5_CLK = CLK;
  assign inst5_I[3:0] = inst9_O[3:0];
  assign inst61_I1[3:0] = inst5_O[3:0];
  assign inst70_I1[3:0] = inst5_O[3:0];
  assign inst80_I0[3:0] = inst5_O[3:0];
  assign inst9_I2[3:0] = inst5_O[3:0];
  assign inst9_I3[3:0] = inst5_O[3:0];
  assign inst9_I6[3:0] = inst5_O[3:0];
  assign inst9_I7[3:0] = inst5_O[3:0];
  assign inst99_I0[3:0] = inst5_O[3:0];
  assign inst50_in = inst42_O[3];
  assign inst49_S[0] = inst50_out;
  assign inst52_I1[1:0] = inst51_O[1:0];
  assign inst54_in = prev_empty_O;
  assign inst55_I1 = inst54_out;
  assign inst55_I0 = ren;
  assign inst56_in = inst55_O;
  assign inst57_I2 = inst56_out;
  assign inst57_I0 = inst1_O[0];
  assign inst0_I[1] = inst57_O;
  assign inst58_in = prev_full_O;
  assign inst59_I1 = inst58_out;
  assign inst59_I0 = wen;
  assign inst60_in = inst59_O;
  assign inst6_CLK = CLK;
  assign inst61_I2[3:0] = inst6_O[3:0];
  assign inst70_I2[3:0] = inst6_O[3:0];
  assign inst82_I0[3:0] = inst6_O[3:0];
  assign inst66_I1 = inst60_out;
  assign inst61_I3[3:0] = inst7_O[3:0];
  assign inst62_in = prev_empty_O;
  assign inst63_I1 = inst62_out;
  assign inst63_I0 = ren;
  assign inst66_I2 = inst63_O;
  assign inst65_I0[1:0] = inst64_O[1:0];
  assign inst66_I0 = inst1_O[0];
  assign inst0_I[2] = inst66_O;
  assign inst67_in = prev_full_O;
  assign inst68_I1 = inst67_out;
  assign inst68_I0 = wen;
  assign inst69_in = inst68_O;
  assign inst74_I1 = inst69_out;
  assign inst7_CLK = CLK;
  assign inst70_I3[3:0] = inst7_O[3:0];
  assign inst84_I0[3:0] = inst7_O[3:0];
  assign inst71_in = prev_empty_O;
  assign inst72_I1 = inst71_out;
  assign inst72_I0 = ren;
  assign inst73_in = inst72_O;
  assign inst74_I2 = inst73_out;
  assign inst74_I0 = inst1_O[0];
  assign inst0_I[3] = inst74_O;
  assign inst75_in = prev_full_O;
  assign inst76_I1 = inst75_out;
  assign inst76_I0 = wen;
  assign inst93_I1 = inst76_O;
  assign inst78_I1[3:0] = wdata[3:0];
  assign inst8_I4[3:0] = inst78_O[3:0];
  assign inst88_I0[3:0] = inst78_O[3:0];
  assign inst79_in = inst77_O[0];
  assign inst78_S[0] = inst79_out;
  assign inst8_I5[3:0] = inst97_O[3:0];
  assign inst80_I1[3:0] = wdata[3:0];
  assign inst88_I1[3:0] = inst80_O[3:0];
  assign inst9_I4[3:0] = inst80_O[3:0];
  assign inst81_in = inst77_O[1];
  assign inst80_S[0] = inst81_out;
  assign inst82_I1[3:0] = wdata[3:0];
  assign inst88_I2[3:0] = inst82_O[3:0];
  assign inst83_in = inst77_O[2];
  assign inst82_S[0] = inst83_out;
  assign inst84_I1[3:0] = wdata[3:0];
  assign inst88_I3[3:0] = inst84_O[3:0];
  assign inst85_in = inst77_O[3];
  assign inst84_S[0] = inst85_out;
  assign inst87_I1[1:0] = inst86_O[1:0];
  assign inst92_I1[1:0] = inst86_O[1:0];
  assign inst89_in = prev_empty_O;
  assign inst90_I1 = inst89_out;
  assign inst9_I5[3:0] = inst99_O[3:0];
  assign inst90_I0 = ren;
  assign inst93_I2 = inst90_O;
  assign inst92_I0[1:0] = inst91_O[1:0];
  assign inst93_I0 = inst1_O[1];
  assign inst0_I[4] = inst93_O;
  assign inst94_in = prev_full_O;
  assign inst95_I1 = inst94_out;
  assign inst95_I0 = wen;
  assign inst97_I1[3:0] = wdata[3:0];
  assign inst98_in = inst96_O[0];
  assign inst97_S[0] = inst98_out;
  assign inst99_I1[3:0] = wdata[3:0];
  assign prev_empty_CLK = CLK;
  assign prev_full_CLK = CLK;
  assign inst101_S[1] = inst96_O[2];
  assign inst103_S[1] = inst96_O[3];
  assign inst24_S[1] = inst23_O[0];
  assign inst26_S[1] = inst23_O[1];
  assign inst28_S[1] = inst23_O[2];
  assign inst30_S[1] = inst23_O[3];
  assign inst43_S[1] = inst42_O[0];
  assign inst45_S[1] = inst42_O[1];
  assign inst47_S[1] = inst42_O[2];
  assign inst49_S[1] = inst42_O[3];
  assign inst78_S[1] = inst77_O[0];
  assign inst80_S[1] = inst77_O[1];
  assign inst82_S[1] = inst77_O[2];
  assign inst84_S[1] = inst77_O[3];
  assign inst97_S[1] = inst96_O[0];
  assign inst99_S[1] = inst96_O[1];

endmodule //Fifo
