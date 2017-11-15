

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

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module or8_wrapped (
  input [7:0] I0,
  input [7:0] I1,
  output [7:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [7:0] inst0__in0;
  wire [7:0] inst0__in1;
  wire [7:0] inst0__out;
  coreir_or #(.width(8)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[7:0] = I0[7:0];
  assign inst0__in1[7:0] = I1[7:0];
  assign O[7:0] = inst0__out[7:0];

endmodule //or8_wrapped

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

module reg_U0 #(parameter init=1) (
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

endmodule //reg_U0

module DFF_init0_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U0)
  wire  inst0__clk;
  wire [0:0] inst0__in;
  wire [0:0] inst0__out;
  reg_U0 #(.init(1'd0)) inst0(
    .clk(inst0__clk),
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__clk = CLK;
  assign inst0__in[0] = I;
  assign O = inst0__out[0];

endmodule //DFF_init0_has_ceFalse_has_resetFalse

module Register8 (
  input  CLK,
  input [7:0] I,
  output [7:0] O
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

  //Wire declarations for instance 'inst4' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst4__CLK;
  wire  inst4__I;
  wire  inst4__O;
  DFF_init0_has_ceFalse_has_resetFalse inst4(
    .CLK(inst4__CLK),
    .I(inst4__I),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst5__CLK;
  wire  inst5__I;
  wire  inst5__O;
  DFF_init0_has_ceFalse_has_resetFalse inst5(
    .CLK(inst5__CLK),
    .I(inst5__I),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst6__CLK;
  wire  inst6__I;
  wire  inst6__O;
  DFF_init0_has_ceFalse_has_resetFalse inst6(
    .CLK(inst6__CLK),
    .I(inst6__I),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst7__CLK;
  wire  inst7__I;
  wire  inst7__O;
  DFF_init0_has_ceFalse_has_resetFalse inst7(
    .CLK(inst7__CLK),
    .I(inst7__I),
    .O(inst7__O)
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
  assign inst4__CLK = CLK;
  assign inst4__I = I[4];
  assign O[4] = inst4__O;
  assign inst5__CLK = CLK;
  assign inst5__I = I[5];
  assign O[5] = inst5__O;
  assign inst6__CLK = CLK;
  assign inst6__I = I[6];
  assign O[6] = inst6__O;
  assign inst7__CLK = CLK;
  assign inst7__I = I[7];
  assign O[7] = inst7__O;

endmodule //Register8

module DFF_init1_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U0)
  wire  inst0__clk;
  wire [0:0] inst0__in;
  wire [0:0] inst0__out;
  reg_U0 #(.init(1'd1)) inst0(
    .clk(inst0__clk),
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__clk = CLK;
  assign inst0__in[0] = I;
  assign O = inst0__out[0];

endmodule //DFF_init1_has_ceFalse_has_resetFalse

module Or15x12 (
  input [11:0] I0,
  input [11:0] I1,
  input [11:0] I10,
  input [11:0] I11,
  input [11:0] I12,
  input [11:0] I13,
  input [11:0] I14,
  input [11:0] I2,
  input [11:0] I3,
  input [11:0] I4,
  input [11:0] I5,
  input [11:0] I6,
  input [11:0] I7,
  input [11:0] I8,
  input [11:0] I9,
  output [11:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [14:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(15)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [14:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(15)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst10' (Module coreir_orr)
  wire [14:0] inst10__in;
  wire  inst10__out;
  coreir_orr #(.width(15)) inst10(
    .in(inst10__in),
    .out(inst10__out)
  );

  //Wire declarations for instance 'inst11' (Module coreir_orr)
  wire [14:0] inst11__in;
  wire  inst11__out;
  coreir_orr #(.width(15)) inst11(
    .in(inst11__in),
    .out(inst11__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [14:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(15)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [14:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(15)) inst3(
    .in(inst3__in),
    .out(inst3__out)
  );

  //Wire declarations for instance 'inst4' (Module coreir_orr)
  wire [14:0] inst4__in;
  wire  inst4__out;
  coreir_orr #(.width(15)) inst4(
    .in(inst4__in),
    .out(inst4__out)
  );

  //Wire declarations for instance 'inst5' (Module coreir_orr)
  wire [14:0] inst5__in;
  wire  inst5__out;
  coreir_orr #(.width(15)) inst5(
    .in(inst5__in),
    .out(inst5__out)
  );

  //Wire declarations for instance 'inst6' (Module coreir_orr)
  wire [14:0] inst6__in;
  wire  inst6__out;
  coreir_orr #(.width(15)) inst6(
    .in(inst6__in),
    .out(inst6__out)
  );

  //Wire declarations for instance 'inst7' (Module coreir_orr)
  wire [14:0] inst7__in;
  wire  inst7__out;
  coreir_orr #(.width(15)) inst7(
    .in(inst7__in),
    .out(inst7__out)
  );

  //Wire declarations for instance 'inst8' (Module coreir_orr)
  wire [14:0] inst8__in;
  wire  inst8__out;
  coreir_orr #(.width(15)) inst8(
    .in(inst8__in),
    .out(inst8__out)
  );

  //Wire declarations for instance 'inst9' (Module coreir_orr)
  wire [14:0] inst9__in;
  wire  inst9__out;
  coreir_orr #(.width(15)) inst9(
    .in(inst9__in),
    .out(inst9__out)
  );

  //All the connections
  assign O[0] = inst0__out;
  assign O[1] = inst1__out;
  assign O[10] = inst10__out;
  assign O[11] = inst11__out;
  assign O[2] = inst2__out;
  assign O[3] = inst3__out;
  assign O[4] = inst4__out;
  assign O[5] = inst5__out;
  assign O[6] = inst6__out;
  assign O[7] = inst7__out;
  assign O[8] = inst8__out;
  assign O[9] = inst9__out;
  assign inst0__in[0] = I0[0];
  assign inst0__in[1] = I1[0];
  assign inst0__in[10] = I10[0];
  assign inst0__in[11] = I11[0];
  assign inst0__in[12] = I12[0];
  assign inst0__in[13] = I13[0];
  assign inst0__in[14] = I14[0];
  assign inst0__in[2] = I2[0];
  assign inst0__in[3] = I3[0];
  assign inst0__in[4] = I4[0];
  assign inst0__in[5] = I5[0];
  assign inst0__in[6] = I6[0];
  assign inst0__in[7] = I7[0];
  assign inst0__in[8] = I8[0];
  assign inst0__in[9] = I9[0];
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[10] = I10[1];
  assign inst1__in[11] = I11[1];
  assign inst1__in[12] = I12[1];
  assign inst1__in[13] = I13[1];
  assign inst1__in[14] = I14[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst1__in[5] = I5[1];
  assign inst1__in[6] = I6[1];
  assign inst1__in[7] = I7[1];
  assign inst1__in[8] = I8[1];
  assign inst1__in[9] = I9[1];
  assign inst10__in[0] = I0[10];
  assign inst10__in[1] = I1[10];
  assign inst10__in[10] = I10[10];
  assign inst10__in[11] = I11[10];
  assign inst10__in[12] = I12[10];
  assign inst10__in[13] = I13[10];
  assign inst10__in[14] = I14[10];
  assign inst10__in[2] = I2[10];
  assign inst10__in[3] = I3[10];
  assign inst10__in[4] = I4[10];
  assign inst10__in[5] = I5[10];
  assign inst10__in[6] = I6[10];
  assign inst10__in[7] = I7[10];
  assign inst10__in[8] = I8[10];
  assign inst10__in[9] = I9[10];
  assign inst11__in[0] = I0[11];
  assign inst11__in[1] = I1[11];
  assign inst11__in[10] = I10[11];
  assign inst11__in[11] = I11[11];
  assign inst11__in[12] = I12[11];
  assign inst11__in[13] = I13[11];
  assign inst11__in[14] = I14[11];
  assign inst11__in[2] = I2[11];
  assign inst11__in[3] = I3[11];
  assign inst11__in[4] = I4[11];
  assign inst11__in[5] = I5[11];
  assign inst11__in[6] = I6[11];
  assign inst11__in[7] = I7[11];
  assign inst11__in[8] = I8[11];
  assign inst11__in[9] = I9[11];
  assign inst2__in[0] = I0[2];
  assign inst2__in[1] = I1[2];
  assign inst2__in[10] = I10[2];
  assign inst2__in[11] = I11[2];
  assign inst2__in[12] = I12[2];
  assign inst2__in[13] = I13[2];
  assign inst2__in[14] = I14[2];
  assign inst2__in[2] = I2[2];
  assign inst2__in[3] = I3[2];
  assign inst2__in[4] = I4[2];
  assign inst2__in[5] = I5[2];
  assign inst2__in[6] = I6[2];
  assign inst2__in[7] = I7[2];
  assign inst2__in[8] = I8[2];
  assign inst2__in[9] = I9[2];
  assign inst3__in[0] = I0[3];
  assign inst3__in[1] = I1[3];
  assign inst3__in[10] = I10[3];
  assign inst3__in[11] = I11[3];
  assign inst3__in[12] = I12[3];
  assign inst3__in[13] = I13[3];
  assign inst3__in[14] = I14[3];
  assign inst3__in[2] = I2[3];
  assign inst3__in[3] = I3[3];
  assign inst3__in[4] = I4[3];
  assign inst3__in[5] = I5[3];
  assign inst3__in[6] = I6[3];
  assign inst3__in[7] = I7[3];
  assign inst3__in[8] = I8[3];
  assign inst3__in[9] = I9[3];
  assign inst4__in[0] = I0[4];
  assign inst4__in[1] = I1[4];
  assign inst4__in[10] = I10[4];
  assign inst4__in[11] = I11[4];
  assign inst4__in[12] = I12[4];
  assign inst4__in[13] = I13[4];
  assign inst4__in[14] = I14[4];
  assign inst4__in[2] = I2[4];
  assign inst4__in[3] = I3[4];
  assign inst4__in[4] = I4[4];
  assign inst4__in[5] = I5[4];
  assign inst4__in[6] = I6[4];
  assign inst4__in[7] = I7[4];
  assign inst4__in[8] = I8[4];
  assign inst4__in[9] = I9[4];
  assign inst5__in[0] = I0[5];
  assign inst5__in[1] = I1[5];
  assign inst5__in[10] = I10[5];
  assign inst5__in[11] = I11[5];
  assign inst5__in[12] = I12[5];
  assign inst5__in[13] = I13[5];
  assign inst5__in[14] = I14[5];
  assign inst5__in[2] = I2[5];
  assign inst5__in[3] = I3[5];
  assign inst5__in[4] = I4[5];
  assign inst5__in[5] = I5[5];
  assign inst5__in[6] = I6[5];
  assign inst5__in[7] = I7[5];
  assign inst5__in[8] = I8[5];
  assign inst5__in[9] = I9[5];
  assign inst6__in[0] = I0[6];
  assign inst6__in[1] = I1[6];
  assign inst6__in[10] = I10[6];
  assign inst6__in[11] = I11[6];
  assign inst6__in[12] = I12[6];
  assign inst6__in[13] = I13[6];
  assign inst6__in[14] = I14[6];
  assign inst6__in[2] = I2[6];
  assign inst6__in[3] = I3[6];
  assign inst6__in[4] = I4[6];
  assign inst6__in[5] = I5[6];
  assign inst6__in[6] = I6[6];
  assign inst6__in[7] = I7[6];
  assign inst6__in[8] = I8[6];
  assign inst6__in[9] = I9[6];
  assign inst7__in[0] = I0[7];
  assign inst7__in[1] = I1[7];
  assign inst7__in[10] = I10[7];
  assign inst7__in[11] = I11[7];
  assign inst7__in[12] = I12[7];
  assign inst7__in[13] = I13[7];
  assign inst7__in[14] = I14[7];
  assign inst7__in[2] = I2[7];
  assign inst7__in[3] = I3[7];
  assign inst7__in[4] = I4[7];
  assign inst7__in[5] = I5[7];
  assign inst7__in[6] = I6[7];
  assign inst7__in[7] = I7[7];
  assign inst7__in[8] = I8[7];
  assign inst7__in[9] = I9[7];
  assign inst8__in[0] = I0[8];
  assign inst8__in[1] = I1[8];
  assign inst8__in[10] = I10[8];
  assign inst8__in[11] = I11[8];
  assign inst8__in[12] = I12[8];
  assign inst8__in[13] = I13[8];
  assign inst8__in[14] = I14[8];
  assign inst8__in[2] = I2[8];
  assign inst8__in[3] = I3[8];
  assign inst8__in[4] = I4[8];
  assign inst8__in[5] = I5[8];
  assign inst8__in[6] = I6[8];
  assign inst8__in[7] = I7[8];
  assign inst8__in[8] = I8[8];
  assign inst8__in[9] = I9[8];
  assign inst9__in[0] = I0[9];
  assign inst9__in[1] = I1[9];
  assign inst9__in[10] = I10[9];
  assign inst9__in[11] = I11[9];
  assign inst9__in[12] = I12[9];
  assign inst9__in[13] = I13[9];
  assign inst9__in[14] = I14[9];
  assign inst9__in[2] = I2[9];
  assign inst9__in[3] = I3[9];
  assign inst9__in[4] = I4[9];
  assign inst9__in[5] = I5[9];
  assign inst9__in[6] = I6[9];
  assign inst9__in[7] = I7[9];
  assign inst9__in[8] = I8[9];
  assign inst9__in[9] = I9[9];

endmodule //Or15x12

module Or15x8 (
  input [7:0] I0,
  input [7:0] I1,
  input [7:0] I10,
  input [7:0] I11,
  input [7:0] I12,
  input [7:0] I13,
  input [7:0] I14,
  input [7:0] I2,
  input [7:0] I3,
  input [7:0] I4,
  input [7:0] I5,
  input [7:0] I6,
  input [7:0] I7,
  input [7:0] I8,
  input [7:0] I9,
  output [7:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [14:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(15)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [14:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(15)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [14:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(15)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [14:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(15)) inst3(
    .in(inst3__in),
    .out(inst3__out)
  );

  //Wire declarations for instance 'inst4' (Module coreir_orr)
  wire [14:0] inst4__in;
  wire  inst4__out;
  coreir_orr #(.width(15)) inst4(
    .in(inst4__in),
    .out(inst4__out)
  );

  //Wire declarations for instance 'inst5' (Module coreir_orr)
  wire [14:0] inst5__in;
  wire  inst5__out;
  coreir_orr #(.width(15)) inst5(
    .in(inst5__in),
    .out(inst5__out)
  );

  //Wire declarations for instance 'inst6' (Module coreir_orr)
  wire [14:0] inst6__in;
  wire  inst6__out;
  coreir_orr #(.width(15)) inst6(
    .in(inst6__in),
    .out(inst6__out)
  );

  //Wire declarations for instance 'inst7' (Module coreir_orr)
  wire [14:0] inst7__in;
  wire  inst7__out;
  coreir_orr #(.width(15)) inst7(
    .in(inst7__in),
    .out(inst7__out)
  );

  //All the connections
  assign O[0] = inst0__out;
  assign O[1] = inst1__out;
  assign O[2] = inst2__out;
  assign O[3] = inst3__out;
  assign O[4] = inst4__out;
  assign O[5] = inst5__out;
  assign O[6] = inst6__out;
  assign O[7] = inst7__out;
  assign inst0__in[0] = I0[0];
  assign inst0__in[1] = I1[0];
  assign inst0__in[10] = I10[0];
  assign inst0__in[11] = I11[0];
  assign inst0__in[12] = I12[0];
  assign inst0__in[13] = I13[0];
  assign inst0__in[14] = I14[0];
  assign inst0__in[2] = I2[0];
  assign inst0__in[3] = I3[0];
  assign inst0__in[4] = I4[0];
  assign inst0__in[5] = I5[0];
  assign inst0__in[6] = I6[0];
  assign inst0__in[7] = I7[0];
  assign inst0__in[8] = I8[0];
  assign inst0__in[9] = I9[0];
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[10] = I10[1];
  assign inst1__in[11] = I11[1];
  assign inst1__in[12] = I12[1];
  assign inst1__in[13] = I13[1];
  assign inst1__in[14] = I14[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst1__in[5] = I5[1];
  assign inst1__in[6] = I6[1];
  assign inst1__in[7] = I7[1];
  assign inst1__in[8] = I8[1];
  assign inst1__in[9] = I9[1];
  assign inst2__in[0] = I0[2];
  assign inst2__in[1] = I1[2];
  assign inst2__in[10] = I10[2];
  assign inst2__in[11] = I11[2];
  assign inst2__in[12] = I12[2];
  assign inst2__in[13] = I13[2];
  assign inst2__in[14] = I14[2];
  assign inst2__in[2] = I2[2];
  assign inst2__in[3] = I3[2];
  assign inst2__in[4] = I4[2];
  assign inst2__in[5] = I5[2];
  assign inst2__in[6] = I6[2];
  assign inst2__in[7] = I7[2];
  assign inst2__in[8] = I8[2];
  assign inst2__in[9] = I9[2];
  assign inst3__in[0] = I0[3];
  assign inst3__in[1] = I1[3];
  assign inst3__in[10] = I10[3];
  assign inst3__in[11] = I11[3];
  assign inst3__in[12] = I12[3];
  assign inst3__in[13] = I13[3];
  assign inst3__in[14] = I14[3];
  assign inst3__in[2] = I2[3];
  assign inst3__in[3] = I3[3];
  assign inst3__in[4] = I4[3];
  assign inst3__in[5] = I5[3];
  assign inst3__in[6] = I6[3];
  assign inst3__in[7] = I7[3];
  assign inst3__in[8] = I8[3];
  assign inst3__in[9] = I9[3];
  assign inst4__in[0] = I0[4];
  assign inst4__in[1] = I1[4];
  assign inst4__in[10] = I10[4];
  assign inst4__in[11] = I11[4];
  assign inst4__in[12] = I12[4];
  assign inst4__in[13] = I13[4];
  assign inst4__in[14] = I14[4];
  assign inst4__in[2] = I2[4];
  assign inst4__in[3] = I3[4];
  assign inst4__in[4] = I4[4];
  assign inst4__in[5] = I5[4];
  assign inst4__in[6] = I6[4];
  assign inst4__in[7] = I7[4];
  assign inst4__in[8] = I8[4];
  assign inst4__in[9] = I9[4];
  assign inst5__in[0] = I0[5];
  assign inst5__in[1] = I1[5];
  assign inst5__in[10] = I10[5];
  assign inst5__in[11] = I11[5];
  assign inst5__in[12] = I12[5];
  assign inst5__in[13] = I13[5];
  assign inst5__in[14] = I14[5];
  assign inst5__in[2] = I2[5];
  assign inst5__in[3] = I3[5];
  assign inst5__in[4] = I4[5];
  assign inst5__in[5] = I5[5];
  assign inst5__in[6] = I6[5];
  assign inst5__in[7] = I7[5];
  assign inst5__in[8] = I8[5];
  assign inst5__in[9] = I9[5];
  assign inst6__in[0] = I0[6];
  assign inst6__in[1] = I1[6];
  assign inst6__in[10] = I10[6];
  assign inst6__in[11] = I11[6];
  assign inst6__in[12] = I12[6];
  assign inst6__in[13] = I13[6];
  assign inst6__in[14] = I14[6];
  assign inst6__in[2] = I2[6];
  assign inst6__in[3] = I3[6];
  assign inst6__in[4] = I4[6];
  assign inst6__in[5] = I5[6];
  assign inst6__in[6] = I6[6];
  assign inst6__in[7] = I7[6];
  assign inst6__in[8] = I8[6];
  assign inst6__in[9] = I9[6];
  assign inst7__in[0] = I0[7];
  assign inst7__in[1] = I1[7];
  assign inst7__in[10] = I10[7];
  assign inst7__in[11] = I11[7];
  assign inst7__in[12] = I12[7];
  assign inst7__in[13] = I13[7];
  assign inst7__in[14] = I14[7];
  assign inst7__in[2] = I2[7];
  assign inst7__in[3] = I3[7];
  assign inst7__in[4] = I4[7];
  assign inst7__in[5] = I5[7];
  assign inst7__in[6] = I6[7];
  assign inst7__in[7] = I7[7];
  assign inst7__in[8] = I8[7];
  assign inst7__in[9] = I9[7];

endmodule //Or15x8

module Or15xNone (
  input  I0,
  input  I1,
  input  I10,
  input  I11,
  input  I12,
  input  I13,
  input  I14,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  input  I6,
  input  I7,
  input  I8,
  input  I9,
  output  O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [14:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(15)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign O = inst0__out;
  assign inst0__in[0] = I0;
  assign inst0__in[1] = I1;
  assign inst0__in[10] = I10;
  assign inst0__in[11] = I11;
  assign inst0__in[12] = I12;
  assign inst0__in[13] = I13;
  assign inst0__in[14] = I14;
  assign inst0__in[2] = I2;
  assign inst0__in[3] = I3;
  assign inst0__in[4] = I4;
  assign inst0__in[5] = I5;
  assign inst0__in[6] = I6;
  assign inst0__in[7] = I7;
  assign inst0__in[8] = I8;
  assign inst0__in[9] = I9;

endmodule //Or15xNone

module Register12_0001 (
  input  CLK,
  input [11:0] I,
  output [11:0] O
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

  //Wire declarations for instance 'inst10' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst10__CLK;
  wire  inst10__I;
  wire  inst10__O;
  DFF_init0_has_ceFalse_has_resetFalse inst10(
    .CLK(inst10__CLK),
    .I(inst10__I),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst11__CLK;
  wire  inst11__I;
  wire  inst11__O;
  DFF_init0_has_ceFalse_has_resetFalse inst11(
    .CLK(inst11__CLK),
    .I(inst11__I),
    .O(inst11__O)
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

  //Wire declarations for instance 'inst4' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst4__CLK;
  wire  inst4__I;
  wire  inst4__O;
  DFF_init0_has_ceFalse_has_resetFalse inst4(
    .CLK(inst4__CLK),
    .I(inst4__I),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst5__CLK;
  wire  inst5__I;
  wire  inst5__O;
  DFF_init0_has_ceFalse_has_resetFalse inst5(
    .CLK(inst5__CLK),
    .I(inst5__I),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst6__CLK;
  wire  inst6__I;
  wire  inst6__O;
  DFF_init0_has_ceFalse_has_resetFalse inst6(
    .CLK(inst6__CLK),
    .I(inst6__I),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst7__CLK;
  wire  inst7__I;
  wire  inst7__O;
  DFF_init0_has_ceFalse_has_resetFalse inst7(
    .CLK(inst7__CLK),
    .I(inst7__I),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst8__CLK;
  wire  inst8__I;
  wire  inst8__O;
  DFF_init0_has_ceFalse_has_resetFalse inst8(
    .CLK(inst8__CLK),
    .I(inst8__I),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst9' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst9__CLK;
  wire  inst9__I;
  wire  inst9__O;
  DFF_init0_has_ceFalse_has_resetFalse inst9(
    .CLK(inst9__CLK),
    .I(inst9__I),
    .O(inst9__O)
  );

  //All the connections
  assign inst0__CLK = CLK;
  assign inst0__I = I[0];
  assign O[0] = inst0__O;
  assign inst1__CLK = CLK;
  assign inst1__I = I[1];
  assign O[1] = inst1__O;
  assign inst10__CLK = CLK;
  assign inst10__I = I[10];
  assign O[10] = inst10__O;
  assign inst11__CLK = CLK;
  assign inst11__I = I[11];
  assign O[11] = inst11__O;
  assign inst2__CLK = CLK;
  assign inst2__I = I[2];
  assign O[2] = inst2__O;
  assign inst3__CLK = CLK;
  assign inst3__I = I[3];
  assign O[3] = inst3__O;
  assign inst4__CLK = CLK;
  assign inst4__I = I[4];
  assign O[4] = inst4__O;
  assign inst5__CLK = CLK;
  assign inst5__I = I[5];
  assign O[5] = inst5__O;
  assign inst6__CLK = CLK;
  assign inst6__I = I[6];
  assign O[6] = inst6__O;
  assign inst7__CLK = CLK;
  assign inst7__I = I[7];
  assign O[7] = inst7__O;
  assign inst8__CLK = CLK;
  assign inst8__I = I[8];
  assign O[8] = inst8__O;
  assign inst9__CLK = CLK;
  assign inst9__I = I[9];
  assign O[9] = inst9__O;

endmodule //Register12_0001

module __silica_BufferPISO (
  input [1:0] I,
  output [1:0] O
);
  //All the connections
  assign O[1:0] = I[1:0];

endmodule //__silica_BufferPISO

module __silica_BufferUART_TX (
  input [14:0] I,
  output [14:0] O
);
  //All the connections
  assign O[14:0] = I[14:0];

endmodule //__silica_BufferUART_TX

module and12_wrapped (
  input [11:0] I0,
  input [11:0] I1,
  output [11:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [11:0] inst0__in0;
  wire [11:0] inst0__in1;
  wire [11:0] inst0__out;
  coreir_and #(.width(12)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[11:0] = I0[11:0];
  assign inst0__in1[11:0] = I1[11:0];
  assign O[11:0] = inst0__out[11:0];

endmodule //and12_wrapped

module SilicaOneHotMux1512 (
  input [11:0] I0,
  input [11:0] I1,
  input [11:0] I10,
  input [11:0] I11,
  input [11:0] I12,
  input [11:0] I13,
  input [11:0] I14,
  input [11:0] I2,
  input [11:0] I3,
  input [11:0] I4,
  input [11:0] I5,
  input [11:0] I6,
  input [11:0] I7,
  input [11:0] I8,
  input [11:0] I9,
  output [11:0] O,
  input [14:0] S
);
  //Wire declarations for instance 'inst0' (Module Or15x12)
  wire [11:0] inst0__I0;
  wire [11:0] inst0__I1;
  wire [11:0] inst0__I10;
  wire [11:0] inst0__I11;
  wire [11:0] inst0__I12;
  wire [11:0] inst0__I13;
  wire [11:0] inst0__I14;
  wire [11:0] inst0__I2;
  wire [11:0] inst0__I3;
  wire [11:0] inst0__I4;
  wire [11:0] inst0__I5;
  wire [11:0] inst0__I6;
  wire [11:0] inst0__I7;
  wire [11:0] inst0__I8;
  wire [11:0] inst0__I9;
  wire [11:0] inst0__O;
  Or15x12 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I10(inst0__I10),
    .I11(inst0__I11),
    .I12(inst0__I12),
    .I13(inst0__I13),
    .I14(inst0__I14),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .I8(inst0__I8),
    .I9(inst0__I9),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and12_wrapped)
  wire [11:0] inst1__I0;
  wire [11:0] inst1__I1;
  wire [11:0] inst1__O;
  and12_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst10' (Module and12_wrapped)
  wire [11:0] inst10__I0;
  wire [11:0] inst10__I1;
  wire [11:0] inst10__O;
  and12_wrapped inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module and12_wrapped)
  wire [11:0] inst11__I0;
  wire [11:0] inst11__I1;
  wire [11:0] inst11__O;
  and12_wrapped inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .O(inst11__O)
  );

  //Wire declarations for instance 'inst12' (Module and12_wrapped)
  wire [11:0] inst12__I0;
  wire [11:0] inst12__I1;
  wire [11:0] inst12__O;
  and12_wrapped inst12(
    .I0(inst12__I0),
    .I1(inst12__I1),
    .O(inst12__O)
  );

  //Wire declarations for instance 'inst13' (Module and12_wrapped)
  wire [11:0] inst13__I0;
  wire [11:0] inst13__I1;
  wire [11:0] inst13__O;
  and12_wrapped inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module and12_wrapped)
  wire [11:0] inst14__I0;
  wire [11:0] inst14__I1;
  wire [11:0] inst14__O;
  and12_wrapped inst14(
    .I0(inst14__I0),
    .I1(inst14__I1),
    .O(inst14__O)
  );

  //Wire declarations for instance 'inst15' (Module and12_wrapped)
  wire [11:0] inst15__I0;
  wire [11:0] inst15__I1;
  wire [11:0] inst15__O;
  and12_wrapped inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .O(inst15__O)
  );

  //Wire declarations for instance 'inst2' (Module and12_wrapped)
  wire [11:0] inst2__I0;
  wire [11:0] inst2__I1;
  wire [11:0] inst2__O;
  and12_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and12_wrapped)
  wire [11:0] inst3__I0;
  wire [11:0] inst3__I1;
  wire [11:0] inst3__O;
  and12_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and12_wrapped)
  wire [11:0] inst4__I0;
  wire [11:0] inst4__I1;
  wire [11:0] inst4__O;
  and12_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and12_wrapped)
  wire [11:0] inst5__I0;
  wire [11:0] inst5__I1;
  wire [11:0] inst5__O;
  and12_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module and12_wrapped)
  wire [11:0] inst6__I0;
  wire [11:0] inst6__I1;
  wire [11:0] inst6__O;
  and12_wrapped inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module and12_wrapped)
  wire [11:0] inst7__I0;
  wire [11:0] inst7__I1;
  wire [11:0] inst7__O;
  and12_wrapped inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module and12_wrapped)
  wire [11:0] inst8__I0;
  wire [11:0] inst8__I1;
  wire [11:0] inst8__O;
  and12_wrapped inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst9' (Module and12_wrapped)
  wire [11:0] inst9__I0;
  wire [11:0] inst9__I1;
  wire [11:0] inst9__O;
  and12_wrapped inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .O(inst9__O)
  );

  //All the connections
  assign inst0__I0[11:0] = inst1__O[11:0];
  assign inst0__I1[11:0] = inst2__O[11:0];
  assign inst0__I10[11:0] = inst11__O[11:0];
  assign inst0__I11[11:0] = inst12__O[11:0];
  assign inst0__I12[11:0] = inst13__O[11:0];
  assign inst0__I13[11:0] = inst14__O[11:0];
  assign inst0__I14[11:0] = inst15__O[11:0];
  assign inst0__I2[11:0] = inst3__O[11:0];
  assign inst0__I3[11:0] = inst4__O[11:0];
  assign inst0__I4[11:0] = inst5__O[11:0];
  assign inst0__I5[11:0] = inst6__O[11:0];
  assign inst0__I6[11:0] = inst7__O[11:0];
  assign inst0__I7[11:0] = inst8__O[11:0];
  assign inst0__I8[11:0] = inst9__O[11:0];
  assign inst0__I9[11:0] = inst10__O[11:0];
  assign O[11:0] = inst0__O[11:0];
  assign inst1__I0[11:0] = I0[11:0];
  assign inst10__I0[11:0] = I9[11:0];
  assign inst11__I0[11:0] = I10[11:0];
  assign inst12__I0[11:0] = I11[11:0];
  assign inst13__I0[11:0] = I12[11:0];
  assign inst14__I0[11:0] = I13[11:0];
  assign inst15__I0[11:0] = I14[11:0];
  assign inst2__I0[11:0] = I1[11:0];
  assign inst3__I0[11:0] = I2[11:0];
  assign inst4__I0[11:0] = I3[11:0];
  assign inst5__I0[11:0] = I4[11:0];
  assign inst6__I0[11:0] = I5[11:0];
  assign inst7__I0[11:0] = I6[11:0];
  assign inst8__I0[11:0] = I7[11:0];
  assign inst9__I0[11:0] = I8[11:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[10] = S[0];
  assign inst1__I1[11] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst1__I1[4] = S[0];
  assign inst1__I1[5] = S[0];
  assign inst1__I1[6] = S[0];
  assign inst1__I1[7] = S[0];
  assign inst1__I1[8] = S[0];
  assign inst1__I1[9] = S[0];
  assign inst10__I1[0] = S[9];
  assign inst10__I1[1] = S[9];
  assign inst10__I1[10] = S[9];
  assign inst10__I1[11] = S[9];
  assign inst10__I1[2] = S[9];
  assign inst10__I1[3] = S[9];
  assign inst10__I1[4] = S[9];
  assign inst10__I1[5] = S[9];
  assign inst10__I1[6] = S[9];
  assign inst10__I1[7] = S[9];
  assign inst10__I1[8] = S[9];
  assign inst10__I1[9] = S[9];
  assign inst11__I1[0] = S[10];
  assign inst11__I1[1] = S[10];
  assign inst11__I1[10] = S[10];
  assign inst11__I1[11] = S[10];
  assign inst11__I1[2] = S[10];
  assign inst11__I1[3] = S[10];
  assign inst11__I1[4] = S[10];
  assign inst11__I1[5] = S[10];
  assign inst11__I1[6] = S[10];
  assign inst11__I1[7] = S[10];
  assign inst11__I1[8] = S[10];
  assign inst11__I1[9] = S[10];
  assign inst12__I1[0] = S[11];
  assign inst12__I1[1] = S[11];
  assign inst12__I1[10] = S[11];
  assign inst12__I1[11] = S[11];
  assign inst12__I1[2] = S[11];
  assign inst12__I1[3] = S[11];
  assign inst12__I1[4] = S[11];
  assign inst12__I1[5] = S[11];
  assign inst12__I1[6] = S[11];
  assign inst12__I1[7] = S[11];
  assign inst12__I1[8] = S[11];
  assign inst12__I1[9] = S[11];
  assign inst13__I1[0] = S[12];
  assign inst13__I1[1] = S[12];
  assign inst13__I1[10] = S[12];
  assign inst13__I1[11] = S[12];
  assign inst13__I1[2] = S[12];
  assign inst13__I1[3] = S[12];
  assign inst13__I1[4] = S[12];
  assign inst13__I1[5] = S[12];
  assign inst13__I1[6] = S[12];
  assign inst13__I1[7] = S[12];
  assign inst13__I1[8] = S[12];
  assign inst13__I1[9] = S[12];
  assign inst14__I1[0] = S[13];
  assign inst14__I1[1] = S[13];
  assign inst14__I1[10] = S[13];
  assign inst14__I1[11] = S[13];
  assign inst14__I1[2] = S[13];
  assign inst14__I1[3] = S[13];
  assign inst14__I1[4] = S[13];
  assign inst14__I1[5] = S[13];
  assign inst14__I1[6] = S[13];
  assign inst14__I1[7] = S[13];
  assign inst14__I1[8] = S[13];
  assign inst14__I1[9] = S[13];
  assign inst15__I1[0] = S[14];
  assign inst15__I1[1] = S[14];
  assign inst15__I1[10] = S[14];
  assign inst15__I1[11] = S[14];
  assign inst15__I1[2] = S[14];
  assign inst15__I1[3] = S[14];
  assign inst15__I1[4] = S[14];
  assign inst15__I1[5] = S[14];
  assign inst15__I1[6] = S[14];
  assign inst15__I1[7] = S[14];
  assign inst15__I1[8] = S[14];
  assign inst15__I1[9] = S[14];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[10] = S[1];
  assign inst2__I1[11] = S[1];
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];
  assign inst2__I1[4] = S[1];
  assign inst2__I1[5] = S[1];
  assign inst2__I1[6] = S[1];
  assign inst2__I1[7] = S[1];
  assign inst2__I1[8] = S[1];
  assign inst2__I1[9] = S[1];
  assign inst3__I1[0] = S[2];
  assign inst3__I1[1] = S[2];
  assign inst3__I1[10] = S[2];
  assign inst3__I1[11] = S[2];
  assign inst3__I1[2] = S[2];
  assign inst3__I1[3] = S[2];
  assign inst3__I1[4] = S[2];
  assign inst3__I1[5] = S[2];
  assign inst3__I1[6] = S[2];
  assign inst3__I1[7] = S[2];
  assign inst3__I1[8] = S[2];
  assign inst3__I1[9] = S[2];
  assign inst4__I1[0] = S[3];
  assign inst4__I1[1] = S[3];
  assign inst4__I1[10] = S[3];
  assign inst4__I1[11] = S[3];
  assign inst4__I1[2] = S[3];
  assign inst4__I1[3] = S[3];
  assign inst4__I1[4] = S[3];
  assign inst4__I1[5] = S[3];
  assign inst4__I1[6] = S[3];
  assign inst4__I1[7] = S[3];
  assign inst4__I1[8] = S[3];
  assign inst4__I1[9] = S[3];
  assign inst5__I1[0] = S[4];
  assign inst5__I1[1] = S[4];
  assign inst5__I1[10] = S[4];
  assign inst5__I1[11] = S[4];
  assign inst5__I1[2] = S[4];
  assign inst5__I1[3] = S[4];
  assign inst5__I1[4] = S[4];
  assign inst5__I1[5] = S[4];
  assign inst5__I1[6] = S[4];
  assign inst5__I1[7] = S[4];
  assign inst5__I1[8] = S[4];
  assign inst5__I1[9] = S[4];
  assign inst6__I1[0] = S[5];
  assign inst6__I1[1] = S[5];
  assign inst6__I1[10] = S[5];
  assign inst6__I1[11] = S[5];
  assign inst6__I1[2] = S[5];
  assign inst6__I1[3] = S[5];
  assign inst6__I1[4] = S[5];
  assign inst6__I1[5] = S[5];
  assign inst6__I1[6] = S[5];
  assign inst6__I1[7] = S[5];
  assign inst6__I1[8] = S[5];
  assign inst6__I1[9] = S[5];
  assign inst7__I1[0] = S[6];
  assign inst7__I1[1] = S[6];
  assign inst7__I1[10] = S[6];
  assign inst7__I1[11] = S[6];
  assign inst7__I1[2] = S[6];
  assign inst7__I1[3] = S[6];
  assign inst7__I1[4] = S[6];
  assign inst7__I1[5] = S[6];
  assign inst7__I1[6] = S[6];
  assign inst7__I1[7] = S[6];
  assign inst7__I1[8] = S[6];
  assign inst7__I1[9] = S[6];
  assign inst8__I1[0] = S[7];
  assign inst8__I1[1] = S[7];
  assign inst8__I1[10] = S[7];
  assign inst8__I1[11] = S[7];
  assign inst8__I1[2] = S[7];
  assign inst8__I1[3] = S[7];
  assign inst8__I1[4] = S[7];
  assign inst8__I1[5] = S[7];
  assign inst8__I1[6] = S[7];
  assign inst8__I1[7] = S[7];
  assign inst8__I1[8] = S[7];
  assign inst8__I1[9] = S[7];
  assign inst9__I1[0] = S[8];
  assign inst9__I1[1] = S[8];
  assign inst9__I1[10] = S[8];
  assign inst9__I1[11] = S[8];
  assign inst9__I1[2] = S[8];
  assign inst9__I1[3] = S[8];
  assign inst9__I1[4] = S[8];
  assign inst9__I1[5] = S[8];
  assign inst9__I1[6] = S[8];
  assign inst9__I1[7] = S[8];
  assign inst9__I1[8] = S[8];
  assign inst9__I1[9] = S[8];

endmodule //SilicaOneHotMux1512

module and8_wrapped (
  input [7:0] I0,
  input [7:0] I1,
  output [7:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [7:0] inst0__in0;
  wire [7:0] inst0__in1;
  wire [7:0] inst0__out;
  coreir_and #(.width(8)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[7:0] = I0[7:0];
  assign inst0__in1[7:0] = I1[7:0];
  assign O[7:0] = inst0__out[7:0];

endmodule //and8_wrapped

module SilicaOneHotMux158 (
  input [7:0] I0,
  input [7:0] I1,
  input [7:0] I10,
  input [7:0] I11,
  input [7:0] I12,
  input [7:0] I13,
  input [7:0] I14,
  input [7:0] I2,
  input [7:0] I3,
  input [7:0] I4,
  input [7:0] I5,
  input [7:0] I6,
  input [7:0] I7,
  input [7:0] I8,
  input [7:0] I9,
  output [7:0] O,
  input [14:0] S
);
  //Wire declarations for instance 'inst0' (Module Or15x8)
  wire [7:0] inst0__I0;
  wire [7:0] inst0__I1;
  wire [7:0] inst0__I10;
  wire [7:0] inst0__I11;
  wire [7:0] inst0__I12;
  wire [7:0] inst0__I13;
  wire [7:0] inst0__I14;
  wire [7:0] inst0__I2;
  wire [7:0] inst0__I3;
  wire [7:0] inst0__I4;
  wire [7:0] inst0__I5;
  wire [7:0] inst0__I6;
  wire [7:0] inst0__I7;
  wire [7:0] inst0__I8;
  wire [7:0] inst0__I9;
  wire [7:0] inst0__O;
  Or15x8 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I10(inst0__I10),
    .I11(inst0__I11),
    .I12(inst0__I12),
    .I13(inst0__I13),
    .I14(inst0__I14),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .I8(inst0__I8),
    .I9(inst0__I9),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and8_wrapped)
  wire [7:0] inst1__I0;
  wire [7:0] inst1__I1;
  wire [7:0] inst1__O;
  and8_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst10' (Module and8_wrapped)
  wire [7:0] inst10__I0;
  wire [7:0] inst10__I1;
  wire [7:0] inst10__O;
  and8_wrapped inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module and8_wrapped)
  wire [7:0] inst11__I0;
  wire [7:0] inst11__I1;
  wire [7:0] inst11__O;
  and8_wrapped inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .O(inst11__O)
  );

  //Wire declarations for instance 'inst12' (Module and8_wrapped)
  wire [7:0] inst12__I0;
  wire [7:0] inst12__I1;
  wire [7:0] inst12__O;
  and8_wrapped inst12(
    .I0(inst12__I0),
    .I1(inst12__I1),
    .O(inst12__O)
  );

  //Wire declarations for instance 'inst13' (Module and8_wrapped)
  wire [7:0] inst13__I0;
  wire [7:0] inst13__I1;
  wire [7:0] inst13__O;
  and8_wrapped inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module and8_wrapped)
  wire [7:0] inst14__I0;
  wire [7:0] inst14__I1;
  wire [7:0] inst14__O;
  and8_wrapped inst14(
    .I0(inst14__I0),
    .I1(inst14__I1),
    .O(inst14__O)
  );

  //Wire declarations for instance 'inst15' (Module and8_wrapped)
  wire [7:0] inst15__I0;
  wire [7:0] inst15__I1;
  wire [7:0] inst15__O;
  and8_wrapped inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .O(inst15__O)
  );

  //Wire declarations for instance 'inst2' (Module and8_wrapped)
  wire [7:0] inst2__I0;
  wire [7:0] inst2__I1;
  wire [7:0] inst2__O;
  and8_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and8_wrapped)
  wire [7:0] inst3__I0;
  wire [7:0] inst3__I1;
  wire [7:0] inst3__O;
  and8_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and8_wrapped)
  wire [7:0] inst4__I0;
  wire [7:0] inst4__I1;
  wire [7:0] inst4__O;
  and8_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and8_wrapped)
  wire [7:0] inst5__I0;
  wire [7:0] inst5__I1;
  wire [7:0] inst5__O;
  and8_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module and8_wrapped)
  wire [7:0] inst6__I0;
  wire [7:0] inst6__I1;
  wire [7:0] inst6__O;
  and8_wrapped inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .O(inst6__O)
  );

  //Wire declarations for instance 'inst7' (Module and8_wrapped)
  wire [7:0] inst7__I0;
  wire [7:0] inst7__I1;
  wire [7:0] inst7__O;
  and8_wrapped inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .O(inst7__O)
  );

  //Wire declarations for instance 'inst8' (Module and8_wrapped)
  wire [7:0] inst8__I0;
  wire [7:0] inst8__I1;
  wire [7:0] inst8__O;
  and8_wrapped inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .O(inst8__O)
  );

  //Wire declarations for instance 'inst9' (Module and8_wrapped)
  wire [7:0] inst9__I0;
  wire [7:0] inst9__I1;
  wire [7:0] inst9__O;
  and8_wrapped inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .O(inst9__O)
  );

  //All the connections
  assign inst0__I0[7:0] = inst1__O[7:0];
  assign inst0__I1[7:0] = inst2__O[7:0];
  assign inst0__I10[7:0] = inst11__O[7:0];
  assign inst0__I11[7:0] = inst12__O[7:0];
  assign inst0__I12[7:0] = inst13__O[7:0];
  assign inst0__I13[7:0] = inst14__O[7:0];
  assign inst0__I14[7:0] = inst15__O[7:0];
  assign inst0__I2[7:0] = inst3__O[7:0];
  assign inst0__I3[7:0] = inst4__O[7:0];
  assign inst0__I4[7:0] = inst5__O[7:0];
  assign inst0__I5[7:0] = inst6__O[7:0];
  assign inst0__I6[7:0] = inst7__O[7:0];
  assign inst0__I7[7:0] = inst8__O[7:0];
  assign inst0__I8[7:0] = inst9__O[7:0];
  assign inst0__I9[7:0] = inst10__O[7:0];
  assign O[7:0] = inst0__O[7:0];
  assign inst1__I0[7:0] = I0[7:0];
  assign inst10__I0[7:0] = I9[7:0];
  assign inst11__I0[7:0] = I10[7:0];
  assign inst12__I0[7:0] = I11[7:0];
  assign inst13__I0[7:0] = I12[7:0];
  assign inst14__I0[7:0] = I13[7:0];
  assign inst15__I0[7:0] = I14[7:0];
  assign inst2__I0[7:0] = I1[7:0];
  assign inst3__I0[7:0] = I2[7:0];
  assign inst4__I0[7:0] = I3[7:0];
  assign inst5__I0[7:0] = I4[7:0];
  assign inst6__I0[7:0] = I5[7:0];
  assign inst7__I0[7:0] = I6[7:0];
  assign inst8__I0[7:0] = I7[7:0];
  assign inst9__I0[7:0] = I8[7:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst1__I1[4] = S[0];
  assign inst1__I1[5] = S[0];
  assign inst1__I1[6] = S[0];
  assign inst1__I1[7] = S[0];
  assign inst10__I1[0] = S[9];
  assign inst10__I1[1] = S[9];
  assign inst10__I1[2] = S[9];
  assign inst10__I1[3] = S[9];
  assign inst10__I1[4] = S[9];
  assign inst10__I1[5] = S[9];
  assign inst10__I1[6] = S[9];
  assign inst10__I1[7] = S[9];
  assign inst11__I1[0] = S[10];
  assign inst11__I1[1] = S[10];
  assign inst11__I1[2] = S[10];
  assign inst11__I1[3] = S[10];
  assign inst11__I1[4] = S[10];
  assign inst11__I1[5] = S[10];
  assign inst11__I1[6] = S[10];
  assign inst11__I1[7] = S[10];
  assign inst12__I1[0] = S[11];
  assign inst12__I1[1] = S[11];
  assign inst12__I1[2] = S[11];
  assign inst12__I1[3] = S[11];
  assign inst12__I1[4] = S[11];
  assign inst12__I1[5] = S[11];
  assign inst12__I1[6] = S[11];
  assign inst12__I1[7] = S[11];
  assign inst13__I1[0] = S[12];
  assign inst13__I1[1] = S[12];
  assign inst13__I1[2] = S[12];
  assign inst13__I1[3] = S[12];
  assign inst13__I1[4] = S[12];
  assign inst13__I1[5] = S[12];
  assign inst13__I1[6] = S[12];
  assign inst13__I1[7] = S[12];
  assign inst14__I1[0] = S[13];
  assign inst14__I1[1] = S[13];
  assign inst14__I1[2] = S[13];
  assign inst14__I1[3] = S[13];
  assign inst14__I1[4] = S[13];
  assign inst14__I1[5] = S[13];
  assign inst14__I1[6] = S[13];
  assign inst14__I1[7] = S[13];
  assign inst15__I1[0] = S[14];
  assign inst15__I1[1] = S[14];
  assign inst15__I1[2] = S[14];
  assign inst15__I1[3] = S[14];
  assign inst15__I1[4] = S[14];
  assign inst15__I1[5] = S[14];
  assign inst15__I1[6] = S[14];
  assign inst15__I1[7] = S[14];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];
  assign inst2__I1[4] = S[1];
  assign inst2__I1[5] = S[1];
  assign inst2__I1[6] = S[1];
  assign inst2__I1[7] = S[1];
  assign inst3__I1[0] = S[2];
  assign inst3__I1[1] = S[2];
  assign inst3__I1[2] = S[2];
  assign inst3__I1[3] = S[2];
  assign inst3__I1[4] = S[2];
  assign inst3__I1[5] = S[2];
  assign inst3__I1[6] = S[2];
  assign inst3__I1[7] = S[2];
  assign inst4__I1[0] = S[3];
  assign inst4__I1[1] = S[3];
  assign inst4__I1[2] = S[3];
  assign inst4__I1[3] = S[3];
  assign inst4__I1[4] = S[3];
  assign inst4__I1[5] = S[3];
  assign inst4__I1[6] = S[3];
  assign inst4__I1[7] = S[3];
  assign inst5__I1[0] = S[4];
  assign inst5__I1[1] = S[4];
  assign inst5__I1[2] = S[4];
  assign inst5__I1[3] = S[4];
  assign inst5__I1[4] = S[4];
  assign inst5__I1[5] = S[4];
  assign inst5__I1[6] = S[4];
  assign inst5__I1[7] = S[4];
  assign inst6__I1[0] = S[5];
  assign inst6__I1[1] = S[5];
  assign inst6__I1[2] = S[5];
  assign inst6__I1[3] = S[5];
  assign inst6__I1[4] = S[5];
  assign inst6__I1[5] = S[5];
  assign inst6__I1[6] = S[5];
  assign inst6__I1[7] = S[5];
  assign inst7__I1[0] = S[6];
  assign inst7__I1[1] = S[6];
  assign inst7__I1[2] = S[6];
  assign inst7__I1[3] = S[6];
  assign inst7__I1[4] = S[6];
  assign inst7__I1[5] = S[6];
  assign inst7__I1[6] = S[6];
  assign inst7__I1[7] = S[6];
  assign inst8__I1[0] = S[7];
  assign inst8__I1[1] = S[7];
  assign inst8__I1[2] = S[7];
  assign inst8__I1[3] = S[7];
  assign inst8__I1[4] = S[7];
  assign inst8__I1[5] = S[7];
  assign inst8__I1[6] = S[7];
  assign inst8__I1[7] = S[7];
  assign inst9__I1[0] = S[8];
  assign inst9__I1[1] = S[8];
  assign inst9__I1[2] = S[8];
  assign inst9__I1[3] = S[8];
  assign inst9__I1[4] = S[8];
  assign inst9__I1[5] = S[8];
  assign inst9__I1[6] = S[8];
  assign inst9__I1[7] = S[8];

