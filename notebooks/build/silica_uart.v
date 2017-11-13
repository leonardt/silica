

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

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

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

module Or11x8 (
  input [7:0] I0,
  input [7:0] I1,
  input [7:0] I10,
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
  wire [10:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(11)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [10:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(11)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [10:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(11)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [10:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(11)) inst3(
    .in(inst3__in),
    .out(inst3__out)
  );

  //Wire declarations for instance 'inst4' (Module coreir_orr)
  wire [10:0] inst4__in;
  wire  inst4__out;
  coreir_orr #(.width(11)) inst4(
    .in(inst4__in),
    .out(inst4__out)
  );

  //Wire declarations for instance 'inst5' (Module coreir_orr)
  wire [10:0] inst5__in;
  wire  inst5__out;
  coreir_orr #(.width(11)) inst5(
    .in(inst5__in),
    .out(inst5__out)
  );

  //Wire declarations for instance 'inst6' (Module coreir_orr)
  wire [10:0] inst6__in;
  wire  inst6__out;
  coreir_orr #(.width(11)) inst6(
    .in(inst6__in),
    .out(inst6__out)
  );

  //Wire declarations for instance 'inst7' (Module coreir_orr)
  wire [10:0] inst7__in;
  wire  inst7__out;
  coreir_orr #(.width(11)) inst7(
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
  assign inst7__in[2] = I2[7];
  assign inst7__in[3] = I3[7];
  assign inst7__in[4] = I4[7];
  assign inst7__in[5] = I5[7];
  assign inst7__in[6] = I6[7];
  assign inst7__in[7] = I7[7];
  assign inst7__in[8] = I8[7];
  assign inst7__in[9] = I9[7];

endmodule //Or11x8

module Or11xNone (
  input  I0,
  input  I1,
  input  I10,
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
  wire [10:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(11)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //All the connections
  assign O = inst0__out;
  assign inst0__in[0] = I0;
  assign inst0__in[1] = I1;
  assign inst0__in[10] = I10;
  assign inst0__in[2] = I2;
  assign inst0__in[3] = I3;
  assign inst0__in[4] = I4;
  assign inst0__in[5] = I5;
  assign inst0__in[6] = I6;
  assign inst0__in[7] = I7;
  assign inst0__in[8] = I8;
  assign inst0__in[9] = I9;

endmodule //Or11xNone

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

module SilicaOneHotMux118 (
  input [7:0] I0,
  input [7:0] I1,
  input [7:0] I10,
  input [7:0] I2,
  input [7:0] I3,
  input [7:0] I4,
  input [7:0] I5,
  input [7:0] I6,
  input [7:0] I7,
  input [7:0] I8,
  input [7:0] I9,
  output [7:0] O,
  input [10:0] S
);
  //Wire declarations for instance 'inst0' (Module Or11x8)
  wire [7:0] inst0__I0;
  wire [7:0] inst0__I1;
  wire [7:0] inst0__I10;
  wire [7:0] inst0__I2;
  wire [7:0] inst0__I3;
  wire [7:0] inst0__I4;
  wire [7:0] inst0__I5;
  wire [7:0] inst0__I6;
  wire [7:0] inst0__I7;
  wire [7:0] inst0__I8;
  wire [7:0] inst0__I9;
  wire [7:0] inst0__O;
  Or11x8 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I10(inst0__I10),
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

endmodule //SilicaOneHotMux118

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

module __silica_BufferPISO (
  input [1:0] I,
  output [1:0] O
);
  //All the connections
  assign O[1:0] = I[1:0];

endmodule //__silica_BufferPISO

module __silica_BufferUART_TX (
  input [10:0] I,
  output [10:0] O
);
  //All the connections
  assign O[10:0] = I[10:0];

endmodule //__silica_BufferUART_TX

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

module SilicaOneHotMux11None (
  input  I0,
  input  I1,
  input  I10,
  input  I2,
  input  I3,
  input  I4,
  input  I5,
  input  I6,
  input  I7,
  input  I8,
  input  I9,
  output  O,
  input [10:0] S
);
  //Wire declarations for instance 'inst0' (Module Or11xNone)
  wire  inst0__I0;
  wire  inst0__I1;
  wire  inst0__I10;
  wire  inst0__I2;
  wire  inst0__I3;
  wire  inst0__I4;
  wire  inst0__I5;
  wire  inst0__I6;
  wire  inst0__I7;
  wire  inst0__I8;
  wire  inst0__I9;
  wire  inst0__O;
  Or11xNone inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I10(inst0__I10),
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

endmodule //SilicaOneHotMux11None

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

module Register11_0001 (
  input  CLK,
  input [10:0] I,
  output [10:0] O
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

endmodule //Register11_0001

module UART_TX (
  input  CLK,
  output  O,
  input [7:0] message
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
  wire [10:0] inst0__I;
  wire [10:0] inst0__O;
  __silica_BufferUART_TX inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register11_0001)
  wire  inst1__CLK;
  wire [10:0] inst1__I;
  wire [10:0] inst1__O;
  Register11_0001 inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module or_wrapped)
  wire  inst2__I0;
  wire  inst2__I1;
  wire  inst2__O;
  or_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
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

  //Wire declarations for instance 'inst4' (Module SilicaOneHotMux118)
  wire [7:0] inst4__I0;
  wire [7:0] inst4__I1;
  wire [7:0] inst4__I10;
  wire [7:0] inst4__I2;
  wire [7:0] inst4__I3;
  wire [7:0] inst4__I4;
  wire [7:0] inst4__I5;
  wire [7:0] inst4__I6;
  wire [7:0] inst4__I7;
  wire [7:0] inst4__I8;
  wire [7:0] inst4__I9;
  wire [7:0] inst4__O;
  wire [10:0] inst4__S;
  SilicaOneHotMux118 inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .I10(inst4__I10),
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

  //Wire declarations for instance 'inst5' (Module SilicaOneHotMux11None)
  wire  inst5__I0;
  wire  inst5__I1;
  wire  inst5__I10;
  wire  inst5__I2;
  wire  inst5__I3;
  wire  inst5__I4;
  wire  inst5__I5;
  wire  inst5__I6;
  wire  inst5__I7;
  wire  inst5__I8;
  wire  inst5__I9;
  wire  inst5__O;
  wire [10:0] inst5__S;
  SilicaOneHotMux11None inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .I10(inst5__I10),
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

  //Wire declarations for instance 'inst6' (Module SilicaOneHotMux11None)
  wire  inst6__I0;
  wire  inst6__I1;
  wire  inst6__I10;
  wire  inst6__I2;
  wire  inst6__I3;
  wire  inst6__I4;
  wire  inst6__I5;
  wire  inst6__I6;
  wire  inst6__I7;
  wire  inst6__I8;
  wire  inst6__I9;
  wire  inst6__O;
  wire [10:0] inst6__S;
  SilicaOneHotMux11None inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .I10(inst6__I10),
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

  //Wire declarations for instance 'inst7' (Module SilicaOneHotMux11None)
  wire  inst7__I0;
  wire  inst7__I1;
  wire  inst7__I10;
  wire  inst7__I2;
  wire  inst7__I3;
  wire  inst7__I4;
  wire  inst7__I5;
  wire  inst7__I6;
  wire  inst7__I7;
  wire  inst7__I8;
  wire  inst7__I9;
  wire  inst7__O;
  wire [10:0] inst7__S;
  SilicaOneHotMux11None inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .I10(inst7__I10),
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

  //All the connections
  assign inst6__I1 = bit_const_GND__out;
  assign inst6__I2 = bit_const_GND__out;
  assign inst6__I3 = bit_const_GND__out;
  assign inst6__I4 = bit_const_GND__out;
  assign inst6__I5 = bit_const_GND__out;
  assign inst6__I6 = bit_const_GND__out;
  assign inst6__I7 = bit_const_GND__out;
  assign inst6__I8 = bit_const_GND__out;
  assign inst6__I9 = bit_const_GND__out;
  assign inst7__I0 = bit_const_GND__out;
  assign inst7__I10 = bit_const_GND__out;
  assign inst1__I[0] = bit_const_GND__out;
  assign inst5__I0 = bit_const_VCC__out;
  assign inst5__I1 = bit_const_VCC__out;
  assign inst5__I10 = bit_const_VCC__out;
  assign inst5__I2 = bit_const_VCC__out;
  assign inst5__I3 = bit_const_VCC__out;
  assign inst5__I4 = bit_const_VCC__out;
  assign inst5__I5 = bit_const_VCC__out;
  assign inst5__I6 = bit_const_VCC__out;
  assign inst5__I7 = bit_const_VCC__out;
  assign inst5__I8 = bit_const_VCC__out;
  assign inst5__I9 = bit_const_VCC__out;
  assign inst6__I0 = bit_const_VCC__out;
  assign inst6__I10 = bit_const_VCC__out;
  assign inst0__I[10:0] = inst1__O[10:0];
  assign inst4__S[10:0] = inst0__O[10:0];
  assign inst5__S[10:0] = inst0__O[10:0];
  assign inst6__S[10:0] = inst0__O[10:0];
  assign inst7__S[10:0] = inst0__O[10:0];
  assign inst1__CLK = CLK;
  assign inst2__I0 = inst1__O[0];
  assign inst2__I1 = inst1__O[10];
  assign inst1__I[1] = inst2__O;
  assign inst3__CLK = CLK;
  assign inst3__LOAD = inst6__O;
  assign inst7__I1 = inst3__O;
  assign inst7__I2 = inst3__O;
  assign inst7__I3 = inst3__O;
  assign inst7__I4 = inst3__O;
  assign inst7__I5 = inst3__O;
  assign inst7__I6 = inst3__O;
  assign inst7__I7 = inst3__O;
  assign inst7__I8 = inst3__O;
  assign inst7__I9 = inst3__O;
  assign inst3__PI[7:0] = inst4__O[7:0];
  assign inst3__SI = inst5__O;
  assign inst4__I0[7:0] = message[7:0];
  assign inst4__I1[7:0] = message[7:0];
  assign inst4__I10[7:0] = message[7:0];
  assign inst4__I2[7:0] = message[7:0];
  assign inst4__I3[7:0] = message[7:0];
  assign inst4__I4[7:0] = message[7:0];
  assign inst4__I5[7:0] = message[7:0];
  assign inst4__I6[7:0] = message[7:0];
  assign inst4__I7[7:0] = message[7:0];
  assign inst4__I8[7:0] = message[7:0];
  assign inst4__I9[7:0] = message[7:0];
  assign O = inst7__O;
  assign inst1__I[10] = inst1__O[9];
  assign inst1__I[2] = inst1__O[1];
  assign inst1__I[3] = inst1__O[2];
  assign inst1__I[4] = inst1__O[3];
  assign inst1__I[5] = inst1__O[4];
  assign inst1__I[6] = inst1__O[5];
  assign inst1__I[7] = inst1__O[6];
  assign inst1__I[8] = inst1__O[7];
  assign inst1__I[9] = inst1__O[8];

endmodule //UART_TX
