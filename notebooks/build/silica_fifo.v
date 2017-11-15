

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

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

module corebit_mux (
  input in0,
  input in1,
  input sel,
  output out
);
  assign out = sel ? in1 : in0;

endmodule //corebit_mux

module and_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_and)
  wire  inst0__in0;
  wire  inst0__in1;
  wire  inst0__out;
  corebit_and inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0 = I0;
  assign inst0__in1 = I1;
  assign O = inst0__out;

endmodule //and_wrapped

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

module coreir_add #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 + in1;

endmodule //coreir_add

module EQ2 (
  input [1:0] I0,
  input [1:0] I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_eq)
  wire [1:0] inst0__in0;
  wire [1:0] inst0__in1;
  wire  inst0__out;
  coreir_eq #(.width(2)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[1:0] = I0[1:0];
  assign inst0__in1[1:0] = I1[1:0];
  assign O = inst0__out;

endmodule //EQ2

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module Decode12 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND__out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND__out)
  );

  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC__out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC__out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire  inst0__O;
  EQ2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //All the connections
  assign inst0__I1[1] = bit_const_GND__out;
  assign inst0__I1[0] = bit_const_VCC__out;
  assign inst0__I0[1:0] = I[1:0];
  assign O = inst0__O;

endmodule //Decode12

module coreir_andr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = &in;

endmodule //coreir_andr

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module Add2 (
  input [1:0] I0,
  input [1:0] I1,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_add)
  wire [1:0] inst0__in0;
  wire [1:0] inst0__in1;
  wire [1:0] inst0__out;
  coreir_add #(.width(2)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[1:0] = I0[1:0];
  assign inst0__in1[1:0] = I1[1:0];
  assign O[1:0] = inst0__out[1:0];

endmodule //Add2

module And3xNone (
  input  I0,
  input  I1,
  input  I2,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_andr)
  wire [2:0] inst0__in;
  wire  inst0__out;
  coreir_andr #(.width(3)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign O = inst0__out;
  assign inst0__in[0] = I0;
  assign inst0__in[1] = I1;
  assign inst0__in[2] = I2;

endmodule //And3xNone

module Decode02 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND__out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND__out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire  inst0__O;
  EQ2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //All the connections
  assign inst0__I1[0] = bit_const_GND__out;
  assign inst0__I1[1] = bit_const_GND__out;
  assign inst0__I0[1:0] = I[1:0];
  assign O = inst0__O;

endmodule //Decode02

module Decode22 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND__out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND__out)
  );

  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC__out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC__out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire  inst0__O;
  EQ2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //All the connections
  assign inst0__I1[0] = bit_const_GND__out;
  assign inst0__I1[1] = bit_const_VCC__out;
  assign inst0__I0[1:0] = I[1:0];
  assign O = inst0__O;

endmodule //Decode22

module Decode32 (
  input [1:0] I,
  output  O
);
  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC__out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC__out)
  );

  //Wire declarations for instance 'inst0' (Module EQ2)
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire  inst0__O;
  EQ2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //All the connections
  assign inst0__I1[0] = bit_const_VCC__out;
  assign inst0__I1[1] = bit_const_VCC__out;
  assign inst0__I0[1:0] = I[1:0];
  assign O = inst0__O;

endmodule //Decode32

module Decoder2 (
  input [1:0] I,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module Decode02)
  wire [1:0] inst0__I;
  wire  inst0__O;
  Decode02 inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Decode12)
  wire [1:0] inst1__I;
  wire  inst1__O;
  Decode12 inst1(
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module Decode22)
  wire [1:0] inst2__I;
  wire  inst2__O;
  Decode22 inst2(
    .I(inst2__I),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module Decode32)
  wire [1:0] inst3__I;
  wire  inst3__O;
  Decode32 inst3(
    .I(inst3__I),
    .O(inst3__O)
  );

  //All the connections
  assign inst0__I[1:0] = I[1:0];
  assign O[0] = inst0__O;
  assign inst1__I[1:0] = I[1:0];
  assign O[1] = inst1__O;
  assign inst2__I[1:0] = I[1:0];
  assign O[2] = inst2__O;
  assign inst3__I[1:0] = I[1:0];
  assign O[3] = inst3__O;

endmodule //Decoder2

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
  wire [7:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [7:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(8)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //All the connections
  assign O[0] = inst0__out;
  assign O[1] = inst1__out;
  assign inst0__in[0] = I0[0];
  assign inst0__in[1] = I1[0];
  assign inst0__in[2] = I2[0];
  assign inst0__in[3] = I3[0];
  assign inst0__in[4] = I4[0];
  assign inst0__in[5] = I5[0];
  assign inst0__in[6] = I6[0];
  assign inst0__in[7] = I7[0];
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst1__in[5] = I5[1];
  assign inst1__in[6] = I6[1];
  assign inst1__in[7] = I7[1];

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
  wire [7:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [7:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(8)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [7:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(8)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [7:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(8)) inst3(
    .in(inst3__in),
    .out(inst3__out)
  );

  //All the connections
  assign O[0] = inst0__out;
  assign O[1] = inst1__out;
  assign O[2] = inst2__out;
  assign O[3] = inst3__out;
  assign inst0__in[0] = I0[0];
  assign inst0__in[1] = I1[0];
  assign inst0__in[2] = I2[0];
  assign inst0__in[3] = I3[0];
  assign inst0__in[4] = I4[0];
  assign inst0__in[5] = I5[0];
  assign inst0__in[6] = I6[0];
  assign inst0__in[7] = I7[0];
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst1__in[5] = I5[1];
  assign inst1__in[6] = I6[1];
  assign inst1__in[7] = I7[1];
  assign inst2__in[0] = I0[2];
  assign inst2__in[1] = I1[2];
  assign inst2__in[2] = I2[2];
  assign inst2__in[3] = I3[2];
  assign inst2__in[4] = I4[2];
  assign inst2__in[5] = I5[2];
  assign inst2__in[6] = I6[2];
  assign inst2__in[7] = I7[2];
  assign inst3__in[0] = I0[3];
  assign inst3__in[1] = I1[3];
  assign inst3__in[2] = I2[3];
  assign inst3__in[3] = I3[3];
  assign inst3__in[4] = I4[3];
  assign inst3__in[5] = I5[3];
  assign inst3__in[6] = I6[3];
  assign inst3__in[7] = I7[3];

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
  wire [7:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(8)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign O = inst0__out;
  assign inst0__in[0] = I0;
  assign inst0__in[1] = I1;
  assign inst0__in[2] = I2;
  assign inst0__in[3] = I3;
  assign inst0__in[4] = I4;
  assign inst0__in[5] = I5;
  assign inst0__in[6] = I6;
  assign inst0__in[7] = I7;

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
  wire  inst0__I0;
  wire  inst0__I1;
  wire  inst0__I2;
  wire  inst0__I3;
  wire  inst0__I4;
  wire  inst0__I5;
  wire  inst0__I6;
  wire  inst0__I7;
  wire  inst0__O;
  Or8xNone inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and_wrapped)
  wire  inst1__I0;
  wire  inst1__I1;
  wire  inst1__O;
  and_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and_wrapped)
  wire  inst2__I0;
  wire  inst2__I1;
  wire  inst2__O;
  and_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and_wrapped)
  wire  inst3__I0;
  wire  inst3__I1;
  wire  inst3__O;
  and_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and_wrapped)
  wire  inst4__I0;
  wire  inst4__I1;
  wire  inst4__O;
  and_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and_wrapped)
  wire  inst5__I0;
  wire  inst5__I1;
  wire  inst5__O;
  and_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module and_wrapped)
  wire  inst6__I0;
  wire  inst6__I1;
  wire  inst6__O;
  and_wrapped inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module and_wrapped)
  wire  inst7__I0;
  wire  inst7__I1;
  wire  inst7__O;
  and_wrapped inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module and_wrapped)
  wire  inst8__I0;
  wire  inst8__I1;
  wire  inst8__O;
  and_wrapped inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .O(inst8__O)
  );

  //All the connections
  assign inst0__I0 = inst1__O;
  assign inst0__I1 = inst2__O;
  assign inst0__I2 = inst3__O;
  assign inst0__I3 = inst4__O;
  assign inst0__I4 = inst5__O;
  assign inst0__I5 = inst6__O;
  assign inst0__I6 = inst7__O;
  assign inst0__I7 = inst8__O;
  assign O = inst0__O;
  assign inst1__I0 = I0;
  assign inst1__I1 = S[0];
  assign inst2__I0 = I1;
  assign inst2__I1 = S[1];
  assign inst3__I0 = I2;
  assign inst3__I1 = S[2];
  assign inst4__I0 = I3;
  assign inst4__I1 = S[3];
  assign inst5__I0 = I4;
  assign inst5__I1 = S[4];
  assign inst6__I0 = I5;
  assign inst6__I1 = S[5];
  assign inst7__I0 = I6;
  assign inst7__I1 = S[6];
  assign inst8__I0 = I7;
  assign inst8__I1 = S[7];

endmodule //SilicaOneHotMux8None

module _Mux2 (
  input [1:0] I,
  output  O,
  input  S
);
  //Wire declarations for instance 'inst0' (Module corebit_mux)
  wire  inst0__in0;
  wire  inst0__in1;
  wire  inst0__out;
  wire  inst0__sel;
  corebit_mux inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out),
    .sel(inst0__sel)
  );

  //All the connections
  assign inst0__in0 = I[0];
  assign inst0__in1 = I[1];
  assign O = inst0__out;
  assign inst0__sel = S;

endmodule //_Mux2