endmodule //SilicaOneHotMux158

module SilicaOneHotMux28 (
  input [7:0] I0,
  input [7:0] I1,
  output [7:0] O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module or8_wrapped)
  wire [7:0] inst0__I0;
  wire [7:0] inst0__I1;
  wire [7:0] inst0__O;
  or8_wrapped inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and8_wrapped)
  wire [7:0] inst1__I0;
  wire [7:0] inst1__I1;
  wire [7:0] inst1__O;
  and8_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and8_wrapped)
  wire [7:0] inst2__I0;
  wire [7:0] inst2__I1;
  wire [7:0] inst2__O;
  and8_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //All the connections
  assign inst0__I0[7:0] = inst1__O[7:0];
  assign inst0__I1[7:0] = inst2__O[7:0];
  assign O[7:0] = inst0__O[7:0];
  assign inst1__I0[7:0] = I0[7:0];
  assign inst2__I0[7:0] = I1[7:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst1__I1[4] = S[0];
  assign inst1__I1[5] = S[0];
  assign inst1__I1[6] = S[0];
  assign inst1__I1[7] = S[0];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];
  assign inst2__I1[4] = S[1];
  assign inst2__I1[5] = S[1];
  assign inst2__I1[6] = S[1];
  assign inst2__I1[7] = S[1];

