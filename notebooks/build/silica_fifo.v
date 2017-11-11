

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

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

module corebit_const #(parameter value=1) (
  output out
);
  assign out = value;

endmodule //corebit_const

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

module corebit_or (
  input in0,
  input in1,
  output out
);
  assign out = in0 | in1;

endmodule //corebit_or

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

module __silica_BufferFifo (
  input [7:0] I,
  output [7:0] O
);
  //All the connections
  assign O[7:0] = I[7:0];

endmodule //__silica_BufferFifo

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

module fold_or82 (
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

  //Wire declarations for instance 'inst5' (Module or2_wrapped)
  wire [1:0] inst5_I0;
  wire [1:0] inst5_I1;
  wire [1:0] inst5_O;
  or2_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module or2_wrapped)
  wire [1:0] inst6_I0;
  wire [1:0] inst6_I1;
  wire [1:0] inst6_O;
  or2_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
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
  assign inst5_I0[1:0] = inst4_O[1:0];
  assign inst5_I1[1:0] = I6[1:0];
  assign inst6_I0[1:0] = inst5_O[1:0];
  assign inst6_I1[1:0] = I7[1:0];
  assign O[1:0] = inst6_O[1:0];

endmodule //fold_or82

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
  //Wire declarations for instance 'inst0' (Module fold_or82)
  wire [1:0] inst0_I0;
  wire [1:0] inst0_I3;
  wire [1:0] inst0_O;
  wire [1:0] inst0_I4;
  wire [1:0] inst0_I2;
  wire [1:0] inst0_I1;
  wire [1:0] inst0_I7;
  wire [1:0] inst0_I5;
  wire [1:0] inst0_I6;
  fold_or82 inst0(
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

module fold_or84 (
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
  //Wire declarations for instance 'inst0' (Module or4_wrapped)
  wire [3:0] inst0_I0;
  wire [3:0] inst0_I1;
  wire [3:0] inst0_O;
  or4_wrapped inst0(
    .I0(inst0_I0),
    .I1(inst0_I1),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module or4_wrapped)
  wire [3:0] inst1_I0;
  wire [3:0] inst1_I1;
  wire [3:0] inst1_O;
  or4_wrapped inst1(
    .I0(inst1_I0),
    .I1(inst1_I1),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or4_wrapped)
  wire [3:0] inst2_I0;
  wire [3:0] inst2_I1;
  wire [3:0] inst2_O;
  or4_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module or4_wrapped)
  wire [3:0] inst3_I0;
  wire [3:0] inst3_I1;
  wire [3:0] inst3_O;
  or4_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module or4_wrapped)
  wire [3:0] inst4_I0;
  wire [3:0] inst4_I1;
  wire [3:0] inst4_O;
  or4_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module or4_wrapped)
  wire [3:0] inst5_I0;
  wire [3:0] inst5_I1;
  wire [3:0] inst5_O;
  or4_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module or4_wrapped)
  wire [3:0] inst6_I0;
  wire [3:0] inst6_I1;
  wire [3:0] inst6_O;
  or4_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //All the connections
  assign inst0_I0[3:0] = I0[3:0];
  assign inst0_I1[3:0] = I1[3:0];
  assign inst1_I0[3:0] = inst0_O[3:0];
  assign inst1_I1[3:0] = I2[3:0];
  assign inst2_I0[3:0] = inst1_O[3:0];
  assign inst2_I1[3:0] = I3[3:0];
  assign inst3_I0[3:0] = inst2_O[3:0];
  assign inst3_I1[3:0] = I4[3:0];
  assign inst4_I0[3:0] = inst3_O[3:0];
  assign inst4_I1[3:0] = I5[3:0];
  assign inst5_I0[3:0] = inst4_O[3:0];
  assign inst5_I1[3:0] = I6[3:0];
  assign inst6_I0[3:0] = inst5_O[3:0];
  assign inst6_I1[3:0] = I7[3:0];
  assign O[3:0] = inst6_O[3:0];