module _Mux4 (
  input [3:0] I,
  output  O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module _Mux2)
  wire [1:0] inst0__I;
  wire  inst0__O;
  wire  inst0__S;
  _Mux2 inst0(
    .I(inst0__I),
    .O(inst0__O),
    .S(inst0__S)
  );

  //Wire declarations for instance 'inst1' (Module _Mux2)
  wire [1:0] inst1__I;
  wire  inst1__O;
  wire  inst1__S;
  _Mux2 inst1(
    .I(inst1__I),
    .O(inst1__O),
    .S(inst1__S)
  );

  //Wire declarations for instance 'inst2' (Module _Mux2)
  wire [1:0] inst2__I;
  wire  inst2__O;
  wire  inst2__S;
  _Mux2 inst2(
    .I(inst2__I),
    .O(inst2__O),
    .S(inst2__S)
  );

  //All the connections
  assign inst2__I[0] = inst0__O;
  assign inst0__S = S[0];
  assign inst2__I[1] = inst1__O;
  assign inst1__S = S[0];
  assign O = inst2__O;
  assign inst2__S = S[1];
  assign inst0__I[0] = I[0];
  assign inst0__I[1] = I[1];
  assign inst1__I[0] = I[2];
  assign inst1__I[1] = I[3];

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
  wire [3:0] inst0__I;
  wire  inst0__O;
  wire [1:0] inst0__S;
  _Mux4 inst0(
    .I(inst0__I),
    .O(inst0__O),
    .S(inst0__S)
  );

  //Wire declarations for instance 'inst1' (Module _Mux4)
  wire [3:0] inst1__I;
  wire  inst1__O;
  wire [1:0] inst1__S;
  _Mux4 inst1(
    .I(inst1__I),
    .O(inst1__O),
    .S(inst1__S)
  );

  //Wire declarations for instance 'inst2' (Module _Mux4)
  wire [3:0] inst2__I;
  wire  inst2__O;
  wire [1:0] inst2__S;
  _Mux4 inst2(
    .I(inst2__I),
    .O(inst2__O),
    .S(inst2__S)
  );

  //Wire declarations for instance 'inst3' (Module _Mux4)
  wire [3:0] inst3__I;
  wire  inst3__O;
  wire [1:0] inst3__S;
  _Mux4 inst3(
    .I(inst3__I),
    .O(inst3__O),
    .S(inst3__S)
  );

  //All the connections
  assign O[0] = inst0__O;
  assign inst0__S[1:0] = S[1:0];
  assign O[1] = inst1__O;
  assign inst1__S[1:0] = S[1:0];
  assign O[2] = inst2__O;
  assign inst2__S[1:0] = S[1:0];
  assign O[3] = inst3__O;
  assign inst3__S[1:0] = S[1:0];
  assign inst0__I[0] = I0[0];
  assign inst0__I[1] = I1[0];
  assign inst0__I[2] = I2[0];
  assign inst0__I[3] = I3[0];
  assign inst1__I[0] = I0[1];
  assign inst1__I[1] = I1[1];
  assign inst1__I[2] = I2[1];
  assign inst1__I[3] = I3[1];
  assign inst2__I[0] = I0[2];
  assign inst2__I[1] = I1[2];
  assign inst2__I[2] = I2[2];
  assign inst2__I[3] = I3[2];
  assign inst3__I[0] = I0[3];
  assign inst3__I[1] = I1[3];
  assign inst3__I[2] = I2[3];
  assign inst3__I[3] = I3[3];

endmodule //Mux4x4

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
  wire [1:0] inst0__in0;
  wire [1:0] inst0__in1;
  wire [1:0] inst0__out;
  coreir_and #(.width(2)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[1:0] = I0[1:0];
  assign inst0__in1[1:0] = I1[1:0];
  assign O[1:0] = inst0__out[1:0];

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
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire [1:0] inst0__I2;
  wire [1:0] inst0__I3;
  wire [1:0] inst0__I4;
  wire [1:0] inst0__I5;
  wire [1:0] inst0__I6;
  wire [1:0] inst0__I7;
  wire [1:0] inst0__O;
  Or8x2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and2_wrapped)
  wire [1:0] inst1__I0;
  wire [1:0] inst1__I1;
  wire [1:0] inst1__O;
  and2_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and2_wrapped)
  wire [1:0] inst2__I0;
  wire [1:0] inst2__I1;
  wire [1:0] inst2__O;
  and2_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and2_wrapped)
  wire [1:0] inst3__I0;
  wire [1:0] inst3__I1;
  wire [1:0] inst3__O;
  and2_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and2_wrapped)
  wire [1:0] inst4__I0;
  wire [1:0] inst4__I1;
  wire [1:0] inst4__O;
  and2_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and2_wrapped)
  wire [1:0] inst5__I0;
  wire [1:0] inst5__I1;
  wire [1:0] inst5__O;
  and2_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module and2_wrapped)
  wire [1:0] inst6__I0;
  wire [1:0] inst6__I1;
  wire [1:0] inst6__O;
  and2_wrapped inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module and2_wrapped)
  wire [1:0] inst7__I0;
  wire [1:0] inst7__I1;
  wire [1:0] inst7__O;
  and2_wrapped inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module and2_wrapped)
  wire [1:0] inst8__I0;
  wire [1:0] inst8__I1;
  wire [1:0] inst8__O;
  and2_wrapped inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .O(inst8__O)
  );

  //All the connections
  assign inst0__I0[1:0] = inst1__O[1:0];
  assign inst0__I1[1:0] = inst2__O[1:0];
  assign inst0__I2[1:0] = inst3__O[1:0];
  assign inst0__I3[1:0] = inst4__O[1:0];
  assign inst0__I4[1:0] = inst5__O[1:0];
  assign inst0__I5[1:0] = inst6__O[1:0];
  assign inst0__I6[1:0] = inst7__O[1:0];
  assign inst0__I7[1:0] = inst8__O[1:0];
  assign O[1:0] = inst0__O[1:0];
  assign inst1__I0[1:0] = I0[1:0];
  assign inst2__I0[1:0] = I1[1:0];
  assign inst3__I0[1:0] = I2[1:0];
  assign inst4__I0[1:0] = I3[1:0];
  assign inst5__I0[1:0] = I4[1:0];
  assign inst6__I0[1:0] = I5[1:0];
  assign inst7__I0[1:0] = I6[1:0];
  assign inst8__I0[1:0] = I7[1:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst3__I1[0] = S[2];
  assign inst3__I1[1] = S[2];
  assign inst4__I1[0] = S[3];
  assign inst4__I1[1] = S[3];
  assign inst5__I1[0] = S[4];
  assign inst5__I1[1] = S[4];
  assign inst6__I1[0] = S[5];
  assign inst6__I1[1] = S[5];
  assign inst7__I1[0] = S[6];
  assign inst7__I1[1] = S[6];
  assign inst8__I1[0] = S[7];
  assign inst8__I1[1] = S[7];

endmodule //SilicaOneHotMux82

module and4_wrapped (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [3:0] inst0__in0;
  wire [3:0] inst0__in1;
  wire [3:0] inst0__out;
  coreir_and #(.width(4)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[3:0] = I0[3:0];
  assign inst0__in1[3:0] = I1[3:0];
  assign O[3:0] = inst0__out[3:0];

endmodule //and4_wrapped

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
  wire [3:0] inst0__I0;
  wire [3:0] inst0__I1;
  wire [3:0] inst0__I2;
  wire [3:0] inst0__I3;
  wire [3:0] inst0__I4;
  wire [3:0] inst0__I5;
  wire [3:0] inst0__I6;
  wire [3:0] inst0__I7;
  wire [3:0] inst0__O;
  Or8x4 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and4_wrapped)
  wire [3:0] inst1__I0;
  wire [3:0] inst1__I1;
  wire [3:0] inst1__O;
  and4_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and4_wrapped)
  wire [3:0] inst2__I0;
  wire [3:0] inst2__I1;
  wire [3:0] inst2__O;
  and4_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and4_wrapped)
  wire [3:0] inst3__I0;
  wire [3:0] inst3__I1;
  wire [3:0] inst3__O;
  and4_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and4_wrapped)
  wire [3:0] inst4__I0;
  wire [3:0] inst4__I1;
  wire [3:0] inst4__O;
  and4_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and4_wrapped)
  wire [3:0] inst5__I0;
  wire [3:0] inst5__I1;
  wire [3:0] inst5__O;
  and4_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module and4_wrapped)
  wire [3:0] inst6__I0;
  wire [3:0] inst6__I1;
  wire [3:0] inst6__O;
  and4_wrapped inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module and4_wrapped)
  wire [3:0] inst7__I0;
  wire [3:0] inst7__I1;
  wire [3:0] inst7__O;
  and4_wrapped inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module and4_wrapped)
  wire [3:0] inst8__I0;
  wire [3:0] inst8__I1;
  wire [3:0] inst8__O;
  and4_wrapped inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .O(inst8__O)
  );

  //All the connections
  assign inst0__I0[3:0] = inst1__O[3:0];
  assign inst0__I1[3:0] = inst2__O[3:0];
  assign inst0__I2[3:0] = inst3__O[3:0];
  assign inst0__I3[3:0] = inst4__O[3:0];
  assign inst0__I4[3:0] = inst5__O[3:0];
  assign inst0__I5[3:0] = inst6__O[3:0];
  assign inst0__I6[3:0] = inst7__O[3:0];
  assign inst0__I7[3:0] = inst8__O[3:0];
  assign O[3:0] = inst0__O[3:0];
  assign inst1__I0[3:0] = I0[3:0];
  assign inst2__I0[3:0] = I1[3:0];
  assign inst3__I0[3:0] = I2[3:0];
  assign inst4__I0[3:0] = I3[3:0];
  assign inst5__I0[3:0] = I4[3:0];
  assign inst6__I0[3:0] = I5[3:0];
  assign inst7__I0[3:0] = I6[3:0];
  assign inst8__I0[3:0] = I7[3:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];
  assign inst3__I1[0] = S[2];
  assign inst3__I1[1] = S[2];
  assign inst3__I1[2] = S[2];
  assign inst3__I1[3] = S[2];
  assign inst4__I1[0] = S[3];
  assign inst4__I1[1] = S[3];
  assign inst4__I1[2] = S[3];
  assign inst4__I1[3] = S[3];
  assign inst5__I1[0] = S[4];
  assign inst5__I1[1] = S[4];
  assign inst5__I1[2] = S[4];
  assign inst5__I1[3] = S[4];
  assign inst6__I1[0] = S[5];
  assign inst6__I1[1] = S[5];
  assign inst6__I1[2] = S[5];
  assign inst6__I1[3] = S[5];
  assign inst7__I1[0] = S[6];
  assign inst7__I1[1] = S[6];
  assign inst7__I1[2] = S[6];
  assign inst7__I1[3] = S[6];
  assign inst8__I1[0] = S[7];
  assign inst8__I1[1] = S[7];
  assign inst8__I1[2] = S[7];
  assign inst8__I1[3] = S[7];

endmodule //SilicaOneHotMux84

module or4_wrapped (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [3:0] inst0__in0;
  wire [3:0] inst0__in1;
  wire [3:0] inst0__out;
  coreir_or #(.width(4)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[3:0] = I0[3:0];
  assign inst0__in1[3:0] = I1[3:0];
  assign O[3:0] = inst0__out[3:0];

endmodule //or4_wrapped

module SilicaOneHotMux24 (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module or4_wrapped)
  wire [3:0] inst0__I0;
  wire [3:0] inst0__I1;
  wire [3:0] inst0__O;
  or4_wrapped inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and4_wrapped)
  wire [3:0] inst1__I0;
  wire [3:0] inst1__I1;
  wire [3:0] inst1__O;
  and4_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and4_wrapped)
  wire [3:0] inst2__I0;
  wire [3:0] inst2__I1;
  wire [3:0] inst2__O;
  and4_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //All the connections
  assign inst0__I0[3:0] = inst1__O[3:0];
  assign inst0__I1[3:0] = inst2__O[3:0];
  assign O[3:0] = inst0__O[3:0];
  assign inst1__I0[3:0] = I0[3:0];
  assign inst2__I0[3:0] = I1[3:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];

endmodule //SilicaOneHotMux24

module reg_U2 #(parameter init=1) (
  input  clk,
  input [0:0] in,
  output [0:0] out
);
  //Wire declarations for instance 'reg0' (Module coreir_reg)
  wire  reg0__clk;
  wire [0:0] reg0__in;
  wire [0:0] reg0__out;
  coreir_reg #(.init(init),.width(1)) reg0(
    .clk(reg0__clk),
    .in(reg0__in),
    .out(reg0__out)
  );

  //All the connections
  assign reg0__clk = clk;
  assign reg0__in[0:0] = in[0:0];
  assign out[0:0] = reg0__out[0:0];