endmodule //SilicaOneHotMux28

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

module SilicaOneHotMux15None (
  input  I0,
  input  I1,
  input  I10,
  input  I11,
  input  I12,
  input  I13,
  input  I14,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  input  I6,
  input  I7,
  input  I8,
  input  I9,
  output  O,
  input [14:0] S
);
  //Wire declarations for instance 'inst0' (Module Or15xNone)
  wire  inst0__I0;
  wire  inst0__I1;
  wire  inst0__I10;
  wire  inst0__I11;
  wire  inst0__I12;
  wire  inst0__I13;
  wire  inst0__I14;
  wire  inst0__I2;
  wire  inst0__I3;
  wire  inst0__I4;
  wire  inst0__I5;
  wire  inst0__I6;
  wire  inst0__I7;
  wire  inst0__I8;
  wire  inst0__I9;
  wire  inst0__O;
  Or15xNone inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I10(inst0__I10),
    .I11(inst0__I11),
    .I12(inst0__I12),
    .I13(inst0__I13),
    .I14(inst0__I14),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .I5(inst0__I5),
    .I6(inst0__I6),
    .I7(inst0__I7),
    .I8(inst0__I8),
    .I9(inst0__I9),
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

  //Wire declarations for instance 'inst10' (Module and_wrapped)
  wire  inst10__I0;
  wire  inst10__I1;
  wire  inst10__O;
  and_wrapped inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module and_wrapped)
  wire  inst11__I0;
  wire  inst11__I1;
  wire  inst11__O;
  and_wrapped inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .O(inst11__O)
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

  //Wire declarations for instance 'inst13' (Module and_wrapped)
  wire  inst13__I0;
  wire  inst13__I1;
  wire  inst13__O;
  and_wrapped inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module and_wrapped)
  wire  inst14__I0;
  wire  inst14__I1;
  wire  inst14__O;
  and_wrapped inst14(
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

  //Wire declarations for instance 'inst9' (Module and_wrapped)
  wire  inst9__I0;
  wire  inst9__I1;
  wire  inst9__O;
  and_wrapped inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .O(inst9__O)
  );

  //All the connections
  assign inst0__I0 = inst1__O;
  assign inst0__I1 = inst2__O;
  assign inst0__I10 = inst11__O;
  assign inst0__I11 = inst12__O;
  assign inst0__I12 = inst13__O;
  assign inst0__I13 = inst14__O;
  assign inst0__I14 = inst15__O;
  assign inst0__I2 = inst3__O;
  assign inst0__I3 = inst4__O;
  assign inst0__I4 = inst5__O;
  assign inst0__I5 = inst6__O;
  assign inst0__I6 = inst7__O;
  assign inst0__I7 = inst8__O;
  assign inst0__I8 = inst9__O;
  assign inst0__I9 = inst10__O;
  assign O = inst0__O;
  assign inst1__I0 = I0;
  assign inst1__I1 = S[0];
  assign inst10__I0 = I9;
  assign inst10__I1 = S[9];
  assign inst11__I0 = I10;
  assign inst11__I1 = S[10];
  assign inst12__I0 = I11;
  assign inst12__I1 = S[11];
  assign inst13__I0 = I12;
  assign inst13__I1 = S[12];
  assign inst14__I0 = I13;
  assign inst14__I1 = S[13];
  assign inst15__I0 = I14;
  assign inst15__I1 = S[14];
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
  assign inst9__I0 = I8;
  assign inst9__I1 = S[8];