endmodule //fold_or84

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
  //Wire declarations for instance 'inst0' (Module fold_or84)
  wire [3:0] inst0_I0;
  wire [3:0] inst0_I3;
  wire [3:0] inst0_O;
  wire [3:0] inst0_I4;
  wire [3:0] inst0_I2;
  wire [3:0] inst0_I1;
  wire [3:0] inst0_I7;
  wire [3:0] inst0_I5;
  wire [3:0] inst0_I6;
  fold_or84 inst0(
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

module fold_or8None (
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

  //Wire declarations for instance 'inst5' (Module or_wrapped)
  wire  inst5_I0;
  wire  inst5_I1;
  wire  inst5_O;
  or_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module or_wrapped)
  wire  inst6_I0;
  wire  inst6_I1;
  wire  inst6_O;
  or_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
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
  assign inst5_I0 = inst4_O;
  assign inst5_I1 = I6;
  assign inst6_I0 = inst5_O;
  assign inst6_I1 = I7;
  assign O = inst6_O;

endmodule //fold_or8None

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
  //Wire declarations for instance 'inst0' (Module fold_or8None)
  wire  inst0_I0;
  wire  inst0_I3;
  wire  inst0_O;
  wire  inst0_I4;
  wire  inst0_I2;
  wire  inst0_I1;
  wire  inst0_I7;
  wire  inst0_I5;
  wire  inst0_I6;
  fold_or8None inst0(
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

  //Wire declarations for instance 'inst10' (Module SilicaOneHotMux8None)
  wire  inst10_I0;
  wire  inst10_I3;
  wire  inst10_O;
  wire  inst10_I4;
  wire  inst10_I2;
  wire  inst10_I1;
  wire  inst10_I7;
  wire  inst10_I5;
  wire  inst10_I6;
  wire [7:0] inst10_S;
  SilicaOneHotMux8None inst10(
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

  //Wire declarations for instance 'inst100' (Module Mux4x4)
  wire [3:0] inst100_I0;
  wire [3:0] inst100_I1;
  wire [3:0] inst100_I2;
  wire [3:0] inst100_I3;
  wire [3:0] inst100_O;
  wire [1:0] inst100_S;
  Mux4x4 inst100(
    .I0(inst100_I0),
    .I1(inst100_I1),
    .I2(inst100_I2),
    .I3(inst100_I3),
    .O(inst100_O),
    .S(inst100_S)
  );

  //Wire declarations for instance 'inst101' (Module corebit_not)
  wire  inst101_in;
  wire  inst101_out;
  corebit_not inst101(
    .in(inst101_in),
    .out(inst101_out)
  );

  //Wire declarations for instance 'inst102' (Module and_wrapped)
  wire  inst102_I0;
  wire  inst102_I1;
  wire  inst102_O;
  and_wrapped inst102(
    .I0(inst102_I0),
    .I1(inst102_I1),
    .O(inst102_O)
  );

  //Wire declarations for instance 'inst103' (Module Add2)
  wire [1:0] inst103_I0;
  wire [1:0] inst103_I1;
  wire [1:0] inst103_O;
  Add2 inst103(
    .I0(inst103_I0),
    .I1(inst103_I1),
    .O(inst103_O)
  );

  //Wire declarations for instance 'inst104' (Module EQ2)
  wire [1:0] inst104_I0;
  wire [1:0] inst104_I1;
  wire  inst104_O;
  EQ2 inst104(
    .I0(inst104_I0),
    .I1(inst104_I1),
    .O(inst104_O)
  );

  //Wire declarations for instance 'inst105' (Module fold_and3None)
  wire  inst105_I0;
  wire  inst105_I1;
  wire  inst105_I2;
  wire  inst105_O;
  fold_and3None inst105(
    .I0(inst105_I0),
    .I1(inst105_I1),
    .I2(inst105_I2),
    .O(inst105_O)
  );

  //Wire declarations for instance 'inst106' (Module corebit_not)
  wire  inst106_in;
  wire  inst106_out;
  corebit_not inst106(
    .in(inst106_in),
    .out(inst106_out)
  );

  //Wire declarations for instance 'inst107' (Module and_wrapped)
  wire  inst107_I0;
  wire  inst107_I1;
  wire  inst107_O;
  and_wrapped inst107(
    .I0(inst107_I0),
    .I1(inst107_I1),
    .O(inst107_O)
  );

  //Wire declarations for instance 'inst108' (Module corebit_not)
  wire  inst108_in;
  wire  inst108_out;
  corebit_not inst108(
    .in(inst108_in),
    .out(inst108_out)
  );

  //Wire declarations for instance 'inst109' (Module Mux4x4)
  wire [3:0] inst109_I0;
  wire [3:0] inst109_I1;
  wire [3:0] inst109_I2;
  wire [3:0] inst109_I3;
  wire [3:0] inst109_O;
  wire [1:0] inst109_S;
  Mux4x4 inst109(
    .I0(inst109_I0),
    .I1(inst109_I1),
    .I2(inst109_I2),
    .I3(inst109_I3),
    .O(inst109_O),
    .S(inst109_S)
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

  //Wire declarations for instance 'inst110' (Module corebit_not)
  wire  inst110_in;
  wire  inst110_out;
  corebit_not inst110(
    .in(inst110_in),
    .out(inst110_out)
  );

  //Wire declarations for instance 'inst111' (Module and_wrapped)
  wire  inst111_I0;
  wire  inst111_I1;
  wire  inst111_O;
  and_wrapped inst111(
    .I0(inst111_I0),
    .I1(inst111_I1),
    .O(inst111_O)
  );

  //Wire declarations for instance 'inst112' (Module corebit_not)
  wire  inst112_in;
  wire  inst112_out;
  corebit_not inst112(
    .in(inst112_in),
    .out(inst112_out)
  );

  //Wire declarations for instance 'inst113' (Module fold_and3None)
  wire  inst113_I0;
  wire  inst113_I1;
  wire  inst113_I2;
  wire  inst113_O;
  fold_and3None inst113(
    .I0(inst113_I0),
    .I1(inst113_I1),
    .I2(inst113_I2),
    .O(inst113_O)
  );

  //Wire declarations for instance 'inst12' (Module Register4)
  wire  inst12_CLK;
  wire [3:0] inst12_I;
  wire [3:0] inst12_O;
  Register4 inst12(
    .CLK(inst12_CLK),
    .I(inst12_I),
    .O(inst12_O)
  );

  //Wire declarations for instance 'inst13' (Module Register4)
  wire  inst13_CLK;
  wire [3:0] inst13_I;
  wire [3:0] inst13_O;
  Register4 inst13(
    .CLK(inst13_CLK),
    .I(inst13_I),
    .O(inst13_O)
  );

  //Wire declarations for instance 'inst14' (Module Register4)
  wire  inst14_CLK;
  wire [3:0] inst14_I;
  wire [3:0] inst14_O;
  Register4 inst14(
    .CLK(inst14_CLK),
    .I(inst14_I),
    .O(inst14_O)
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

  //Wire declarations for instance 'inst16' (Module SilicaOneHotMux84)
  wire [3:0] inst16_I0;
  wire [3:0] inst16_I3;
  wire [3:0] inst16_O;
  wire [3:0] inst16_I4;
  wire [3:0] inst16_I2;
  wire [3:0] inst16_I1;
  wire [3:0] inst16_I7;
  wire [3:0] inst16_I5;
  wire [3:0] inst16_I6;
  wire [7:0] inst16_S;
  SilicaOneHotMux84 inst16(
    .I0(inst16_I0),
    .I1(inst16_I1),
    .I2(inst16_I2),
    .I3(inst16_I3),
    .I4(inst16_I4),
    .I5(inst16_I5),
    .I6(inst16_I6),
    .I7(inst16_I7),
    .O(inst16_O),
    .S(inst16_S)
  );

  //Wire declarations for instance 'inst17' (Module SilicaOneHotMux84)
  wire [3:0] inst17_I0;
  wire [3:0] inst17_I3;
  wire [3:0] inst17_O;
  wire [3:0] inst17_I4;
  wire [3:0] inst17_I2;
  wire [3:0] inst17_I1;
  wire [3:0] inst17_I7;
  wire [3:0] inst17_I5;
  wire [3:0] inst17_I6;
  wire [7:0] inst17_S;
  SilicaOneHotMux84 inst17(
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

  //Wire declarations for instance 'inst18' (Module SilicaOneHotMux84)
  wire [3:0] inst18_I0;
  wire [3:0] inst18_I3;
  wire [3:0] inst18_O;
  wire [3:0] inst18_I4;
  wire [3:0] inst18_I2;
  wire [3:0] inst18_I1;
  wire [3:0] inst18_I7;
  wire [3:0] inst18_I5;
  wire [3:0] inst18_I6;
  wire [7:0] inst18_S;
  SilicaOneHotMux84 inst18(
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

  //Wire declarations for instance 'inst2' (Module SilicaOneHotMux82)
  wire [1:0] inst2_I0;
  wire [1:0] inst2_I3;
  wire [1:0] inst2_O;
  wire [1:0] inst2_I4;
  wire [1:0] inst2_I2;
  wire [1:0] inst2_I1;
  wire [1:0] inst2_I7;
  wire [1:0] inst2_I5;
  wire [1:0] inst2_I6;
  wire [7:0] inst2_S;
  SilicaOneHotMux82 inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .I2(inst2_I2),
    .I3(inst2_I3),
    .I4(inst2_I4),
    .I5(inst2_I5),
    .I6(inst2_I6),
    .I7(inst2_I7),
    .O(inst2_O),
    .S(inst2_S)
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

  //Wire declarations for instance 'inst21' (Module SilicaOneHotMux8None)
  wire  inst21_I0;
  wire  inst21_I3;
  wire  inst21_O;
  wire  inst21_I4;
  wire  inst21_I2;
  wire  inst21_I1;
  wire  inst21_I7;
  wire  inst21_I5;
  wire  inst21_I6;
  wire [7:0] inst21_S;
  SilicaOneHotMux8None inst21(
    .I0(inst21_I0),
    .I1(inst21_I1),
    .I2(inst21_I2),
    .I3(inst21_I3),
    .I4(inst21_I4),
    .I5(inst21_I5),
    .I6(inst21_I6),
    .I7(inst21_I7),
    .O(inst21_O),
    .S(inst21_S)
  );

  //Wire declarations for instance 'inst22' (Module corebit_not)
  wire  inst22_in;
  wire  inst22_out;
  corebit_not inst22(
    .in(inst22_in),
    .out(inst22_out)
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

  //Wire declarations for instance 'inst24' (Module Decoder2)
  wire [1:0] inst24_I;
  wire [3:0] inst24_O;
  Decoder2 inst24(
    .I(inst24_I),
    .O(inst24_O)
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

  //Wire declarations for instance 'inst28' (Module Mux2x4)
  wire [3:0] inst28_I0;
  wire [3:0] inst28_I1;
  wire [3:0] inst28_O;
  wire  inst28_S;
  Mux2x4 inst28(
    .I0(inst28_I0),
    .I1(inst28_I1),
    .O(inst28_O),
    .S(inst28_S)
  );

  //Wire declarations for instance 'inst29' (Module Add2)
  wire [1:0] inst29_I0;
  wire [1:0] inst29_I1;
  wire [1:0] inst29_O;
  Add2 inst29(
    .I0(inst29_I0),
    .I1(inst29_I1),
    .O(inst29_O)
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

  //Wire declarations for instance 'inst30' (Module EQ2)
  wire [1:0] inst30_I0;
  wire [1:0] inst30_I1;
  wire  inst30_O;
  EQ2 inst30(
    .I0(inst30_I0),
    .I1(inst30_I1),
    .O(inst30_O)
  );

  //Wire declarations for instance 'inst31' (Module Mux4x4)
  wire [3:0] inst31_I0;
  wire [3:0] inst31_I1;
  wire [3:0] inst31_I2;
  wire [3:0] inst31_I3;
  wire [3:0] inst31_O;
  wire [1:0] inst31_S;
  Mux4x4 inst31(
    .I0(inst31_I0),
    .I1(inst31_I1),
    .I2(inst31_I2),
    .I3(inst31_I3),
    .O(inst31_O),
    .S(inst31_S)
  );

  //Wire declarations for instance 'inst32' (Module corebit_not)
  wire  inst32_in;
  wire  inst32_out;
  corebit_not inst32(
    .in(inst32_in),
    .out(inst32_out)
  );

  //Wire declarations for instance 'inst33' (Module and_wrapped)
  wire  inst33_I0;
  wire  inst33_I1;
  wire  inst33_O;
  and_wrapped inst33(
    .I0(inst33_I0),
    .I1(inst33_I1),
    .O(inst33_O)
  );

  //Wire declarations for instance 'inst34' (Module Add2)
  wire [1:0] inst34_I0;
  wire [1:0] inst34_I1;
  wire [1:0] inst34_O;
  Add2 inst34(
    .I0(inst34_I0),
    .I1(inst34_I1),
    .O(inst34_O)
  );

  //Wire declarations for instance 'inst35' (Module EQ2)
  wire [1:0] inst35_I0;
  wire [1:0] inst35_I1;
  wire  inst35_O;
  EQ2 inst35(
    .I0(inst35_I0),
    .I1(inst35_I1),
    .O(inst35_O)
  );

  //Wire declarations for instance 'inst36' (Module fold_and3None)
  wire  inst36_I0;
  wire  inst36_I1;
  wire  inst36_I2;
  wire  inst36_O;
  fold_and3None inst36(
    .I0(inst36_I0),
    .I1(inst36_I1),
    .I2(inst36_I2),
    .O(inst36_O)
  );

  //Wire declarations for instance 'inst37' (Module corebit_not)
  wire  inst37_in;
  wire  inst37_out;
  corebit_not inst37(
    .in(inst37_in),
    .out(inst37_out)
  );

  //Wire declarations for instance 'inst38' (Module and_wrapped)
  wire  inst38_I0;
  wire  inst38_I1;
  wire  inst38_O;
  and_wrapped inst38(
    .I0(inst38_I0),
    .I1(inst38_I1),
    .O(inst38_O)
  );

  //Wire declarations for instance 'inst39' (Module Decoder2)
  wire [1:0] inst39_I;
  wire [3:0] inst39_O;
  Decoder2 inst39(
    .I(inst39_I),
    .O(inst39_O)
  );

  //Wire declarations for instance 'inst4' (Module SilicaOneHotMux82)
  wire [1:0] inst4_I0;
  wire [1:0] inst4_I3;
  wire [1:0] inst4_O;
  wire [1:0] inst4_I4;
  wire [1:0] inst4_I2;
  wire [1:0] inst4_I1;
  wire [1:0] inst4_I7;
  wire [1:0] inst4_I5;
  wire [1:0] inst4_I6;
  wire [7:0] inst4_S;
  SilicaOneHotMux82 inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .I2(inst4_I2),
    .I3(inst4_I3),
    .I4(inst4_I4),
    .I5(inst4_I5),
    .I6(inst4_I6),
    .I7(inst4_I7),
    .O(inst4_O),
    .S(inst4_S)
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

  //Wire declarations for instance 'inst43' (Module Mux2x4)
  wire [3:0] inst43_I0;
  wire [3:0] inst43_I1;
  wire [3:0] inst43_O;
  wire  inst43_S;
  Mux2x4 inst43(
    .I0(inst43_I0),
    .I1(inst43_I1),
    .O(inst43_O),
    .S(inst43_S)
  );

  //Wire declarations for instance 'inst44' (Module Add2)
  wire [1:0] inst44_I0;
  wire [1:0] inst44_I1;
  wire [1:0] inst44_O;
  Add2 inst44(
    .I0(inst44_I0),
    .I1(inst44_I1),
    .O(inst44_O)
  );

  //Wire declarations for instance 'inst45' (Module EQ2)
  wire [1:0] inst45_I0;
  wire [1:0] inst45_I1;
  wire  inst45_O;
  EQ2 inst45(
    .I0(inst45_I0),
    .I1(inst45_I1),
    .O(inst45_O)
  );

  //Wire declarations for instance 'inst46' (Module Mux4x4)
  wire [3:0] inst46_I0;
  wire [3:0] inst46_I1;
  wire [3:0] inst46_I2;
  wire [3:0] inst46_I3;
  wire [3:0] inst46_O;
  wire [1:0] inst46_S;
  Mux4x4 inst46(
    .I0(inst46_I0),
    .I1(inst46_I1),
    .I2(inst46_I2),
    .I3(inst46_I3),
    .O(inst46_O),
    .S(inst46_S)
  );

  //Wire declarations for instance 'inst47' (Module corebit_not)
  wire  inst47_in;
  wire  inst47_out;
  corebit_not inst47(
    .in(inst47_in),
    .out(inst47_out)
  );

  //Wire declarations for instance 'inst48' (Module and_wrapped)
  wire  inst48_I0;
  wire  inst48_I1;
  wire  inst48_O;
  and_wrapped inst48(
    .I0(inst48_I0),
    .I1(inst48_I1),
    .O(inst48_O)
  );

  //Wire declarations for instance 'inst49' (Module corebit_not)
  wire  inst49_in;
  wire  inst49_out;
  corebit_not inst49(
    .in(inst49_in),
    .out(inst49_out)
  );

  //Wire declarations for instance 'inst50' (Module fold_and3None)
  wire  inst50_I0;
  wire  inst50_I1;
  wire  inst50_I2;
  wire  inst50_O;
  fold_and3None inst50(
    .I0(inst50_I0),
    .I1(inst50_I1),
    .I2(inst50_I2),
    .O(inst50_O)
  );

  //Wire declarations for instance 'inst51' (Module corebit_not)
  wire  inst51_in;
  wire  inst51_out;
  corebit_not inst51(
    .in(inst51_in),
    .out(inst51_out)
  );

  //Wire declarations for instance 'inst52' (Module and_wrapped)
  wire  inst52_I0;
  wire  inst52_I1;
  wire  inst52_O;
  and_wrapped inst52(
    .I0(inst52_I0),
    .I1(inst52_I1),
    .O(inst52_O)
  );

  //Wire declarations for instance 'inst53' (Module corebit_not)
  wire  inst53_in;
  wire  inst53_out;
  corebit_not inst53(
    .in(inst53_in),
    .out(inst53_out)
  );

  //Wire declarations for instance 'inst54' (Module Mux4x4)
  wire [3:0] inst54_I0;
  wire [3:0] inst54_I1;
  wire [3:0] inst54_I2;
  wire [3:0] inst54_I3;
  wire [3:0] inst54_O;
  wire [1:0] inst54_S;
  Mux4x4 inst54(
    .I0(inst54_I0),
    .I1(inst54_I1),
    .I2(inst54_I2),
    .I3(inst54_I3),
    .O(inst54_O),
    .S(inst54_S)
  );

  //Wire declarations for instance 'inst55' (Module corebit_not)
  wire  inst55_in;
  wire  inst55_out;
  corebit_not inst55(
    .in(inst55_in),
    .out(inst55_out)
  );

  //Wire declarations for instance 'inst56' (Module and_wrapped)
  wire  inst56_I0;
  wire  inst56_I1;
  wire  inst56_O;
  and_wrapped inst56(
    .I0(inst56_I0),
    .I1(inst56_I1),
    .O(inst56_O)
  );

  //Wire declarations for instance 'inst57' (Module Add2)
  wire [1:0] inst57_I0;
  wire [1:0] inst57_I1;
  wire [1:0] inst57_O;
  Add2 inst57(
    .I0(inst57_I0),
    .I1(inst57_I1),
    .O(inst57_O)
  );

  //Wire declarations for instance 'inst58' (Module EQ2)
  wire [1:0] inst58_I0;
  wire [1:0] inst58_I1;
  wire  inst58_O;
  EQ2 inst58(
    .I0(inst58_I0),
    .I1(inst58_I1),
    .O(inst58_O)
  );

  //Wire declarations for instance 'inst59' (Module fold_and3None)
  wire  inst59_I0;
  wire  inst59_I1;
  wire  inst59_I2;
  wire  inst59_O;
  fold_and3None inst59(
    .I0(inst59_I0),
    .I1(inst59_I1),
    .I2(inst59_I2),
    .O(inst59_O)
  );

  //Wire declarations for instance 'inst6' (Module SilicaOneHotMux8None)
  wire  inst6_I0;
  wire  inst6_I3;
  wire  inst6_O;
  wire  inst6_I4;
  wire  inst6_I2;
  wire  inst6_I1;
  wire  inst6_I7;
  wire  inst6_I5;
  wire  inst6_I6;
  wire [7:0] inst6_S;
  SilicaOneHotMux8None inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .I2(inst6_I2),
    .I3(inst6_I3),
    .I4(inst6_I4),
    .I5(inst6_I5),
    .I6(inst6_I6),
    .I7(inst6_I7),
    .O(inst6_O),
    .S(inst6_S)
  );

  //Wire declarations for instance 'inst60' (Module corebit_not)
  wire  inst60_in;
  wire  inst60_out;
  corebit_not inst60(
    .in(inst60_in),
    .out(inst60_out)
  );

  //Wire declarations for instance 'inst61' (Module and_wrapped)
  wire  inst61_I0;
  wire  inst61_I1;
  wire  inst61_O;
  and_wrapped inst61(
    .I0(inst61_I0),
    .I1(inst61_I1),
    .O(inst61_O)
  );

  //Wire declarations for instance 'inst62' (Module corebit_not)
  wire  inst62_in;
  wire  inst62_out;
  corebit_not inst62(
    .in(inst62_in),
    .out(inst62_out)
  );

  //Wire declarations for instance 'inst63' (Module Mux4x4)
  wire [3:0] inst63_I0;
  wire [3:0] inst63_I1;
  wire [3:0] inst63_I2;
  wire [3:0] inst63_I3;
  wire [3:0] inst63_O;
  wire [1:0] inst63_S;
  Mux4x4 inst63(
    .I0(inst63_I0),
    .I1(inst63_I1),
    .I2(inst63_I2),
    .I3(inst63_I3),
    .O(inst63_O),
    .S(inst63_S)
  );

  //Wire declarations for instance 'inst64' (Module corebit_not)
  wire  inst64_in;
  wire  inst64_out;
  corebit_not inst64(
    .in(inst64_in),
    .out(inst64_out)
  );

  //Wire declarations for instance 'inst65' (Module and_wrapped)
  wire  inst65_I0;
  wire  inst65_I1;
  wire  inst65_O;
  and_wrapped inst65(
    .I0(inst65_I0),
    .I1(inst65_I1),
    .O(inst65_O)
  );

  //Wire declarations for instance 'inst66' (Module corebit_not)
  wire  inst66_in;
  wire  inst66_out;
  corebit_not inst66(
    .in(inst66_in),
    .out(inst66_out)
  );

  //Wire declarations for instance 'inst67' (Module fold_and3None)
  wire  inst67_I0;
  wire  inst67_I1;
  wire  inst67_I2;
  wire  inst67_O;
  fold_and3None inst67(
    .I0(inst67_I0),
    .I1(inst67_I1),
    .I2(inst67_I2),
    .O(inst67_O)
  );

  //Wire declarations for instance 'inst68' (Module corebit_not)
  wire  inst68_in;
  wire  inst68_out;
  corebit_not inst68(
    .in(inst68_in),
    .out(inst68_out)
  );

  //Wire declarations for instance 'inst69' (Module and_wrapped)
  wire  inst69_I0;
  wire  inst69_I1;
  wire  inst69_O;
  and_wrapped inst69(
    .I0(inst69_I0),
    .I1(inst69_I1),
    .O(inst69_O)
  );

  //Wire declarations for instance 'inst7' (Module Register2)
  wire  inst7_CLK;
  wire [1:0] inst7_I;
  wire [1:0] inst7_O;
  Register2 inst7(
    .CLK(inst7_CLK),
    .I(inst7_I),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst70' (Module Decoder2)
  wire [1:0] inst70_I;
  wire [3:0] inst70_O;
  Decoder2 inst70(
    .I(inst70_I),
    .O(inst70_O)
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

  //Wire declarations for instance 'inst74' (Module Mux2x4)
  wire [3:0] inst74_I0;
  wire [3:0] inst74_I1;
  wire [3:0] inst74_O;
  wire  inst74_S;
  Mux2x4 inst74(
    .I0(inst74_I0),
    .I1(inst74_I1),
    .O(inst74_O),
    .S(inst74_S)
  );

  //Wire declarations for instance 'inst75' (Module Add2)
  wire [1:0] inst75_I0;
  wire [1:0] inst75_I1;
  wire [1:0] inst75_O;
  Add2 inst75(
    .I0(inst75_I0),
    .I1(inst75_I1),
    .O(inst75_O)
  );

  //Wire declarations for instance 'inst76' (Module EQ2)
  wire [1:0] inst76_I0;
  wire [1:0] inst76_I1;
  wire  inst76_O;
  EQ2 inst76(
    .I0(inst76_I0),
    .I1(inst76_I1),
    .O(inst76_O)
  );

  //Wire declarations for instance 'inst77' (Module Mux4x4)
  wire [3:0] inst77_I0;
  wire [3:0] inst77_I1;
  wire [3:0] inst77_I2;
  wire [3:0] inst77_I3;
  wire [3:0] inst77_O;
  wire [1:0] inst77_S;
  Mux4x4 inst77(
    .I0(inst77_I0),
    .I1(inst77_I1),
    .I2(inst77_I2),
    .I3(inst77_I3),
    .O(inst77_O),
    .S(inst77_S)
  );

  //Wire declarations for instance 'inst78' (Module corebit_not)
  wire  inst78_in;
  wire  inst78_out;
  corebit_not inst78(
    .in(inst78_in),
    .out(inst78_out)
  );

  //Wire declarations for instance 'inst79' (Module and_wrapped)
  wire  inst79_I0;
  wire  inst79_I1;
  wire  inst79_O;
  and_wrapped inst79(
    .I0(inst79_I0),
    .I1(inst79_I1),
    .O(inst79_O)
  );

  //Wire declarations for instance 'inst8' (Module SilicaOneHotMux82)
  wire [1:0] inst8_I0;
  wire [1:0] inst8_I3;
  wire [1:0] inst8_O;
  wire [1:0] inst8_I4;
  wire [1:0] inst8_I2;
  wire [1:0] inst8_I1;
  wire [1:0] inst8_I7;
  wire [1:0] inst8_I5;
  wire [1:0] inst8_I6;
  wire [7:0] inst8_S;
  SilicaOneHotMux82 inst8(
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

  //Wire declarations for instance 'inst80' (Module Add2)
  wire [1:0] inst80_I0;
  wire [1:0] inst80_I1;
  wire [1:0] inst80_O;
  Add2 inst80(
    .I0(inst80_I0),
    .I1(inst80_I1),
    .O(inst80_O)
  );

  //Wire declarations for instance 'inst81' (Module EQ2)
  wire [1:0] inst81_I0;
  wire [1:0] inst81_I1;
  wire  inst81_O;
  EQ2 inst81(
    .I0(inst81_I0),
    .I1(inst81_I1),
    .O(inst81_O)
  );

  //Wire declarations for instance 'inst82' (Module fold_and3None)
  wire  inst82_I0;
  wire  inst82_I1;
  wire  inst82_I2;
  wire  inst82_O;
  fold_and3None inst82(
    .I0(inst82_I0),
    .I1(inst82_I1),
    .I2(inst82_I2),
    .O(inst82_O)
  );

  //Wire declarations for instance 'inst83' (Module corebit_not)
  wire  inst83_in;
  wire  inst83_out;
  corebit_not inst83(
    .in(inst83_in),
    .out(inst83_out)
  );

  //Wire declarations for instance 'inst84' (Module and_wrapped)
  wire  inst84_I0;
  wire  inst84_I1;
  wire  inst84_O;
  and_wrapped inst84(
    .I0(inst84_I0),
    .I1(inst84_I1),
    .O(inst84_O)
  );

  //Wire declarations for instance 'inst85' (Module Decoder2)
  wire [1:0] inst85_I;
  wire [3:0] inst85_O;
  Decoder2 inst85(
    .I(inst85_I),
    .O(inst85_O)
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

  //Wire declarations for instance 'inst89' (Module Mux2x4)
  wire [3:0] inst89_I0;
  wire [3:0] inst89_I1;
  wire [3:0] inst89_O;
  wire  inst89_S;
  Mux2x4 inst89(
    .I0(inst89_I0),
    .I1(inst89_I1),
    .O(inst89_O),
    .S(inst89_S)
  );

  //Wire declarations for instance 'inst90' (Module Add2)
  wire [1:0] inst90_I0;
  wire [1:0] inst90_I1;
  wire [1:0] inst90_O;
  Add2 inst90(
    .I0(inst90_I0),
    .I1(inst90_I1),
    .O(inst90_O)
  );

  //Wire declarations for instance 'inst91' (Module EQ2)
  wire [1:0] inst91_I0;
  wire [1:0] inst91_I1;
  wire  inst91_O;
  EQ2 inst91(
    .I0(inst91_I0),
    .I1(inst91_I1),
    .O(inst91_O)
  );

  //Wire declarations for instance 'inst92' (Module Mux4x4)
  wire [3:0] inst92_I0;
  wire [3:0] inst92_I1;
  wire [3:0] inst92_I2;
  wire [3:0] inst92_I3;
  wire [3:0] inst92_O;
  wire [1:0] inst92_S;
  Mux4x4 inst92(
    .I0(inst92_I0),
    .I1(inst92_I1),
    .I2(inst92_I2),
    .I3(inst92_I3),
    .O(inst92_O),
    .S(inst92_S)
  );

  //Wire declarations for instance 'inst93' (Module corebit_not)
  wire  inst93_in;
  wire  inst93_out;
  corebit_not inst93(
    .in(inst93_in),
    .out(inst93_out)
  );

  //Wire declarations for instance 'inst94' (Module and_wrapped)
  wire  inst94_I0;
  wire  inst94_I1;
  wire  inst94_O;
  and_wrapped inst94(
    .I0(inst94_I0),
    .I1(inst94_I1),
    .O(inst94_O)
  );

  //Wire declarations for instance 'inst95' (Module corebit_not)
  wire  inst95_in;
  wire  inst95_out;
  corebit_not inst95(
    .in(inst95_in),
    .out(inst95_out)
  );

  //Wire declarations for instance 'inst96' (Module fold_and3None)
  wire  inst96_I0;
  wire  inst96_I1;
  wire  inst96_I2;
  wire  inst96_O;
  fold_and3None inst96(
    .I0(inst96_I0),
    .I1(inst96_I1),
    .I2(inst96_I2),
    .O(inst96_O)
  );

  //Wire declarations for instance 'inst97' (Module corebit_not)
  wire  inst97_in;
  wire  inst97_out;
  corebit_not inst97(
    .in(inst97_in),
    .out(inst97_out)
  );

  //Wire declarations for instance 'inst98' (Module and_wrapped)
  wire  inst98_I0;
  wire  inst98_I1;
  wire  inst98_O;
  and_wrapped inst98(
    .I0(inst98_I0),
    .I1(inst98_I1),
    .O(inst98_O)
  );

  //Wire declarations for instance 'inst99' (Module corebit_not)
  wire  inst99_in;
  wire  inst99_out;
  corebit_not inst99(
    .in(inst99_in),
    .out(inst99_out)
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
  assign inst10_I0 = bit_const_GND_out;
  assign inst10_I2 = bit_const_GND_out;
  assign inst10_I4 = bit_const_GND_out;
  assign inst10_I6 = bit_const_GND_out;
  assign inst20_I1 = bit_const_GND_out;
  assign inst20_I5 = bit_const_GND_out;
  assign inst21_I0 = bit_const_GND_out;
  assign inst21_I2 = bit_const_GND_out;
  assign inst21_I4 = bit_const_GND_out;
  assign inst21_I6 = bit_const_GND_out;
  assign inst6_I1 = bit_const_GND_out;
  assign inst6_I5 = bit_const_GND_out;
  assign inst103_I1[1] = bit_const_GND_out;
  assign inst2_I0[0] = bit_const_GND_out;
  assign inst2_I1[0] = bit_const_GND_out;
  assign inst2_I2[0] = bit_const_GND_out;
  assign inst2_I3[0] = bit_const_GND_out;
  assign inst2_I4[0] = bit_const_GND_out;
  assign inst2_I5[0] = bit_const_GND_out;
  assign inst2_I6[0] = bit_const_GND_out;
  assign inst2_I7[0] = bit_const_GND_out;
  assign inst29_I1[1] = bit_const_GND_out;
  assign inst34_I1[1] = bit_const_GND_out;
  assign inst44_I1[1] = bit_const_GND_out;
  assign inst57_I1[1] = bit_const_GND_out;
  assign inst75_I1[1] = bit_const_GND_out;
  assign inst80_I1[1] = bit_const_GND_out;
  assign inst90_I1[1] = bit_const_GND_out;
  assign inst103_I1[0] = bit_const_VCC_out;
  assign inst2_I0[1] = bit_const_VCC_out;
  assign inst2_I1[1] = bit_const_VCC_out;
  assign inst2_I2[1] = bit_const_VCC_out;
  assign inst2_I3[1] = bit_const_VCC_out;
  assign inst2_I4[1] = bit_const_VCC_out;
  assign inst2_I5[1] = bit_const_VCC_out;
  assign inst2_I6[1] = bit_const_VCC_out;
  assign inst2_I7[1] = bit_const_VCC_out;
  assign inst29_I1[0] = bit_const_VCC_out;
  assign inst34_I1[0] = bit_const_VCC_out;
  assign inst44_I1[0] = bit_const_VCC_out;
  assign inst57_I1[0] = bit_const_VCC_out;
  assign inst75_I1[0] = bit_const_VCC_out;
  assign inst80_I1[0] = bit_const_VCC_out;
  assign inst90_I1[0] = bit_const_VCC_out;
  assign inst10_S[7:0] = inst0_O[7:0];
  assign inst15_S[7:0] = inst0_O[7:0];
  assign inst16_S[7:0] = inst0_O[7:0];
  assign inst17_S[7:0] = inst0_O[7:0];
  assign inst18_S[7:0] = inst0_O[7:0];
  assign inst19_S[7:0] = inst0_O[7:0];
  assign inst2_S[7:0] = inst0_O[7:0];
  assign inst20_S[7:0] = inst0_O[7:0];
  assign inst21_S[7:0] = inst0_O[7:0];
  assign inst4_S[7:0] = inst0_O[7:0];
  assign inst6_S[7:0] = inst0_O[7:0];
  assign inst8_S[7:0] = inst0_O[7:0];
  assign inst1_CLK = CLK;
  assign inst1_I[1:0] = inst2_O[1:0];
  assign inst10_I1 = inst45_O;
  assign inst10_I3 = prev_full_O;
  assign inst10_I5 = inst91_O;
  assign inst10_I7 = prev_full_O;
  assign prev_full_I = inst10_O;
  assign inst100_I0[3:0] = inst11_O[3:0];
  assign inst100_I1[3:0] = inst12_O[3:0];
  assign inst100_I2[3:0] = inst13_O[3:0];
  assign inst100_I3[3:0] = inst14_O[3:0];
  assign inst19_I6[3:0] = inst100_O[3:0];
  assign inst100_S[1:0] = inst3_O[1:0];
  assign inst101_in = prev_empty_O;
  assign inst102_I1 = inst101_out;
  assign inst102_I0 = ren;
  assign inst105_I2 = inst102_O;
  assign inst103_I0[1:0] = inst3_O[1:0];
  assign inst104_I0[1:0] = inst103_O[1:0];
  assign inst4_I6[1:0] = inst103_O[1:0];
  assign inst104_I1[1:0] = inst7_O[1:0];
  assign inst20_I6 = inst104_O;
  assign inst6_I6 = inst104_O;
  assign inst105_I0 = inst1_O[1];
  assign inst105_I1 = inst99_out;
  assign inst0_I[6] = inst105_O;
  assign inst106_in = prev_full_O;
  assign inst107_I1 = inst106_out;
  assign inst107_I0 = wen;
  assign inst108_in = inst107_O;
  assign inst113_I1 = inst108_out;
  assign inst109_I0[3:0] = inst11_O[3:0];
  assign inst109_I1[3:0] = inst12_O[3:0];
  assign inst109_I2[3:0] = inst13_O[3:0];
  assign inst109_I3[3:0] = inst14_O[3:0];
  assign inst19_I7[3:0] = inst109_O[3:0];
  assign inst109_S[1:0] = inst3_O[1:0];
  assign inst11_CLK = CLK;
  assign inst11_I[3:0] = inst15_O[3:0];
  assign inst15_I2[3:0] = inst11_O[3:0];
  assign inst15_I3[3:0] = inst11_O[3:0];
  assign inst15_I6[3:0] = inst11_O[3:0];
  assign inst15_I7[3:0] = inst11_O[3:0];
  assign inst25_I0[3:0] = inst11_O[3:0];
  assign inst40_I0[3:0] = inst11_O[3:0];
  assign inst54_I0[3:0] = inst11_O[3:0];
  assign inst63_I0[3:0] = inst11_O[3:0];
  assign inst71_I0[3:0] = inst11_O[3:0];
  assign inst86_I0[3:0] = inst11_O[3:0];
  assign inst110_in = prev_empty_O;
  assign inst111_I1 = inst110_out;
  assign inst111_I0 = ren;
  assign inst112_in = inst111_O;
  assign inst113_I2 = inst112_out;
  assign inst113_I0 = inst1_O[1];
  assign inst0_I[7] = inst113_O;
  assign inst12_CLK = CLK;
  assign inst12_I[3:0] = inst16_O[3:0];
  assign inst16_I2[3:0] = inst12_O[3:0];
  assign inst16_I3[3:0] = inst12_O[3:0];
  assign inst16_I6[3:0] = inst12_O[3:0];
  assign inst16_I7[3:0] = inst12_O[3:0];
  assign inst26_I0[3:0] = inst12_O[3:0];
  assign inst41_I0[3:0] = inst12_O[3:0];
  assign inst54_I1[3:0] = inst12_O[3:0];
  assign inst63_I1[3:0] = inst12_O[3:0];
  assign inst72_I0[3:0] = inst12_O[3:0];
  assign inst87_I0[3:0] = inst12_O[3:0];
  assign inst13_CLK = CLK;
  assign inst13_I[3:0] = inst17_O[3:0];
  assign inst17_I2[3:0] = inst13_O[3:0];
  assign inst17_I3[3:0] = inst13_O[3:0];
  assign inst17_I6[3:0] = inst13_O[3:0];
  assign inst17_I7[3:0] = inst13_O[3:0];
  assign inst27_I0[3:0] = inst13_O[3:0];
  assign inst42_I0[3:0] = inst13_O[3:0];
  assign inst54_I2[3:0] = inst13_O[3:0];
  assign inst63_I2[3:0] = inst13_O[3:0];
  assign inst73_I0[3:0] = inst13_O[3:0];
  assign inst88_I0[3:0] = inst13_O[3:0];
  assign inst14_CLK = CLK;
  assign inst14_I[3:0] = inst18_O[3:0];
  assign inst18_I2[3:0] = inst14_O[3:0];
  assign inst18_I3[3:0] = inst14_O[3:0];
  assign inst18_I6[3:0] = inst14_O[3:0];
  assign inst18_I7[3:0] = inst14_O[3:0];
  assign inst28_I0[3:0] = inst14_O[3:0];
  assign inst43_I0[3:0] = inst14_O[3:0];
  assign inst54_I3[3:0] = inst14_O[3:0];
  assign inst63_I3[3:0] = inst14_O[3:0];
  assign inst74_I0[3:0] = inst14_O[3:0];
  assign inst89_I0[3:0] = inst14_O[3:0];
  assign inst15_I0[3:0] = inst25_O[3:0];
  assign inst15_I1[3:0] = inst40_O[3:0];
  assign inst15_I4[3:0] = inst71_O[3:0];
  assign inst15_I5[3:0] = inst86_O[3:0];
  assign inst16_I0[3:0] = inst26_O[3:0];
  assign inst16_I1[3:0] = inst41_O[3:0];
  assign inst16_I4[3:0] = inst72_O[3:0];
  assign inst16_I5[3:0] = inst87_O[3:0];
  assign inst17_I0[3:0] = inst27_O[3:0];
  assign inst17_I1[3:0] = inst42_O[3:0];
  assign inst17_I4[3:0] = inst73_O[3:0];
  assign inst17_I5[3:0] = inst88_O[3:0];
  assign inst18_I0[3:0] = inst28_O[3:0];
  assign inst18_I1[3:0] = inst43_O[3:0];
  assign inst18_I4[3:0] = inst74_O[3:0];
  assign inst18_I5[3:0] = inst89_O[3:0];
  assign inst19_I0[3:0] = inst31_O[3:0];
  assign inst19_I1[3:0] = inst46_O[3:0];
  assign inst19_I2[3:0] = inst54_O[3:0];
  assign inst19_I3[3:0] = inst63_O[3:0];
  assign inst19_I4[3:0] = inst77_O[3:0];
  assign inst19_I5[3:0] = inst92_O[3:0];
  assign rdata[3:0] = inst19_O[3:0];
  assign inst20_I0 = inst35_O;
  assign inst20_I2 = inst58_O;
  assign inst20_I3 = prev_empty_O;
  assign inst20_I4 = inst81_O;
  assign inst20_I7 = prev_empty_O;
  assign empty = inst20_O;
  assign inst21_I1 = inst45_O;
  assign inst21_I3 = prev_full_O;
  assign inst21_I5 = inst91_O;
  assign inst21_I7 = prev_full_O;
  assign full = inst21_O;
  assign inst22_in = prev_full_O;
  assign inst23_I1 = inst22_out;
  assign inst23_I0 = wen;
  assign inst36_I1 = inst23_O;
  assign inst24_I[1:0] = inst7_O[1:0];
  assign inst25_I1[3:0] = wdata[3:0];
  assign inst31_I0[3:0] = inst25_O[3:0];
  assign inst25_S = inst24_O[0];
  assign inst26_I1[3:0] = wdata[3:0];
  assign inst31_I1[3:0] = inst26_O[3:0];
  assign inst26_S = inst24_O[1];
  assign inst27_I1[3:0] = wdata[3:0];
  assign inst31_I2[3:0] = inst27_O[3:0];
  assign inst27_S = inst24_O[2];
  assign inst28_I1[3:0] = wdata[3:0];
  assign inst31_I3[3:0] = inst28_O[3:0];
  assign inst28_S = inst24_O[3];
  assign inst29_I0[1:0] = inst7_O[1:0];
  assign inst30_I1[1:0] = inst29_O[1:0];
  assign inst35_I1[1:0] = inst29_O[1:0];
  assign inst8_I0[1:0] = inst29_O[1:0];
  assign inst3_CLK = CLK;
  assign inst3_I[1:0] = inst4_O[1:0];
  assign inst30_I0[1:0] = inst3_O[1:0];
  assign inst31_S[1:0] = inst3_O[1:0];
  assign inst34_I0[1:0] = inst3_O[1:0];
  assign inst4_I1[1:0] = inst3_O[1:0];
  assign inst4_I3[1:0] = inst3_O[1:0];
  assign inst4_I5[1:0] = inst3_O[1:0];
  assign inst4_I7[1:0] = inst3_O[1:0];
  assign inst45_I0[1:0] = inst3_O[1:0];
  assign inst46_S[1:0] = inst3_O[1:0];
  assign inst54_S[1:0] = inst3_O[1:0];
  assign inst57_I0[1:0] = inst3_O[1:0];
  assign inst63_S[1:0] = inst3_O[1:0];
  assign inst76_I0[1:0] = inst3_O[1:0];
  assign inst77_S[1:0] = inst3_O[1:0];
  assign inst80_I0[1:0] = inst3_O[1:0];
  assign inst91_I0[1:0] = inst3_O[1:0];
  assign inst92_S[1:0] = inst3_O[1:0];
  assign inst32_in = prev_empty_O;
  assign inst33_I1 = inst32_out;
  assign inst33_I0 = ren;
  assign inst36_I2 = inst33_O;
  assign inst35_I0[1:0] = inst34_O[1:0];
  assign inst4_I0[1:0] = inst34_O[1:0];
  assign inst6_I0 = inst35_O;
  assign inst36_I0 = inst1_O[0];
  assign inst0_I[0] = inst36_O;
  assign inst37_in = prev_full_O;
  assign inst38_I1 = inst37_out;
  assign inst38_I0 = wen;
  assign inst50_I1 = inst38_O;
  assign inst39_I[1:0] = inst7_O[1:0];
  assign inst4_I2[1:0] = inst57_O[1:0];
  assign inst4_I4[1:0] = inst80_O[1:0];
  assign inst40_I1[3:0] = wdata[3:0];
  assign inst46_I0[3:0] = inst40_O[3:0];
  assign inst40_S = inst39_O[0];
  assign inst41_I1[3:0] = wdata[3:0];
  assign inst46_I1[3:0] = inst41_O[3:0];
  assign inst41_S = inst39_O[1];
  assign inst42_I1[3:0] = wdata[3:0];
  assign inst46_I2[3:0] = inst42_O[3:0];
  assign inst42_S = inst39_O[2];
  assign inst43_I1[3:0] = wdata[3:0];
  assign inst46_I3[3:0] = inst43_O[3:0];
  assign inst43_S = inst39_O[3];
  assign inst44_I0[1:0] = inst7_O[1:0];
  assign inst45_I1[1:0] = inst44_O[1:0];
  assign inst8_I1[1:0] = inst44_O[1:0];
  assign inst47_in = prev_empty_O;
  assign inst48_I1 = inst47_out;
  assign inst48_I0 = ren;
  assign inst49_in = inst48_O;
  assign inst50_I2 = inst49_out;
  assign inst50_I0 = inst1_O[0];
  assign inst0_I[1] = inst50_O;
  assign inst51_in = prev_full_O;
  assign inst52_I1 = inst51_out;
  assign inst52_I0 = wen;
  assign inst53_in = inst52_O;
  assign inst59_I1 = inst53_out;
  assign inst55_in = prev_empty_O;
  assign inst56_I1 = inst55_out;
  assign inst56_I0 = ren;
  assign inst59_I2 = inst56_O;
  assign inst58_I0[1:0] = inst57_O[1:0];
  assign inst58_I1[1:0] = inst7_O[1:0];
  assign inst6_I2 = inst58_O;
  assign inst59_I0 = inst1_O[0];
  assign inst0_I[2] = inst59_O;
  assign inst6_I3 = prev_empty_O;
  assign inst6_I4 = inst81_O;
  assign inst6_I7 = prev_empty_O;
  assign prev_empty_I = inst6_O;
  assign inst60_in = prev_full_O;
  assign inst61_I1 = inst60_out;
  assign inst61_I0 = wen;
  assign inst62_in = inst61_O;
  assign inst67_I1 = inst62_out;
  assign inst64_in = prev_empty_O;
  assign inst65_I1 = inst64_out;
  assign inst65_I0 = ren;
  assign inst66_in = inst65_O;
  assign inst67_I2 = inst66_out;
  assign inst67_I0 = inst1_O[0];
  assign inst0_I[3] = inst67_O;
  assign inst68_in = prev_full_O;
  assign inst69_I1 = inst68_out;
  assign inst69_I0 = wen;
  assign inst82_I1 = inst69_O;
  assign inst7_CLK = CLK;
  assign inst7_I[1:0] = inst8_O[1:0];
  assign inst70_I[1:0] = inst7_O[1:0];
  assign inst75_I0[1:0] = inst7_O[1:0];
  assign inst8_I2[1:0] = inst7_O[1:0];
  assign inst8_I3[1:0] = inst7_O[1:0];
  assign inst8_I6[1:0] = inst7_O[1:0];
  assign inst8_I7[1:0] = inst7_O[1:0];
  assign inst85_I[1:0] = inst7_O[1:0];
  assign inst90_I0[1:0] = inst7_O[1:0];
  assign inst71_I1[3:0] = wdata[3:0];
  assign inst77_I0[3:0] = inst71_O[3:0];
  assign inst71_S = inst70_O[0];
  assign inst72_I1[3:0] = wdata[3:0];
  assign inst77_I1[3:0] = inst72_O[3:0];
  assign inst72_S = inst70_O[1];
  assign inst73_I1[3:0] = wdata[3:0];
  assign inst77_I2[3:0] = inst73_O[3:0];
  assign inst73_S = inst70_O[2];
  assign inst74_I1[3:0] = wdata[3:0];
  assign inst77_I3[3:0] = inst74_O[3:0];
  assign inst74_S = inst70_O[3];
  assign inst76_I1[1:0] = inst75_O[1:0];
  assign inst8_I4[1:0] = inst75_O[1:0];
  assign inst81_I1[1:0] = inst75_O[1:0];
  assign inst78_in = prev_empty_O;
  assign inst79_I1 = inst78_out;
  assign inst79_I0 = ren;
  assign inst82_I2 = inst79_O;
  assign inst8_I5[1:0] = inst90_O[1:0];
  assign inst81_I0[1:0] = inst80_O[1:0];
  assign inst82_I0 = inst1_O[1];
  assign inst0_I[4] = inst82_O;
  assign inst83_in = prev_full_O;
  assign inst84_I1 = inst83_out;
  assign inst84_I0 = wen;
  assign inst96_I1 = inst84_O;
  assign inst86_I1[3:0] = wdata[3:0];
  assign inst92_I0[3:0] = inst86_O[3:0];
  assign inst86_S = inst85_O[0];
  assign inst87_I1[3:0] = wdata[3:0];
  assign inst92_I1[3:0] = inst87_O[3:0];
  assign inst87_S = inst85_O[1];
  assign inst88_I1[3:0] = wdata[3:0];
  assign inst92_I2[3:0] = inst88_O[3:0];
  assign inst88_S = inst85_O[2];
  assign inst89_I1[3:0] = wdata[3:0];
  assign inst92_I3[3:0] = inst89_O[3:0];
  assign inst89_S = inst85_O[3];
  assign inst91_I1[1:0] = inst90_O[1:0];
  assign inst93_in = prev_empty_O;
  assign inst94_I1 = inst93_out;
  assign inst94_I0 = ren;
  assign inst95_in = inst94_O;
  assign inst96_I2 = inst95_out;
  assign inst96_I0 = inst1_O[1];
  assign inst0_I[5] = inst96_O;
  assign inst97_in = prev_full_O;
  assign inst98_I1 = inst97_out;
  assign inst98_I0 = wen;
  assign inst99_in = inst98_O;
  assign prev_empty_CLK = CLK;
  assign prev_full_CLK = CLK;

endmodule //Fifo