endmodule //reg_U2

module DFF_init1_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U2)
  wire  inst0__clk;
  wire [0:0] inst0__in;
  wire [0:0] inst0__out;
  reg_U2 #(.init(1'd1)) inst0(
    .clk(inst0__clk),
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__clk = CLK;
  assign inst0__in[0] = I;
  assign O = inst0__out[0];

endmodule //DFF_init1_has_ceFalse_has_resetFalse

module DFF_init0_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U2)
  wire  inst0__clk;
  wire [0:0] inst0__in;
  wire [0:0] inst0__out;
  reg_U2 #(.init(1'd0)) inst0(
    .clk(inst0__clk),
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__clk = CLK;
  assign inst0__in[0] = I;
  assign O = inst0__out[0];

endmodule //DFF_init0_has_ceFalse_has_resetFalse

module Register2_0001 (
  input  CLK,
  input [1:0] I,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init1_has_ceFalse_has_resetFalse)
  wire  inst0__CLK;
  wire  inst0__I;
  wire  inst0__O;
  DFF_init1_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0__CLK),
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1__CLK;
  wire  inst1__I;
  wire  inst1__O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //All the connections
  assign inst0__CLK = CLK;
  assign inst0__I = I[0];
  assign O[0] = inst0__O;
  assign inst1__CLK = CLK;
  assign inst1__I = I[1];
  assign O[1] = inst1__O;

endmodule //Register2_0001

module Register2 (
  input  CLK,
  input [1:0] I,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst0__CLK;
  wire  inst0__I;
  wire  inst0__O;
  DFF_init0_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0__CLK),
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1__CLK;
  wire  inst1__I;
  wire  inst1__O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //All the connections
  assign inst0__CLK = CLK;
  assign inst0__I = I[0];
  assign O[0] = inst0__O;
  assign inst1__CLK = CLK;
  assign inst1__I = I[1];
  assign O[1] = inst1__O;

endmodule //Register2

