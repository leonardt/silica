

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

module corebit_mux (
  input in0,
  input in1,
  input sel,
  output out
);
  assign out = sel ? in1 : in0;

endmodule //corebit_mux

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

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

module coreir_mux #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  input sel,
  output [width-1:0] out
);
  assign out = sel ? in1 : in0;

endmodule //coreir_mux

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

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

module Or4x4 (
  input [3:0] I0,
  input [3:0] I1,
  input [3:0] I2,
  input [3:0] I3,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [3:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(4)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [3:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(4)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [3:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(4)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [3:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(4)) inst3(
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
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst2__in[0] = I0[2];
  assign inst2__in[1] = I1[2];
  assign inst2__in[2] = I2[2];
  assign inst2__in[3] = I3[2];
  assign inst3__in[0] = I0[3];
  assign inst3__in[1] = I1[3];
  assign inst3__in[2] = I2[3];
  assign inst3__in[3] = I3[3];

endmodule //Or4x4

module SilicaOneHotMux44 (
  input [3:0] I0,
  input [3:0] I1,
  input [3:0] I2,
  input [3:0] I3,
  output [3:0] O,
  input [3:0] S
);
  //Wire declarations for instance 'inst0' (Module Or4x4)
  wire [3:0] inst0__I0;
  wire [3:0] inst0__I1;
  wire [3:0] inst0__I2;
  wire [3:0] inst0__I3;
  wire [3:0] inst0__O;
  Or4x4 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
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

  //All the connections
  assign inst0__I0[3:0] = inst1__O[3:0];
  assign inst0__I1[3:0] = inst2__O[3:0];
  assign inst0__I2[3:0] = inst3__O[3:0];
  assign inst0__I3[3:0] = inst4__O[3:0];
  assign O[3:0] = inst0__O[3:0];
  assign inst1__I0[3:0] = I0[3:0];
  assign inst2__I0[3:0] = I1[3:0];
  assign inst3__I0[3:0] = I2[3:0];
  assign inst4__I0[3:0] = I3[3:0];
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

endmodule //SilicaOneHotMux44

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

module Or4xNone (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [3:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(4)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign O = inst0__out;
  assign inst0__in[0] = I0;
  assign inst0__in[1] = I1;
  assign inst0__in[2] = I2;
  assign inst0__in[3] = I3;

endmodule //Or4xNone

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

module Mux2x4 (
  input [3:0] I0,
  input [3:0] I1,
  output [3:0] O,
  input  S
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

  //Wire declarations for instance 'inst3' (Module _Mux2)
  wire [1:0] inst3__I;
  wire  inst3__O;
  wire  inst3__S;
  _Mux2 inst3(
    .I(inst3__I),
    .O(inst3__O),
    .S(inst3__S)
  );

  //All the connections
  assign O[0] = inst0__O;
  assign inst0__S = S;
  assign O[1] = inst1__O;
  assign inst1__S = S;
  assign O[2] = inst2__O;
  assign inst2__S = S;
  assign O[3] = inst3__O;
  assign inst3__S = S;
  assign inst0__I[0] = I0[0];
  assign inst0__I[1] = I1[0];
  assign inst1__I[0] = I0[1];
  assign inst1__I[1] = I1[1];
  assign inst2__I[0] = I0[2];
  assign inst2__I[1] = I1[2];
  assign inst3__I[0] = I0[3];
  assign inst3__I[1] = I1[3];

endmodule //Mux2x4

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

module reg_U3 #(parameter init=1) (
  input  clk,
  input  en,
  input [0:0] in,
  output [0:0] out
);
  //Wire declarations for instance 'enMux' (Module coreir_mux)
  wire [0:0] enMux__in0;
  wire [0:0] enMux__in1;
  wire [0:0] enMux__out;
  wire  enMux__sel;
  coreir_mux #(.width(1)) enMux(
    .in0(enMux__in0),
    .in1(enMux__in1),
    .out(enMux__out),
    .sel(enMux__sel)
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
  assign enMux__in0[0:0] = reg0__out[0:0];
  assign enMux__in1[0:0] = in[0:0];
  assign reg0__in[0:0] = enMux__out[0:0];
  assign enMux__sel = en;
  assign reg0__clk = clk;
  assign out[0:0] = reg0__out[0:0];

endmodule //reg_U3

module DFF_init0_has_ceTrue_has_resetFalse (
  input  CE,
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U3)
  wire  inst0__clk;
  wire  inst0__en;
  wire [0:0] inst0__in;
  wire [0:0] inst0__out;
  reg_U3 #(.init(1'd0)) inst0(
    .clk(inst0__clk),
    .en(inst0__en),
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__clk = CLK;
  assign inst0__en = CE;
  assign inst0__in[0] = I;
  assign O = inst0__out[0];

endmodule //DFF_init0_has_ceTrue_has_resetFalse

module Register4CE (
  input  CE,
  input  CLK,
  input [3:0] I,
  output [3:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init0_has_ceTrue_has_resetFalse)
  wire  inst0__CE;
  wire  inst0__CLK;
  wire  inst0__I;
  wire  inst0__O;
  DFF_init0_has_ceTrue_has_resetFalse inst0(
    .CE(inst0__CE),
    .CLK(inst0__CLK),
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceTrue_has_resetFalse)
  wire  inst1__CE;
  wire  inst1__CLK;
  wire  inst1__I;
  wire  inst1__O;
  DFF_init0_has_ceTrue_has_resetFalse inst1(
    .CE(inst1__CE),
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module DFF_init0_has_ceTrue_has_resetFalse)
  wire  inst2__CE;
  wire  inst2__CLK;
  wire  inst2__I;
  wire  inst2__O;
  DFF_init0_has_ceTrue_has_resetFalse inst2(
    .CE(inst2__CE),
    .CLK(inst2__CLK),
    .I(inst2__I),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module DFF_init0_has_ceTrue_has_resetFalse)
  wire  inst3__CE;
  wire  inst3__CLK;
  wire  inst3__I;
  wire  inst3__O;
  DFF_init0_has_ceTrue_has_resetFalse inst3(
    .CE(inst3__CE),
    .CLK(inst3__CLK),
    .I(inst3__I),
    .O(inst3__O)
  );

  //All the connections
  assign inst0__CE = CE;
  assign inst0__CLK = CLK;
  assign inst0__I = I[0];
  assign O[0] = inst0__O;
  assign inst1__CE = CE;
  assign inst1__CLK = CLK;
  assign inst1__I = I[1];
  assign O[1] = inst1__O;
  assign inst2__CE = CE;
  assign inst2__CLK = CLK;
  assign inst2__I = I[2];
  assign O[2] = inst2__O;
  assign inst3__CE = CE;
  assign inst3__CLK = CLK;
  assign inst3__I = I[3];
  assign O[3] = inst3__O;

endmodule //Register4CE

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

  //Wire declarations for instance 'inst10' (Module Mux4x4)
  wire [3:0] inst10__I0;
  wire [3:0] inst10__I1;
  wire [3:0] inst10__I2;
  wire [3:0] inst10__I3;
  wire [3:0] inst10__O;
  wire [1:0] inst10__S;
  Mux4x4 inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .I2(inst10__I2),
    .I3(inst10__I3),
    .O(inst10__O),
    .S(inst10__S)
  );

  //Wire declarations for instance 'inst100' (Module corebit_not)
  wire  inst100__in;
  wire  inst100__out;
  corebit_not inst100(
    .in(inst100__in),
    .out(inst100__out)
  );

  //Wire declarations for instance 'inst101' (Module And3xNone)
  wire  inst101__I0;
  wire  inst101__I1;
  wire  inst101__I2;
  wire  inst101__O;
  And3xNone inst101(
    .I0(inst101__I0),
    .I1(inst101__I1),
    .I2(inst101__I2),
    .O(inst101__O)
  );

  //Wire declarations for instance 'inst102' (Module SilicaOneHotMux8None)
  wire  inst102__I0;
  wire  inst102__I1;
  wire  inst102__I2;
  wire  inst102__I3;
  wire  inst102__I4;
  wire  inst102__I5;
  wire  inst102__I6;
  wire  inst102__I7;
  wire  inst102__O;
  wire [7:0] inst102__S;
  SilicaOneHotMux8None inst102(
    .I0(inst102__I0),
    .I1(inst102__I1),
    .I2(inst102__I2),
    .I3(inst102__I3),
    .I4(inst102__I4),
    .I5(inst102__I5),
    .I6(inst102__I6),
    .I7(inst102__I7),
    .O(inst102__O),
    .S(inst102__S)
  );

  //Wire declarations for instance 'inst103' (Module SilicaOneHotMux82)
  wire [1:0] inst103__I0;
  wire [1:0] inst103__I1;
  wire [1:0] inst103__I2;
  wire [1:0] inst103__I3;
  wire [1:0] inst103__I4;
  wire [1:0] inst103__I5;
  wire [1:0] inst103__I6;
  wire [1:0] inst103__I7;
  wire [1:0] inst103__O;
  wire [7:0] inst103__S;
  SilicaOneHotMux82 inst103(
    .I0(inst103__I0),
    .I1(inst103__I1),
    .I2(inst103__I2),
    .I3(inst103__I3),
    .I4(inst103__I4),
    .I5(inst103__I5),
    .I6(inst103__I6),
    .I7(inst103__I7),
    .O(inst103__O),
    .S(inst103__S)
  );

  //Wire declarations for instance 'inst104' (Module SilicaOneHotMux44)
  wire [3:0] inst104__I0;
  wire [3:0] inst104__I1;
  wire [3:0] inst104__I2;
  wire [3:0] inst104__I3;
  wire [3:0] inst104__O;
  wire [3:0] inst104__S;
  SilicaOneHotMux44 inst104(
    .I0(inst104__I0),
    .I1(inst104__I1),
    .I2(inst104__I2),
    .I3(inst104__I3),
    .O(inst104__O),
    .S(inst104__S)
  );

  //Wire declarations for instance 'inst105' (Module SilicaOneHotMux44)
  wire [3:0] inst105__I0;
  wire [3:0] inst105__I1;
  wire [3:0] inst105__I2;
  wire [3:0] inst105__I3;
  wire [3:0] inst105__O;
  wire [3:0] inst105__S;
  SilicaOneHotMux44 inst105(
    .I0(inst105__I0),
    .I1(inst105__I1),
    .I2(inst105__I2),
    .I3(inst105__I3),
    .O(inst105__O),
    .S(inst105__S)
  );

  //Wire declarations for instance 'inst106' (Module SilicaOneHotMux44)
  wire [3:0] inst106__I0;
  wire [3:0] inst106__I1;
  wire [3:0] inst106__I2;
  wire [3:0] inst106__I3;
  wire [3:0] inst106__O;
  wire [3:0] inst106__S;
  SilicaOneHotMux44 inst106(
    .I0(inst106__I0),
    .I1(inst106__I1),
    .I2(inst106__I2),
    .I3(inst106__I3),
    .O(inst106__O),
    .S(inst106__S)
  );

  //Wire declarations for instance 'inst107' (Module SilicaOneHotMux44)
  wire [3:0] inst107__I0;
  wire [3:0] inst107__I1;
  wire [3:0] inst107__I2;
  wire [3:0] inst107__I3;
  wire [3:0] inst107__O;
  wire [3:0] inst107__S;
  SilicaOneHotMux44 inst107(
    .I0(inst107__I0),
    .I1(inst107__I1),
    .I2(inst107__I2),
    .I3(inst107__I3),
    .O(inst107__O),
    .S(inst107__S)
  );

  //Wire declarations for instance 'inst108' (Module Or4xNone)
  wire  inst108__I0;
  wire  inst108__I1;
  wire  inst108__I2;
  wire  inst108__I3;
  wire  inst108__O;
  Or4xNone inst108(
    .I0(inst108__I0),
    .I1(inst108__I1),
    .I2(inst108__I2),
    .I3(inst108__I3),
    .O(inst108__O)
  );

  //Wire declarations for instance 'inst109' (Module Or4xNone)
  wire  inst109__I0;
  wire  inst109__I1;
  wire  inst109__I2;
  wire  inst109__I3;
  wire  inst109__O;
  Or4xNone inst109(
    .I0(inst109__I0),
    .I1(inst109__I1),
    .I2(inst109__I2),
    .I3(inst109__I3),
    .O(inst109__O)
  );

  //Wire declarations for instance 'inst11' (Module corebit_not)
  wire  inst11__in;
  wire  inst11__out;
  corebit_not inst11(
    .in(inst11__in),
    .out(inst11__out)
  );

  //Wire declarations for instance 'inst110' (Module Or4xNone)
  wire  inst110__I0;
  wire  inst110__I1;
  wire  inst110__I2;
  wire  inst110__I3;
  wire  inst110__O;
  Or4xNone inst110(
    .I0(inst110__I0),
    .I1(inst110__I1),
    .I2(inst110__I2),
    .I3(inst110__I3),
    .O(inst110__O)
  );

  //Wire declarations for instance 'inst111' (Module Or4xNone)
  wire  inst111__I0;
  wire  inst111__I1;
  wire  inst111__I2;
  wire  inst111__I3;
  wire  inst111__O;
  Or4xNone inst111(
    .I0(inst111__I0),
    .I1(inst111__I1),
    .I2(inst111__I2),
    .I3(inst111__I3),
    .O(inst111__O)
  );

  //Wire declarations for instance 'inst112' (Module SilicaOneHotMux82)
  wire [1:0] inst112__I0;
  wire [1:0] inst112__I1;
  wire [1:0] inst112__I2;
  wire [1:0] inst112__I3;
  wire [1:0] inst112__I4;
  wire [1:0] inst112__I5;
  wire [1:0] inst112__I6;
  wire [1:0] inst112__I7;
  wire [1:0] inst112__O;
  wire [7:0] inst112__S;
  SilicaOneHotMux82 inst112(
    .I0(inst112__I0),
    .I1(inst112__I1),
    .I2(inst112__I2),
    .I3(inst112__I3),
    .I4(inst112__I4),
    .I5(inst112__I5),
    .I6(inst112__I6),
    .I7(inst112__I7),
    .O(inst112__O),
    .S(inst112__S)
  );

  //Wire declarations for instance 'inst113' (Module SilicaOneHotMux8None)
  wire  inst113__I0;
  wire  inst113__I1;
  wire  inst113__I2;
  wire  inst113__I3;
  wire  inst113__I4;
  wire  inst113__I5;
  wire  inst113__I6;
  wire  inst113__I7;
  wire  inst113__O;
  wire [7:0] inst113__S;
  SilicaOneHotMux8None inst113(
    .I0(inst113__I0),
    .I1(inst113__I1),
    .I2(inst113__I2),
    .I3(inst113__I3),
    .I4(inst113__I4),
    .I5(inst113__I5),
    .I6(inst113__I6),
    .I7(inst113__I7),
    .O(inst113__O),
    .S(inst113__S)
  );

  //Wire declarations for instance 'inst114' (Module SilicaOneHotMux8None)
  wire  inst114__I0;
  wire  inst114__I1;
  wire  inst114__I2;
  wire  inst114__I3;
  wire  inst114__I4;
  wire  inst114__I5;
  wire  inst114__I6;
  wire  inst114__I7;
  wire  inst114__O;
  wire [7:0] inst114__S;
  SilicaOneHotMux8None inst114(
    .I0(inst114__I0),
    .I1(inst114__I1),
    .I2(inst114__I2),
    .I3(inst114__I3),
    .I4(inst114__I4),
    .I5(inst114__I5),
    .I6(inst114__I6),
    .I7(inst114__I7),
    .O(inst114__O),
    .S(inst114__S)
  );

  //Wire declarations for instance 'inst115' (Module SilicaOneHotMux8None)
  wire  inst115__I0;
  wire  inst115__I1;
  wire  inst115__I2;
  wire  inst115__I3;
  wire  inst115__I4;
  wire  inst115__I5;
  wire  inst115__I6;
  wire  inst115__I7;
  wire  inst115__O;
  wire [7:0] inst115__S;
  SilicaOneHotMux8None inst115(
    .I0(inst115__I0),
    .I1(inst115__I1),
    .I2(inst115__I2),
    .I3(inst115__I3),
    .I4(inst115__I4),
    .I5(inst115__I5),
    .I6(inst115__I6),
    .I7(inst115__I7),
    .O(inst115__O),
    .S(inst115__S)
  );

  //Wire declarations for instance 'inst116' (Module SilicaOneHotMux84)
  wire [3:0] inst116__I0;
  wire [3:0] inst116__I1;
  wire [3:0] inst116__I2;
  wire [3:0] inst116__I3;
  wire [3:0] inst116__I4;
  wire [3:0] inst116__I5;
  wire [3:0] inst116__I6;
  wire [3:0] inst116__I7;
  wire [3:0] inst116__O;
  wire [7:0] inst116__S;
  SilicaOneHotMux84 inst116(
    .I0(inst116__I0),
    .I1(inst116__I1),
    .I2(inst116__I2),
    .I3(inst116__I3),
    .I4(inst116__I4),
    .I5(inst116__I5),
    .I6(inst116__I6),
    .I7(inst116__I7),
    .O(inst116__O),
    .S(inst116__S)
  );

  //Wire declarations for instance 'inst12' (Module and_wrapped)
  wire  inst12__I0;
  wire  inst12__I1;
  wire  inst12__O;
  and_wrapped inst12(
    .I0(inst12__I0),
    .I1(inst12__I1),
    .O(inst12__O)
  );

  //Wire declarations for instance 'inst13' (Module Decoder2)
  wire [1:0] inst13__I;
  wire [3:0] inst13__O;
  Decoder2 inst13(
    .I(inst13__I),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module Mux2x4)
  wire [3:0] inst14__I0;
  wire [3:0] inst14__I1;
  wire [3:0] inst14__O;
  wire  inst14__S;
  Mux2x4 inst14(
    .I0(inst14__I0),
    .I1(inst14__I1),
    .O(inst14__O),
    .S(inst14__S)
  );

  //Wire declarations for instance 'inst15' (Module Mux2x4)
  wire [3:0] inst15__I0;
  wire [3:0] inst15__I1;
  wire [3:0] inst15__O;
  wire  inst15__S;
  Mux2x4 inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .O(inst15__O),
    .S(inst15__S)
  );

  //Wire declarations for instance 'inst16' (Module Mux2x4)
  wire [3:0] inst16__I0;
  wire [3:0] inst16__I1;
  wire [3:0] inst16__O;
  wire  inst16__S;
  Mux2x4 inst16(
    .I0(inst16__I0),
    .I1(inst16__I1),
    .O(inst16__O),
    .S(inst16__S)
  );

  //Wire declarations for instance 'inst17' (Module Mux2x4)
  wire [3:0] inst17__I0;
  wire [3:0] inst17__I1;
  wire [3:0] inst17__O;
  wire  inst17__S;
  Mux2x4 inst17(
    .I0(inst17__I0),
    .I1(inst17__I1),
    .O(inst17__O),
    .S(inst17__S)
  );

  //Wire declarations for instance 'inst18' (Module Add2)
  wire [1:0] inst18__I0;
  wire [1:0] inst18__I1;
  wire [1:0] inst18__O;
  Add2 inst18(
    .I0(inst18__I0),
    .I1(inst18__I1),
    .O(inst18__O)
  );

  //Wire declarations for instance 'inst19' (Module EQ2)
  wire [1:0] inst19__I0;
  wire [1:0] inst19__I1;
  wire  inst19__O;
  EQ2 inst19(
    .I0(inst19__I0),
    .I1(inst19__I1),
    .O(inst19__O)
  );

  //Wire declarations for instance 'inst20' (Module corebit_not)
  wire  inst20__in;
  wire  inst20__out;
  corebit_not inst20(
    .in(inst20__in),
    .out(inst20__out)
  );

  //Wire declarations for instance 'inst21' (Module and_wrapped)
  wire  inst21__I0;
  wire  inst21__I1;
  wire  inst21__O;
  and_wrapped inst21(
    .I0(inst21__I0),
    .I1(inst21__I1),
    .O(inst21__O)
  );

  //Wire declarations for instance 'inst22' (Module Add2)
  wire [1:0] inst22__I0;
  wire [1:0] inst22__I1;
  wire [1:0] inst22__O;
  Add2 inst22(
    .I0(inst22__I0),
    .I1(inst22__I1),
    .O(inst22__O)
  );

  //Wire declarations for instance 'inst23' (Module EQ2)
  wire [1:0] inst23__I0;
  wire [1:0] inst23__I1;
  wire  inst23__O;
  EQ2 inst23(
    .I0(inst23__I0),
    .I1(inst23__I1),
    .O(inst23__O)
  );

  //Wire declarations for instance 'inst24' (Module And3xNone)
  wire  inst24__I0;
  wire  inst24__I1;
  wire  inst24__I2;
  wire  inst24__O;
  And3xNone inst24(
    .I0(inst24__I0),
    .I1(inst24__I1),
    .I2(inst24__I2),
    .O(inst24__O)
  );

  //Wire declarations for instance 'inst25' (Module Mux4x4)
  wire [3:0] inst25__I0;
  wire [3:0] inst25__I1;
  wire [3:0] inst25__I2;
  wire [3:0] inst25__I3;
  wire [3:0] inst25__O;
  wire [1:0] inst25__S;
  Mux4x4 inst25(
    .I0(inst25__I0),
    .I1(inst25__I1),
    .I2(inst25__I2),
    .I3(inst25__I3),
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

  //Wire declarations for instance 'inst27' (Module and_wrapped)
  wire  inst27__I0;
  wire  inst27__I1;
  wire  inst27__O;
  and_wrapped inst27(
    .I0(inst27__I0),
    .I1(inst27__I1),
    .O(inst27__O)
  );

  //Wire declarations for instance 'inst28' (Module Decoder2)
  wire [1:0] inst28__I;
  wire [3:0] inst28__O;
  Decoder2 inst28(
    .I(inst28__I),
    .O(inst28__O)
  );

  //Wire declarations for instance 'inst29' (Module Mux2x4)
  wire [3:0] inst29__I0;
  wire [3:0] inst29__I1;
  wire [3:0] inst29__O;
  wire  inst29__S;
  Mux2x4 inst29(
    .I0(inst29__I0),
    .I1(inst29__I1),
    .O(inst29__O),
    .S(inst29__S)
  );

  //Wire declarations for instance 'inst3' (Module Register2)
  wire  inst3__CLK;
  wire [1:0] inst3__I;
  wire [1:0] inst3__O;
  Register2 inst3(
    .CLK(inst3__CLK),
    .I(inst3__I),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst30' (Module Mux2x4)
  wire [3:0] inst30__I0;
  wire [3:0] inst30__I1;
  wire [3:0] inst30__O;
  wire  inst30__S;
  Mux2x4 inst30(
    .I0(inst30__I0),
    .I1(inst30__I1),
    .O(inst30__O),
    .S(inst30__S)
  );

  //Wire declarations for instance 'inst31' (Module Mux2x4)
  wire [3:0] inst31__I0;
  wire [3:0] inst31__I1;
  wire [3:0] inst31__O;
  wire  inst31__S;
  Mux2x4 inst31(
    .I0(inst31__I0),
    .I1(inst31__I1),
    .O(inst31__O),
    .S(inst31__S)
  );

  //Wire declarations for instance 'inst32' (Module Mux2x4)
  wire [3:0] inst32__I0;
  wire [3:0] inst32__I1;
  wire [3:0] inst32__O;
  wire  inst32__S;
  Mux2x4 inst32(
    .I0(inst32__I0),
    .I1(inst32__I1),
    .O(inst32__O),
    .S(inst32__S)
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

  //Wire declarations for instance 'inst37' (Module corebit_not)
  wire  inst37__in;
  wire  inst37__out;
  corebit_not inst37(
    .in(inst37__in),
    .out(inst37__out)
  );

  //Wire declarations for instance 'inst38' (Module And3xNone)
  wire  inst38__I0;
  wire  inst38__I1;
  wire  inst38__I2;
  wire  inst38__O;
  And3xNone inst38(
    .I0(inst38__I0),
    .I1(inst38__I1),
    .I2(inst38__I2),
    .O(inst38__O)
  );

  //Wire declarations for instance 'inst39' (Module Mux4x4)
  wire [3:0] inst39__I0;
  wire [3:0] inst39__I1;
  wire [3:0] inst39__I2;
  wire [3:0] inst39__I3;
  wire [3:0] inst39__O;
  wire [1:0] inst39__S;
  Mux4x4 inst39(
    .I0(inst39__I0),
    .I1(inst39__I1),
    .I2(inst39__I2),
    .I3(inst39__I3),
    .O(inst39__O),
    .S(inst39__S)
  );

  //Wire declarations for instance 'inst4' (Module Register4CE)
  wire  inst4__CE;
  wire  inst4__CLK;
  wire [3:0] inst4__I;
  wire [3:0] inst4__O;
  Register4CE inst4(
    .CE(inst4__CE),
    .CLK(inst4__CLK),
    .I(inst4__I),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst40' (Module corebit_not)
  wire  inst40__in;
  wire  inst40__out;
  corebit_not inst40(
    .in(inst40__in),
    .out(inst40__out)
  );

  //Wire declarations for instance 'inst41' (Module and_wrapped)
  wire  inst41__I0;
  wire  inst41__I1;
  wire  inst41__O;
  and_wrapped inst41(
    .I0(inst41__I0),
    .I1(inst41__I1),
    .O(inst41__O)
  );

  //Wire declarations for instance 'inst42' (Module corebit_not)
  wire  inst42__in;
  wire  inst42__out;
  corebit_not inst42(
    .in(inst42__in),
    .out(inst42__out)
  );

  //Wire declarations for instance 'inst43' (Module corebit_not)
  wire  inst43__in;
  wire  inst43__out;
  corebit_not inst43(
    .in(inst43__in),
    .out(inst43__out)
  );

  //Wire declarations for instance 'inst44' (Module and_wrapped)
  wire  inst44__I0;
  wire  inst44__I1;
  wire  inst44__O;
  and_wrapped inst44(
    .I0(inst44__I0),
    .I1(inst44__I1),
    .O(inst44__O)
  );

  //Wire declarations for instance 'inst45' (Module Add2)
  wire [1:0] inst45__I0;
  wire [1:0] inst45__I1;
  wire [1:0] inst45__O;
  Add2 inst45(
    .I0(inst45__I0),
    .I1(inst45__I1),
    .O(inst45__O)
  );

  //Wire declarations for instance 'inst46' (Module EQ2)
  wire [1:0] inst46__I0;
  wire [1:0] inst46__I1;
  wire  inst46__O;
  EQ2 inst46(
    .I0(inst46__I0),
    .I1(inst46__I1),
    .O(inst46__O)
  );

  //Wire declarations for instance 'inst47' (Module And3xNone)
  wire  inst47__I0;
  wire  inst47__I1;
  wire  inst47__I2;
  wire  inst47__O;
  And3xNone inst47(
    .I0(inst47__I0),
    .I1(inst47__I1),
    .I2(inst47__I2),
    .O(inst47__O)
  );

  //Wire declarations for instance 'inst48' (Module Mux4x4)
  wire [3:0] inst48__I0;
  wire [3:0] inst48__I1;
  wire [3:0] inst48__I2;
  wire [3:0] inst48__I3;
  wire [3:0] inst48__O;
  wire [1:0] inst48__S;
  Mux4x4 inst48(
    .I0(inst48__I0),
    .I1(inst48__I1),
    .I2(inst48__I2),
    .I3(inst48__I3),
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

  //Wire declarations for instance 'inst5' (Module Register4CE)
  wire  inst5__CE;
  wire  inst5__CLK;
  wire [3:0] inst5__I;
  wire [3:0] inst5__O;
  Register4CE inst5(
    .CE(inst5__CE),
    .CLK(inst5__CLK),
    .I(inst5__I),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst50' (Module and_wrapped)
  wire  inst50__I0;
  wire  inst50__I1;
  wire  inst50__O;
  and_wrapped inst50(
    .I0(inst50__I0),
    .I1(inst50__I1),
    .O(inst50__O)
  );

  //Wire declarations for instance 'inst51' (Module corebit_not)
  wire  inst51__in;
  wire  inst51__out;
  corebit_not inst51(
    .in(inst51__in),
    .out(inst51__out)
  );

  //Wire declarations for instance 'inst52' (Module corebit_not)
  wire  inst52__in;
  wire  inst52__out;
  corebit_not inst52(
    .in(inst52__in),
    .out(inst52__out)
  );

  //Wire declarations for instance 'inst53' (Module and_wrapped)
  wire  inst53__I0;
  wire  inst53__I1;
  wire  inst53__O;
  and_wrapped inst53(
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

  //Wire declarations for instance 'inst55' (Module And3xNone)
  wire  inst55__I0;
  wire  inst55__I1;
  wire  inst55__I2;
  wire  inst55__O;
  And3xNone inst55(
    .I0(inst55__I0),
    .I1(inst55__I1),
    .I2(inst55__I2),
    .O(inst55__O)
  );

  //Wire declarations for instance 'inst56' (Module Mux4x4)
  wire [3:0] inst56__I0;
  wire [3:0] inst56__I1;
  wire [3:0] inst56__I2;
  wire [3:0] inst56__I3;
  wire [3:0] inst56__O;
  wire [1:0] inst56__S;
  Mux4x4 inst56(
    .I0(inst56__I0),
    .I1(inst56__I1),
    .I2(inst56__I2),
    .I3(inst56__I3),
    .O(inst56__O),
    .S(inst56__S)
  );

  //Wire declarations for instance 'inst57' (Module corebit_not)
  wire  inst57__in;
  wire  inst57__out;
  corebit_not inst57(
    .in(inst57__in),
    .out(inst57__out)
  );

  //Wire declarations for instance 'inst58' (Module and_wrapped)
  wire  inst58__I0;
  wire  inst58__I1;
  wire  inst58__O;
  and_wrapped inst58(
    .I0(inst58__I0),
    .I1(inst58__I1),
    .O(inst58__O)
  );

  //Wire declarations for instance 'inst59' (Module Decoder2)
  wire [1:0] inst59__I;
  wire [3:0] inst59__O;
  Decoder2 inst59(
    .I(inst59__I),
    .O(inst59__O)
  );

  //Wire declarations for instance 'inst6' (Module Register4CE)
  wire  inst6__CE;
  wire  inst6__CLK;
  wire [3:0] inst6__I;
  wire [3:0] inst6__O;
  Register4CE inst6(
    .CE(inst6__CE),
    .CLK(inst6__CLK),
    .I(inst6__I),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst60' (Module Mux2x4)
  wire [3:0] inst60__I0;
  wire [3:0] inst60__I1;
  wire [3:0] inst60__O;
  wire  inst60__S;
  Mux2x4 inst60(
    .I0(inst60__I0),
    .I1(inst60__I1),
    .O(inst60__O),
    .S(inst60__S)
  );

  //Wire declarations for instance 'inst61' (Module Mux2x4)
  wire [3:0] inst61__I0;
  wire [3:0] inst61__I1;
  wire [3:0] inst61__O;
  wire  inst61__S;
  Mux2x4 inst61(
    .I0(inst61__I0),
    .I1(inst61__I1),
    .O(inst61__O),
    .S(inst61__S)
  );

  //Wire declarations for instance 'inst62' (Module Mux2x4)
  wire [3:0] inst62__I0;
  wire [3:0] inst62__I1;
  wire [3:0] inst62__O;
  wire  inst62__S;
  Mux2x4 inst62(
    .I0(inst62__I0),
    .I1(inst62__I1),
    .O(inst62__O),
    .S(inst62__S)
  );

  //Wire declarations for instance 'inst63' (Module Mux2x4)
  wire [3:0] inst63__I0;
  wire [3:0] inst63__I1;
  wire [3:0] inst63__O;
  wire  inst63__S;
  Mux2x4 inst63(
    .I0(inst63__I0),
    .I1(inst63__I1),
    .O(inst63__O),
    .S(inst63__S)
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

  //Wire declarations for instance 'inst66' (Module corebit_not)
  wire  inst66__in;
  wire  inst66__out;
  corebit_not inst66(
    .in(inst66__in),
    .out(inst66__out)
  );

  //Wire declarations for instance 'inst67' (Module and_wrapped)
  wire  inst67__I0;
  wire  inst67__I1;
  wire  inst67__O;
  and_wrapped inst67(
    .I0(inst67__I0),
    .I1(inst67__I1),
    .O(inst67__O)
  );

  //Wire declarations for instance 'inst68' (Module Add2)
  wire [1:0] inst68__I0;
  wire [1:0] inst68__I1;
  wire [1:0] inst68__O;
  Add2 inst68(
    .I0(inst68__I0),
    .I1(inst68__I1),
    .O(inst68__O)
  );

  //Wire declarations for instance 'inst69' (Module EQ2)
  wire [1:0] inst69__I0;
  wire [1:0] inst69__I1;
  wire  inst69__O;
  EQ2 inst69(
    .I0(inst69__I0),
    .I1(inst69__I1),
    .O(inst69__O)
  );

  //Wire declarations for instance 'inst7' (Module Register4CE)
  wire  inst7__CE;
  wire  inst7__CLK;
  wire [3:0] inst7__I;
  wire [3:0] inst7__O;
  Register4CE inst7(
    .CE(inst7__CE),
    .CLK(inst7__CLK),
    .I(inst7__I),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst70' (Module And3xNone)
  wire  inst70__I0;
  wire  inst70__I1;
  wire  inst70__I2;
  wire  inst70__O;
  And3xNone inst70(
    .I0(inst70__I0),
    .I1(inst70__I1),
    .I2(inst70__I2),
    .O(inst70__O)
  );

  //Wire declarations for instance 'inst71' (Module Mux4x4)
  wire [3:0] inst71__I0;
  wire [3:0] inst71__I1;
  wire [3:0] inst71__I2;
  wire [3:0] inst71__I3;
  wire [3:0] inst71__O;
  wire [1:0] inst71__S;
  Mux4x4 inst71(
    .I0(inst71__I0),
    .I1(inst71__I1),
    .I2(inst71__I2),
    .I3(inst71__I3),
    .O(inst71__O),
    .S(inst71__S)
  );

  //Wire declarations for instance 'inst72' (Module corebit_not)
  wire  inst72__in;
  wire  inst72__out;
  corebit_not inst72(
    .in(inst72__in),
    .out(inst72__out)
  );

  //Wire declarations for instance 'inst73' (Module and_wrapped)
  wire  inst73__I0;
  wire  inst73__I1;
  wire  inst73__O;
  and_wrapped inst73(
    .I0(inst73__I0),
    .I1(inst73__I1),
    .O(inst73__O)
  );

  //Wire declarations for instance 'inst74' (Module Decoder2)
  wire [1:0] inst74__I;
  wire [3:0] inst74__O;
  Decoder2 inst74(
    .I(inst74__I),
    .O(inst74__O)
  );

  //Wire declarations for instance 'inst75' (Module Mux2x4)
  wire [3:0] inst75__I0;
  wire [3:0] inst75__I1;
  wire [3:0] inst75__O;
  wire  inst75__S;
  Mux2x4 inst75(
    .I0(inst75__I0),
    .I1(inst75__I1),
    .O(inst75__O),
    .S(inst75__S)
  );

  //Wire declarations for instance 'inst76' (Module Mux2x4)
  wire [3:0] inst76__I0;
  wire [3:0] inst76__I1;
  wire [3:0] inst76__O;
  wire  inst76__S;
  Mux2x4 inst76(
    .I0(inst76__I0),
    .I1(inst76__I1),
    .O(inst76__O),
    .S(inst76__S)
  );

  //Wire declarations for instance 'inst77' (Module Mux2x4)
  wire [3:0] inst77__I0;
  wire [3:0] inst77__I1;
  wire [3:0] inst77__O;
  wire  inst77__S;
  Mux2x4 inst77(
    .I0(inst77__I0),
    .I1(inst77__I1),
    .O(inst77__O),
    .S(inst77__S)
  );

  //Wire declarations for instance 'inst78' (Module Mux2x4)
  wire [3:0] inst78__I0;
  wire [3:0] inst78__I1;
  wire [3:0] inst78__O;
  wire  inst78__S;
  Mux2x4 inst78(
    .I0(inst78__I0),
    .I1(inst78__I1),
    .O(inst78__O),
    .S(inst78__S)
  );

  //Wire declarations for instance 'inst79' (Module Add2)
  wire [1:0] inst79__I0;
  wire [1:0] inst79__I1;
  wire [1:0] inst79__O;
  Add2 inst79(
    .I0(inst79__I0),
    .I1(inst79__I1),
    .O(inst79__O)
  );

  //Wire declarations for instance 'inst8' (Module Register2)
  wire  inst8__CLK;
  wire [1:0] inst8__I;
  wire [1:0] inst8__O;
  Register2 inst8(
    .CLK(inst8__CLK),
    .I(inst8__I),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst80' (Module EQ2)
  wire [1:0] inst80__I0;
  wire [1:0] inst80__I1;
  wire  inst80__O;
  EQ2 inst80(
    .I0(inst80__I0),
    .I1(inst80__I1),
    .O(inst80__O)
  );

  //Wire declarations for instance 'inst81' (Module corebit_not)
  wire  inst81__in;
  wire  inst81__out;
  corebit_not inst81(
    .in(inst81__in),
    .out(inst81__out)
  );

  //Wire declarations for instance 'inst82' (Module and_wrapped)
  wire  inst82__I0;
  wire  inst82__I1;
  wire  inst82__O;
  and_wrapped inst82(
    .I0(inst82__I0),
    .I1(inst82__I1),
    .O(inst82__O)
  );

  //Wire declarations for instance 'inst83' (Module corebit_not)
  wire  inst83__in;
  wire  inst83__out;
  corebit_not inst83(
    .in(inst83__in),
    .out(inst83__out)
  );

  //Wire declarations for instance 'inst84' (Module And3xNone)
  wire  inst84__I0;
  wire  inst84__I1;
  wire  inst84__I2;
  wire  inst84__O;
  And3xNone inst84(
    .I0(inst84__I0),
    .I1(inst84__I1),
    .I2(inst84__I2),
    .O(inst84__O)
  );

  //Wire declarations for instance 'inst85' (Module Mux4x4)
  wire [3:0] inst85__I0;
  wire [3:0] inst85__I1;
  wire [3:0] inst85__I2;
  wire [3:0] inst85__I3;
  wire [3:0] inst85__O;
  wire [1:0] inst85__S;
  Mux4x4 inst85(
    .I0(inst85__I0),
    .I1(inst85__I1),
    .I2(inst85__I2),
    .I3(inst85__I3),
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

  //Wire declarations for instance 'inst87' (Module and_wrapped)
  wire  inst87__I0;
  wire  inst87__I1;
  wire  inst87__O;
  and_wrapped inst87(
    .I0(inst87__I0),
    .I1(inst87__I1),
    .O(inst87__O)
  );

  //Wire declarations for instance 'inst88' (Module corebit_not)
  wire  inst88__in;
  wire  inst88__out;
  corebit_not inst88(
    .in(inst88__in),
    .out(inst88__out)
  );

  //Wire declarations for instance 'inst89' (Module corebit_not)
  wire  inst89__in;
  wire  inst89__out;
  corebit_not inst89(
    .in(inst89__in),
    .out(inst89__out)
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

  //Wire declarations for instance 'inst97' (Module corebit_not)
  wire  inst97__in;
  wire  inst97__out;
  corebit_not inst97(
    .in(inst97__in),
    .out(inst97__out)
  );

  //Wire declarations for instance 'inst98' (Module corebit_not)
  wire  inst98__in;
  wire  inst98__out;
  corebit_not inst98(
    .in(inst98__in),
    .out(inst98__out)
  );

  //Wire declarations for instance 'inst99' (Module and_wrapped)
  wire  inst99__I0;
  wire  inst99__I1;
  wire  inst99__O;
  and_wrapped inst99(
    .I0(inst99__I0),
    .I1(inst99__I1),
    .O(inst99__O)
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
  assign inst102__I0 = bit_const_GND__out;
  assign inst102__I2 = bit_const_GND__out;
  assign inst102__I4 = bit_const_GND__out;
  assign inst102__I6 = bit_const_GND__out;
  assign inst113__I1 = bit_const_GND__out;
  assign inst113__I5 = bit_const_GND__out;
  assign inst1__I[0] = bit_const_GND__out;
  assign inst18__I1[1] = bit_const_GND__out;
  assign inst22__I1[1] = bit_const_GND__out;
  assign inst33__I1[1] = bit_const_GND__out;
  assign inst45__I1[1] = bit_const_GND__out;
  assign inst64__I1[1] = bit_const_GND__out;
  assign inst68__I1[1] = bit_const_GND__out;
  assign inst79__I1[1] = bit_const_GND__out;
  assign inst91__I1[1] = bit_const_GND__out;
  assign inst1__I[1] = bit_const_VCC__out;
  assign inst18__I1[0] = bit_const_VCC__out;
  assign inst22__I1[0] = bit_const_VCC__out;
  assign inst33__I1[0] = bit_const_VCC__out;
  assign inst45__I1[0] = bit_const_VCC__out;
  assign inst64__I1[0] = bit_const_VCC__out;
  assign inst68__I1[0] = bit_const_VCC__out;
  assign inst79__I1[0] = bit_const_VCC__out;
  assign inst91__I1[0] = bit_const_VCC__out;
  assign inst102__S[7:0] = inst0__O[7:0];
  assign inst103__S[7:0] = inst0__O[7:0];
  assign inst112__S[7:0] = inst0__O[7:0];
  assign inst113__S[7:0] = inst0__O[7:0];
  assign inst114__S[7:0] = inst0__O[7:0];
  assign inst115__S[7:0] = inst0__O[7:0];
  assign inst116__S[7:0] = inst0__O[7:0];
  assign inst1__CLK = CLK;
  assign inst10__I0[3:0] = inst4__O[3:0];
  assign inst10__I1[3:0] = inst5__O[3:0];
  assign inst10__I2[3:0] = inst6__O[3:0];
  assign inst10__I3[3:0] = inst7__O[3:0];
  assign inst116__I0[3:0] = inst10__O[3:0];
  assign inst10__S[1:0] = inst3__O[1:0];
  assign inst100__in = inst99__O;
  assign inst101__I2 = inst100__out;
  assign inst101__I0 = inst1__O[1];
  assign inst101__I1 = inst97__out;
  assign inst0__I[7] = inst101__O;
  assign inst102__I1 = inst34__O;
  assign inst102__I3 = next_full__O;
  assign inst102__I5 = inst80__O;
  assign inst102__I7 = next_full__O;
  assign next_full__I = inst102__O;
  assign inst103__I0[1:0] = inst22__O[1:0];
  assign inst103__I1[1:0] = inst3__O[1:0];
  assign inst103__I2[1:0] = inst45__O[1:0];
  assign inst103__I3[1:0] = inst3__O[1:0];
  assign inst103__I4[1:0] = inst68__O[1:0];
  assign inst103__I5[1:0] = inst3__O[1:0];
  assign inst103__I6[1:0] = inst91__O[1:0];
  assign inst103__I7[1:0] = inst3__O[1:0];
  assign inst3__I[1:0] = inst103__O[1:0];
  assign inst104__I0[3:0] = inst14__O[3:0];
  assign inst104__I1[3:0] = inst29__O[3:0];
  assign inst104__I2[3:0] = inst60__O[3:0];
  assign inst104__I3[3:0] = inst75__O[3:0];
  assign inst4__I[3:0] = inst104__O[3:0];
  assign inst105__I0[3:0] = inst15__O[3:0];
  assign inst105__I1[3:0] = inst30__O[3:0];
  assign inst105__I2[3:0] = inst61__O[3:0];
  assign inst105__I3[3:0] = inst76__O[3:0];
  assign inst5__I[3:0] = inst105__O[3:0];
  assign inst106__I0[3:0] = inst16__O[3:0];
  assign inst106__I1[3:0] = inst31__O[3:0];
  assign inst106__I2[3:0] = inst62__O[3:0];
  assign inst106__I3[3:0] = inst77__O[3:0];
  assign inst6__I[3:0] = inst106__O[3:0];
  assign inst107__I0[3:0] = inst17__O[3:0];
  assign inst107__I1[3:0] = inst32__O[3:0];
  assign inst107__I2[3:0] = inst63__O[3:0];
  assign inst107__I3[3:0] = inst78__O[3:0];
  assign inst7__I[3:0] = inst107__O[3:0];
  assign inst108__I0 = inst0__O[0];
  assign inst108__I1 = inst0__O[1];
  assign inst108__I2 = inst0__O[4];
  assign inst108__I3 = inst0__O[5];
  assign inst4__CE = inst108__O;
  assign inst109__I0 = inst0__O[0];
  assign inst109__I1 = inst0__O[1];
  assign inst109__I2 = inst0__O[4];
  assign inst109__I3 = inst0__O[5];
  assign inst5__CE = inst109__O;
  assign inst11__in = next_full__O;
  assign inst12__I1 = inst11__out;
  assign inst110__I0 = inst0__O[0];
  assign inst110__I1 = inst0__O[1];
  assign inst110__I2 = inst0__O[4];
  assign inst110__I3 = inst0__O[5];
  assign inst6__CE = inst110__O;
  assign inst111__I0 = inst0__O[0];
  assign inst111__I1 = inst0__O[1];
  assign inst111__I2 = inst0__O[4];
  assign inst111__I3 = inst0__O[5];
  assign inst7__CE = inst111__O;
  assign inst112__I0[1:0] = inst18__O[1:0];
  assign inst112__I1[1:0] = inst33__O[1:0];
  assign inst112__I2[1:0] = inst8__O[1:0];
  assign inst112__I3[1:0] = inst8__O[1:0];
  assign inst112__I4[1:0] = inst64__O[1:0];
  assign inst112__I5[1:0] = inst79__O[1:0];
  assign inst112__I6[1:0] = inst8__O[1:0];
  assign inst112__I7[1:0] = inst8__O[1:0];
  assign inst8__I[1:0] = inst112__O[1:0];
  assign inst113__I0 = inst23__O;
  assign inst113__I2 = inst46__O;
  assign inst113__I3 = next_empty__O;
  assign inst113__I4 = inst69__O;
  assign inst113__I6 = inst92__O;
  assign inst113__I7 = next_empty__O;
  assign next_empty__I = inst113__O;
  assign inst114__I0 = next_empty__O;
  assign inst114__I1 = next_empty__O;
  assign inst114__I2 = next_empty__O;
  assign inst114__I3 = next_empty__O;
  assign inst114__I4 = next_empty__O;
  assign inst114__I5 = next_empty__O;
  assign inst114__I6 = next_empty__O;
  assign inst114__I7 = next_empty__O;
  assign empty = inst114__O;
  assign inst115__I0 = next_full__O;
  assign inst115__I1 = next_full__O;
  assign inst115__I2 = next_full__O;
  assign inst115__I3 = next_full__O;
  assign inst115__I4 = next_full__O;
  assign inst115__I5 = next_full__O;
  assign inst115__I6 = next_full__O;
  assign inst115__I7 = next_full__O;
  assign full = inst115__O;
  assign inst116__I1[3:0] = inst25__O[3:0];
  assign inst116__I2[3:0] = inst39__O[3:0];
  assign inst116__I3[3:0] = inst48__O[3:0];
  assign inst116__I4[3:0] = inst56__O[3:0];
  assign inst116__I5[3:0] = inst71__O[3:0];
  assign inst116__I6[3:0] = inst85__O[3:0];
  assign inst116__I7[3:0] = inst94__O[3:0];
  assign rdata[3:0] = inst116__O[3:0];
  assign inst12__I0 = wen;
  assign inst24__I1 = inst12__O;
  assign inst13__I[1:0] = inst8__O[1:0];
  assign inst14__I0[3:0] = inst4__O[3:0];
  assign inst14__I1[3:0] = wdata[3:0];
  assign inst14__S = inst13__O[0];
  assign inst15__I0[3:0] = inst5__O[3:0];
  assign inst15__I1[3:0] = wdata[3:0];
  assign inst15__S = inst13__O[1];
  assign inst16__I0[3:0] = inst6__O[3:0];
  assign inst16__I1[3:0] = wdata[3:0];
  assign inst16__S = inst13__O[2];
  assign inst17__I0[3:0] = inst7__O[3:0];
  assign inst17__I1[3:0] = wdata[3:0];
  assign inst17__S = inst13__O[3];
  assign inst18__I0[1:0] = inst8__O[1:0];
  assign inst19__I1[1:0] = inst18__O[1:0];
  assign inst23__I1[1:0] = inst18__O[1:0];
  assign inst19__I0[1:0] = inst3__O[1:0];
  assign inst20__in = next_empty__O;
  assign inst21__I1 = inst20__out;
  assign inst21__I0 = ren;
  assign inst24__I2 = inst21__O;
  assign inst22__I0[1:0] = inst3__O[1:0];
  assign inst23__I0[1:0] = inst22__O[1:0];
  assign inst24__I0 = inst1__O[0];
  assign inst0__I[0] = inst24__O;
  assign inst25__I0[3:0] = inst4__O[3:0];
  assign inst25__I1[3:0] = inst5__O[3:0];
  assign inst25__I2[3:0] = inst6__O[3:0];
  assign inst25__I3[3:0] = inst7__O[3:0];
  assign inst25__S[1:0] = inst3__O[1:0];
  assign inst26__in = next_full__O;
  assign inst27__I1 = inst26__out;
  assign inst27__I0 = wen;
  assign inst38__I1 = inst27__O;
  assign inst28__I[1:0] = inst8__O[1:0];
  assign inst29__I0[3:0] = inst4__O[3:0];
  assign inst29__I1[3:0] = wdata[3:0];
  assign inst29__S = inst28__O[0];
  assign inst3__CLK = CLK;
  assign inst34__I0[1:0] = inst3__O[1:0];
  assign inst39__S[1:0] = inst3__O[1:0];
  assign inst45__I0[1:0] = inst3__O[1:0];
  assign inst48__S[1:0] = inst3__O[1:0];
  assign inst56__S[1:0] = inst3__O[1:0];
  assign inst65__I0[1:0] = inst3__O[1:0];
  assign inst68__I0[1:0] = inst3__O[1:0];
  assign inst71__S[1:0] = inst3__O[1:0];
  assign inst80__I0[1:0] = inst3__O[1:0];
  assign inst85__S[1:0] = inst3__O[1:0];
  assign inst91__I0[1:0] = inst3__O[1:0];
  assign inst94__S[1:0] = inst3__O[1:0];
  assign inst30__I0[3:0] = inst5__O[3:0];
  assign inst30__I1[3:0] = wdata[3:0];
  assign inst30__S = inst28__O[1];
  assign inst31__I0[3:0] = inst6__O[3:0];
  assign inst31__I1[3:0] = wdata[3:0];
  assign inst31__S = inst28__O[2];
  assign inst32__I0[3:0] = inst7__O[3:0];
  assign inst32__I1[3:0] = wdata[3:0];
  assign inst32__S = inst28__O[3];
  assign inst33__I0[1:0] = inst8__O[1:0];
  assign inst34__I1[1:0] = inst33__O[1:0];
  assign inst35__in = next_empty__O;
  assign inst36__I1 = inst35__out;
  assign inst36__I0 = ren;
  assign inst37__in = inst36__O;
  assign inst38__I2 = inst37__out;
  assign inst38__I0 = inst1__O[0];
  assign inst0__I[1] = inst38__O;
  assign inst39__I0[3:0] = inst4__O[3:0];
  assign inst39__I1[3:0] = inst5__O[3:0];
  assign inst39__I2[3:0] = inst6__O[3:0];
  assign inst39__I3[3:0] = inst7__O[3:0];
  assign inst4__CLK = CLK;
  assign inst48__I0[3:0] = inst4__O[3:0];
  assign inst56__I0[3:0] = inst4__O[3:0];
  assign inst60__I0[3:0] = inst4__O[3:0];
  assign inst71__I0[3:0] = inst4__O[3:0];
  assign inst75__I0[3:0] = inst4__O[3:0];
  assign inst85__I0[3:0] = inst4__O[3:0];
  assign inst94__I0[3:0] = inst4__O[3:0];
  assign inst40__in = next_full__O;
  assign inst41__I1 = inst40__out;
  assign inst41__I0 = wen;
  assign inst42__in = inst41__O;
  assign inst47__I1 = inst42__out;
  assign inst43__in = next_empty__O;
  assign inst44__I1 = inst43__out;
  assign inst44__I0 = ren;
  assign inst47__I2 = inst44__O;
  assign inst46__I0[1:0] = inst45__O[1:0];
  assign inst46__I1[1:0] = inst8__O[1:0];
  assign inst47__I0 = inst1__O[0];
  assign inst0__I[2] = inst47__O;
  assign inst48__I1[3:0] = inst5__O[3:0];
  assign inst48__I2[3:0] = inst6__O[3:0];
  assign inst48__I3[3:0] = inst7__O[3:0];
  assign inst49__in = next_full__O;
  assign inst50__I1 = inst49__out;
  assign inst5__CLK = CLK;
  assign inst56__I1[3:0] = inst5__O[3:0];
  assign inst61__I0[3:0] = inst5__O[3:0];
  assign inst71__I1[3:0] = inst5__O[3:0];
  assign inst76__I0[3:0] = inst5__O[3:0];
  assign inst85__I1[3:0] = inst5__O[3:0];
  assign inst94__I1[3:0] = inst5__O[3:0];
  assign inst50__I0 = wen;
  assign inst51__in = inst50__O;
  assign inst55__I1 = inst51__out;
  assign inst52__in = next_empty__O;
  assign inst53__I1 = inst52__out;
  assign inst53__I0 = ren;
  assign inst54__in = inst53__O;
  assign inst55__I2 = inst54__out;
  assign inst55__I0 = inst1__O[0];
  assign inst0__I[3] = inst55__O;
  assign inst56__I2[3:0] = inst6__O[3:0];
  assign inst56__I3[3:0] = inst7__O[3:0];
  assign inst57__in = next_full__O;
  assign inst58__I1 = inst57__out;
  assign inst58__I0 = wen;
  assign inst70__I1 = inst58__O;
  assign inst59__I[1:0] = inst8__O[1:0];
  assign inst6__CLK = CLK;
  assign inst62__I0[3:0] = inst6__O[3:0];
  assign inst71__I2[3:0] = inst6__O[3:0];
  assign inst77__I0[3:0] = inst6__O[3:0];
  assign inst85__I2[3:0] = inst6__O[3:0];
  assign inst94__I2[3:0] = inst6__O[3:0];
  assign inst60__I1[3:0] = wdata[3:0];
  assign inst60__S = inst59__O[0];
  assign inst61__I1[3:0] = wdata[3:0];
  assign inst61__S = inst59__O[1];
  assign inst62__I1[3:0] = wdata[3:0];
  assign inst62__S = inst59__O[2];
  assign inst63__I0[3:0] = inst7__O[3:0];
  assign inst63__I1[3:0] = wdata[3:0];
  assign inst63__S = inst59__O[3];
  assign inst64__I0[1:0] = inst8__O[1:0];
  assign inst65__I1[1:0] = inst64__O[1:0];
  assign inst69__I1[1:0] = inst64__O[1:0];
  assign inst66__in = next_empty__O;
  assign inst67__I1 = inst66__out;
  assign inst67__I0 = ren;
  assign inst70__I2 = inst67__O;
  assign inst69__I0[1:0] = inst68__O[1:0];
  assign inst7__CLK = CLK;
  assign inst71__I3[3:0] = inst7__O[3:0];
  assign inst78__I0[3:0] = inst7__O[3:0];
  assign inst85__I3[3:0] = inst7__O[3:0];
  assign inst94__I3[3:0] = inst7__O[3:0];
  assign inst70__I0 = inst1__O[1];
  assign inst0__I[4] = inst70__O;
  assign inst72__in = next_full__O;
  assign inst73__I1 = inst72__out;
  assign inst73__I0 = wen;
  assign inst84__I1 = inst73__O;
  assign inst74__I[1:0] = inst8__O[1:0];
  assign inst75__I1[3:0] = wdata[3:0];
  assign inst75__S = inst74__O[0];
  assign inst76__I1[3:0] = wdata[3:0];
  assign inst76__S = inst74__O[1];
  assign inst77__I1[3:0] = wdata[3:0];
  assign inst77__S = inst74__O[2];
  assign inst78__I1[3:0] = wdata[3:0];
  assign inst78__S = inst74__O[3];
  assign inst79__I0[1:0] = inst8__O[1:0];
  assign inst80__I1[1:0] = inst79__O[1:0];
  assign inst8__CLK = CLK;
  assign inst92__I1[1:0] = inst8__O[1:0];
  assign inst81__in = next_empty__O;
  assign inst82__I1 = inst81__out;
  assign inst82__I0 = ren;
  assign inst83__in = inst82__O;
  assign inst84__I2 = inst83__out;
  assign inst84__I0 = inst1__O[1];
  assign inst0__I[5] = inst84__O;
  assign inst86__in = next_full__O;
  assign inst87__I1 = inst86__out;
  assign inst87__I0 = wen;
  assign inst88__in = inst87__O;
  assign inst93__I1 = inst88__out;
  assign inst89__in = next_empty__O;
  assign inst90__I1 = inst89__out;
  assign inst90__I0 = ren;
  assign inst93__I2 = inst90__O;
  assign inst92__I0[1:0] = inst91__O[1:0];
  assign inst93__I0 = inst1__O[1];
  assign inst0__I[6] = inst93__O;
  assign inst95__in = next_full__O;
  assign inst96__I1 = inst95__out;
  assign inst96__I0 = wen;
  assign inst97__in = inst96__O;
  assign inst98__in = next_empty__O;
  assign inst99__I1 = inst98__out;
  assign inst99__I0 = ren;
  assign next_empty__CLK = CLK;
  assign next_full__CLK = CLK;
  assign inst104__S[0] = inst0__O[0];
  assign inst105__S[0] = inst0__O[0];
  assign inst106__S[0] = inst0__O[0];
  assign inst107__S[0] = inst0__O[0];
  assign inst104__S[1] = inst0__O[1];
  assign inst105__S[1] = inst0__O[1];
  assign inst106__S[1] = inst0__O[1];
  assign inst107__S[1] = inst0__O[1];
  assign inst104__S[2] = inst0__O[4];
  assign inst105__S[2] = inst0__O[4];
  assign inst106__S[2] = inst0__O[4];
  assign inst107__S[2] = inst0__O[4];
  assign inst104__S[3] = inst0__O[5];
  assign inst105__S[3] = inst0__O[5];
  assign inst106__S[3] = inst0__O[5];
  assign inst107__S[3] = inst0__O[5];

endmodule //Fifo