endmodule //SilicaOneHotMux15None

module or_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_or)
  wire  inst0__in0;
  wire  inst0__in1;
  wire  inst0__out;
  corebit_or inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0 = I0;
  assign inst0__in1 = I1;
  assign O = inst0__out;

endmodule //or_wrapped

module SilicaOneHotMux2None (
  input  I0,
  input  I1,
  output  O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module or_wrapped)
  wire  inst0__I0;
  wire  inst0__I1;
  wire  inst0__O;
  or_wrapped inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
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

  //All the connections
  assign inst0__I0 = inst1__O;
  assign inst0__I1 = inst2__O;
  assign O = inst0__O;
  assign inst1__I0 = I0;
  assign inst1__I1 = S[0];
  assign inst2__I0 = I1;
  assign inst2__I1 = S[1];

endmodule //SilicaOneHotMux2None

module PISO (
  input  CLK,
  input  LOAD,
  output  O,
  input [7:0] PI,
  input  SI
);
  //Wire declarations for instance 'inst0' (Module __silica_BufferPISO)
  wire [1:0] inst0__I;
  wire [1:0] inst0__O;
  __silica_BufferPISO inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register8)
  wire  inst1__CLK;
  wire [7:0] inst1__I;
  wire [7:0] inst1__O;
  Register8 inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module SilicaOneHotMux28)
  wire [7:0] inst2__I0;
  wire [7:0] inst2__I1;
  wire [7:0] inst2__O;
  wire [1:0] inst2__S;
  SilicaOneHotMux28 inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O),
    .S(inst2__S)
  );

  //Wire declarations for instance 'inst3' (Module SilicaOneHotMux2None)
  wire  inst3__I0;
  wire  inst3__I1;
  wire  inst3__O;
  wire [1:0] inst3__S;
  SilicaOneHotMux2None inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O),
    .S(inst3__S)
  );

  //Wire declarations for instance 'inst4' (Module corebit_not)
  wire  inst4__in;
  wire  inst4__out;
  corebit_not inst4(
    .in(inst4__in),
    .out(inst4__out)
  );

  //All the connections
  assign inst2__S[1:0] = inst0__O[1:0];
  assign inst3__S[1:0] = inst0__O[1:0];
  assign inst1__CLK = CLK;
  assign inst1__I[7:0] = inst2__O[7:0];
  assign inst2__I0[7:0] = PI[7:0];
  assign inst3__I0 = inst1__O[7];
  assign inst3__I1 = inst1__O[7];
  assign O = inst3__O;
  assign inst4__in = LOAD;
  assign inst0__I[1] = inst4__out;
  assign inst0__I[0] = LOAD;
  assign inst2__I1[0] = SI;
  assign inst2__I1[1] = inst1__O[0];
  assign inst2__I1[2] = inst1__O[1];
  assign inst2__I1[3] = inst1__O[2];
  assign inst2__I1[4] = inst1__O[3];
  assign inst2__I1[5] = inst1__O[4];
  assign inst2__I1[6] = inst1__O[5];
  assign inst2__I1[7] = inst1__O[6];