module Register4 (
  input  CLK,
  input [3:0] I,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst0__CLK;
  wire  inst0__I;
  wire  inst0__O;
  DFF_init0_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0__CLK),
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1__CLK;
  wire  inst1__I;
  wire  inst1__O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst2__CLK;
  wire  inst2__I;
  wire  inst2__O;
  DFF_init0_has_ceFalse_has_resetFalse inst2(
    .CLK(inst2__CLK),
    .I(inst2__I),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst3__CLK;
  wire  inst3__I;
  wire  inst3__O;
  DFF_init0_has_ceFalse_has_resetFalse inst3(
    .CLK(inst3__CLK),
    .I(inst3__I),
    .O(inst3__O)
  );

  //All the connections
  assign inst0__CLK = CLK;
  assign inst0__I = I[0];
  assign O[0] = inst0__O;
  assign inst1__CLK = CLK;
  assign inst1__I = I[1];
  assign O[1] = inst1__O;
  assign inst2__CLK = CLK;
  assign inst2__I = I[2];
  assign O[2] = inst2__O;
  assign inst3__CLK = CLK;
  assign inst3__I = I[3];
  assign O[3] = inst3__O;

endmodule //Register4

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
  wire  bit_const_GND__out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND__out)
  );

  //Wire declarations for instance 'bit_const_VCC' (Module corebit_const)
  wire  bit_const_VCC__out;
  corebit_const #(.value(1)) bit_const_VCC(
    .out(bit_const_VCC__out)
  );

  //Wire declarations for instance 'inst0' (Module __silica_BufferFifo)
  wire [7:0] inst0__I;
  wire [7:0] inst0__O;
  __silica_BufferFifo inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register2_0001)
  wire  inst1__CLK;
  wire [1:0] inst1__I;
  wire [1:0] inst1__O;
  Register2_0001 inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst10' (Module SilicaOneHotMux84)
  wire [3:0] inst10__I0;
  wire [3:0] inst10__I1;
  wire [3:0] inst10__I2;
  wire [3:0] inst10__I3;
  wire [3:0] inst10__I4;
  wire [3:0] inst10__I5;
  wire [3:0] inst10__I6;
  wire [3:0] inst10__I7;
  wire [3:0] inst10__O;
  wire [7:0] inst10__S;
  SilicaOneHotMux84 inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .I2(inst10__I2),
    .I3(inst10__I3),
    .I4(inst10__I4),
    .I5(inst10__I5),
    .I6(inst10__I6),
    .I7(inst10__I7),
    .O(inst10__O),
    .S(inst10__S)
  );

  //Wire declarations for instance 'inst100' (Module SilicaOneHotMux24)
  wire [3:0] inst100__I0;
  wire [3:0] inst100__I1;
  wire [3:0] inst100__O;
  wire [1:0] inst100__S;
  SilicaOneHotMux24 inst100(
    .I0(inst100__I0),
    .I1(inst100__I1),
    .O(inst100__O),
    .S(inst100__S)
  );

  //Wire declarations for instance 'inst101' (Module corebit_not)
  wire  inst101__in;
  wire  inst101__out;
  corebit_not inst101(
    .in(inst101__in),
    .out(inst101__out)
  );

  //Wire declarations for instance 'inst102' (Module SilicaOneHotMux24)
  wire [3:0] inst102__I0;
  wire [3:0] inst102__I1;
  wire [3:0] inst102__O;
  wire [1:0] inst102__S;
  SilicaOneHotMux24 inst102(
    .I0(inst102__I0),
    .I1(inst102__I1),
    .O(inst102__O),
    .S(inst102__S)
  );

  //Wire declarations for instance 'inst103' (Module corebit_not)
  wire  inst103__in;
  wire  inst103__out;
  corebit_not inst103(
    .in(inst103__in),
    .out(inst103__out)
  );

  //Wire declarations for instance 'inst104' (Module SilicaOneHotMux24)
  wire [3:0] inst104__I0;
  wire [3:0] inst104__I1;
  wire [3:0] inst104__O;
  wire [1:0] inst104__S;
  SilicaOneHotMux24 inst104(
    .I0(inst104__I0),
    .I1(inst104__I1),
    .O(inst104__O),
    .S(inst104__S)
  );

  //Wire declarations for instance 'inst105' (Module corebit_not)
  wire  inst105__in;
  wire  inst105__out;
  corebit_not inst105(
    .in(inst105__in),
    .out(inst105__out)
  );

  //Wire declarations for instance 'inst106' (Module Add2)
  wire [1:0] inst106__I0;
  wire [1:0] inst106__I1;
  wire [1:0] inst106__O;
  Add2 inst106(
    .I0(inst106__I0),
    .I1(inst106__I1),
    .O(inst106__O)
  );

  //Wire declarations for instance 'inst107' (Module EQ2)
  wire [1:0] inst107__I0;
  wire [1:0] inst107__I1;
  wire  inst107__O;
  EQ2 inst107(
    .I0(inst107__I0),
    .I1(inst107__I1),
    .O(inst107__O)
  );

  //Wire declarations for instance 'inst108' (Module corebit_not)
  wire  inst108__in;
  wire  inst108__out;
  corebit_not inst108(
    .in(inst108__in),
    .out(inst108__out)
  );

  //Wire declarations for instance 'inst109' (Module and_wrapped)
  wire  inst109__I0;
  wire  inst109__I1;
  wire  inst109__O;
  and_wrapped inst109(
    .I0(inst109__I0),
    .I1(inst109__I1),
    .O(inst109__O)
  );

  //Wire declarations for instance 'inst11' (Module SilicaOneHotMux84)
  wire [3:0] inst11__I0;
  wire [3:0] inst11__I1;
  wire [3:0] inst11__I2;
  wire [3:0] inst11__I3;
  wire [3:0] inst11__I4;
  wire [3:0] inst11__I5;
  wire [3:0] inst11__I6;
  wire [3:0] inst11__I7;
  wire [3:0] inst11__O;
  wire [7:0] inst11__S;
  SilicaOneHotMux84 inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .I2(inst11__I2),
    .I3(inst11__I3),
    .I4(inst11__I4),
    .I5(inst11__I5),
    .I6(inst11__I6),
    .I7(inst11__I7),
    .O(inst11__O),
    .S(inst11__S)
  );

  //Wire declarations for instance 'inst110' (Module corebit_not)
  wire  inst110__in;
  wire  inst110__out;
  corebit_not inst110(
    .in(inst110__in),
    .out(inst110__out)
  );

  //Wire declarations for instance 'inst111' (Module And3xNone)
  wire  inst111__I0;
  wire  inst111__I1;
  wire  inst111__I2;
  wire  inst111__O;
  And3xNone inst111(
    .I0(inst111__I0),
    .I1(inst111__I1),
    .I2(inst111__I2),
    .O(inst111__O)
  );

  //Wire declarations for instance 'inst112' (Module Mux4x4)
  wire [3:0] inst112__I0;
  wire [3:0] inst112__I1;
  wire [3:0] inst112__I2;
  wire [3:0] inst112__I3;
  wire [3:0] inst112__O;
  wire [1:0] inst112__S;
  Mux4x4 inst112(
    .I0(inst112__I0),
    .I1(inst112__I1),
    .I2(inst112__I2),
    .I3(inst112__I3),
    .O(inst112__O),
    .S(inst112__S)
  );

  //Wire declarations for instance 'inst113' (Module corebit_not)
  wire  inst113__in;
  wire  inst113__out;
  corebit_not inst113(
    .in(inst113__in),
    .out(inst113__out)
  );

  //Wire declarations for instance 'inst114' (Module and_wrapped)
  wire  inst114__I0;
  wire  inst114__I1;
  wire  inst114__O;
  and_wrapped inst114(
    .I0(inst114__I0),
    .I1(inst114__I1),
    .O(inst114__O)
  );

  //Wire declarations for instance 'inst115' (Module corebit_not)
  wire  inst115__in;
  wire  inst115__out;
  corebit_not inst115(
    .in(inst115__in),
    .out(inst115__out)
  );

  //Wire declarations for instance 'inst116' (Module corebit_not)
  wire  inst116__in;
  wire  inst116__out;
  corebit_not inst116(
    .in(inst116__in),
    .out(inst116__out)
  );

  //Wire declarations for instance 'inst117' (Module and_wrapped)
  wire  inst117__I0;
  wire  inst117__I1;
  wire  inst117__O;
  and_wrapped inst117(
    .I0(inst117__I0),
    .I1(inst117__I1),
    .O(inst117__O)
  );

  //Wire declarations for instance 'inst118' (Module Add2)
  wire [1:0] inst118__I0;
  wire [1:0] inst118__I1;
  wire [1:0] inst118__O;
  Add2 inst118(
    .I0(inst118__I0),
    .I1(inst118__I1),
    .O(inst118__O)
  );

  //Wire declarations for instance 'inst119' (Module EQ2)
  wire [1:0] inst119__I0;
  wire [1:0] inst119__I1;
  wire  inst119__O;
  EQ2 inst119(
    .I0(inst119__I0),
    .I1(inst119__I1),
    .O(inst119__O)
  );

  //Wire declarations for instance 'inst12' (Module SilicaOneHotMux84)
  wire [3:0] inst12__I0;
  wire [3:0] inst12__I1;
  wire [3:0] inst12__I2;
  wire [3:0] inst12__I3;
  wire [3:0] inst12__I4;
  wire [3:0] inst12__I5;
  wire [3:0] inst12__I6;
  wire [3:0] inst12__I7;
  wire [3:0] inst12__O;
  wire [7:0] inst12__S;
  SilicaOneHotMux84 inst12(
    .I0(inst12__I0),
    .I1(inst12__I1),
    .I2(inst12__I2),
    .I3(inst12__I3),
    .I4(inst12__I4),
    .I5(inst12__I5),
    .I6(inst12__I6),
    .I7(inst12__I7),
    .O(inst12__O),
    .S(inst12__S)
  );

  //Wire declarations for instance 'inst120' (Module And3xNone)
  wire  inst120__I0;
  wire  inst120__I1;
  wire  inst120__I2;
  wire  inst120__O;
  And3xNone inst120(
    .I0(inst120__I0),
    .I1(inst120__I1),
    .I2(inst120__I2),
    .O(inst120__O)
  );

  //Wire declarations for instance 'inst121' (Module Mux4x4)
  wire [3:0] inst121__I0;
  wire [3:0] inst121__I1;
  wire [3:0] inst121__I2;
  wire [3:0] inst121__I3;
  wire [3:0] inst121__O;
  wire [1:0] inst121__S;
  Mux4x4 inst121(
    .I0(inst121__I0),
    .I1(inst121__I1),
    .I2(inst121__I2),
    .I3(inst121__I3),
    .O(inst121__O),
    .S(inst121__S)
  );

  //Wire declarations for instance 'inst122' (Module corebit_not)
  wire  inst122__in;
  wire  inst122__out;
  corebit_not inst122(
    .in(inst122__in),
    .out(inst122__out)
  );

  //Wire declarations for instance 'inst123' (Module and_wrapped)
  wire  inst123__I0;
  wire  inst123__I1;
  wire  inst123__O;
  and_wrapped inst123(
    .I0(inst123__I0),
    .I1(inst123__I1),
    .O(inst123__O)
  );

  //Wire declarations for instance 'inst124' (Module corebit_not)
  wire  inst124__in;
  wire  inst124__out;
  corebit_not inst124(
    .in(inst124__in),
    .out(inst124__out)
  );

  //Wire declarations for instance 'inst125' (Module corebit_not)
  wire  inst125__in;
  wire  inst125__out;
  corebit_not inst125(
    .in(inst125__in),
    .out(inst125__out)
  );

  //Wire declarations for instance 'inst126' (Module and_wrapped)
  wire  inst126__I0;
  wire  inst126__I1;
  wire  inst126__O;
  and_wrapped inst126(
    .I0(inst126__I0),
    .I1(inst126__I1),
    .O(inst126__O)
  );

  //Wire declarations for instance 'inst127' (Module corebit_not)
  wire  inst127__in;
  wire  inst127__out;
  corebit_not inst127(
    .in(inst127__in),
    .out(inst127__out)
  );

  //Wire declarations for instance 'inst128' (Module And3xNone)
  wire  inst128__I0;
  wire  inst128__I1;
  wire  inst128__I2;
  wire  inst128__O;
  And3xNone inst128(
    .I0(inst128__I0),
    .I1(inst128__I1),
    .I2(inst128__I2),
    .O(inst128__O)
  );

  //Wire declarations for instance 'inst13' (Module SilicaOneHotMux84)
  wire [3:0] inst13__I0;
  wire [3:0] inst13__I1;
  wire [3:0] inst13__I2;
  wire [3:0] inst13__I3;
  wire [3:0] inst13__I4;
  wire [3:0] inst13__I5;
  wire [3:0] inst13__I6;
  wire [3:0] inst13__I7;
  wire [3:0] inst13__O;
  wire [7:0] inst13__S;
  SilicaOneHotMux84 inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .I2(inst13__I2),
    .I3(inst13__I3),
    .I4(inst13__I4),
    .I5(inst13__I5),
    .I6(inst13__I6),
    .I7(inst13__I7),
    .O(inst13__O),
    .S(inst13__S)
  );

  //Wire declarations for instance 'inst15' (Module SilicaOneHotMux8None)
  wire  inst15__I0;
  wire  inst15__I1;
  wire  inst15__I2;
  wire  inst15__I3;
  wire  inst15__I4;
  wire  inst15__I5;
  wire  inst15__I6;
  wire  inst15__I7;
  wire  inst15__O;
  wire [7:0] inst15__S;
  SilicaOneHotMux8None inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .I2(inst15__I2),
    .I3(inst15__I3),
    .I4(inst15__I4),
    .I5(inst15__I5),
    .I6(inst15__I6),
    .I7(inst15__I7),
    .O(inst15__O),
    .S(inst15__S)
  );

  //Wire declarations for instance 'inst16' (Module Register2)
  wire  inst16__CLK;
  wire [1:0] inst16__I;
  wire [1:0] inst16__O;
  Register2 inst16(
    .CLK(inst16__CLK),
    .I(inst16__I),
    .O(inst16__O)
  );

  //Wire declarations for instance 'inst17' (Module SilicaOneHotMux82)
  wire [1:0] inst17__I0;
  wire [1:0] inst17__I1;
  wire [1:0] inst17__I2;
  wire [1:0] inst17__I3;
  wire [1:0] inst17__I4;
  wire [1:0] inst17__I5;
  wire [1:0] inst17__I6;
  wire [1:0] inst17__I7;
  wire [1:0] inst17__O;
  wire [7:0] inst17__S;
  SilicaOneHotMux82 inst17(
    .I0(inst17__I0),
    .I1(inst17__I1),
    .I2(inst17__I2),
    .I3(inst17__I3),
    .I4(inst17__I4),
    .I5(inst17__I5),
    .I6(inst17__I6),
    .I7(inst17__I7),
    .O(inst17__O),
    .S(inst17__S)
  );

  //Wire declarations for instance 'inst18' (Module SilicaOneHotMux84)
  wire [3:0] inst18__I0;
  wire [3:0] inst18__I1;
  wire [3:0] inst18__I2;
  wire [3:0] inst18__I3;
  wire [3:0] inst18__I4;
  wire [3:0] inst18__I5;
  wire [3:0] inst18__I6;
  wire [3:0] inst18__I7;
  wire [3:0] inst18__O;
  wire [7:0] inst18__S;
  SilicaOneHotMux84 inst18(
    .I0(inst18__I0),
    .I1(inst18__I1),
    .I2(inst18__I2),
    .I3(inst18__I3),
    .I4(inst18__I4),
    .I5(inst18__I5),
    .I6(inst18__I6),
    .I7(inst18__I7),
    .O(inst18__O),
    .S(inst18__S)
  );

  //Wire declarations for instance 'inst19' (Module SilicaOneHotMux8None)
  wire  inst19__I0;
  wire  inst19__I1;
  wire  inst19__I2;
  wire  inst19__I3;
  wire  inst19__I4;
  wire  inst19__I5;
  wire  inst19__I6;
  wire  inst19__I7;
  wire  inst19__O;
  wire [7:0] inst19__S;
  SilicaOneHotMux8None inst19(
    .I0(inst19__I0),
    .I1(inst19__I1),
    .I2(inst19__I2),
    .I3(inst19__I3),
    .I4(inst19__I4),
    .I5(inst19__I5),
    .I6(inst19__I6),
    .I7(inst19__I7),
    .O(inst19__O),
    .S(inst19__S)
  );

  //Wire declarations for instance 'inst2' (Module Register2)
  wire  inst2__CLK;
  wire [1:0] inst2__I;
  wire [1:0] inst2__O;
  Register2 inst2(
    .CLK(inst2__CLK),
    .I(inst2__I),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst20' (Module SilicaOneHotMux8None)
  wire  inst20__I0;
  wire  inst20__I1;
  wire  inst20__I2;
  wire  inst20__I3;
  wire  inst20__I4;
  wire  inst20__I5;
  wire  inst20__I6;
  wire  inst20__I7;
  wire  inst20__O;
  wire [7:0] inst20__S;
  SilicaOneHotMux8None inst20(
    .I0(inst20__I0),
    .I1(inst20__I1),
    .I2(inst20__I2),
    .I3(inst20__I3),
    .I4(inst20__I4),
    .I5(inst20__I5),
    .I6(inst20__I6),
    .I7(inst20__I7),
    .O(inst20__O),
    .S(inst20__S)
  );

  //Wire declarations for instance 'inst21' (Module Mux4x4)
  wire [3:0] inst21__I0;
  wire [3:0] inst21__I1;
  wire [3:0] inst21__I2;
  wire [3:0] inst21__I3;
  wire [3:0] inst21__O;
  wire [1:0] inst21__S;
  Mux4x4 inst21(
    .I0(inst21__I0),
    .I1(inst21__I1),
    .I2(inst21__I2),
    .I3(inst21__I3),
    .O(inst21__O),
    .S(inst21__S)
  );

  //Wire declarations for instance 'inst22' (Module corebit_not)
  wire  inst22__in;
  wire  inst22__out;
  corebit_not inst22(
    .in(inst22__in),
    .out(inst22__out)
  );

  //Wire declarations for instance 'inst23' (Module and_wrapped)
  wire  inst23__I0;
  wire  inst23__I1;
  wire  inst23__O;
  and_wrapped inst23(
    .I0(inst23__I0),
    .I1(inst23__I1),
    .O(inst23__O)
  );

  //Wire declarations for instance 'inst24' (Module Decoder2)
  wire [1:0] inst24__I;
  wire [3:0] inst24__O;
  Decoder2 inst24(
    .I(inst24__I),
    .O(inst24__O)
  );

  //Wire declarations for instance 'inst25' (Module SilicaOneHotMux24)
  wire [3:0] inst25__I0;
  wire [3:0] inst25__I1;
  wire [3:0] inst25__O;
  wire [1:0] inst25__S;
  SilicaOneHotMux24 inst25(
    .I0(inst25__I0),
    .I1(inst25__I1),
    .O(inst25__O),
    .S(inst25__S)
  );

  //Wire declarations for instance 'inst26' (Module corebit_not)
  wire  inst26__in;
  wire  inst26__out;
  corebit_not inst26(
    .in(inst26__in),
    .out(inst26__out)
  );

  //Wire declarations for instance 'inst27' (Module SilicaOneHotMux24)
  wire [3:0] inst27__I0;
  wire [3:0] inst27__I1;
  wire [3:0] inst27__O;
  wire [1:0] inst27__S;
  SilicaOneHotMux24 inst27(
    .I0(inst27__I0),
    .I1(inst27__I1),
    .O(inst27__O),
    .S(inst27__S)
  );

  //Wire declarations for instance 'inst28' (Module corebit_not)
  wire  inst28__in;
  wire  inst28__out;
  corebit_not inst28(
    .in(inst28__in),
    .out(inst28__out)
  );

  //Wire declarations for instance 'inst29' (Module SilicaOneHotMux24)
  wire [3:0] inst29__I0;
  wire [3:0] inst29__I1;
  wire [3:0] inst29__O;
  wire [1:0] inst29__S;
  SilicaOneHotMux24 inst29(
    .I0(inst29__I0),
    .I1(inst29__I1),
    .O(inst29__O),
    .S(inst29__S)
  );

  //Wire declarations for instance 'inst3' (Module SilicaOneHotMux82)
  wire [1:0] inst3__I0;
  wire [1:0] inst3__I1;
  wire [1:0] inst3__I2;
  wire [1:0] inst3__I3;
  wire [1:0] inst3__I4;
  wire [1:0] inst3__I5;
  wire [1:0] inst3__I6;
  wire [1:0] inst3__I7;
  wire [1:0] inst3__O;
  wire [7:0] inst3__S;
  SilicaOneHotMux82 inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .I2(inst3__I2),
    .I3(inst3__I3),
    .I4(inst3__I4),
    .I5(inst3__I5),
    .I6(inst3__I6),
    .I7(inst3__I7),
    .O(inst3__O),
    .S(inst3__S)
  );

  //Wire declarations for instance 'inst30' (Module corebit_not)
  wire  inst30__in;
  wire  inst30__out;
  corebit_not inst30(
    .in(inst30__in),
    .out(inst30__out)
  );

  //Wire declarations for instance 'inst31' (Module SilicaOneHotMux24)
  wire [3:0] inst31__I0;
  wire [3:0] inst31__I1;
  wire [3:0] inst31__O;
  wire [1:0] inst31__S;
  SilicaOneHotMux24 inst31(
    .I0(inst31__I0),
    .I1(inst31__I1),
    .O(inst31__O),
    .S(inst31__S)
  );

  //Wire declarations for instance 'inst32' (Module corebit_not)
  wire  inst32__in;
  wire  inst32__out;
  corebit_not inst32(
    .in(inst32__in),
    .out(inst32__out)
  );

  //Wire declarations for instance 'inst33' (Module Add2)
  wire [1:0] inst33__I0;
  wire [1:0] inst33__I1;
  wire [1:0] inst33__O;
  Add2 inst33(
    .I0(inst33__I0),
    .I1(inst33__I1),
    .O(inst33__O)
  );

  //Wire declarations for instance 'inst34' (Module EQ2)
  wire [1:0] inst34__I0;
  wire [1:0] inst34__I1;
  wire  inst34__O;
  EQ2 inst34(
    .I0(inst34__I0),
    .I1(inst34__I1),
    .O(inst34__O)
  );

  //Wire declarations for instance 'inst35' (Module corebit_not)
  wire  inst35__in;
  wire  inst35__out;
  corebit_not inst35(
    .in(inst35__in),
    .out(inst35__out)
  );

  //Wire declarations for instance 'inst36' (Module and_wrapped)
  wire  inst36__I0;
  wire  inst36__I1;
  wire  inst36__O;
  and_wrapped inst36(
    .I0(inst36__I0),
    .I1(inst36__I1),
    .O(inst36__O)
  );

  //Wire declarations for instance 'inst37' (Module Add2)
  wire [1:0] inst37__I0;
  wire [1:0] inst37__I1;
  wire [1:0] inst37__O;
  Add2 inst37(
    .I0(inst37__I0),
    .I1(inst37__I1),
    .O(inst37__O)
  );

  //Wire declarations for instance 'inst38' (Module EQ2)
  wire [1:0] inst38__I0;
  wire [1:0] inst38__I1;
  wire  inst38__O;
  EQ2 inst38(
    .I0(inst38__I0),
    .I1(inst38__I1),
    .O(inst38__O)
  );

  //Wire declarations for instance 'inst39' (Module And3xNone)
  wire  inst39__I0;
  wire  inst39__I1;
  wire  inst39__I2;
  wire  inst39__O;
  And3xNone inst39(
    .I0(inst39__I0),
    .I1(inst39__I1),
    .I2(inst39__I2),
    .O(inst39__O)
  );

  //Wire declarations for instance 'inst40' (Module Mux4x4)
  wire [3:0] inst40__I0;
  wire [3:0] inst40__I1;
  wire [3:0] inst40__I2;
  wire [3:0] inst40__I3;
  wire [3:0] inst40__O;
  wire [1:0] inst40__S;
  Mux4x4 inst40(
    .I0(inst40__I0),
    .I1(inst40__I1),
    .I2(inst40__I2),
    .I3(inst40__I3),
    .O(inst40__O),
    .S(inst40__S)
  );

  //Wire declarations for instance 'inst41' (Module corebit_not)
  wire  inst41__in;
  wire  inst41__out;
  corebit_not inst41(
    .in(inst41__in),
    .out(inst41__out)
  );

  //Wire declarations for instance 'inst42' (Module and_wrapped)
  wire  inst42__I0;
  wire  inst42__I1;
  wire  inst42__O;
  and_wrapped inst42(
    .I0(inst42__I0),
    .I1(inst42__I1),
    .O(inst42__O)
  );

  //Wire declarations for instance 'inst43' (Module Decoder2)
  wire [1:0] inst43__I;
  wire [3:0] inst43__O;
  Decoder2 inst43(
    .I(inst43__I),
    .O(inst43__O)
  );

  //Wire declarations for instance 'inst44' (Module SilicaOneHotMux24)
  wire [3:0] inst44__I0;
  wire [3:0] inst44__I1;
  wire [3:0] inst44__O;
  wire [1:0] inst44__S;
  SilicaOneHotMux24 inst44(
    .I0(inst44__I0),
    .I1(inst44__I1),
    .O(inst44__O),
    .S(inst44__S)
  );

  //Wire declarations for instance 'inst45' (Module corebit_not)
  wire  inst45__in;
  wire  inst45__out;
  corebit_not inst45(
    .in(inst45__in),
    .out(inst45__out)
  );

  //Wire declarations for instance 'inst46' (Module SilicaOneHotMux24)
  wire [3:0] inst46__I0;
  wire [3:0] inst46__I1;
  wire [3:0] inst46__O;
  wire [1:0] inst46__S;
  SilicaOneHotMux24 inst46(
    .I0(inst46__I0),
    .I1(inst46__I1),
    .O(inst46__O),
    .S(inst46__S)
  );

  //Wire declarations for instance 'inst47' (Module corebit_not)
  wire  inst47__in;
  wire  inst47__out;
  corebit_not inst47(
    .in(inst47__in),
    .out(inst47__out)
  );

  //Wire declarations for instance 'inst48' (Module SilicaOneHotMux24)
  wire [3:0] inst48__I0;
  wire [3:0] inst48__I1;
  wire [3:0] inst48__O;
  wire [1:0] inst48__S;
  SilicaOneHotMux24 inst48(
    .I0(inst48__I0),
    .I1(inst48__I1),
    .O(inst48__O),
    .S(inst48__S)
  );

  //Wire declarations for instance 'inst49' (Module corebit_not)
  wire  inst49__in;
  wire  inst49__out;
  corebit_not inst49(
    .in(inst49__in),
    .out(inst49__out)
  );

  //Wire declarations for instance 'inst5' (Module SilicaOneHotMux8None)
  wire  inst5__I0;
  wire  inst5__I1;
  wire  inst5__I2;
  wire  inst5__I3;
  wire  inst5__I4;
  wire  inst5__I5;
  wire  inst5__I6;
  wire  inst5__I7;
  wire  inst5__O;
  wire [7:0] inst5__S;
  SilicaOneHotMux8None inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .I2(inst5__I2),
    .I3(inst5__I3),
    .I4(inst5__I4),
    .I5(inst5__I5),
    .I6(inst5__I6),
    .I7(inst5__I7),
    .O(inst5__O),
    .S(inst5__S)
  );

  //Wire declarations for instance 'inst50' (Module SilicaOneHotMux24)
  wire [3:0] inst50__I0;
  wire [3:0] inst50__I1;
  wire [3:0] inst50__O;
  wire [1:0] inst50__S;
  SilicaOneHotMux24 inst50(
    .I0(inst50__I0),
    .I1(inst50__I1),
    .O(inst50__O),
    .S(inst50__S)
  );

  //Wire declarations for instance 'inst51' (Module corebit_not)
  wire  inst51__in;
  wire  inst51__out;
  corebit_not inst51(
    .in(inst51__in),
    .out(inst51__out)
  );

  //Wire declarations for instance 'inst52' (Module Add2)
  wire [1:0] inst52__I0;
  wire [1:0] inst52__I1;
  wire [1:0] inst52__O;
  Add2 inst52(
    .I0(inst52__I0),
    .I1(inst52__I1),
    .O(inst52__O)
  );

  //Wire declarations for instance 'inst53' (Module EQ2)
  wire [1:0] inst53__I0;
  wire [1:0] inst53__I1;
  wire  inst53__O;
  EQ2 inst53(
    .I0(inst53__I0),
    .I1(inst53__I1),
    .O(inst53__O)
  );

  //Wire declarations for instance 'inst54' (Module corebit_not)
  wire  inst54__in;
  wire  inst54__out;
  corebit_not inst54(
    .in(inst54__in),
    .out(inst54__out)
  );

  //Wire declarations for instance 'inst55' (Module and_wrapped)
  wire  inst55__I0;
  wire  inst55__I1;
  wire  inst55__O;
  and_wrapped inst55(
    .I0(inst55__I0),
    .I1(inst55__I1),
    .O(inst55__O)
  );

  //Wire declarations for instance 'inst56' (Module corebit_not)
  wire  inst56__in;
  wire  inst56__out;
  corebit_not inst56(
    .in(inst56__in),
    .out(inst56__out)
  );

  //Wire declarations for instance 'inst57' (Module And3xNone)
  wire  inst57__I0;
  wire  inst57__I1;
  wire  inst57__I2;
  wire  inst57__O;
  And3xNone inst57(
    .I0(inst57__I0),
    .I1(inst57__I1),
    .I2(inst57__I2),
    .O(inst57__O)
  );

  //Wire declarations for instance 'inst58' (Module Mux4x4)
  wire [3:0] inst58__I0;
  wire [3:0] inst58__I1;
  wire [3:0] inst58__I2;
  wire [3:0] inst58__I3;
  wire [3:0] inst58__O;
  wire [1:0] inst58__S;
  Mux4x4 inst58(
    .I0(inst58__I0),
    .I1(inst58__I1),
    .I2(inst58__I2),
    .I3(inst58__I3),
    .O(inst58__O),
    .S(inst58__S)
  );

  //Wire declarations for instance 'inst59' (Module corebit_not)
  wire  inst59__in;
  wire  inst59__out;
  corebit_not inst59(
    .in(inst59__in),
    .out(inst59__out)
  );

  //Wire declarations for instance 'inst6' (Module Register4)
  wire  inst6__CLK;
  wire [3:0] inst6__I;
  wire [3:0] inst6__O;
  Register4 inst6(
    .CLK(inst6__CLK),
    .I(inst6__I),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst60' (Module and_wrapped)
  wire  inst60__I0;
  wire  inst60__I1;
  wire  inst60__O;
  and_wrapped inst60(
    .I0(inst60__I0),
    .I1(inst60__I1),
    .O(inst60__O)
  );

  //Wire declarations for instance 'inst61' (Module corebit_not)
  wire  inst61__in;
  wire  inst61__out;
  corebit_not inst61(
    .in(inst61__in),
    .out(inst61__out)
  );

  //Wire declarations for instance 'inst62' (Module corebit_not)
  wire  inst62__in;
  wire  inst62__out;
  corebit_not inst62(
    .in(inst62__in),
    .out(inst62__out)
  );

  //Wire declarations for instance 'inst63' (Module and_wrapped)
  wire  inst63__I0;
  wire  inst63__I1;
  wire  inst63__O;
  and_wrapped inst63(
    .I0(inst63__I0),
    .I1(inst63__I1),
    .O(inst63__O)
  );

  //Wire declarations for instance 'inst64' (Module Add2)
  wire [1:0] inst64__I0;
  wire [1:0] inst64__I1;
  wire [1:0] inst64__O;
  Add2 inst64(
    .I0(inst64__I0),
    .I1(inst64__I1),
    .O(inst64__O)
  );

  //Wire declarations for instance 'inst65' (Module EQ2)
  wire [1:0] inst65__I0;
  wire [1:0] inst65__I1;
  wire  inst65__O;
  EQ2 inst65(
    .I0(inst65__I0),
    .I1(inst65__I1),
    .O(inst65__O)
  );

  //Wire declarations for instance 'inst66' (Module And3xNone)
  wire  inst66__I0;
  wire  inst66__I1;
  wire  inst66__I2;
  wire  inst66__O;
  And3xNone inst66(
    .I0(inst66__I0),
    .I1(inst66__I1),
    .I2(inst66__I2),
    .O(inst66__O)
  );

  //Wire declarations for instance 'inst67' (Module Mux4x4)
  wire [3:0] inst67__I0;
  wire [3:0] inst67__I1;
  wire [3:0] inst67__I2;
  wire [3:0] inst67__I3;
  wire [3:0] inst67__O;
  wire [1:0] inst67__S;
  Mux4x4 inst67(
    .I0(inst67__I0),
    .I1(inst67__I1),
    .I2(inst67__I2),
    .I3(inst67__I3),
    .O(inst67__O),
    .S(inst67__S)
  );

  //Wire declarations for instance 'inst68' (Module corebit_not)
  wire  inst68__in;
  wire  inst68__out;
  corebit_not inst68(
    .in(inst68__in),
    .out(inst68__out)
  );

  //Wire declarations for instance 'inst69' (Module and_wrapped)
  wire  inst69__I0;
  wire  inst69__I1;
  wire  inst69__O;
  and_wrapped inst69(
    .I0(inst69__I0),
    .I1(inst69__I1),
    .O(inst69__O)
  );

  //Wire declarations for instance 'inst7' (Module Register4)
  wire  inst7__CLK;
  wire [3:0] inst7__I;
  wire [3:0] inst7__O;
  Register4 inst7(
    .CLK(inst7__CLK),
    .I(inst7__I),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst70' (Module corebit_not)
  wire  inst70__in;
  wire  inst70__out;
  corebit_not inst70(
    .in(inst70__in),
    .out(inst70__out)
  );

  //Wire declarations for instance 'inst71' (Module corebit_not)
  wire  inst71__in;
  wire  inst71__out;
  corebit_not inst71(
    .in(inst71__in),
    .out(inst71__out)
  );

  //Wire declarations for instance 'inst72' (Module and_wrapped)
  wire  inst72__I0;
  wire  inst72__I1;
  wire  inst72__O;
  and_wrapped inst72(
    .I0(inst72__I0),
    .I1(inst72__I1),
    .O(inst72__O)
  );

  //Wire declarations for instance 'inst73' (Module corebit_not)
  wire  inst73__in;
  wire  inst73__out;
  corebit_not inst73(
    .in(inst73__in),
    .out(inst73__out)
  );

  //Wire declarations for instance 'inst74' (Module And3xNone)
  wire  inst74__I0;
  wire  inst74__I1;
  wire  inst74__I2;
  wire  inst74__O;
  And3xNone inst74(
    .I0(inst74__I0),
    .I1(inst74__I1),
    .I2(inst74__I2),
    .O(inst74__O)
  );

  //Wire declarations for instance 'inst75' (Module Mux4x4)
  wire [3:0] inst75__I0;
  wire [3:0] inst75__I1;
  wire [3:0] inst75__I2;
  wire [3:0] inst75__I3;
  wire [3:0] inst75__O;
  wire [1:0] inst75__S;
  Mux4x4 inst75(
    .I0(inst75__I0),
    .I1(inst75__I1),
    .I2(inst75__I2),
    .I3(inst75__I3),
    .O(inst75__O),
    .S(inst75__S)
  );

  //Wire declarations for instance 'inst76' (Module corebit_not)
  wire  inst76__in;
  wire  inst76__out;
  corebit_not inst76(
    .in(inst76__in),
    .out(inst76__out)
  );

  //Wire declarations for instance 'inst77' (Module and_wrapped)
  wire  inst77__I0;
  wire  inst77__I1;
  wire  inst77__O;
  and_wrapped inst77(
    .I0(inst77__I0),
    .I1(inst77__I1),
    .O(inst77__O)
  );

  //Wire declarations for instance 'inst78' (Module Decoder2)
  wire [1:0] inst78__I;
  wire [3:0] inst78__O;
  Decoder2 inst78(
    .I(inst78__I),
    .O(inst78__O)
  );

  //Wire declarations for instance 'inst79' (Module SilicaOneHotMux24)
  wire [3:0] inst79__I0;
  wire [3:0] inst79__I1;
  wire [3:0] inst79__O;
  wire [1:0] inst79__S;
  SilicaOneHotMux24 inst79(
    .I0(inst79__I0),
    .I1(inst79__I1),
    .O(inst79__O),
    .S(inst79__S)
  );

  //Wire declarations for instance 'inst8' (Module Register4)
  wire  inst8__CLK;
  wire [3:0] inst8__I;
  wire [3:0] inst8__O;
  Register4 inst8(
    .CLK(inst8__CLK),
    .I(inst8__I),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst80' (Module corebit_not)
  wire  inst80__in;
  wire  inst80__out;
  corebit_not inst80(
    .in(inst80__in),
    .out(inst80__out)
  );

  //Wire declarations for instance 'inst81' (Module SilicaOneHotMux24)
  wire [3:0] inst81__I0;
  wire [3:0] inst81__I1;
  wire [3:0] inst81__O;
  wire [1:0] inst81__S;
  SilicaOneHotMux24 inst81(
    .I0(inst81__I0),
    .I1(inst81__I1),
    .O(inst81__O),
    .S(inst81__S)
  );

  //Wire declarations for instance 'inst82' (Module corebit_not)
  wire  inst82__in;
  wire  inst82__out;
  corebit_not inst82(
    .in(inst82__in),
    .out(inst82__out)
  );

  //Wire declarations for instance 'inst83' (Module SilicaOneHotMux24)
  wire [3:0] inst83__I0;
  wire [3:0] inst83__I1;
  wire [3:0] inst83__O;
  wire [1:0] inst83__S;
  SilicaOneHotMux24 inst83(
    .I0(inst83__I0),
    .I1(inst83__I1),
    .O(inst83__O),
    .S(inst83__S)
  );

  //Wire declarations for instance 'inst84' (Module corebit_not)
  wire  inst84__in;
  wire  inst84__out;
  corebit_not inst84(
    .in(inst84__in),
    .out(inst84__out)
  );

  //Wire declarations for instance 'inst85' (Module SilicaOneHotMux24)
  wire [3:0] inst85__I0;
  wire [3:0] inst85__I1;
  wire [3:0] inst85__O;
  wire [1:0] inst85__S;
  SilicaOneHotMux24 inst85(
    .I0(inst85__I0),
    .I1(inst85__I1),
    .O(inst85__O),
    .S(inst85__S)
  );

  //Wire declarations for instance 'inst86' (Module corebit_not)
  wire  inst86__in;
  wire  inst86__out;
  corebit_not inst86(
    .in(inst86__in),
    .out(inst86__out)
  );

  //Wire declarations for instance 'inst87' (Module Add2)
  wire [1:0] inst87__I0;
  wire [1:0] inst87__I1;
  wire [1:0] inst87__O;
  Add2 inst87(
    .I0(inst87__I0),
    .I1(inst87__I1),
    .O(inst87__O)
  );

  //Wire declarations for instance 'inst88' (Module EQ2)
  wire [1:0] inst88__I0;
  wire [1:0] inst88__I1;
  wire  inst88__O;
  EQ2 inst88(
    .I0(inst88__I0),
    .I1(inst88__I1),
    .O(inst88__O)
  );

  //Wire declarations for instance 'inst89' (Module corebit_not)
  wire  inst89__in;
  wire  inst89__out;
  corebit_not inst89(
    .in(inst89__in),
    .out(inst89__out)
  );

  //Wire declarations for instance 'inst9' (Module Register4)
  wire  inst9__CLK;
  wire [3:0] inst9__I;
  wire [3:0] inst9__O;
  Register4 inst9(
    .CLK(inst9__CLK),
    .I(inst9__I),
    .O(inst9__O)
  );

  //Wire declarations for instance 'inst90' (Module and_wrapped)
  wire  inst90__I0;
  wire  inst90__I1;
  wire  inst90__O;
  and_wrapped inst90(
    .I0(inst90__I0),
    .I1(inst90__I1),
    .O(inst90__O)
  );

  //Wire declarations for instance 'inst91' (Module Add2)
  wire [1:0] inst91__I0;
  wire [1:0] inst91__I1;
  wire [1:0] inst91__O;
  Add2 inst91(
    .I0(inst91__I0),
    .I1(inst91__I1),
    .O(inst91__O)
  );

  //Wire declarations for instance 'inst92' (Module EQ2)
  wire [1:0] inst92__I0;
  wire [1:0] inst92__I1;
  wire  inst92__O;
  EQ2 inst92(
    .I0(inst92__I0),
    .I1(inst92__I1),
    .O(inst92__O)
  );

  //Wire declarations for instance 'inst93' (Module And3xNone)
  wire  inst93__I0;
  wire  inst93__I1;
  wire  inst93__I2;
  wire  inst93__O;
  And3xNone inst93(
    .I0(inst93__I0),
    .I1(inst93__I1),
    .I2(inst93__I2),
    .O(inst93__O)
  );

  //Wire declarations for instance 'inst94' (Module Mux4x4)
  wire [3:0] inst94__I0;
  wire [3:0] inst94__I1;
  wire [3:0] inst94__I2;
  wire [3:0] inst94__I3;
  wire [3:0] inst94__O;
  wire [1:0] inst94__S;
  Mux4x4 inst94(
    .I0(inst94__I0),
    .I1(inst94__I1),
    .I2(inst94__I2),
    .I3(inst94__I3),
    .O(inst94__O),
    .S(inst94__S)
  );

  //Wire declarations for instance 'inst95' (Module corebit_not)
  wire  inst95__in;
  wire  inst95__out;
  corebit_not inst95(
    .in(inst95__in),
    .out(inst95__out)
  );

  //Wire declarations for instance 'inst96' (Module and_wrapped)
  wire  inst96__I0;
  wire  inst96__I1;
  wire  inst96__O;
  and_wrapped inst96(
    .I0(inst96__I0),
    .I1(inst96__I1),
    .O(inst96__O)
  );

  //Wire declarations for instance 'inst97' (Module Decoder2)
  wire [1:0] inst97__I;
  wire [3:0] inst97__O;
  Decoder2 inst97(
    .I(inst97__I),
    .O(inst97__O)
  );

  //Wire declarations for instance 'inst98' (Module SilicaOneHotMux24)
  wire [3:0] inst98__I0;
  wire [3:0] inst98__I1;
  wire [3:0] inst98__O;
  wire [1:0] inst98__S;
  SilicaOneHotMux24 inst98(
    .I0(inst98__I0),
    .I1(inst98__I1),
    .O(inst98__O),
    .S(inst98__S)
  );

  //Wire declarations for instance 'inst99' (Module corebit_not)
  wire  inst99__in;
  wire  inst99__out;
  corebit_not inst99(
    .in(inst99__in),
    .out(inst99__out)
  );

  //Wire declarations for instance 'next_empty' (Module DFF_init1_has_ceFalse_has_resetFalse)
  wire  next_empty__CLK;
  wire  next_empty__I;
  wire  next_empty__O;
  DFF_init1_has_ceFalse_has_resetFalse next_empty(
    .CLK(next_empty__CLK),
    .I(next_empty__I),
    .O(next_empty__O)
  );

  //Wire declarations for instance 'next_full' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  next_full__CLK;
  wire  next_full__I;
  wire  next_full__O;
  DFF_init0_has_ceFalse_has_resetFalse next_full(
    .CLK(next_full__CLK),
    .I(next_full__I),
    .O(next_full__O)
  );

  //All the connections
  assign inst15__I0 = bit_const_GND__out;
  assign inst15__I2 = bit_const_GND__out;
  assign inst15__I4 = bit_const_GND__out;
  assign inst15__I6 = bit_const_GND__out;
  assign inst5__I1 = bit_const_GND__out;
  assign inst5__I5 = bit_const_GND__out;
  assign inst1__I[0] = bit_const_GND__out;
  assign inst106__I1[1] = bit_const_GND__out;
  assign inst118__I1[1] = bit_const_GND__out;
  assign inst33__I1[1] = bit_const_GND__out;
  assign inst37__I1[1] = bit_const_GND__out;
  assign inst52__I1[1] = bit_const_GND__out;
  assign inst64__I1[1] = bit_const_GND__out;
  assign inst87__I1[1] = bit_const_GND__out;
  assign inst91__I1[1] = bit_const_GND__out;
  assign inst1__I[1] = bit_const_VCC__out;
  assign inst106__I1[0] = bit_const_VCC__out;
  assign inst118__I1[0] = bit_const_VCC__out;
  assign inst33__I1[0] = bit_const_VCC__out;
  assign inst37__I1[0] = bit_const_VCC__out;
  assign inst52__I1[0] = bit_const_VCC__out;
  assign inst64__I1[0] = bit_const_VCC__out;
  assign inst87__I1[0] = bit_const_VCC__out;
  assign inst91__I1[0] = bit_const_VCC__out;
  assign inst10__S[7:0] = inst0__O[7:0];
  assign inst11__S[7:0] = inst0__O[7:0];
  assign inst12__S[7:0] = inst0__O[7:0];
  assign inst13__S[7:0] = inst0__O[7:0];
  assign inst15__S[7:0] = inst0__O[7:0];
  assign inst17__S[7:0] = inst0__O[7:0];
  assign inst18__S[7:0] = inst0__O[7:0];
  assign inst19__S[7:0] = inst0__O[7:0];
  assign inst20__S[7:0] = inst0__O[7:0];
  assign inst3__S[7:0] = inst0__O[7:0];
  assign inst5__S[7:0] = inst0__O[7:0];
  assign inst1__CLK = CLK;
  assign inst10__I0[3:0] = inst25__O[3:0];
  assign inst10__I1[3:0] = inst44__O[3:0];
  assign inst10__I2[3:0] = inst6__O[3:0];
  assign inst10__I3[3:0] = inst6__O[3:0];
  assign inst10__I4[3:0] = inst79__O[3:0];
  assign inst10__I5[3:0] = inst98__O[3:0];
  assign inst10__I6[3:0] = inst6__O[3:0];
  assign inst10__I7[3:0] = inst6__O[3:0];
  assign inst6__I[3:0] = inst10__O[3:0];
  assign inst100__I0[3:0] = inst7__O[3:0];
  assign inst100__I1[3:0] = wdata[3:0];
  assign inst11__I5[3:0] = inst100__O[3:0];
  assign inst101__in = inst97__O[1];
  assign inst100__S[0] = inst101__out;
  assign inst102__I0[3:0] = inst8__O[3:0];
  assign inst102__I1[3:0] = wdata[3:0];
  assign inst12__I5[3:0] = inst102__O[3:0];
  assign inst103__in = inst97__O[2];
  assign inst102__S[0] = inst103__out;
  assign inst104__I0[3:0] = inst9__O[3:0];
  assign inst104__I1[3:0] = wdata[3:0];
  assign inst13__I5[3:0] = inst104__O[3:0];
  assign inst105__in = inst97__O[3];
  assign inst104__S[0] = inst105__out;
  assign inst106__I0[1:0] = inst16__O[1:0];
  assign inst107__I1[1:0] = inst106__O[1:0];
  assign inst17__I5[1:0] = inst106__O[1:0];
  assign inst107__I0[1:0] = inst2__O[1:0];
  assign inst15__I5 = inst107__O;
  assign inst108__in = next_empty__O;
  assign inst109__I1 = inst108__out;
  assign inst109__I0 = ren;
  assign inst110__in = inst109__O;
  assign inst11__I0[3:0] = inst27__O[3:0];
  assign inst11__I1[3:0] = inst46__O[3:0];
  assign inst11__I2[3:0] = inst7__O[3:0];
  assign inst11__I3[3:0] = inst7__O[3:0];
  assign inst11__I4[3:0] = inst81__O[3:0];
  assign inst11__I6[3:0] = inst7__O[3:0];
  assign inst11__I7[3:0] = inst7__O[3:0];
  assign inst7__I[3:0] = inst11__O[3:0];
  assign inst111__I2 = inst110__out;
  assign inst111__I0 = inst1__O[1];
  assign inst111__I1 = inst96__O;
  assign inst0__I[5] = inst111__O;
  assign inst112__I0[3:0] = inst6__O[3:0];
  assign inst112__I1[3:0] = inst7__O[3:0];
  assign inst112__I2[3:0] = inst8__O[3:0];
  assign inst112__I3[3:0] = inst9__O[3:0];
  assign inst18__I6[3:0] = inst112__O[3:0];
  assign inst112__S[1:0] = inst2__O[1:0];
  assign inst113__in = next_full__O;
  assign inst114__I1 = inst113__out;
  assign inst114__I0 = wen;
  assign inst115__in = inst114__O;
  assign inst120__I1 = inst115__out;
  assign inst116__in = next_empty__O;
  assign inst117__I1 = inst116__out;
  assign inst117__I0 = ren;
  assign inst120__I2 = inst117__O;
  assign inst118__I0[1:0] = inst2__O[1:0];
  assign inst119__I0[1:0] = inst118__O[1:0];
  assign inst3__I6[1:0] = inst118__O[1:0];
  assign inst119__I1[1:0] = inst16__O[1:0];
  assign inst5__I6 = inst119__O;
  assign inst12__I0[3:0] = inst29__O[3:0];
  assign inst12__I1[3:0] = inst48__O[3:0];
  assign inst12__I2[3:0] = inst8__O[3:0];
  assign inst12__I3[3:0] = inst8__O[3:0];
  assign inst12__I4[3:0] = inst83__O[3:0];
  assign inst12__I6[3:0] = inst8__O[3:0];
  assign inst12__I7[3:0] = inst8__O[3:0];
  assign inst8__I[3:0] = inst12__O[3:0];
  assign inst120__I0 = inst1__O[1];
  assign inst0__I[6] = inst120__O;
  assign inst121__I0[3:0] = inst6__O[3:0];
  assign inst121__I1[3:0] = inst7__O[3:0];
  assign inst121__I2[3:0] = inst8__O[3:0];
  assign inst121__I3[3:0] = inst9__O[3:0];
  assign inst18__I7[3:0] = inst121__O[3:0];
  assign inst121__S[1:0] = inst2__O[1:0];
  assign inst122__in = next_full__O;
  assign inst123__I1 = inst122__out;
  assign inst123__I0 = wen;
  assign inst124__in = inst123__O;
  assign inst128__I1 = inst124__out;
  assign inst125__in = next_empty__O;
  assign inst126__I1 = inst125__out;
  assign inst126__I0 = ren;
  assign inst127__in = inst126__O;
  assign inst128__I2 = inst127__out;
  assign inst128__I0 = inst1__O[1];
  assign inst0__I[7] = inst128__O;
  assign inst13__I0[3:0] = inst31__O[3:0];
  assign inst13__I1[3:0] = inst50__O[3:0];
  assign inst13__I2[3:0] = inst9__O[3:0];
  assign inst13__I3[3:0] = inst9__O[3:0];
  assign inst13__I4[3:0] = inst85__O[3:0];
  assign inst13__I6[3:0] = inst9__O[3:0];
  assign inst13__I7[3:0] = inst9__O[3:0];
  assign inst9__I[3:0] = inst13__O[3:0];
  assign inst15__I1 = inst53__O;
  assign inst15__I3 = next_full__O;
  assign inst15__I7 = next_full__O;
  assign next_full__I = inst15__O;
  assign inst16__CLK = CLK;
  assign inst16__I[1:0] = inst17__O[1:0];
  assign inst17__I2[1:0] = inst16__O[1:0];
  assign inst17__I3[1:0] = inst16__O[1:0];
  assign inst17__I6[1:0] = inst16__O[1:0];
  assign inst17__I7[1:0] = inst16__O[1:0];
  assign inst24__I[1:0] = inst16__O[1:0];
  assign inst33__I0[1:0] = inst16__O[1:0];
  assign inst43__I[1:0] = inst16__O[1:0];
  assign inst52__I0[1:0] = inst16__O[1:0];
  assign inst65__I1[1:0] = inst16__O[1:0];
  assign inst78__I[1:0] = inst16__O[1:0];
  assign inst87__I0[1:0] = inst16__O[1:0];
  assign inst97__I[1:0] = inst16__O[1:0];
  assign inst17__I0[1:0] = inst33__O[1:0];
  assign inst17__I1[1:0] = inst52__O[1:0];
  assign inst17__I4[1:0] = inst87__O[1:0];
  assign inst18__I0[3:0] = inst21__O[3:0];
  assign inst18__I1[3:0] = inst40__O[3:0];
  assign inst18__I2[3:0] = inst58__O[3:0];
  assign inst18__I3[3:0] = inst67__O[3:0];
  assign inst18__I4[3:0] = inst75__O[3:0];
  assign inst18__I5[3:0] = inst94__O[3:0];
  assign rdata[3:0] = inst18__O[3:0];
  assign inst19__I0 = next_full__O;
  assign inst19__I1 = next_full__O;
  assign inst19__I2 = next_full__O;
  assign inst19__I3 = next_full__O;
  assign inst19__I4 = next_full__O;
  assign inst19__I5 = next_full__O;
  assign inst19__I6 = next_full__O;
  assign inst19__I7 = next_full__O;
  assign full = inst19__O;
  assign inst2__CLK = CLK;
  assign inst2__I[1:0] = inst3__O[1:0];
  assign inst21__S[1:0] = inst2__O[1:0];
  assign inst3__I1[1:0] = inst2__O[1:0];
  assign inst3__I3[1:0] = inst2__O[1:0];
  assign inst3__I5[1:0] = inst2__O[1:0];
  assign inst3__I7[1:0] = inst2__O[1:0];
  assign inst34__I0[1:0] = inst2__O[1:0];
  assign inst37__I0[1:0] = inst2__O[1:0];
  assign inst40__S[1:0] = inst2__O[1:0];
  assign inst53__I0[1:0] = inst2__O[1:0];
  assign inst58__S[1:0] = inst2__O[1:0];
  assign inst64__I0[1:0] = inst2__O[1:0];
  assign inst67__S[1:0] = inst2__O[1:0];
  assign inst75__S[1:0] = inst2__O[1:0];
  assign inst88__I0[1:0] = inst2__O[1:0];
  assign inst91__I0[1:0] = inst2__O[1:0];
  assign inst94__S[1:0] = inst2__O[1:0];
  assign inst20__I0 = next_empty__O;
  assign inst20__I1 = next_empty__O;
  assign inst20__I2 = next_empty__O;
  assign inst20__I3 = next_empty__O;
  assign inst20__I4 = next_empty__O;
  assign inst20__I5 = next_empty__O;
  assign inst20__I6 = next_empty__O;
  assign inst20__I7 = next_empty__O;
  assign empty = inst20__O;
  assign inst21__I0[3:0] = inst6__O[3:0];
  assign inst21__I1[3:0] = inst7__O[3:0];
  assign inst21__I2[3:0] = inst8__O[3:0];
  assign inst21__I3[3:0] = inst9__O[3:0];
  assign inst22__in = next_full__O;
  assign inst23__I1 = inst22__out;
  assign inst23__I0 = wen;
  assign inst39__I1 = inst23__O;
  assign inst25__I0[3:0] = inst6__O[3:0];
  assign inst25__I1[3:0] = wdata[3:0];
  assign inst26__in = inst24__O[0];
  assign inst25__S[0] = inst26__out;
  assign inst27__I0[3:0] = inst7__O[3:0];
  assign inst27__I1[3:0] = wdata[3:0];
  assign inst28__in = inst24__O[1];
  assign inst27__S[0] = inst28__out;
  assign inst29__I0[3:0] = inst8__O[3:0];
  assign inst29__I1[3:0] = wdata[3:0];
  assign inst3__I0[1:0] = inst37__O[1:0];
  assign inst3__I2[1:0] = inst64__O[1:0];
  assign inst3__I4[1:0] = inst91__O[1:0];
  assign inst30__in = inst24__O[2];
  assign inst29__S[0] = inst30__out;
  assign inst31__I0[3:0] = inst9__O[3:0];
  assign inst31__I1[3:0] = wdata[3:0];
  assign inst32__in = inst24__O[3];
  assign inst31__S[0] = inst32__out;
  assign inst34__I1[1:0] = inst33__O[1:0];
  assign inst38__I1[1:0] = inst33__O[1:0];
  assign inst35__in = next_empty__O;
  assign inst36__I1 = inst35__out;
  assign inst36__I0 = ren;
  assign inst39__I2 = inst36__O;
  assign inst38__I0[1:0] = inst37__O[1:0];
  assign inst5__I0 = inst38__O;
  assign inst39__I0 = inst1__O[0];
  assign inst0__I[0] = inst39__O;
  assign inst40__I0[3:0] = inst6__O[3:0];
  assign inst40__I1[3:0] = inst7__O[3:0];
  assign inst40__I2[3:0] = inst8__O[3:0];
  assign inst40__I3[3:0] = inst9__O[3:0];
  assign inst41__in = next_full__O;
  assign inst42__I1 = inst41__out;
  assign inst42__I0 = wen;
  assign inst57__I1 = inst42__O;
  assign inst44__I0[3:0] = inst6__O[3:0];
  assign inst44__I1[3:0] = wdata[3:0];
  assign inst45__in = inst43__O[0];
  assign inst44__S[0] = inst45__out;
  assign inst46__I0[3:0] = inst7__O[3:0];
  assign inst46__I1[3:0] = wdata[3:0];
  assign inst47__in = inst43__O[1];
  assign inst46__S[0] = inst47__out;
  assign inst48__I0[3:0] = inst8__O[3:0];
  assign inst48__I1[3:0] = wdata[3:0];
  assign inst49__in = inst43__O[2];
  assign inst48__S[0] = inst49__out;
  assign inst5__I2 = inst65__O;
  assign inst5__I3 = next_empty__O;
  assign inst5__I4 = inst92__O;
  assign inst5__I7 = next_empty__O;
  assign next_empty__I = inst5__O;
  assign inst50__I0[3:0] = inst9__O[3:0];
  assign inst50__I1[3:0] = wdata[3:0];
  assign inst51__in = inst43__O[3];
  assign inst50__S[0] = inst51__out;
  assign inst53__I1[1:0] = inst52__O[1:0];
  assign inst54__in = next_empty__O;
  assign inst55__I1 = inst54__out;
  assign inst55__I0 = ren;
  assign inst56__in = inst55__O;
  assign inst57__I2 = inst56__out;
  assign inst57__I0 = inst1__O[0];
  assign inst0__I[1] = inst57__O;
  assign inst58__I0[3:0] = inst6__O[3:0];
  assign inst58__I1[3:0] = inst7__O[3:0];
  assign inst58__I2[3:0] = inst8__O[3:0];
  assign inst58__I3[3:0] = inst9__O[3:0];
  assign inst59__in = next_full__O;
  assign inst60__I1 = inst59__out;
  assign inst6__CLK = CLK;
  assign inst67__I0[3:0] = inst6__O[3:0];
  assign inst75__I0[3:0] = inst6__O[3:0];
  assign inst79__I0[3:0] = inst6__O[3:0];
  assign inst94__I0[3:0] = inst6__O[3:0];
  assign inst98__I0[3:0] = inst6__O[3:0];
  assign inst60__I0 = wen;
  assign inst61__in = inst60__O;
  assign inst66__I1 = inst61__out;
  assign inst62__in = next_empty__O;
  assign inst63__I1 = inst62__out;
  assign inst63__I0 = ren;
  assign inst66__I2 = inst63__O;
  assign inst65__I0[1:0] = inst64__O[1:0];
  assign inst66__I0 = inst1__O[0];
  assign inst0__I[2] = inst66__O;
  assign inst67__I1[3:0] = inst7__O[3:0];
  assign inst67__I2[3:0] = inst8__O[3:0];
  assign inst67__I3[3:0] = inst9__O[3:0];
  assign inst68__in = next_full__O;
  assign inst69__I1 = inst68__out;
  assign inst69__I0 = wen;
  assign inst70__in = inst69__O;
  assign inst7__CLK = CLK;
  assign inst75__I1[3:0] = inst7__O[3:0];
  assign inst81__I0[3:0] = inst7__O[3:0];
  assign inst94__I1[3:0] = inst7__O[3:0];
  assign inst74__I1 = inst70__out;
  assign inst71__in = next_empty__O;
  assign inst72__I1 = inst71__out;
  assign inst72__I0 = ren;
  assign inst73__in = inst72__O;
  assign inst74__I2 = inst73__out;
  assign inst74__I0 = inst1__O[0];
  assign inst0__I[3] = inst74__O;
  assign inst75__I2[3:0] = inst8__O[3:0];
  assign inst75__I3[3:0] = inst9__O[3:0];
  assign inst76__in = next_full__O;
  assign inst77__I1 = inst76__out;
  assign inst77__I0 = wen;
  assign inst93__I1 = inst77__O;
  assign inst79__I1[3:0] = wdata[3:0];
  assign inst8__CLK = CLK;
  assign inst83__I0[3:0] = inst8__O[3:0];
  assign inst94__I2[3:0] = inst8__O[3:0];
  assign inst80__in = inst78__O[0];
  assign inst79__S[0] = inst80__out;
  assign inst81__I1[3:0] = wdata[3:0];
  assign inst82__in = inst78__O[1];
  assign inst81__S[0] = inst82__out;
  assign inst83__I1[3:0] = wdata[3:0];
  assign inst84__in = inst78__O[2];
  assign inst83__S[0] = inst84__out;
  assign inst85__I0[3:0] = inst9__O[3:0];
  assign inst85__I1[3:0] = wdata[3:0];
  assign inst86__in = inst78__O[3];
  assign inst85__S[0] = inst86__out;
  assign inst88__I1[1:0] = inst87__O[1:0];
  assign inst92__I1[1:0] = inst87__O[1:0];
  assign inst89__in = next_empty__O;
  assign inst90__I1 = inst89__out;
  assign inst9__CLK = CLK;
  assign inst94__I3[3:0] = inst9__O[3:0];
  assign inst90__I0 = ren;
  assign inst93__I2 = inst90__O;
  assign inst92__I0[1:0] = inst91__O[1:0];
  assign inst93__I0 = inst1__O[1];
  assign inst0__I[4] = inst93__O;
  assign inst95__in = next_full__O;
  assign inst96__I1 = inst95__out;
  assign inst96__I0 = wen;
  assign inst98__I1[3:0] = wdata[3:0];
  assign inst99__in = inst97__O[0];
  assign inst98__S[0] = inst99__out;
  assign next_empty__CLK = CLK;
  assign next_full__CLK = CLK;
  assign inst100__S[1] = inst97__O[1];
  assign inst102__S[1] = inst97__O[2];
  assign inst104__S[1] = inst97__O[3];
  assign inst25__S[1] = inst24__O[0];
  assign inst27__S[1] = inst24__O[1];
  assign inst29__S[1] = inst24__O[2];
  assign inst31__S[1] = inst24__O[3];
  assign inst44__S[1] = inst43__O[0];
  assign inst46__S[1] = inst43__O[1];
  assign inst48__S[1] = inst43__O[2];
  assign inst50__S[1] = inst43__O[3];
  assign inst79__S[1] = inst78__O[0];
  assign inst81__S[1] = inst78__O[1];
  assign inst83__S[1] = inst78__O[2];
  assign inst85__S[1] = inst78__O[3];
  assign inst98__S[1] = inst97__O[0];

endmodule //Fifo
