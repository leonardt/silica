

module coreir_add #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 + in1;

endmodule //coreir_add

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module coreir_andr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = &in;

endmodule //coreir_andr

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

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

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

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

module corebit_mux (
  input in0,
  input in1,
  input sel,
  output out
);
  assign out = sel ? in1 : in0;

endmodule //corebit_mux

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

module __silica_BufferFifo (
  input [7:0] I,
  output [7:0] O
);
  //All the connections
  assign O[7:0] = I[7:0];

endmodule //__silica_BufferFifo

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

module Mux2x4 (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O,
  input  S
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

  //Wire declarations for instance 'inst3' (Module _Mux2)
  wire [1:0] inst3_I;
  wire  inst3_S;
  wire  inst3_O;
  _Mux2 inst3(
    .I(inst3_I),
    .O(inst3_O),
    .S(inst3_S)
  );

  //All the connections
  assign O[0] = inst0_O;
  assign inst0_S = S;
  assign O[1] = inst1_O;
  assign inst1_S = S;
  assign O[2] = inst2_O;
  assign inst2_S = S;
  assign O[3] = inst3_O;
  assign inst3_S = S;
  assign inst0_I[0] = I0[0];
  assign inst0_I[1] = I1[0];
  assign inst1_I[0] = I0[1];
  assign inst1_I[1] = I1[1];
  assign inst2_I[0] = I0[2];
  assign inst2_I[1] = I1[2];
  assign inst3_I[0] = I0[3];
  assign inst3_I[1] = I1[3];

endmodule //Mux2x4

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

  //Wire declarations for instance 'inst10' (Module Register4)
  wire  inst10_CLK;
  wire [3:0] inst10_I;
  wire [3:0] inst10_O;
  Register4 inst10(
    .CLK(inst10_CLK),
    .I(inst10_I),
    .O(inst10_O)
  );

  //Wire declarations for instance 'inst100' (Module corebit_not)
  wire  inst100_in;
  wire  inst100_out;
  corebit_not inst100(
    .in(inst100_in),
    .out(inst100_out)
  );

  //Wire declarations for instance 'inst101' (Module and_wrapped)
  wire  inst101_I0;
  wire  inst101_I1;
  wire  inst101_O;
  and_wrapped inst101(
    .I0(inst101_I0),
    .I1(inst101_I1),
    .O(inst101_O)
  );

  //Wire declarations for instance 'inst102' (Module Add2)
  wire [1:0] inst102_I0;
  wire [1:0] inst102_I1;
  wire [1:0] inst102_O;
  Add2 inst102(
    .I0(inst102_I0),
    .I1(inst102_I1),
    .O(inst102_O)
  );

  //Wire declarations for instance 'inst103' (Module EQ2)
  wire [1:0] inst103_I0;
  wire [1:0] inst103_I1;
  wire  inst103_O;
  EQ2 inst103(
    .I0(inst103_I0),
    .I1(inst103_I1),
    .O(inst103_O)
  );

  //Wire declarations for instance 'inst104' (Module And3xNone)
  wire  inst104_I0;
  wire  inst104_I1;
  wire  inst104_I2;
  wire  inst104_O;
  And3xNone inst104(
    .I0(inst104_I0),
    .I1(inst104_I1),
    .I2(inst104_I2),
    .O(inst104_O)
  );

  //Wire declarations for instance 'inst105' (Module corebit_not)
  wire  inst105_in;
  wire  inst105_out;
  corebit_not inst105(
    .in(inst105_in),
    .out(inst105_out)
  );

  //Wire declarations for instance 'inst106' (Module and_wrapped)
  wire  inst106_I0;
  wire  inst106_I1;
  wire  inst106_O;
  and_wrapped inst106(
    .I0(inst106_I0),
    .I1(inst106_I1),
    .O(inst106_O)
  );

  //Wire declarations for instance 'inst107' (Module corebit_not)
  wire  inst107_in;
  wire  inst107_out;
  corebit_not inst107(
    .in(inst107_in),
    .out(inst107_out)
  );

  //Wire declarations for instance 'inst108' (Module Mux4x4)
  wire [3:0] inst108_I0;
  wire [3:0] inst108_I1;
  wire [3:0] inst108_I2;
  wire [3:0] inst108_I3;
  wire [3:0] inst108_O;
  wire [1:0] inst108_S;
  Mux4x4 inst108(
    .I0(inst108_I0),
    .I1(inst108_I1),
    .I2(inst108_I2),
    .I3(inst108_I3),
    .O(inst108_O),
    .S(inst108_S)
  );

  //Wire declarations for instance 'inst109' (Module corebit_not)
  wire  inst109_in;
  wire  inst109_out;
  corebit_not inst109(
    .in(inst109_in),
    .out(inst109_out)
  );

  //Wire declarations for instance 'inst11' (Module Register4)
  wire  inst11_CLK;
  wire [3:0] inst11_I;
  wire [3:0] inst11_O;
  Register4 inst11(
    .CLK(inst11_CLK),
    .I(inst11_I),
    .O(inst11_O)
  );

  //Wire declarations for instance 'inst110' (Module and_wrapped)
  wire  inst110_I0;
  wire  inst110_I1;
  wire  inst110_O;
  and_wrapped inst110(
    .I0(inst110_I0),
    .I1(inst110_I1),
    .O(inst110_O)
  );

  //Wire declarations for instance 'inst111' (Module corebit_not)
  wire  inst111_in;
  wire  inst111_out;
  corebit_not inst111(
    .in(inst111_in),
    .out(inst111_out)
  );

  //Wire declarations for instance 'inst112' (Module And3xNone)
  wire  inst112_I0;
  wire  inst112_I1;
  wire  inst112_I2;
  wire  inst112_O;
  And3xNone inst112(
    .I0(inst112_I0),
    .I1(inst112_I1),
    .I2(inst112_I2),
    .O(inst112_O)
  );

  //Wire declarations for instance 'inst12' (Module SilicaOneHotMux84)
  wire [3:0] inst12_I0;
  wire [3:0] inst12_I3;
  wire [3:0] inst12_O;
  wire [3:0] inst12_I4;
  wire [3:0] inst12_I2;
  wire [3:0] inst12_I1;
  wire [3:0] inst12_I7;
  wire [3:0] inst12_I5;
  wire [3:0] inst12_I6;
  wire [7:0] inst12_S;
  SilicaOneHotMux84 inst12(
    .I0(inst12_I0),
    .I1(inst12_I1),
    .I2(inst12_I2),
    .I3(inst12_I3),
    .I4(inst12_I4),
    .I5(inst12_I5),
    .I6(inst12_I6),
    .I7(inst12_I7),
    .O(inst12_O),
    .S(inst12_S)
  );

  //Wire declarations for instance 'inst13' (Module SilicaOneHotMux84)
  wire [3:0] inst13_I0;
  wire [3:0] inst13_I3;
  wire [3:0] inst13_O;
  wire [3:0] inst13_I4;
  wire [3:0] inst13_I2;
  wire [3:0] inst13_I1;
  wire [3:0] inst13_I7;
  wire [3:0] inst13_I5;
  wire [3:0] inst13_I6;
  wire [7:0] inst13_S;
  SilicaOneHotMux84 inst13(
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

  //Wire declarations for instance 'inst14' (Module SilicaOneHotMux84)
  wire [3:0] inst14_I0;
  wire [3:0] inst14_I3;
  wire [3:0] inst14_O;
  wire [3:0] inst14_I4;
  wire [3:0] inst14_I2;
  wire [3:0] inst14_I1;
  wire [3:0] inst14_I7;
  wire [3:0] inst14_I5;
  wire [3:0] inst14_I6;
  wire [7:0] inst14_S;
  SilicaOneHotMux84 inst14(
    .I0(inst14_I0),
    .I1(inst14_I1),
    .I2(inst14_I2),
    .I3(inst14_I3),
    .I4(inst14_I4),
    .I5(inst14_I5),
    .I6(inst14_I6),
    .I7(inst14_I7),
    .O(inst14_O),
    .S(inst14_S)
  );

  //Wire declarations for instance 'inst15' (Module SilicaOneHotMux84)
  wire [3:0] inst15_I0;
  wire [3:0] inst15_I3;
  wire [3:0] inst15_O;
  wire [3:0] inst15_I4;
  wire [3:0] inst15_I2;
  wire [3:0] inst15_I1;
  wire [3:0] inst15_I7;
  wire [3:0] inst15_I5;
  wire [3:0] inst15_I6;
  wire [7:0] inst15_S;
  SilicaOneHotMux84 inst15(
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

  //Wire declarations for instance 'inst17' (Module SilicaOneHotMux8None)
  wire  inst17_I0;
  wire  inst17_I3;
  wire  inst17_O;
  wire  inst17_I4;
  wire  inst17_I2;
  wire  inst17_I1;
  wire  inst17_I7;
  wire  inst17_I5;
  wire  inst17_I6;
  wire [7:0] inst17_S;
  SilicaOneHotMux8None inst17(
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

  //Wire declarations for instance 'inst2' (Module Register2)
  wire  inst2_CLK;
  wire [1:0] inst2_I;
  wire [1:0] inst2_O;
  Register2 inst2(
    .CLK(inst2_CLK),
    .I(inst2_I),
    .O(inst2_O)
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

  //Wire declarations for instance 'inst24' (Module Mux2x4)
  wire [3:0] inst24_I0;
  wire [3:0] inst24_I1;
  wire [3:0] inst24_O;
  wire  inst24_S;
  Mux2x4 inst24(
    .I0(inst24_I0),
    .I1(inst24_I1),
    .O(inst24_O),
    .S(inst24_S)
  );

  //Wire declarations for instance 'inst25' (Module Mux2x4)
  wire [3:0] inst25_I0;
  wire [3:0] inst25_I1;
  wire [3:0] inst25_O;
  wire  inst25_S;
  Mux2x4 inst25(
    .I0(inst25_I0),
    .I1(inst25_I1),
    .O(inst25_O),
    .S(inst25_S)
  );

  //Wire declarations for instance 'inst26' (Module Mux2x4)
  wire [3:0] inst26_I0;
  wire [3:0] inst26_I1;
  wire [3:0] inst26_O;
  wire  inst26_S;
  Mux2x4 inst26(
    .I0(inst26_I0),
    .I1(inst26_I1),
    .O(inst26_O),
    .S(inst26_S)
  );

  //Wire declarations for instance 'inst27' (Module Mux2x4)
  wire [3:0] inst27_I0;
  wire [3:0] inst27_I1;
  wire [3:0] inst27_O;
  wire  inst27_S;
  Mux2x4 inst27(
    .I0(inst27_I0),
    .I1(inst27_I1),
    .O(inst27_O),
    .S(inst27_S)
  );

  //Wire declarations for instance 'inst28' (Module Add2)
  wire [1:0] inst28_I0;
  wire [1:0] inst28_I1;
  wire [1:0] inst28_O;
  Add2 inst28(
    .I0(inst28_I0),
    .I1(inst28_I1),
    .O(inst28_O)
  );

  //Wire declarations for instance 'inst29' (Module EQ2)
  wire [1:0] inst29_I0;
  wire [1:0] inst29_I1;
  wire  inst29_O;
  EQ2 inst29(
    .I0(inst29_I0),
    .I1(inst29_I1),
    .O(inst29_O)
  );

  //Wire declarations for instance 'inst3' (Module SilicaOneHotMux82)
  wire [1:0] inst3_I0;
  wire [1:0] inst3_I3;
  wire [1:0] inst3_O;
  wire [1:0] inst3_I4;
  wire [1:0] inst3_I2;
  wire [1:0] inst3_I1;
  wire [1:0] inst3_I7;
  wire [1:0] inst3_I5;
  wire [1:0] inst3_I6;
  wire [7:0] inst3_S;
  SilicaOneHotMux82 inst3(
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

  //Wire declarations for instance 'inst30' (Module Mux4x4)
  wire [3:0] inst30_I0;
  wire [3:0] inst30_I1;
  wire [3:0] inst30_I2;
  wire [3:0] inst30_I3;
  wire [3:0] inst30_O;
  wire [1:0] inst30_S;
  Mux4x4 inst30(
    .I0(inst30_I0),
    .I1(inst30_I1),
    .I2(inst30_I2),
    .I3(inst30_I3),
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

  //Wire declarations for instance 'inst32' (Module and_wrapped)
  wire  inst32_I0;
  wire  inst32_I1;
  wire  inst32_O;
  and_wrapped inst32(
    .I0(inst32_I0),
    .I1(inst32_I1),
    .O(inst32_O)
  );

  //Wire declarations for instance 'inst33' (Module Add2)
  wire [1:0] inst33_I0;
  wire [1:0] inst33_I1;
  wire [1:0] inst33_O;
  Add2 inst33(
    .I0(inst33_I0),
    .I1(inst33_I1),
    .O(inst33_O)
  );

  //Wire declarations for instance 'inst34' (Module EQ2)
  wire [1:0] inst34_I0;
  wire [1:0] inst34_I1;
  wire  inst34_O;
  EQ2 inst34(
    .I0(inst34_I0),
    .I1(inst34_I1),
    .O(inst34_O)
  );

  //Wire declarations for instance 'inst35' (Module And3xNone)
  wire  inst35_I0;
  wire  inst35_I1;
  wire  inst35_I2;
  wire  inst35_O;
  And3xNone inst35(
    .I0(inst35_I0),
    .I1(inst35_I1),
    .I2(inst35_I2),
    .O(inst35_O)
  );

  //Wire declarations for instance 'inst36' (Module corebit_not)
  wire  inst36_in;
  wire  inst36_out;
  corebit_not inst36(
    .in(inst36_in),
    .out(inst36_out)
  );

  //Wire declarations for instance 'inst37' (Module and_wrapped)
  wire  inst37_I0;
  wire  inst37_I1;
  wire  inst37_O;
  and_wrapped inst37(
    .I0(inst37_I0),
    .I1(inst37_I1),
    .O(inst37_O)
  );

  //Wire declarations for instance 'inst38' (Module Decoder2)
  wire [1:0] inst38_I;
  wire [3:0] inst38_O;
  Decoder2 inst38(
    .I(inst38_I),
    .O(inst38_O)
  );

  //Wire declarations for instance 'inst39' (Module Mux2x4)
  wire [3:0] inst39_I0;
  wire [3:0] inst39_I1;
  wire [3:0] inst39_O;
  wire  inst39_S;
  Mux2x4 inst39(
    .I0(inst39_I0),
    .I1(inst39_I1),
    .O(inst39_O),
    .S(inst39_S)
  );

  //Wire declarations for instance 'inst4' (Module Register2)
  wire  inst4_CLK;
  wire [1:0] inst4_I;
  wire [1:0] inst4_O;
  Register2 inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst40' (Module Mux2x4)
  wire [3:0] inst40_I0;
  wire [3:0] inst40_I1;
  wire [3:0] inst40_O;
  wire  inst40_S;
  Mux2x4 inst40(
    .I0(inst40_I0),
    .I1(inst40_I1),
    .O(inst40_O),
    .S(inst40_S)
  );

  //Wire declarations for instance 'inst41' (Module Mux2x4)
  wire [3:0] inst41_I0;
  wire [3:0] inst41_I1;
  wire [3:0] inst41_O;
  wire  inst41_S;
  Mux2x4 inst41(
    .I0(inst41_I0),
    .I1(inst41_I1),
    .O(inst41_O),
    .S(inst41_S)
  );

  //Wire declarations for instance 'inst42' (Module Mux2x4)
  wire [3:0] inst42_I0;
  wire [3:0] inst42_I1;
  wire [3:0] inst42_O;
  wire  inst42_S;
  Mux2x4 inst42(
    .I0(inst42_I0),
    .I1(inst42_I1),
    .O(inst42_O),
    .S(inst42_S)
  );

  //Wire declarations for instance 'inst43' (Module Add2)
  wire [1:0] inst43_I0;
  wire [1:0] inst43_I1;
  wire [1:0] inst43_O;
  Add2 inst43(
    .I0(inst43_I0),
    .I1(inst43_I1),
    .O(inst43_O)
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

  //Wire declarations for instance 'inst45' (Module Mux4x4)
  wire [3:0] inst45_I0;
  wire [3:0] inst45_I1;
  wire [3:0] inst45_I2;
  wire [3:0] inst45_I3;
  wire [3:0] inst45_O;
  wire [1:0] inst45_S;
  Mux4x4 inst45(
    .I0(inst45_I0),
    .I1(inst45_I1),
    .I2(inst45_I2),
    .I3(inst45_I3),
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

  //Wire declarations for instance 'inst47' (Module and_wrapped)
  wire  inst47_I0;
  wire  inst47_I1;
  wire  inst47_O;
  and_wrapped inst47(
    .I0(inst47_I0),
    .I1(inst47_I1),
    .O(inst47_O)
  );

  //Wire declarations for instance 'inst48' (Module corebit_not)
  wire  inst48_in;
  wire  inst48_out;
  corebit_not inst48(
    .in(inst48_in),
    .out(inst48_out)
  );

  //Wire declarations for instance 'inst49' (Module And3xNone)
  wire  inst49_I0;
  wire  inst49_I1;
  wire  inst49_I2;
  wire  inst49_O;
  And3xNone inst49(
    .I0(inst49_I0),
    .I1(inst49_I1),
    .I2(inst49_I2),
    .O(inst49_O)
  );

  //Wire declarations for instance 'inst5' (Module SilicaOneHotMux82)
  wire [1:0] inst5_I0;
  wire [1:0] inst5_I3;
  wire [1:0] inst5_O;
  wire [1:0] inst5_I4;
  wire [1:0] inst5_I2;
  wire [1:0] inst5_I1;
  wire [1:0] inst5_I7;
  wire [1:0] inst5_I5;
  wire [1:0] inst5_I6;
  wire [7:0] inst5_S;
  SilicaOneHotMux82 inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .I2(inst5_I2),
    .I3(inst5_I3),
    .I4(inst5_I4),
    .I5(inst5_I5),
    .I6(inst5_I6),
    .I7(inst5_I7),
    .O(inst5_O),
    .S(inst5_S)
  );

  //Wire declarations for instance 'inst50' (Module corebit_not)
  wire  inst50_in;
  wire  inst50_out;
  corebit_not inst50(
    .in(inst50_in),
    .out(inst50_out)
  );

  //Wire declarations for instance 'inst51' (Module and_wrapped)
  wire  inst51_I0;
  wire  inst51_I1;
  wire  inst51_O;
  and_wrapped inst51(
    .I0(inst51_I0),
    .I1(inst51_I1),
    .O(inst51_O)
  );

  //Wire declarations for instance 'inst52' (Module corebit_not)
  wire  inst52_in;
  wire  inst52_out;
  corebit_not inst52(
    .in(inst52_in),
    .out(inst52_out)
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

  //Wire declarations for instance 'inst56' (Module Add2)
  wire [1:0] inst56_I0;
  wire [1:0] inst56_I1;
  wire [1:0] inst56_O;
  Add2 inst56(
    .I0(inst56_I0),
    .I1(inst56_I1),
    .O(inst56_O)
  );

  //Wire declarations for instance 'inst57' (Module EQ2)
  wire [1:0] inst57_I0;
  wire [1:0] inst57_I1;
  wire  inst57_O;
  EQ2 inst57(
    .I0(inst57_I0),
    .I1(inst57_I1),
    .O(inst57_O)
  );

  //Wire declarations for instance 'inst58' (Module And3xNone)
  wire  inst58_I0;
  wire  inst58_I1;
  wire  inst58_I2;
  wire  inst58_O;
  And3xNone inst58(
    .I0(inst58_I0),
    .I1(inst58_I1),
    .I2(inst58_I2),
    .O(inst58_O)
  );

  //Wire declarations for instance 'inst59' (Module corebit_not)
  wire  inst59_in;
  wire  inst59_out;
  corebit_not inst59(
    .in(inst59_in),
    .out(inst59_out)
  );

  //Wire declarations for instance 'inst60' (Module and_wrapped)
  wire  inst60_I0;
  wire  inst60_I1;
  wire  inst60_O;
  and_wrapped inst60(
    .I0(inst60_I0),
    .I1(inst60_I1),
    .O(inst60_O)
  );

  //Wire declarations for instance 'inst61' (Module corebit_not)
  wire  inst61_in;
  wire  inst61_out;
  corebit_not inst61(
    .in(inst61_in),
    .out(inst61_out)
  );

  //Wire declarations for instance 'inst62' (Module Mux4x4)
  wire [3:0] inst62_I0;
  wire [3:0] inst62_I1;
  wire [3:0] inst62_I2;
  wire [3:0] inst62_I3;
  wire [3:0] inst62_O;
  wire [1:0] inst62_S;
  Mux4x4 inst62(
    .I0(inst62_I0),
    .I1(inst62_I1),
    .I2(inst62_I2),
    .I3(inst62_I3),
    .O(inst62_O),
    .S(inst62_S)
  );

  //Wire declarations for instance 'inst63' (Module corebit_not)
  wire  inst63_in;
  wire  inst63_out;
  corebit_not inst63(
    .in(inst63_in),
    .out(inst63_out)
  );

  //Wire declarations for instance 'inst64' (Module and_wrapped)
  wire  inst64_I0;
  wire  inst64_I1;
  wire  inst64_O;
  and_wrapped inst64(
    .I0(inst64_I0),
    .I1(inst64_I1),
    .O(inst64_O)
  );

  //Wire declarations for instance 'inst65' (Module corebit_not)
  wire  inst65_in;
  wire  inst65_out;
  corebit_not inst65(
    .in(inst65_in),
    .out(inst65_out)
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

  //Wire declarations for instance 'inst69' (Module Decoder2)
  wire [1:0] inst69_I;
  wire [3:0] inst69_O;
  Decoder2 inst69(
    .I(inst69_I),
    .O(inst69_O)
  );

  //Wire declarations for instance 'inst7' (Module SilicaOneHotMux8None)
  wire  inst7_I0;
  wire  inst7_I3;
  wire  inst7_O;
  wire  inst7_I4;
  wire  inst7_I2;
  wire  inst7_I1;
  wire  inst7_I7;
  wire  inst7_I5;
  wire  inst7_I6;
  wire [7:0] inst7_S;
  SilicaOneHotMux8None inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .I2(inst7_I2),
    .I3(inst7_I3),
    .I4(inst7_I4),
    .I5(inst7_I5),
    .I6(inst7_I6),
    .I7(inst7_I7),
    .O(inst7_O),
    .S(inst7_S)
  );

  //Wire declarations for instance 'inst70' (Module Mux2x4)
  wire [3:0] inst70_I0;
  wire [3:0] inst70_I1;
  wire [3:0] inst70_O;
  wire  inst70_S;
  Mux2x4 inst70(
    .I0(inst70_I0),
    .I1(inst70_I1),
    .O(inst70_O),
    .S(inst70_S)
  );

  //Wire declarations for instance 'inst71' (Module Mux2x4)
  wire [3:0] inst71_I0;
  wire [3:0] inst71_I1;
  wire [3:0] inst71_O;
  wire  inst71_S;
  Mux2x4 inst71(
    .I0(inst71_I0),
    .I1(inst71_I1),
    .O(inst71_O),
    .S(inst71_S)
  );

  //Wire declarations for instance 'inst72' (Module Mux2x4)
  wire [3:0] inst72_I0;
  wire [3:0] inst72_I1;
  wire [3:0] inst72_O;
  wire  inst72_S;
  Mux2x4 inst72(
    .I0(inst72_I0),
    .I1(inst72_I1),
    .O(inst72_O),
    .S(inst72_S)
  );

  //Wire declarations for instance 'inst73' (Module Mux2x4)
  wire [3:0] inst73_I0;
  wire [3:0] inst73_I1;
  wire [3:0] inst73_O;
  wire  inst73_S;
  Mux2x4 inst73(
    .I0(inst73_I0),
    .I1(inst73_I1),
    .O(inst73_O),
    .S(inst73_S)
  );

  //Wire declarations for instance 'inst74' (Module Add2)
  wire [1:0] inst74_I0;
  wire [1:0] inst74_I1;
  wire [1:0] inst74_O;
  Add2 inst74(
    .I0(inst74_I0),
    .I1(inst74_I1),
    .O(inst74_O)
  );

  //Wire declarations for instance 'inst75' (Module EQ2)
  wire [1:0] inst75_I0;
  wire [1:0] inst75_I1;
  wire  inst75_O;
  EQ2 inst75(
    .I0(inst75_I0),
    .I1(inst75_I1),
    .O(inst75_O)
  );

  //Wire declarations for instance 'inst76' (Module Mux4x4)
  wire [3:0] inst76_I0;
  wire [3:0] inst76_I1;
  wire [3:0] inst76_I2;
  wire [3:0] inst76_I3;
  wire [3:0] inst76_O;
  wire [1:0] inst76_S;
  Mux4x4 inst76(
    .I0(inst76_I0),
    .I1(inst76_I1),
    .I2(inst76_I2),
    .I3(inst76_I3),
    .O(inst76_O),
    .S(inst76_S)
  );

  //Wire declarations for instance 'inst77' (Module corebit_not)
  wire  inst77_in;
  wire  inst77_out;
  corebit_not inst77(
    .in(inst77_in),
    .out(inst77_out)
  );

  //Wire declarations for instance 'inst78' (Module and_wrapped)
  wire  inst78_I0;
  wire  inst78_I1;
  wire  inst78_O;
  and_wrapped inst78(
    .I0(inst78_I0),
    .I1(inst78_I1),
    .O(inst78_O)
  );

  //Wire declarations for instance 'inst79' (Module Add2)
  wire [1:0] inst79_I0;
  wire [1:0] inst79_I1;
  wire [1:0] inst79_O;
  Add2 inst79(
    .I0(inst79_I0),
    .I1(inst79_I1),
    .O(inst79_O)
  );

  //Wire declarations for instance 'inst8' (Module Register4)
  wire  inst8_CLK;
  wire [3:0] inst8_I;
  wire [3:0] inst8_O;
  Register4 inst8(
    .CLK(inst8_CLK),
    .I(inst8_I),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst80' (Module EQ2)
  wire [1:0] inst80_I0;
  wire [1:0] inst80_I1;
  wire  inst80_O;
  EQ2 inst80(
    .I0(inst80_I0),
    .I1(inst80_I1),
    .O(inst80_O)
  );

  //Wire declarations for instance 'inst81' (Module And3xNone)
  wire  inst81_I0;
  wire  inst81_I1;
  wire  inst81_I2;
  wire  inst81_O;
  And3xNone inst81(
    .I0(inst81_I0),
    .I1(inst81_I1),
    .I2(inst81_I2),
    .O(inst81_O)
  );

  //Wire declarations for instance 'inst82' (Module corebit_not)
  wire  inst82_in;
  wire  inst82_out;
  corebit_not inst82(
    .in(inst82_in),
    .out(inst82_out)
  );

  //Wire declarations for instance 'inst83' (Module and_wrapped)
  wire  inst83_I0;
  wire  inst83_I1;
  wire  inst83_O;
  and_wrapped inst83(
    .I0(inst83_I0),
    .I1(inst83_I1),
    .O(inst83_O)
  );

  //Wire declarations for instance 'inst84' (Module Decoder2)
  wire [1:0] inst84_I;
  wire [3:0] inst84_O;
  Decoder2 inst84(
    .I(inst84_I),
    .O(inst84_O)
  );

  //Wire declarations for instance 'inst85' (Module Mux2x4)
  wire [3:0] inst85_I0;
  wire [3:0] inst85_I1;
  wire [3:0] inst85_O;
  wire  inst85_S;
  Mux2x4 inst85(
    .I0(inst85_I0),
    .I1(inst85_I1),
    .O(inst85_O),
    .S(inst85_S)
  );

  //Wire declarations for instance 'inst86' (Module Mux2x4)
  wire [3:0] inst86_I0;
  wire [3:0] inst86_I1;
  wire [3:0] inst86_O;
  wire  inst86_S;
  Mux2x4 inst86(
    .I0(inst86_I0),
    .I1(inst86_I1),
    .O(inst86_O),
    .S(inst86_S)
  );

  //Wire declarations for instance 'inst87' (Module Mux2x4)
  wire [3:0] inst87_I0;
  wire [3:0] inst87_I1;
  wire [3:0] inst87_O;
  wire  inst87_S;
  Mux2x4 inst87(
    .I0(inst87_I0),
    .I1(inst87_I1),
    .O(inst87_O),
    .S(inst87_S)
  );

  //Wire declarations for instance 'inst88' (Module Mux2x4)
  wire [3:0] inst88_I0;
  wire [3:0] inst88_I1;
  wire [3:0] inst88_O;
  wire  inst88_S;
  Mux2x4 inst88(
    .I0(inst88_I0),
    .I1(inst88_I1),
    .O(inst88_O),
    .S(inst88_S)
  );

  //Wire declarations for instance 'inst89' (Module Add2)
  wire [1:0] inst89_I0;
  wire [1:0] inst89_I1;
  wire [1:0] inst89_O;
  Add2 inst89(
    .I0(inst89_I0),
    .I1(inst89_I1),
    .O(inst89_O)
  );

  //Wire declarations for instance 'inst9' (Module Register4)
  wire  inst9_CLK;
  wire [3:0] inst9_I;
  wire [3:0] inst9_O;
  Register4 inst9(
    .CLK(inst9_CLK),
    .I(inst9_I),
    .O(inst9_O)
  );

  //Wire declarations for instance 'inst90' (Module EQ2)
  wire [1:0] inst90_I0;
  wire [1:0] inst90_I1;
  wire  inst90_O;
  EQ2 inst90(
    .I0(inst90_I0),
    .I1(inst90_I1),
    .O(inst90_O)
  );

  //Wire declarations for instance 'inst91' (Module Mux4x4)
  wire [3:0] inst91_I0;
  wire [3:0] inst91_I1;
  wire [3:0] inst91_I2;
  wire [3:0] inst91_I3;
  wire [3:0] inst91_O;
  wire [1:0] inst91_S;
  Mux4x4 inst91(
    .I0(inst91_I0),
    .I1(inst91_I1),
    .I2(inst91_I2),
    .I3(inst91_I3),
    .O(inst91_O),
    .S(inst91_S)
  );

  //Wire declarations for instance 'inst92' (Module corebit_not)
  wire  inst92_in;
  wire  inst92_out;
  corebit_not inst92(
    .in(inst92_in),
    .out(inst92_out)
  );

  //Wire declarations for instance 'inst93' (Module and_wrapped)
  wire  inst93_I0;
  wire  inst93_I1;
  wire  inst93_O;
  and_wrapped inst93(
    .I0(inst93_I0),
    .I1(inst93_I1),
    .O(inst93_O)
  );

  //Wire declarations for instance 'inst94' (Module corebit_not)
  wire  inst94_in;
  wire  inst94_out;
  corebit_not inst94(
    .in(inst94_in),
    .out(inst94_out)
  );

  //Wire declarations for instance 'inst95' (Module And3xNone)
  wire  inst95_I0;
  wire  inst95_I1;
  wire  inst95_I2;
  wire  inst95_O;
  And3xNone inst95(
    .I0(inst95_I0),
    .I1(inst95_I1),
    .I2(inst95_I2),
    .O(inst95_O)
  );

  //Wire declarations for instance 'inst96' (Module corebit_not)
  wire  inst96_in;
  wire  inst96_out;
  corebit_not inst96(
    .in(inst96_in),
    .out(inst96_out)
  );

  //Wire declarations for instance 'inst97' (Module and_wrapped)
  wire  inst97_I0;
  wire  inst97_I1;
  wire  inst97_O;
  and_wrapped inst97(
    .I0(inst97_I0),
    .I1(inst97_I1),
    .O(inst97_O)
  );

  //Wire declarations for instance 'inst98' (Module corebit_not)
  wire  inst98_in;
  wire  inst98_out;
  corebit_not inst98(
    .in(inst98_in),
    .out(inst98_out)
  );

  //Wire declarations for instance 'inst99' (Module Mux4x4)
  wire [3:0] inst99_I0;
  wire [3:0] inst99_I1;
  wire [3:0] inst99_I2;
  wire [3:0] inst99_I3;
  wire [3:0] inst99_O;
  wire [1:0] inst99_S;
  Mux4x4 inst99(
    .I0(inst99_I0),
    .I1(inst99_I1),
    .I2(inst99_I2),
    .I3(inst99_I3),
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
  assign inst17_I0 = bit_const_GND_out;
  assign inst17_I2 = bit_const_GND_out;
  assign inst17_I4 = bit_const_GND_out;
  assign inst17_I6 = bit_const_GND_out;
  assign inst18_I1 = bit_const_GND_out;
  assign inst18_I5 = bit_const_GND_out;
  assign inst20_I0 = bit_const_GND_out;
  assign inst20_I2 = bit_const_GND_out;
  assign inst20_I4 = bit_const_GND_out;
  assign inst20_I6 = bit_const_GND_out;
  assign inst7_I1 = bit_const_GND_out;
  assign inst7_I5 = bit_const_GND_out;
  assign inst1_I[0] = bit_const_GND_out;
  assign inst102_I1[1] = bit_const_GND_out;
  assign inst28_I1[1] = bit_const_GND_out;
  assign inst33_I1[1] = bit_const_GND_out;
  assign inst43_I1[1] = bit_const_GND_out;
  assign inst56_I1[1] = bit_const_GND_out;
  assign inst74_I1[1] = bit_const_GND_out;
  assign inst79_I1[1] = bit_const_GND_out;
  assign inst89_I1[1] = bit_const_GND_out;
  assign inst1_I[1] = bit_const_VCC_out;
  assign inst102_I1[0] = bit_const_VCC_out;
  assign inst28_I1[0] = bit_const_VCC_out;
  assign inst33_I1[0] = bit_const_VCC_out;
  assign inst43_I1[0] = bit_const_VCC_out;
  assign inst56_I1[0] = bit_const_VCC_out;
  assign inst74_I1[0] = bit_const_VCC_out;
  assign inst79_I1[0] = bit_const_VCC_out;
  assign inst89_I1[0] = bit_const_VCC_out;
  assign inst12_S[7:0] = inst0_O[7:0];
  assign inst13_S[7:0] = inst0_O[7:0];
  assign inst14_S[7:0] = inst0_O[7:0];
  assign inst15_S[7:0] = inst0_O[7:0];
  assign inst17_S[7:0] = inst0_O[7:0];
  assign inst18_S[7:0] = inst0_O[7:0];
  assign inst19_S[7:0] = inst0_O[7:0];
  assign inst20_S[7:0] = inst0_O[7:0];
  assign inst3_S[7:0] = inst0_O[7:0];
  assign inst5_S[7:0] = inst0_O[7:0];
  assign inst7_S[7:0] = inst0_O[7:0];
  assign inst1_CLK = CLK;
  assign inst10_CLK = CLK;
  assign inst10_I[3:0] = inst14_O[3:0];
  assign inst108_I2[3:0] = inst10_O[3:0];
  assign inst14_I2[3:0] = inst10_O[3:0];
  assign inst14_I3[3:0] = inst10_O[3:0];
  assign inst14_I6[3:0] = inst10_O[3:0];
  assign inst14_I7[3:0] = inst10_O[3:0];
  assign inst26_I0[3:0] = inst10_O[3:0];
  assign inst41_I0[3:0] = inst10_O[3:0];
  assign inst53_I2[3:0] = inst10_O[3:0];
  assign inst62_I2[3:0] = inst10_O[3:0];
  assign inst72_I0[3:0] = inst10_O[3:0];
  assign inst87_I0[3:0] = inst10_O[3:0];
  assign inst99_I2[3:0] = inst10_O[3:0];
  assign inst100_in = prev_empty_O;
  assign inst101_I1 = inst100_out;
  assign inst101_I0 = ren;
  assign inst104_I2 = inst101_O;
  assign inst102_I0[1:0] = inst2_O[1:0];
  assign inst103_I0[1:0] = inst102_O[1:0];
  assign inst3_I6[1:0] = inst102_O[1:0];
  assign inst103_I1[1:0] = inst4_O[1:0];
  assign inst18_I6 = inst103_O;
  assign inst7_I6 = inst103_O;
  assign inst104_I0 = inst1_O[1];
  assign inst104_I1 = inst98_out;
  assign inst0_I[6] = inst104_O;
  assign inst105_in = prev_full_O;
  assign inst106_I1 = inst105_out;
  assign inst106_I0 = wen;
  assign inst107_in = inst106_O;
  assign inst112_I1 = inst107_out;
  assign inst108_I0[3:0] = inst8_O[3:0];
  assign inst108_I1[3:0] = inst9_O[3:0];
  assign inst108_I3[3:0] = inst11_O[3:0];
  assign inst19_I7[3:0] = inst108_O[3:0];
  assign inst108_S[1:0] = inst2_O[1:0];
  assign inst109_in = prev_empty_O;
  assign inst110_I1 = inst109_out;
  assign inst11_CLK = CLK;
  assign inst11_I[3:0] = inst15_O[3:0];
  assign inst15_I2[3:0] = inst11_O[3:0];
  assign inst15_I3[3:0] = inst11_O[3:0];
  assign inst15_I6[3:0] = inst11_O[3:0];
  assign inst15_I7[3:0] = inst11_O[3:0];
  assign inst27_I0[3:0] = inst11_O[3:0];
  assign inst42_I0[3:0] = inst11_O[3:0];
  assign inst53_I3[3:0] = inst11_O[3:0];
  assign inst62_I3[3:0] = inst11_O[3:0];
  assign inst73_I0[3:0] = inst11_O[3:0];
  assign inst88_I0[3:0] = inst11_O[3:0];
  assign inst99_I3[3:0] = inst11_O[3:0];
  assign inst110_I0 = ren;
  assign inst111_in = inst110_O;
  assign inst112_I2 = inst111_out;
  assign inst112_I0 = inst1_O[1];
  assign inst0_I[7] = inst112_O;
  assign inst12_I0[3:0] = inst24_O[3:0];
  assign inst12_I1[3:0] = inst39_O[3:0];
  assign inst12_I2[3:0] = inst8_O[3:0];
  assign inst12_I3[3:0] = inst8_O[3:0];
  assign inst12_I4[3:0] = inst70_O[3:0];
  assign inst12_I5[3:0] = inst85_O[3:0];
  assign inst12_I6[3:0] = inst8_O[3:0];
  assign inst12_I7[3:0] = inst8_O[3:0];
  assign inst8_I[3:0] = inst12_O[3:0];
  assign inst13_I0[3:0] = inst25_O[3:0];
  assign inst13_I1[3:0] = inst40_O[3:0];
  assign inst13_I2[3:0] = inst9_O[3:0];
  assign inst13_I3[3:0] = inst9_O[3:0];
  assign inst13_I4[3:0] = inst71_O[3:0];
  assign inst13_I5[3:0] = inst86_O[3:0];
  assign inst13_I6[3:0] = inst9_O[3:0];
  assign inst13_I7[3:0] = inst9_O[3:0];
  assign inst9_I[3:0] = inst13_O[3:0];
  assign inst14_I0[3:0] = inst26_O[3:0];
  assign inst14_I1[3:0] = inst41_O[3:0];
  assign inst14_I4[3:0] = inst72_O[3:0];
  assign inst14_I5[3:0] = inst87_O[3:0];
  assign inst15_I0[3:0] = inst27_O[3:0];
  assign inst15_I1[3:0] = inst42_O[3:0];
  assign inst15_I4[3:0] = inst73_O[3:0];
  assign inst15_I5[3:0] = inst88_O[3:0];
  assign inst17_I1 = inst44_O;
  assign inst17_I3 = prev_full_O;
  assign inst17_I5 = inst90_O;
  assign inst17_I7 = prev_full_O;
  assign prev_full_I = inst17_O;
  assign inst18_I0 = inst34_O;
  assign inst18_I2 = inst57_O;
  assign inst18_I3 = prev_empty_O;
  assign inst18_I4 = inst80_O;
  assign inst18_I7 = prev_empty_O;
  assign empty = inst18_O;
  assign inst19_I0[3:0] = inst30_O[3:0];
  assign inst19_I1[3:0] = inst45_O[3:0];
  assign inst19_I2[3:0] = inst53_O[3:0];
  assign inst19_I3[3:0] = inst62_O[3:0];
  assign inst19_I4[3:0] = inst76_O[3:0];
  assign inst19_I5[3:0] = inst91_O[3:0];
  assign inst19_I6[3:0] = inst99_O[3:0];
  assign rdata[3:0] = inst19_O[3:0];
  assign inst2_CLK = CLK;
  assign inst2_I[1:0] = inst3_O[1:0];
  assign inst29_I0[1:0] = inst2_O[1:0];
  assign inst3_I1[1:0] = inst2_O[1:0];
  assign inst3_I3[1:0] = inst2_O[1:0];
  assign inst3_I5[1:0] = inst2_O[1:0];
  assign inst3_I7[1:0] = inst2_O[1:0];
  assign inst30_S[1:0] = inst2_O[1:0];
  assign inst33_I0[1:0] = inst2_O[1:0];
  assign inst44_I0[1:0] = inst2_O[1:0];
  assign inst45_S[1:0] = inst2_O[1:0];
  assign inst53_S[1:0] = inst2_O[1:0];
  assign inst56_I0[1:0] = inst2_O[1:0];
  assign inst62_S[1:0] = inst2_O[1:0];
  assign inst75_I0[1:0] = inst2_O[1:0];
  assign inst76_S[1:0] = inst2_O[1:0];
  assign inst79_I0[1:0] = inst2_O[1:0];
  assign inst90_I0[1:0] = inst2_O[1:0];
  assign inst91_S[1:0] = inst2_O[1:0];
  assign inst99_S[1:0] = inst2_O[1:0];
  assign inst20_I1 = inst44_O;
  assign inst20_I3 = prev_full_O;
  assign inst20_I5 = inst90_O;
  assign inst20_I7 = prev_full_O;
  assign full = inst20_O;
  assign inst21_in = prev_full_O;
  assign inst22_I1 = inst21_out;
  assign inst22_I0 = wen;
  assign inst35_I1 = inst22_O;
  assign inst23_I[1:0] = inst4_O[1:0];
  assign inst24_I0[3:0] = inst8_O[3:0];
  assign inst24_I1[3:0] = wdata[3:0];
  assign inst30_I0[3:0] = inst24_O[3:0];
  assign inst24_S = inst23_O[0];
  assign inst25_I0[3:0] = inst9_O[3:0];
  assign inst25_I1[3:0] = wdata[3:0];
  assign inst30_I1[3:0] = inst25_O[3:0];
  assign inst25_S = inst23_O[1];
  assign inst26_I1[3:0] = wdata[3:0];
  assign inst30_I2[3:0] = inst26_O[3:0];
  assign inst26_S = inst23_O[2];
  assign inst27_I1[3:0] = wdata[3:0];
  assign inst30_I3[3:0] = inst27_O[3:0];
  assign inst27_S = inst23_O[3];
  assign inst28_I0[1:0] = inst4_O[1:0];
  assign inst29_I1[1:0] = inst28_O[1:0];
  assign inst34_I1[1:0] = inst28_O[1:0];
  assign inst5_I0[1:0] = inst28_O[1:0];
  assign inst3_I0[1:0] = inst33_O[1:0];
  assign inst3_I2[1:0] = inst56_O[1:0];
  assign inst3_I4[1:0] = inst79_O[1:0];
  assign inst31_in = prev_empty_O;
  assign inst32_I1 = inst31_out;
  assign inst32_I0 = ren;
  assign inst35_I2 = inst32_O;
  assign inst34_I0[1:0] = inst33_O[1:0];
  assign inst7_I0 = inst34_O;
  assign inst35_I0 = inst1_O[0];
  assign inst0_I[0] = inst35_O;
  assign inst36_in = prev_full_O;
  assign inst37_I1 = inst36_out;
  assign inst37_I0 = wen;
  assign inst49_I1 = inst37_O;
  assign inst38_I[1:0] = inst4_O[1:0];
  assign inst39_I0[3:0] = inst8_O[3:0];
  assign inst39_I1[3:0] = wdata[3:0];
  assign inst45_I0[3:0] = inst39_O[3:0];
  assign inst39_S = inst38_O[0];
  assign inst4_CLK = CLK;
  assign inst4_I[1:0] = inst5_O[1:0];
  assign inst43_I0[1:0] = inst4_O[1:0];
  assign inst5_I2[1:0] = inst4_O[1:0];
  assign inst5_I3[1:0] = inst4_O[1:0];
  assign inst5_I6[1:0] = inst4_O[1:0];
  assign inst5_I7[1:0] = inst4_O[1:0];
  assign inst57_I1[1:0] = inst4_O[1:0];
  assign inst69_I[1:0] = inst4_O[1:0];
  assign inst74_I0[1:0] = inst4_O[1:0];
  assign inst84_I[1:0] = inst4_O[1:0];
  assign inst89_I0[1:0] = inst4_O[1:0];
  assign inst40_I0[3:0] = inst9_O[3:0];
  assign inst40_I1[3:0] = wdata[3:0];
  assign inst45_I1[3:0] = inst40_O[3:0];
  assign inst40_S = inst38_O[1];
  assign inst41_I1[3:0] = wdata[3:0];
  assign inst45_I2[3:0] = inst41_O[3:0];
  assign inst41_S = inst38_O[2];
  assign inst42_I1[3:0] = wdata[3:0];
  assign inst45_I3[3:0] = inst42_O[3:0];
  assign inst42_S = inst38_O[3];
  assign inst44_I1[1:0] = inst43_O[1:0];
  assign inst5_I1[1:0] = inst43_O[1:0];
  assign inst46_in = prev_empty_O;
  assign inst47_I1 = inst46_out;
  assign inst47_I0 = ren;
  assign inst48_in = inst47_O;
  assign inst49_I2 = inst48_out;
  assign inst49_I0 = inst1_O[0];
  assign inst0_I[1] = inst49_O;
  assign inst5_I4[1:0] = inst74_O[1:0];
  assign inst5_I5[1:0] = inst89_O[1:0];
  assign inst50_in = prev_full_O;
  assign inst51_I1 = inst50_out;
  assign inst51_I0 = wen;
  assign inst52_in = inst51_O;
  assign inst58_I1 = inst52_out;
  assign inst53_I0[3:0] = inst8_O[3:0];
  assign inst53_I1[3:0] = inst9_O[3:0];
  assign inst54_in = prev_empty_O;
  assign inst55_I1 = inst54_out;
  assign inst55_I0 = ren;
  assign inst58_I2 = inst55_O;
  assign inst57_I0[1:0] = inst56_O[1:0];
  assign inst7_I2 = inst57_O;
  assign inst58_I0 = inst1_O[0];
  assign inst0_I[2] = inst58_O;
  assign inst59_in = prev_full_O;
  assign inst60_I1 = inst59_out;
  assign inst60_I0 = wen;
  assign inst61_in = inst60_O;
  assign inst66_I1 = inst61_out;
  assign inst62_I0[3:0] = inst8_O[3:0];
  assign inst62_I1[3:0] = inst9_O[3:0];
  assign inst63_in = prev_empty_O;
  assign inst64_I1 = inst63_out;
  assign inst64_I0 = ren;
  assign inst65_in = inst64_O;
  assign inst66_I2 = inst65_out;
  assign inst66_I0 = inst1_O[0];
  assign inst0_I[3] = inst66_O;
  assign inst67_in = prev_full_O;
  assign inst68_I1 = inst67_out;
  assign inst68_I0 = wen;
  assign inst81_I1 = inst68_O;
  assign inst7_I3 = prev_empty_O;
  assign inst7_I4 = inst80_O;
  assign inst7_I7 = prev_empty_O;
  assign prev_empty_I = inst7_O;
  assign inst70_I0[3:0] = inst8_O[3:0];
  assign inst70_I1[3:0] = wdata[3:0];
  assign inst76_I0[3:0] = inst70_O[3:0];
  assign inst70_S = inst69_O[0];
  assign inst71_I0[3:0] = inst9_O[3:0];
  assign inst71_I1[3:0] = wdata[3:0];
  assign inst76_I1[3:0] = inst71_O[3:0];
  assign inst71_S = inst69_O[1];
  assign inst72_I1[3:0] = wdata[3:0];
  assign inst76_I2[3:0] = inst72_O[3:0];
  assign inst72_S = inst69_O[2];
  assign inst73_I1[3:0] = wdata[3:0];
  assign inst76_I3[3:0] = inst73_O[3:0];
  assign inst73_S = inst69_O[3];
  assign inst75_I1[1:0] = inst74_O[1:0];
  assign inst80_I1[1:0] = inst74_O[1:0];
  assign inst77_in = prev_empty_O;
  assign inst78_I1 = inst77_out;
  assign inst78_I0 = ren;
  assign inst81_I2 = inst78_O;
  assign inst80_I0[1:0] = inst79_O[1:0];
  assign inst8_CLK = CLK;
  assign inst85_I0[3:0] = inst8_O[3:0];
  assign inst99_I0[3:0] = inst8_O[3:0];
  assign inst81_I0 = inst1_O[1];
  assign inst0_I[4] = inst81_O;
  assign inst82_in = prev_full_O;
  assign inst83_I1 = inst82_out;
  assign inst83_I0 = wen;
  assign inst95_I1 = inst83_O;
  assign inst85_I1[3:0] = wdata[3:0];
  assign inst91_I0[3:0] = inst85_O[3:0];
  assign inst85_S = inst84_O[0];
  assign inst86_I0[3:0] = inst9_O[3:0];
  assign inst86_I1[3:0] = wdata[3:0];
  assign inst91_I1[3:0] = inst86_O[3:0];
  assign inst86_S = inst84_O[1];
  assign inst87_I1[3:0] = wdata[3:0];
  assign inst91_I2[3:0] = inst87_O[3:0];
  assign inst87_S = inst84_O[2];
  assign inst88_I1[3:0] = wdata[3:0];
  assign inst91_I3[3:0] = inst88_O[3:0];
  assign inst88_S = inst84_O[3];
  assign inst90_I1[1:0] = inst89_O[1:0];
  assign inst9_CLK = CLK;
  assign inst99_I1[3:0] = inst9_O[3:0];
  assign inst92_in = prev_empty_O;
  assign inst93_I1 = inst92_out;
  assign inst93_I0 = ren;
  assign inst94_in = inst93_O;
  assign inst95_I2 = inst94_out;
  assign inst95_I0 = inst1_O[1];
  assign inst0_I[5] = inst95_O;
  assign inst96_in = prev_full_O;
  assign inst97_I1 = inst96_out;
  assign inst97_I0 = wen;
  assign inst98_in = inst97_O;
  assign prev_empty_CLK = CLK;
  assign prev_full_CLK = CLK;

endmodule //Fifo