endmodule //PISO

module UART_TX (
  input  CLK,
  output  O,
  input [7:0] message,
  input  valid
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

  //Wire declarations for instance 'inst0' (Module __silica_BufferUART_TX)
  wire [14:0] inst0__I;
  wire [14:0] inst0__O;
  __silica_BufferUART_TX inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register12_0001)
  wire  inst1__CLK;
  wire [11:0] inst1__I;
  wire [11:0] inst1__O;
  Register12_0001 inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst10' (Module and_wrapped)
  wire  inst10__I0;
  wire  inst10__I1;
  wire  inst10__O;
  and_wrapped inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module and_wrapped)
  wire  inst11__I0;
  wire  inst11__I1;
  wire  inst11__O;
  and_wrapped inst11(
    .I0(inst11__I0),
    .I1(inst11__I1),
    .O(inst11__O)
  );

  //Wire declarations for instance 'inst12' (Module corebit_not)
  wire  inst12__in;
  wire  inst12__out;
  corebit_not inst12(
    .in(inst12__in),
    .out(inst12__out)
  );

  //Wire declarations for instance 'inst13' (Module and_wrapped)
  wire  inst13__I0;
  wire  inst13__I1;
  wire  inst13__O;
  and_wrapped inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module and_wrapped)
  wire  inst14__I0;
  wire  inst14__I1;
  wire  inst14__O;
  and_wrapped inst14(
    .I0(inst14__I0),
    .I1(inst14__I1),
    .O(inst14__O)
  );

  //Wire declarations for instance 'inst15' (Module corebit_not)
  wire  inst15__in;
  wire  inst15__out;
  corebit_not inst15(
    .in(inst15__in),
    .out(inst15__out)
  );

  //Wire declarations for instance 'inst16' (Module and_wrapped)
  wire  inst16__I0;
  wire  inst16__I1;
  wire  inst16__O;
  and_wrapped inst16(
    .I0(inst16__I0),
    .I1(inst16__I1),
    .O(inst16__O)
  );

  //Wire declarations for instance 'inst2' (Module SilicaOneHotMux1512)
  wire [11:0] inst2__I0;
  wire [11:0] inst2__I1;
  wire [11:0] inst2__I10;
  wire [11:0] inst2__I11;
  wire [11:0] inst2__I12;
  wire [11:0] inst2__I13;
  wire [11:0] inst2__I14;
  wire [11:0] inst2__I2;
  wire [11:0] inst2__I3;
  wire [11:0] inst2__I4;
  wire [11:0] inst2__I5;
  wire [11:0] inst2__I6;
  wire [11:0] inst2__I7;
  wire [11:0] inst2__I8;
  wire [11:0] inst2__I9;
  wire [11:0] inst2__O;
  wire [14:0] inst2__S;
  SilicaOneHotMux1512 inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .I10(inst2__I10),
    .I11(inst2__I11),
    .I12(inst2__I12),
    .I13(inst2__I13),
    .I14(inst2__I14),
    .I2(inst2__I2),
    .I3(inst2__I3),
    .I4(inst2__I4),
    .I5(inst2__I5),
    .I6(inst2__I6),
    .I7(inst2__I7),
    .I8(inst2__I8),
    .I9(inst2__I9),
    .O(inst2__O),
    .S(inst2__S)
  );

  //Wire declarations for instance 'inst3' (Module PISO)
  wire  inst3__CLK;
  wire  inst3__LOAD;
  wire  inst3__O;
  wire [7:0] inst3__PI;
  wire  inst3__SI;
  PISO inst3(
    .CLK(inst3__CLK),
    .LOAD(inst3__LOAD),
    .O(inst3__O),
    .PI(inst3__PI),
    .SI(inst3__SI)
  );

  //Wire declarations for instance 'inst4' (Module SilicaOneHotMux15None)
  wire  inst4__I0;
  wire  inst4__I1;
  wire  inst4__I10;
  wire  inst4__I11;
  wire  inst4__I12;
  wire  inst4__I13;
  wire  inst4__I14;
  wire  inst4__I2;
  wire  inst4__I3;
  wire  inst4__I4;
  wire  inst4__I5;
  wire  inst4__I6;
  wire  inst4__I7;
  wire  inst4__I8;
  wire  inst4__I9;
  wire  inst4__O;
  wire [14:0] inst4__S;
  SilicaOneHotMux15None inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .I10(inst4__I10),
    .I11(inst4__I11),
    .I12(inst4__I12),
    .I13(inst4__I13),
    .I14(inst4__I14),
    .I2(inst4__I2),
    .I3(inst4__I3),
    .I4(inst4__I4),
    .I5(inst4__I5),
    .I6(inst4__I6),
    .I7(inst4__I7),
    .I8(inst4__I8),
    .I9(inst4__I9),
    .O(inst4__O),
    .S(inst4__S)
  );

  //Wire declarations for instance 'inst5' (Module SilicaOneHotMux158)
  wire [7:0] inst5__I0;
  wire [7:0] inst5__I1;
  wire [7:0] inst5__I10;
  wire [7:0] inst5__I11;
  wire [7:0] inst5__I12;
  wire [7:0] inst5__I13;
  wire [7:0] inst5__I14;
  wire [7:0] inst5__I2;
  wire [7:0] inst5__I3;
  wire [7:0] inst5__I4;
  wire [7:0] inst5__I5;
  wire [7:0] inst5__I6;
  wire [7:0] inst5__I7;
  wire [7:0] inst5__I8;
  wire [7:0] inst5__I9;
  wire [7:0] inst5__O;
  wire [14:0] inst5__S;
  SilicaOneHotMux158 inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .I10(inst5__I10),
    .I11(inst5__I11),
    .I12(inst5__I12),
    .I13(inst5__I13),
    .I14(inst5__I14),
    .I2(inst5__I2),
    .I3(inst5__I3),
    .I4(inst5__I4),
    .I5(inst5__I5),
    .I6(inst5__I6),
    .I7(inst5__I7),
    .I8(inst5__I8),
    .I9(inst5__I9),
    .O(inst5__O),
    .S(inst5__S)
  );

  //Wire declarations for instance 'inst6' (Module SilicaOneHotMux15None)
  wire  inst6__I0;
  wire  inst6__I1;
  wire  inst6__I10;
  wire  inst6__I11;
  wire  inst6__I12;
  wire  inst6__I13;
  wire  inst6__I14;
  wire  inst6__I2;
  wire  inst6__I3;
  wire  inst6__I4;
  wire  inst6__I5;
  wire  inst6__I6;
  wire  inst6__I7;
  wire  inst6__I8;
  wire  inst6__I9;
  wire  inst6__O;
  wire [14:0] inst6__S;
  SilicaOneHotMux15None inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .I10(inst6__I10),
    .I11(inst6__I11),
    .I12(inst6__I12),
    .I13(inst6__I13),
    .I14(inst6__I14),
    .I2(inst6__I2),
    .I3(inst6__I3),
    .I4(inst6__I4),
    .I5(inst6__I5),
    .I6(inst6__I6),
    .I7(inst6__I7),
    .I8(inst6__I8),
    .I9(inst6__I9),
    .O(inst6__O),
    .S(inst6__S)
  );

  //Wire declarations for instance 'inst7' (Module SilicaOneHotMux15None)
  wire  inst7__I0;
  wire  inst7__I1;
  wire  inst7__I10;
  wire  inst7__I11;
  wire  inst7__I12;
  wire  inst7__I13;
  wire  inst7__I14;
  wire  inst7__I2;
  wire  inst7__I3;
  wire  inst7__I4;
  wire  inst7__I5;
  wire  inst7__I6;
  wire  inst7__I7;
  wire  inst7__I8;
  wire  inst7__I9;
  wire  inst7__O;
  wire [14:0] inst7__S;
  SilicaOneHotMux15None inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .I10(inst7__I10),
    .I11(inst7__I11),
    .I12(inst7__I12),
    .I13(inst7__I13),
    .I14(inst7__I14),
    .I2(inst7__I2),
    .I3(inst7__I3),
    .I4(inst7__I4),
    .I5(inst7__I5),
    .I6(inst7__I6),
    .I7(inst7__I7),
    .I8(inst7__I8),
    .I9(inst7__I9),
    .O(inst7__O),
    .S(inst7__S)
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

  //Wire declarations for instance 'inst9' (Module corebit_not)
  wire  inst9__in;
  wire  inst9__out;
  corebit_not inst9(
    .in(inst9__in),
    .out(inst9__out)
  );

  //All the connections
  assign inst6__I10 = bit_const_GND__out;
  assign inst6__I2 = bit_const_GND__out;
  assign inst6__I3 = bit_const_GND__out;
  assign inst6__I4 = bit_const_GND__out;
  assign inst6__I5 = bit_const_GND__out;
  assign inst6__I6 = bit_const_GND__out;
  assign inst6__I7 = bit_const_GND__out;
  assign inst6__I8 = bit_const_GND__out;
  assign inst6__I9 = bit_const_GND__out;
  assign inst7__I0 = bit_const_GND__out;
  assign inst7__I11 = bit_const_GND__out;
  assign inst7__I13 = bit_const_GND__out;
  assign inst2__I0[0] = bit_const_GND__out;
  assign inst2__I0[10] = bit_const_GND__out;
  assign inst2__I0[11] = bit_const_GND__out;
  assign inst2__I0[2] = bit_const_GND__out;
  assign inst2__I0[3] = bit_const_GND__out;
  assign inst2__I0[4] = bit_const_GND__out;
  assign inst2__I0[5] = bit_const_GND__out;
  assign inst2__I0[6] = bit_const_GND__out;
  assign inst2__I0[7] = bit_const_GND__out;
  assign inst2__I0[8] = bit_const_GND__out;
  assign inst2__I0[9] = bit_const_GND__out;
  assign inst2__I1[0] = bit_const_GND__out;
  assign inst2__I1[1] = bit_const_GND__out;
  assign inst2__I1[10] = bit_const_GND__out;
  assign inst2__I1[2] = bit_const_GND__out;
  assign inst2__I1[3] = bit_const_GND__out;
  assign inst2__I1[4] = bit_const_GND__out;
  assign inst2__I1[5] = bit_const_GND__out;
  assign inst2__I1[6] = bit_const_GND__out;
  assign inst2__I1[7] = bit_const_GND__out;
  assign inst2__I1[8] = bit_const_GND__out;
  assign inst2__I1[9] = bit_const_GND__out;
  assign inst2__I10[0] = bit_const_GND__out;
  assign inst2__I10[1] = bit_const_GND__out;
  assign inst2__I10[11] = bit_const_GND__out;
  assign inst2__I10[2] = bit_const_GND__out;
  assign inst2__I10[3] = bit_const_GND__out;
  assign inst2__I10[4] = bit_const_GND__out;
  assign inst2__I10[5] = bit_const_GND__out;
  assign inst2__I10[6] = bit_const_GND__out;
  assign inst2__I10[7] = bit_const_GND__out;
  assign inst2__I10[8] = bit_const_GND__out;
  assign inst2__I10[9] = bit_const_GND__out;
  assign inst2__I11[0] = bit_const_GND__out;
  assign inst2__I11[10] = bit_const_GND__out;
  assign inst2__I11[11] = bit_const_GND__out;
  assign inst2__I11[2] = bit_const_GND__out;
  assign inst2__I11[3] = bit_const_GND__out;
  assign inst2__I11[4] = bit_const_GND__out;
  assign inst2__I11[5] = bit_const_GND__out;
  assign inst2__I11[6] = bit_const_GND__out;
  assign inst2__I11[7] = bit_const_GND__out;
  assign inst2__I11[8] = bit_const_GND__out;
  assign inst2__I11[9] = bit_const_GND__out;
  assign inst2__I12[0] = bit_const_GND__out;
  assign inst2__I12[1] = bit_const_GND__out;
  assign inst2__I12[10] = bit_const_GND__out;
  assign inst2__I12[2] = bit_const_GND__out;
  assign inst2__I12[3] = bit_const_GND__out;
  assign inst2__I12[4] = bit_const_GND__out;
  assign inst2__I12[5] = bit_const_GND__out;
  assign inst2__I12[6] = bit_const_GND__out;
  assign inst2__I12[7] = bit_const_GND__out;
  assign inst2__I12[8] = bit_const_GND__out;
  assign inst2__I12[9] = bit_const_GND__out;
  assign inst2__I13[0] = bit_const_GND__out;
  assign inst2__I13[10] = bit_const_GND__out;
  assign inst2__I13[11] = bit_const_GND__out;
  assign inst2__I13[2] = bit_const_GND__out;
  assign inst2__I13[3] = bit_const_GND__out;
  assign inst2__I13[4] = bit_const_GND__out;
  assign inst2__I13[5] = bit_const_GND__out;
  assign inst2__I13[6] = bit_const_GND__out;
  assign inst2__I13[7] = bit_const_GND__out;
  assign inst2__I13[8] = bit_const_GND__out;
  assign inst2__I13[9] = bit_const_GND__out;
  assign inst2__I14[0] = bit_const_GND__out;
  assign inst2__I14[1] = bit_const_GND__out;
  assign inst2__I14[10] = bit_const_GND__out;
  assign inst2__I14[2] = bit_const_GND__out;
  assign inst2__I14[3] = bit_const_GND__out;
  assign inst2__I14[4] = bit_const_GND__out;
  assign inst2__I14[5] = bit_const_GND__out;
  assign inst2__I14[6] = bit_const_GND__out;
  assign inst2__I14[7] = bit_const_GND__out;
  assign inst2__I14[8] = bit_const_GND__out;
  assign inst2__I14[9] = bit_const_GND__out;
  assign inst2__I2[0] = bit_const_GND__out;
  assign inst2__I2[1] = bit_const_GND__out;
  assign inst2__I2[10] = bit_const_GND__out;
  assign inst2__I2[11] = bit_const_GND__out;
  assign inst2__I2[3] = bit_const_GND__out;
  assign inst2__I2[4] = bit_const_GND__out;
  assign inst2__I2[5] = bit_const_GND__out;
  assign inst2__I2[6] = bit_const_GND__out;
  assign inst2__I2[7] = bit_const_GND__out;
  assign inst2__I2[8] = bit_const_GND__out;
  assign inst2__I2[9] = bit_const_GND__out;
  assign inst2__I3[0] = bit_const_GND__out;
  assign inst2__I3[1] = bit_const_GND__out;
  assign inst2__I3[10] = bit_const_GND__out;
  assign inst2__I3[11] = bit_const_GND__out;
  assign inst2__I3[2] = bit_const_GND__out;
  assign inst2__I3[4] = bit_const_GND__out;
  assign inst2__I3[5] = bit_const_GND__out;
  assign inst2__I3[6] = bit_const_GND__out;
  assign inst2__I3[7] = bit_const_GND__out;
  assign inst2__I3[8] = bit_const_GND__out;
  assign inst2__I3[9] = bit_const_GND__out;
  assign inst2__I4[0] = bit_const_GND__out;
  assign inst2__I4[1] = bit_const_GND__out;
  assign inst2__I4[10] = bit_const_GND__out;
  assign inst2__I4[11] = bit_const_GND__out;
  assign inst2__I4[2] = bit_const_GND__out;
  assign inst2__I4[3] = bit_const_GND__out;
  assign inst2__I4[5] = bit_const_GND__out;
  assign inst2__I4[6] = bit_const_GND__out;
  assign inst2__I4[7] = bit_const_GND__out;
  assign inst2__I4[8] = bit_const_GND__out;
  assign inst2__I4[9] = bit_const_GND__out;
  assign inst2__I5[0] = bit_const_GND__out;
  assign inst2__I5[1] = bit_const_GND__out;
  assign inst2__I5[10] = bit_const_GND__out;
  assign inst2__I5[11] = bit_const_GND__out;
  assign inst2__I5[2] = bit_const_GND__out;
  assign inst2__I5[3] = bit_const_GND__out;
  assign inst2__I5[4] = bit_const_GND__out;
  assign inst2__I5[6] = bit_const_GND__out;
  assign inst2__I5[7] = bit_const_GND__out;
  assign inst2__I5[8] = bit_const_GND__out;
  assign inst2__I5[9] = bit_const_GND__out;
  assign inst2__I6[0] = bit_const_GND__out;
  assign inst2__I6[1] = bit_const_GND__out;
  assign inst2__I6[10] = bit_const_GND__out;
  assign inst2__I6[11] = bit_const_GND__out;
  assign inst2__I6[2] = bit_const_GND__out;
  assign inst2__I6[3] = bit_const_GND__out;
  assign inst2__I6[4] = bit_const_GND__out;
  assign inst2__I6[5] = bit_const_GND__out;
  assign inst2__I6[7] = bit_const_GND__out;
  assign inst2__I6[8] = bit_const_GND__out;
  assign inst2__I6[9] = bit_const_GND__out;
  assign inst2__I7[0] = bit_const_GND__out;
  assign inst2__I7[1] = bit_const_GND__out;
  assign inst2__I7[10] = bit_const_GND__out;
  assign inst2__I7[11] = bit_const_GND__out;
  assign inst2__I7[2] = bit_const_GND__out;
  assign inst2__I7[3] = bit_const_GND__out;
  assign inst2__I7[4] = bit_const_GND__out;
  assign inst2__I7[5] = bit_const_GND__out;
  assign inst2__I7[6] = bit_const_GND__out;
  assign inst2__I7[8] = bit_const_GND__out;
  assign inst2__I7[9] = bit_const_GND__out;
  assign inst2__I8[0] = bit_const_GND__out;
  assign inst2__I8[1] = bit_const_GND__out;
  assign inst2__I8[10] = bit_const_GND__out;
  assign inst2__I8[11] = bit_const_GND__out;
  assign inst2__I8[2] = bit_const_GND__out;
  assign inst2__I8[3] = bit_const_GND__out;
  assign inst2__I8[4] = bit_const_GND__out;
  assign inst2__I8[5] = bit_const_GND__out;
  assign inst2__I8[6] = bit_const_GND__out;
  assign inst2__I8[7] = bit_const_GND__out;
  assign inst2__I8[9] = bit_const_GND__out;
  assign inst2__I9[0] = bit_const_GND__out;
  assign inst2__I9[1] = bit_const_GND__out;
  assign inst2__I9[10] = bit_const_GND__out;
  assign inst2__I9[11] = bit_const_GND__out;
  assign inst2__I9[2] = bit_const_GND__out;
  assign inst2__I9[3] = bit_const_GND__out;
  assign inst2__I9[4] = bit_const_GND__out;
  assign inst2__I9[5] = bit_const_GND__out;
  assign inst2__I9[6] = bit_const_GND__out;
  assign inst2__I9[7] = bit_const_GND__out;
  assign inst2__I9[8] = bit_const_GND__out;
  assign inst4__I0 = bit_const_VCC__out;
  assign inst4__I1 = bit_const_VCC__out;
  assign inst4__I10 = bit_const_VCC__out;
  assign inst4__I11 = bit_const_VCC__out;
  assign inst4__I12 = bit_const_VCC__out;
  assign inst4__I13 = bit_const_VCC__out;
  assign inst4__I14 = bit_const_VCC__out;
  assign inst4__I2 = bit_const_VCC__out;
  assign inst4__I3 = bit_const_VCC__out;
  assign inst4__I4 = bit_const_VCC__out;
  assign inst4__I5 = bit_const_VCC__out;
  assign inst4__I6 = bit_const_VCC__out;
  assign inst4__I7 = bit_const_VCC__out;
  assign inst4__I8 = bit_const_VCC__out;
  assign inst4__I9 = bit_const_VCC__out;
  assign inst2__I0[1] = bit_const_VCC__out;
  assign inst2__I1[11] = bit_const_VCC__out;
  assign inst2__I10[10] = bit_const_VCC__out;
  assign inst2__I11[1] = bit_const_VCC__out;
  assign inst2__I12[11] = bit_const_VCC__out;
  assign inst2__I13[1] = bit_const_VCC__out;
  assign inst2__I14[11] = bit_const_VCC__out;
  assign inst2__I2[2] = bit_const_VCC__out;
  assign inst2__I3[3] = bit_const_VCC__out;
  assign inst2__I4[4] = bit_const_VCC__out;
  assign inst2__I5[5] = bit_const_VCC__out;
  assign inst2__I6[6] = bit_const_VCC__out;
  assign inst2__I7[7] = bit_const_VCC__out;
  assign inst2__I8[8] = bit_const_VCC__out;
  assign inst2__I9[9] = bit_const_VCC__out;
  assign inst2__S[14:0] = inst0__O[14:0];
  assign inst4__S[14:0] = inst0__O[14:0];
  assign inst5__S[14:0] = inst0__O[14:0];
  assign inst6__S[14:0] = inst0__O[14:0];
  assign inst7__S[14:0] = inst0__O[14:0];
  assign inst1__CLK = CLK;
  assign inst1__I[11:0] = inst2__O[11:0];
  assign inst10__I0 = inst1__O[0];
  assign inst10__I1 = inst9__out;
  assign inst0__I[1] = inst10__O;
  assign inst11__I0 = inst1__O[10];
  assign inst11__I1 = valid;
  assign inst0__I[11] = inst11__O;
  assign inst12__in = valid;
  assign inst13__I1 = inst12__out;
  assign inst13__I0 = inst1__O[10];
  assign inst0__I[12] = inst13__O;
  assign inst14__I0 = inst1__O[11];
  assign inst14__I1 = valid;
  assign inst0__I[13] = inst14__O;
  assign inst15__in = valid;
  assign inst16__I1 = inst15__out;
  assign inst16__I0 = inst1__O[11];
  assign inst0__I[14] = inst16__O;
  assign inst3__CLK = CLK;
  assign inst3__LOAD = inst6__O;
  assign inst7__I1 = inst3__O;
  assign inst7__I10 = inst3__O;
  assign inst7__I12 = inst3__O;
  assign inst7__I14 = inst3__O;
  assign inst7__I2 = inst3__O;
  assign inst7__I3 = inst3__O;
  assign inst7__I4 = inst3__O;
  assign inst7__I5 = inst3__O;
  assign inst7__I6 = inst3__O;
  assign inst7__I7 = inst3__O;
  assign inst7__I8 = inst3__O;
  assign inst7__I9 = inst3__O;
  assign inst3__PI[7:0] = inst5__O[7:0];
  assign inst3__SI = inst4__O;
  assign inst5__I0[7:0] = message[7:0];
  assign inst5__I1[7:0] = message[7:0];
  assign inst5__I10[7:0] = message[7:0];
  assign inst5__I11[7:0] = message[7:0];
  assign inst5__I12[7:0] = message[7:0];
  assign inst5__I13[7:0] = message[7:0];
  assign inst5__I14[7:0] = message[7:0];
  assign inst5__I2[7:0] = message[7:0];
  assign inst5__I3[7:0] = message[7:0];
  assign inst5__I4[7:0] = message[7:0];
  assign inst5__I5[7:0] = message[7:0];
  assign inst5__I6[7:0] = message[7:0];
  assign inst5__I7[7:0] = message[7:0];
  assign inst5__I8[7:0] = message[7:0];
  assign inst5__I9[7:0] = message[7:0];
  assign inst6__I0 = valid;
  assign inst6__I1 = valid;
  assign inst6__I11 = valid;
  assign inst6__I12 = valid;
  assign inst6__I13 = valid;
  assign inst6__I14 = valid;
  assign O = inst7__O;
  assign inst8__I0 = inst1__O[0];
  assign inst8__I1 = valid;
  assign inst0__I[0] = inst8__O;
  assign inst9__in = valid;
  assign inst0__I[10] = inst1__O[9];
  assign inst0__I[2] = inst1__O[1];
  assign inst0__I[3] = inst1__O[2];
  assign inst0__I[4] = inst1__O[3];
  assign inst0__I[5] = inst1__O[4];
  assign inst0__I[6] = inst1__O[5];
  assign inst0__I[7] = inst1__O[6];
  assign inst0__I[8] = inst1__O[7];
  assign inst0__I[9] = inst1__O[8];

endmodule //UART_TX
