

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

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

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

module coreir_ult #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 < in1;

endmodule //coreir_ult

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

module Or6x2 (
  input [1:0] I0,
  input [1:0] I1,
  input [1:0] I2,
  input [1:0] I3,
  input [1:0] I4,
  input [1:0] I5,
  output [1:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [5:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(6)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [5:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(6)) inst1(
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
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst1__in[5] = I5[1];

endmodule //Or6x2

module Or6xNone (
  input  I0,
  input  I1,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [5:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(6)) inst0(
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

endmodule //Or6xNone

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
  //Wire declarations for instance 'inst0' (Module Or6x2)
  wire [1:0] inst0__I0;
  wire [1:0] inst0__I1;
  wire [1:0] inst0__I2;
  wire [1:0] inst0__I3;
  wire [1:0] inst0__I4;
  wire [1:0] inst0__I5;
  wire [1:0] inst0__O;
  Or6x2 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
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

  //All the connections
  assign inst0__I0[1:0] = inst1__O[1:0];
  assign inst0__I1[1:0] = inst2__O[1:0];
  assign inst0__I2[1:0] = inst3__O[1:0];
  assign inst0__I3[1:0] = inst4__O[1:0];
  assign inst0__I4[1:0] = inst5__O[1:0];
  assign inst0__I5[1:0] = inst6__O[1:0];
  assign O[1:0] = inst0__O[1:0];
  assign inst1__I0[1:0] = I0[1:0];
  assign inst2__I0[1:0] = I1[1:0];
  assign inst3__I0[1:0] = I2[1:0];
  assign inst4__I0[1:0] = I3[1:0];
  assign inst5__I0[1:0] = I4[1:0];
  assign inst6__I0[1:0] = I5[1:0];
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

endmodule //SilicaOneHotMux62

module ULT2 (
  input [1:0] I0,
  input [1:0] I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_ult)
  wire [1:0] inst0__in0;
  wire [1:0] inst0__in1;
  wire  inst0__out;
  coreir_ult #(.width(2)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[1:0] = I0[1:0];
  assign inst0__in1[1:0] = I1[1:0];
  assign O = inst0__out;

endmodule //ULT2

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
  //Wire declarations for instance 'inst0' (Module Or6xNone)
  wire  inst0__I0;
  wire  inst0__I1;
  wire  inst0__I2;
  wire  inst0__I3;
  wire  inst0__I4;
  wire  inst0__I5;
  wire  inst0__O;
  Or6xNone inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
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

  //All the connections
  assign inst0__I0 = inst1__O;
  assign inst0__I1 = inst2__O;
  assign inst0__I2 = inst3__O;
  assign inst0__I3 = inst4__O;
  assign inst0__I4 = inst5__O;
  assign inst0__I5 = inst6__O;
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

endmodule //SilicaOneHotMux6None

module Detect111 (
  input  CLK,
  input  I,
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

  //Wire declarations for instance 'inst0' (Module __silica_BufferDetect111)
  wire [5:0] inst0__I;
  wire [5:0] inst0__O;
  __silica_BufferDetect111 inst0(
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

  //Wire declarations for instance 'inst10' (Module corebit_not)
  wire  inst10__in;
  wire  inst10__out;
  corebit_not inst10(
    .in(inst10__in),
    .out(inst10__out)
  );

  //Wire declarations for instance 'inst11' (Module EQ2)
  wire [1:0] inst11__I0;
  wire [1:0] inst11__I1;
  wire  inst11__O;
  EQ2 inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .O(inst11__O)
  );

  //Wire declarations for instance 'inst12' (Module And3xNone)
  wire  inst12__I0;
  wire  inst12__I1;
  wire  inst12__I2;
  wire  inst12__O;
  And3xNone inst12(
    .I0(inst12__I0),
    .I1(inst12__I1),
    .I2(inst12__I2),
    .O(inst12__O)
  );

  //Wire declarations for instance 'inst13' (Module corebit_not)
  wire  inst13__in;
  wire  inst13__out;
  corebit_not inst13(
    .in(inst13__in),
    .out(inst13__out)
  );

  //Wire declarations for instance 'inst14' (Module EQ2)
  wire [1:0] inst14__I0;
  wire [1:0] inst14__I1;
  wire  inst14__O;
  EQ2 inst14(
    .I0(inst14__I0),
    .I1(inst14__I1),
    .O(inst14__O)
  );

  //Wire declarations for instance 'inst15' (Module and_wrapped)
  wire  inst15__I0;
  wire  inst15__I1;
  wire  inst15__O;
  and_wrapped inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .O(inst15__O)
  );

  //Wire declarations for instance 'inst16' (Module ULT2)
  wire [1:0] inst16__I0;
  wire [1:0] inst16__I1;
  wire  inst16__O;
  ULT2 inst16(
    .I0(inst16__I0),
    .I1(inst16__I1),
    .O(inst16__O)
  );

  //Wire declarations for instance 'inst17' (Module Add2)
  wire [1:0] inst17__I0;
  wire [1:0] inst17__I1;
  wire [1:0] inst17__O;
  Add2 inst17(
    .I0(inst17__I0),
    .I1(inst17__I1),
    .O(inst17__O)
  );

  //Wire declarations for instance 'inst18' (Module EQ2)
  wire [1:0] inst18__I0;
  wire [1:0] inst18__I1;
  wire  inst18__O;
  EQ2 inst18(
    .I0(inst18__I0),
    .I1(inst18__I1),
    .O(inst18__O)
  );

  //Wire declarations for instance 'inst19' (Module And3xNone)
  wire  inst19__I0;
  wire  inst19__I1;
  wire  inst19__I2;
  wire  inst19__O;
  And3xNone inst19(
    .I0(inst19__I0),
    .I1(inst19__I1),
    .I2(inst19__I2),
    .O(inst19__O)
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

  //Wire declarations for instance 'inst20' (Module ULT2)
  wire [1:0] inst20__I0;
  wire [1:0] inst20__I1;
  wire  inst20__O;
  ULT2 inst20(
    .I0(inst20__I0),
    .I1(inst20__I1),
    .O(inst20__O)
  );

  //Wire declarations for instance 'inst21' (Module corebit_not)
  wire  inst21__in;
  wire  inst21__out;
  corebit_not inst21(
    .in(inst21__in),
    .out(inst21__out)
  );

  //Wire declarations for instance 'inst22' (Module EQ2)
  wire [1:0] inst22__I0;
  wire [1:0] inst22__I1;
  wire  inst22__O;
  EQ2 inst22(
    .I0(inst22__I0),
    .I1(inst22__I1),
    .O(inst22__O)
  );

  //Wire declarations for instance 'inst23' (Module And3xNone)
  wire  inst23__I0;
  wire  inst23__I1;
  wire  inst23__I2;
  wire  inst23__O;
  And3xNone inst23(
    .I0(inst23__I0),
    .I1(inst23__I1),
    .I2(inst23__I2),
    .O(inst23__O)
  );

  //Wire declarations for instance 'inst24' (Module corebit_not)
  wire  inst24__in;
  wire  inst24__out;
  corebit_not inst24(
    .in(inst24__in),
    .out(inst24__out)
  );

  //Wire declarations for instance 'inst25' (Module EQ2)
  wire [1:0] inst25__I0;
  wire [1:0] inst25__I1;
  wire  inst25__O;
  EQ2 inst25(
    .I0(inst25__I0),
    .I1(inst25__I1),
    .O(inst25__O)
  );

  //Wire declarations for instance 'inst26' (Module and_wrapped)
  wire  inst26__I0;
  wire  inst26__I1;
  wire  inst26__O;
  and_wrapped inst26(
    .I0(inst26__I0),
    .I1(inst26__I1),
    .O(inst26__O)
  );

  //Wire declarations for instance 'inst3' (Module SilicaOneHotMux62)
  wire [1:0] inst3__I0;
  wire [1:0] inst3__I1;
  wire [1:0] inst3__I2;
  wire [1:0] inst3__I3;
  wire [1:0] inst3__I4;
  wire [1:0] inst3__I5;
  wire [1:0] inst3__O;
  wire [5:0] inst3__S;
  SilicaOneHotMux62 inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .I2(inst3__I2),
    .I3(inst3__I3),
    .I4(inst3__I4),
    .I5(inst3__I5),
    .O(inst3__O),
    .S(inst3__S)
  );

  //Wire declarations for instance 'inst4' (Module SilicaOneHotMux6None)
  wire  inst4__I0;
  wire  inst4__I1;
  wire  inst4__I2;
  wire  inst4__I3;
  wire  inst4__I4;
  wire  inst4__I5;
  wire  inst4__O;
  wire [5:0] inst4__S;
  SilicaOneHotMux6None inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .I2(inst4__I2),
    .I3(inst4__I3),
    .I4(inst4__I4),
    .I5(inst4__I5),
    .O(inst4__O),
    .S(inst4__S)
  );

  //Wire declarations for instance 'inst5' (Module ULT2)
  wire [1:0] inst5__I0;
  wire [1:0] inst5__I1;
  wire  inst5__O;
  ULT2 inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module Add2)
  wire [1:0] inst6__I0;
  wire [1:0] inst6__I1;
  wire [1:0] inst6__O;
  Add2 inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module EQ2)
  wire [1:0] inst7__I0;
  wire [1:0] inst7__I1;
  wire  inst7__O;
  EQ2 inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module And3xNone)
  wire  inst8__I0;
  wire  inst8__I1;
  wire  inst8__I2;
  wire  inst8__O;
  And3xNone inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .I2(inst8__I2),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst9' (Module ULT2)
  wire [1:0] inst9__I0;
  wire [1:0] inst9__I1;
  wire  inst9__O;
  ULT2 inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .O(inst9__O)
  );

  //All the connections
  assign inst1__I[0] = bit_const_GND__out;
  assign inst14__I0[0] = bit_const_GND__out;
  assign inst14__I0[1] = bit_const_GND__out;
  assign inst17__I1[1] = bit_const_GND__out;
  assign inst25__I0[0] = bit_const_GND__out;
  assign inst25__I0[1] = bit_const_GND__out;
  assign inst3__I2[0] = bit_const_GND__out;
  assign inst3__I2[1] = bit_const_GND__out;
  assign inst3__I5[0] = bit_const_GND__out;
  assign inst3__I5[1] = bit_const_GND__out;
  assign inst6__I1[1] = bit_const_GND__out;
  assign inst1__I[1] = bit_const_VCC__out;
  assign inst11__I1[0] = bit_const_VCC__out;
  assign inst11__I1[1] = bit_const_VCC__out;
  assign inst14__I1[0] = bit_const_VCC__out;
  assign inst14__I1[1] = bit_const_VCC__out;
  assign inst16__I1[0] = bit_const_VCC__out;
  assign inst16__I1[1] = bit_const_VCC__out;
  assign inst17__I1[0] = bit_const_VCC__out;
  assign inst18__I1[0] = bit_const_VCC__out;
  assign inst18__I1[1] = bit_const_VCC__out;
  assign inst20__I1[0] = bit_const_VCC__out;
  assign inst20__I1[1] = bit_const_VCC__out;
  assign inst22__I1[0] = bit_const_VCC__out;
  assign inst22__I1[1] = bit_const_VCC__out;
  assign inst25__I1[0] = bit_const_VCC__out;
  assign inst25__I1[1] = bit_const_VCC__out;
  assign inst5__I1[0] = bit_const_VCC__out;
  assign inst5__I1[1] = bit_const_VCC__out;
  assign inst6__I1[0] = bit_const_VCC__out;
  assign inst7__I1[0] = bit_const_VCC__out;
  assign inst7__I1[1] = bit_const_VCC__out;
  assign inst9__I1[0] = bit_const_VCC__out;
  assign inst9__I1[1] = bit_const_VCC__out;
  assign inst3__S[5:0] = inst0__O[5:0];
  assign inst4__S[5:0] = inst0__O[5:0];
  assign inst1__CLK = CLK;
  assign inst10__in = inst9__O;
  assign inst12__I2 = inst10__out;
  assign inst11__I0[1:0] = inst2__O[1:0];
  assign inst4__I1 = inst11__O;
  assign inst12__I0 = inst1__O[0];
  assign inst12__I1 = I;
  assign inst0__I[1] = inst12__O;
  assign inst13__in = I;
  assign inst15__I1 = inst13__out;
  assign inst4__I2 = inst14__O;
  assign inst15__I0 = inst1__O[0];
  assign inst0__I[2] = inst15__O;
  assign inst16__I0[1:0] = inst2__O[1:0];
  assign inst19__I2 = inst16__O;
  assign inst17__I0[1:0] = inst2__O[1:0];
  assign inst18__I0[1:0] = inst17__O[1:0];
  assign inst3__I3[1:0] = inst17__O[1:0];
  assign inst4__I3 = inst18__O;
  assign inst19__I0 = inst1__O[1];
  assign inst19__I1 = I;
  assign inst0__I[3] = inst19__O;
  assign inst2__CLK = CLK;
  assign inst2__I[1:0] = inst3__O[1:0];
  assign inst20__I0[1:0] = inst2__O[1:0];
  assign inst22__I0[1:0] = inst2__O[1:0];
  assign inst3__I1[1:0] = inst2__O[1:0];
  assign inst3__I4[1:0] = inst2__O[1:0];
  assign inst5__I0[1:0] = inst2__O[1:0];
  assign inst6__I0[1:0] = inst2__O[1:0];
  assign inst9__I0[1:0] = inst2__O[1:0];
  assign inst21__in = inst20__O;
  assign inst23__I2 = inst21__out;
  assign inst4__I4 = inst22__O;
  assign inst23__I0 = inst1__O[1];
  assign inst23__I1 = I;
  assign inst0__I[4] = inst23__O;
  assign inst24__in = I;
  assign inst26__I1 = inst24__out;
  assign inst4__I5 = inst25__O;
  assign inst26__I0 = inst1__O[1];
  assign inst0__I[5] = inst26__O;
  assign inst3__I0[1:0] = inst6__O[1:0];
  assign inst4__I0 = inst7__O;
  assign O = inst4__O;
  assign inst8__I2 = inst5__O;
  assign inst7__I0[1:0] = inst6__O[1:0];
  assign inst8__I0 = inst1__O[0];
  assign inst8__I1 = I;
  assign inst0__I[0] = inst8__O;

endmodule //Detect111
