

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

module coreir_andr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = &in;

endmodule //coreir_andr

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

module coreir_eq #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output out
);
  assign out = in0 == in1;

endmodule //coreir_eq

module mem #(parameter depth=1, parameter width=1) (
  input clk,
  input [width-1:0] wdata,
  input [$clog2(depth)-1:0] waddr,
  input wen,
  output [width-1:0] rdata,
  input [$clog2(depth)-1:0] raddr
);
reg [width-1:0] data[depth];
always @(posedge clk) begin
  if (wen) begin
    data[waddr] <= wdata;
  end
end
assign rdata = data[raddr];

endmodule //mem

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

module coreir_orr #(parameter width=1) (
  input [width-1:0] in,
  output out
);
  assign out = |in;

endmodule //coreir_orr

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

module __silica_BufferFifo (
  input [7:0] I,
  output [7:0] O
);
  //All the connections
  assign O[7:0] = I[7:0];

endmodule //__silica_BufferFifo

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

  //Wire declarations for instance 'inst10' (Module EQ2)
  wire [1:0] inst10__I0;
  wire [1:0] inst10__I1;
  wire  inst10__O;
  EQ2 inst10(
    .I0(inst10__I0),
    .I1(inst10__I1),
    .O(inst10__O)
  );

  //Wire declarations for instance 'inst11' (Module corebit_not)
  wire  inst11__in;
  wire  inst11__out;
  corebit_not inst11(
    .in(inst11__in),
    .out(inst11__out)
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

  //Wire declarations for instance 'inst13' (Module Add2)
  wire [1:0] inst13__I0;
  wire [1:0] inst13__I1;
  wire [1:0] inst13__O;
  Add2 inst13(
    .I0(inst13__I0),
    .I1(inst13__I1),
    .O(inst13__O)
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

  //Wire declarations for instance 'inst15' (Module And3xNone)
  wire  inst15__I0;
  wire  inst15__I1;
  wire  inst15__I2;
  wire  inst15__O;
  And3xNone inst15(
    .I0(inst15__I0),
    .I1(inst15__I1),
    .I2(inst15__I2),
    .O(inst15__O)
  );

  //Wire declarations for instance 'inst16' (Module corebit_not)
  wire  inst16__in;
  wire  inst16__out;
  corebit_not inst16(
    .in(inst16__in),
    .out(inst16__out)
  );

  //Wire declarations for instance 'inst17' (Module and_wrapped)
  wire  inst17__I0;
  wire  inst17__I1;
  wire  inst17__O;
  and_wrapped inst17(
    .I0(inst17__I0),
    .I1(inst17__I1),
    .O(inst17__O)
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

  //Wire declarations for instance 'inst2' (Module Register2)
  wire  inst2__CLK;
  wire [1:0] inst2__I;
  wire [1:0] inst2__O;
  Register2 inst2(
    .CLK(inst2__CLK),
    .I(inst2__I),
    .O(inst2__O)
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

  //Wire declarations for instance 'inst22' (Module corebit_not)
  wire  inst22__in;
  wire  inst22__out;
  corebit_not inst22(
    .in(inst22__in),
    .out(inst22__out)
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

  //Wire declarations for instance 'inst25' (Module and_wrapped)
  wire  inst25__I0;
  wire  inst25__I1;
  wire  inst25__O;
  and_wrapped inst25(
    .I0(inst25__I0),
    .I1(inst25__I1),
    .O(inst25__O)
  );

  //Wire declarations for instance 'inst26' (Module corebit_not)
  wire  inst26__in;
  wire  inst26__out;
  corebit_not inst26(
    .in(inst26__in),
    .out(inst26__out)
  );

  //Wire declarations for instance 'inst27' (Module corebit_not)
  wire  inst27__in;
  wire  inst27__out;
  corebit_not inst27(
    .in(inst27__in),
    .out(inst27__out)
  );

  //Wire declarations for instance 'inst28' (Module and_wrapped)
  wire  inst28__I0;
  wire  inst28__I1;
  wire  inst28__O;
  and_wrapped inst28(
    .I0(inst28__I0),
    .I1(inst28__I1),
    .O(inst28__O)
  );

  //Wire declarations for instance 'inst29' (Module Add2)
  wire [1:0] inst29__I0;
  wire [1:0] inst29__I1;
  wire [1:0] inst29__O;
  Add2 inst29(
    .I0(inst29__I0),
    .I1(inst29__I1),
    .O(inst29__O)
  );

  //Wire declarations for instance 'inst30' (Module EQ2)
  wire [1:0] inst30__I0;
  wire [1:0] inst30__I1;
  wire  inst30__O;
  EQ2 inst30(
    .I0(inst30__I0),
    .I1(inst30__I1),
    .O(inst30__O)
  );

  //Wire declarations for instance 'inst31' (Module And3xNone)
  wire  inst31__I0;
  wire  inst31__I1;
  wire  inst31__I2;
  wire  inst31__O;
  And3xNone inst31(
    .I0(inst31__I0),
    .I1(inst31__I1),
    .I2(inst31__I2),
    .O(inst31__O)
  );

  //Wire declarations for instance 'inst32' (Module corebit_not)
  wire  inst32__in;
  wire  inst32__out;
  corebit_not inst32(
    .in(inst32__in),
    .out(inst32__out)
  );

  //Wire declarations for instance 'inst33' (Module and_wrapped)
  wire  inst33__I0;
  wire  inst33__I1;
  wire  inst33__O;
  and_wrapped inst33(
    .I0(inst33__I0),
    .I1(inst33__I1),
    .O(inst33__O)
  );

  //Wire declarations for instance 'inst34' (Module corebit_not)
  wire  inst34__in;
  wire  inst34__out;
  corebit_not inst34(
    .in(inst34__in),
    .out(inst34__out)
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

  //Wire declarations for instance 'inst39' (Module corebit_not)
  wire  inst39__in;
  wire  inst39__out;
  corebit_not inst39(
    .in(inst39__in),
    .out(inst39__out)
  );

  //Wire declarations for instance 'inst4' (Module Register2)
  wire  inst4__CLK;
  wire [1:0] inst4__I;
  wire [1:0] inst4__O;
  Register2 inst4(
    .CLK(inst4__CLK),
    .I(inst4__I),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst40' (Module and_wrapped)
  wire  inst40__I0;
  wire  inst40__I1;
  wire  inst40__O;
  and_wrapped inst40(
    .I0(inst40__I0),
    .I1(inst40__I1),
    .O(inst40__O)
  );

  //Wire declarations for instance 'inst41' (Module Add2)
  wire [1:0] inst41__I0;
  wire [1:0] inst41__I1;
  wire [1:0] inst41__O;
  Add2 inst41(
    .I0(inst41__I0),
    .I1(inst41__I1),
    .O(inst41__O)
  );

  //Wire declarations for instance 'inst42' (Module EQ2)
  wire [1:0] inst42__I0;
  wire [1:0] inst42__I1;
  wire  inst42__O;
  EQ2 inst42(
    .I0(inst42__I0),
    .I1(inst42__I1),
    .O(inst42__O)
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

  //Wire declarations for instance 'inst48' (Module corebit_not)
  wire  inst48__in;
  wire  inst48__out;
  corebit_not inst48(
    .in(inst48__in),
    .out(inst48__out)
  );

  //Wire declarations for instance 'inst49' (Module and_wrapped)
  wire  inst49__I0;
  wire  inst49__I1;
  wire  inst49__O;
  and_wrapped inst49(
    .I0(inst49__I0),
    .I1(inst49__I1),
    .O(inst49__O)
  );

  //Wire declarations for instance 'inst5' (Module mem)
  wire  inst5__clk;
  wire [1:0] inst5__raddr;
  wire [3:0] inst5__rdata;
  wire [1:0] inst5__waddr;
  wire [3:0] inst5__wdata;
  wire  inst5__wen;
  mem #(.depth(4),.width(4)) inst5(
    .clk(inst5__clk),
    .raddr(inst5__raddr),
    .rdata(inst5__rdata),
    .waddr(inst5__waddr),
    .wdata(inst5__wdata),
    .wen(inst5__wen)
  );

  //Wire declarations for instance 'inst50' (Module Add2)
  wire [1:0] inst50__I0;
  wire [1:0] inst50__I1;
  wire [1:0] inst50__O;
  Add2 inst50(
    .I0(inst50__I0),
    .I1(inst50__I1),
    .O(inst50__O)
  );

  //Wire declarations for instance 'inst51' (Module EQ2)
  wire [1:0] inst51__I0;
  wire [1:0] inst51__I1;
  wire  inst51__O;
  EQ2 inst51(
    .I0(inst51__I0),
    .I1(inst51__I1),
    .O(inst51__O)
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

  //Wire declarations for instance 'inst56' (Module corebit_not)
  wire  inst56__in;
  wire  inst56__out;
  corebit_not inst56(
    .in(inst56__in),
    .out(inst56__out)
  );

  //Wire declarations for instance 'inst57' (Module and_wrapped)
  wire  inst57__I0;
  wire  inst57__I1;
  wire  inst57__O;
  and_wrapped inst57(
    .I0(inst57__I0),
    .I1(inst57__I1),
    .O(inst57__O)
  );

  //Wire declarations for instance 'inst58' (Module corebit_not)
  wire  inst58__in;
  wire  inst58__out;
  corebit_not inst58(
    .in(inst58__in),
    .out(inst58__out)
  );

  //Wire declarations for instance 'inst59' (Module corebit_not)
  wire  inst59__in;
  wire  inst59__out;
  corebit_not inst59(
    .in(inst59__in),
    .out(inst59__out)
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

  //Wire declarations for instance 'inst61' (Module Add2)
  wire [1:0] inst61__I0;
  wire [1:0] inst61__I1;
  wire [1:0] inst61__O;
  Add2 inst61(
    .I0(inst61__I0),
    .I1(inst61__I1),
    .O(inst61__O)
  );

  //Wire declarations for instance 'inst62' (Module EQ2)
  wire [1:0] inst62__I0;
  wire [1:0] inst62__I1;
  wire  inst62__O;
  EQ2 inst62(
    .I0(inst62__I0),
    .I1(inst62__I1),
    .O(inst62__O)
  );

  //Wire declarations for instance 'inst63' (Module And3xNone)
  wire  inst63__I0;
  wire  inst63__I1;
  wire  inst63__I2;
  wire  inst63__O;
  And3xNone inst63(
    .I0(inst63__I0),
    .I1(inst63__I1),
    .I2(inst63__I2),
    .O(inst63__O)
  );

  //Wire declarations for instance 'inst64' (Module corebit_not)
  wire  inst64__in;
  wire  inst64__out;
  corebit_not inst64(
    .in(inst64__in),
    .out(inst64__out)
  );

  //Wire declarations for instance 'inst65' (Module and_wrapped)
  wire  inst65__I0;
  wire  inst65__I1;
  wire  inst65__O;
  and_wrapped inst65(
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

  //Wire declarations for instance 'inst67' (Module corebit_not)
  wire  inst67__in;
  wire  inst67__out;
  corebit_not inst67(
    .in(inst67__in),
    .out(inst67__out)
  );

  //Wire declarations for instance 'inst68' (Module and_wrapped)
  wire  inst68__I0;
  wire  inst68__I1;
  wire  inst68__O;
  and_wrapped inst68(
    .I0(inst68__I0),
    .I1(inst68__I1),
    .O(inst68__O)
  );

  //Wire declarations for instance 'inst69' (Module corebit_not)
  wire  inst69__in;
  wire  inst69__out;
  corebit_not inst69(
    .in(inst69__in),
    .out(inst69__out)
  );

  //Wire declarations for instance 'inst7' (Module corebit_not)
  wire  inst7__in;
  wire  inst7__out;
  corebit_not inst7(
    .in(inst7__in),
    .out(inst7__out)
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

  //Wire declarations for instance 'inst71' (Module Or4xNone)
  wire  inst71__I0;
  wire  inst71__I1;
  wire  inst71__I2;
  wire  inst71__I3;
  wire  inst71__O;
  Or4xNone inst71(
    .I0(inst71__I0),
    .I1(inst71__I1),
    .I2(inst71__I2),
    .I3(inst71__I3),
    .O(inst71__O)
  );

  //Wire declarations for instance 'inst72' (Module SilicaOneHotMux82)
  wire [1:0] inst72__I0;
  wire [1:0] inst72__I1;
  wire [1:0] inst72__I2;
  wire [1:0] inst72__I3;
  wire [1:0] inst72__I4;
  wire [1:0] inst72__I5;
  wire [1:0] inst72__I6;
  wire [1:0] inst72__I7;
  wire [1:0] inst72__O;
  wire [7:0] inst72__S;
  SilicaOneHotMux82 inst72(
    .I0(inst72__I0),
    .I1(inst72__I1),
    .I2(inst72__I2),
    .I3(inst72__I3),
    .I4(inst72__I4),
    .I5(inst72__I5),
    .I6(inst72__I6),
    .I7(inst72__I7),
    .O(inst72__O),
    .S(inst72__S)
  );

  //Wire declarations for instance 'inst73' (Module SilicaOneHotMux8None)
  wire  inst73__I0;
  wire  inst73__I1;
  wire  inst73__I2;
  wire  inst73__I3;
  wire  inst73__I4;
  wire  inst73__I5;
  wire  inst73__I6;
  wire  inst73__I7;
  wire  inst73__O;
  wire [7:0] inst73__S;
  SilicaOneHotMux8None inst73(
    .I0(inst73__I0),
    .I1(inst73__I1),
    .I2(inst73__I2),
    .I3(inst73__I3),
    .I4(inst73__I4),
    .I5(inst73__I5),
    .I6(inst73__I6),
    .I7(inst73__I7),
    .O(inst73__O),
    .S(inst73__S)
  );

  //Wire declarations for instance 'inst74' (Module SilicaOneHotMux82)
  wire [1:0] inst74__I0;
  wire [1:0] inst74__I1;
  wire [1:0] inst74__I2;
  wire [1:0] inst74__I3;
  wire [1:0] inst74__I4;
  wire [1:0] inst74__I5;
  wire [1:0] inst74__I6;
  wire [1:0] inst74__I7;
  wire [1:0] inst74__O;
  wire [7:0] inst74__S;
  SilicaOneHotMux82 inst74(
    .I0(inst74__I0),
    .I1(inst74__I1),
    .I2(inst74__I2),
    .I3(inst74__I3),
    .I4(inst74__I4),
    .I5(inst74__I5),
    .I6(inst74__I6),
    .I7(inst74__I7),
    .O(inst74__O),
    .S(inst74__S)
  );

  //Wire declarations for instance 'inst75' (Module SilicaOneHotMux8None)
  wire  inst75__I0;
  wire  inst75__I1;
  wire  inst75__I2;
  wire  inst75__I3;
  wire  inst75__I4;
  wire  inst75__I5;
  wire  inst75__I6;
  wire  inst75__I7;
  wire  inst75__O;
  wire [7:0] inst75__S;
  SilicaOneHotMux8None inst75(
    .I0(inst75__I0),
    .I1(inst75__I1),
    .I2(inst75__I2),
    .I3(inst75__I3),
    .I4(inst75__I4),
    .I5(inst75__I5),
    .I6(inst75__I6),
    .I7(inst75__I7),
    .O(inst75__O),
    .S(inst75__S)
  );

  //Wire declarations for instance 'inst76' (Module SilicaOneHotMux84)
  wire [3:0] inst76__I0;
  wire [3:0] inst76__I1;
  wire [3:0] inst76__I2;
  wire [3:0] inst76__I3;
  wire [3:0] inst76__I4;
  wire [3:0] inst76__I5;
  wire [3:0] inst76__I6;
  wire [3:0] inst76__I7;
  wire [3:0] inst76__O;
  wire [7:0] inst76__S;
  SilicaOneHotMux84 inst76(
    .I0(inst76__I0),
    .I1(inst76__I1),
    .I2(inst76__I2),
    .I3(inst76__I3),
    .I4(inst76__I4),
    .I5(inst76__I5),
    .I6(inst76__I6),
    .I7(inst76__I7),
    .O(inst76__O),
    .S(inst76__S)
  );

  //Wire declarations for instance 'inst77' (Module SilicaOneHotMux8None)
  wire  inst77__I0;
  wire  inst77__I1;
  wire  inst77__I2;
  wire  inst77__I3;
  wire  inst77__I4;
  wire  inst77__I5;
  wire  inst77__I6;
  wire  inst77__I7;
  wire  inst77__O;
  wire [7:0] inst77__S;
  SilicaOneHotMux8None inst77(
    .I0(inst77__I0),
    .I1(inst77__I1),
    .I2(inst77__I2),
    .I3(inst77__I3),
    .I4(inst77__I4),
    .I5(inst77__I5),
    .I6(inst77__I6),
    .I7(inst77__I7),
    .O(inst77__O),
    .S(inst77__S)
  );

  //Wire declarations for instance 'inst78' (Module SilicaOneHotMux8None)
  wire  inst78__I0;
  wire  inst78__I1;
  wire  inst78__I2;
  wire  inst78__I3;
  wire  inst78__I4;
  wire  inst78__I5;
  wire  inst78__I6;
  wire  inst78__I7;
  wire  inst78__O;
  wire [7:0] inst78__S;
  SilicaOneHotMux8None inst78(
    .I0(inst78__I0),
    .I1(inst78__I1),
    .I2(inst78__I2),
    .I3(inst78__I3),
    .I4(inst78__I4),
    .I5(inst78__I5),
    .I6(inst78__I6),
    .I7(inst78__I7),
    .O(inst78__O),
    .S(inst78__S)
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

  //Wire declarations for instance 'inst9' (Module Add2)
  wire [1:0] inst9__I0;
  wire [1:0] inst9__I1;
  wire [1:0] inst9__O;
  Add2 inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .O(inst9__O)
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
  assign inst73__I1 = bit_const_GND__out;
  assign inst73__I5 = bit_const_GND__out;
  assign inst75__I0 = bit_const_GND__out;
  assign inst75__I2 = bit_const_GND__out;
  assign inst75__I4 = bit_const_GND__out;
  assign inst75__I6 = bit_const_GND__out;
  assign inst1__I[0] = bit_const_GND__out;
  assign inst13__I1[1] = bit_const_GND__out;
  assign inst18__I1[1] = bit_const_GND__out;
  assign inst29__I1[1] = bit_const_GND__out;
  assign inst41__I1[1] = bit_const_GND__out;
  assign inst45__I1[1] = bit_const_GND__out;
  assign inst50__I1[1] = bit_const_GND__out;
  assign inst61__I1[1] = bit_const_GND__out;
  assign inst9__I1[1] = bit_const_GND__out;
  assign inst1__I[1] = bit_const_VCC__out;
  assign inst13__I1[0] = bit_const_VCC__out;
  assign inst18__I1[0] = bit_const_VCC__out;
  assign inst29__I1[0] = bit_const_VCC__out;
  assign inst41__I1[0] = bit_const_VCC__out;
  assign inst45__I1[0] = bit_const_VCC__out;
  assign inst50__I1[0] = bit_const_VCC__out;
  assign inst61__I1[0] = bit_const_VCC__out;
  assign inst9__I1[0] = bit_const_VCC__out;
  assign inst72__S[7:0] = inst0__O[7:0];
  assign inst73__S[7:0] = inst0__O[7:0];
  assign inst74__S[7:0] = inst0__O[7:0];
  assign inst75__S[7:0] = inst0__O[7:0];
  assign inst76__S[7:0] = inst0__O[7:0];
  assign inst77__S[7:0] = inst0__O[7:0];
  assign inst78__S[7:0] = inst0__O[7:0];
  assign inst1__CLK = CLK;
  assign inst10__I0[1:0] = inst4__O[1:0];
  assign inst10__I1[1:0] = inst9__O[1:0];
  assign inst11__in = next_empty__O;
  assign inst12__I1 = inst11__out;
  assign inst12__I0 = ren;
  assign inst15__I2 = inst12__O;
  assign inst13__I0[1:0] = inst4__O[1:0];
  assign inst14__I0[1:0] = inst13__O[1:0];
  assign inst74__I0[1:0] = inst13__O[1:0];
  assign inst14__I1[1:0] = inst9__O[1:0];
  assign inst73__I0 = inst14__O;
  assign inst15__I0 = inst1__O[0];
  assign inst15__I1 = inst8__O;
  assign inst0__I[0] = inst15__O;
  assign inst16__in = next_full__O;
  assign inst17__I1 = inst16__out;
  assign inst17__I0 = wen;
  assign inst23__I1 = inst17__O;
  assign inst18__I0[1:0] = inst2__O[1:0];
  assign inst19__I1[1:0] = inst18__O[1:0];
  assign inst72__I1[1:0] = inst18__O[1:0];
  assign inst19__I0[1:0] = inst4__O[1:0];
  assign inst75__I1 = inst19__O;
  assign inst2__CLK = CLK;
  assign inst2__I[1:0] = inst72__O[1:0];
  assign inst30__I1[1:0] = inst2__O[1:0];
  assign inst41__I0[1:0] = inst2__O[1:0];
  assign inst5__waddr[1:0] = inst2__O[1:0];
  assign inst50__I0[1:0] = inst2__O[1:0];
  assign inst62__I1[1:0] = inst2__O[1:0];
  assign inst72__I2[1:0] = inst2__O[1:0];
  assign inst72__I3[1:0] = inst2__O[1:0];
  assign inst72__I6[1:0] = inst2__O[1:0];
  assign inst72__I7[1:0] = inst2__O[1:0];
  assign inst9__I0[1:0] = inst2__O[1:0];
  assign inst20__in = next_empty__O;
  assign inst21__I1 = inst20__out;
  assign inst21__I0 = ren;
  assign inst22__in = inst21__O;
  assign inst23__I2 = inst22__out;
  assign inst23__I0 = inst1__O[0];
  assign inst0__I[1] = inst23__O;
  assign inst24__in = next_full__O;
  assign inst25__I1 = inst24__out;
  assign inst25__I0 = wen;
  assign inst26__in = inst25__O;
  assign inst31__I1 = inst26__out;
  assign inst27__in = next_empty__O;
  assign inst28__I1 = inst27__out;
  assign inst28__I0 = ren;
  assign inst31__I2 = inst28__O;
  assign inst29__I0[1:0] = inst4__O[1:0];
  assign inst30__I0[1:0] = inst29__O[1:0];
  assign inst74__I2[1:0] = inst29__O[1:0];
  assign inst73__I2 = inst30__O;
  assign inst31__I0 = inst1__O[0];
  assign inst0__I[2] = inst31__O;
  assign inst32__in = next_full__O;
  assign inst33__I1 = inst32__out;
  assign inst33__I0 = wen;
  assign inst34__in = inst33__O;
  assign inst38__I1 = inst34__out;
  assign inst35__in = next_empty__O;
  assign inst36__I1 = inst35__out;
  assign inst36__I0 = ren;
  assign inst37__in = inst36__O;
  assign inst38__I2 = inst37__out;
  assign inst38__I0 = inst1__O[0];
  assign inst0__I[3] = inst38__O;
  assign inst39__in = next_full__O;
  assign inst40__I1 = inst39__out;
  assign inst4__CLK = CLK;
  assign inst4__I[1:0] = inst74__O[1:0];
  assign inst42__I0[1:0] = inst4__O[1:0];
  assign inst45__I0[1:0] = inst4__O[1:0];
  assign inst5__raddr[1:0] = inst4__O[1:0];
  assign inst51__I0[1:0] = inst4__O[1:0];
  assign inst61__I0[1:0] = inst4__O[1:0];
  assign inst74__I1[1:0] = inst4__O[1:0];
  assign inst74__I3[1:0] = inst4__O[1:0];
  assign inst74__I5[1:0] = inst4__O[1:0];
  assign inst74__I7[1:0] = inst4__O[1:0];
  assign inst40__I0 = wen;
  assign inst47__I1 = inst40__O;
  assign inst42__I1[1:0] = inst41__O[1:0];
  assign inst46__I1[1:0] = inst41__O[1:0];
  assign inst72__I4[1:0] = inst41__O[1:0];
  assign inst43__in = next_empty__O;
  assign inst44__I1 = inst43__out;
  assign inst44__I0 = ren;
  assign inst47__I2 = inst44__O;
  assign inst46__I0[1:0] = inst45__O[1:0];
  assign inst74__I4[1:0] = inst45__O[1:0];
  assign inst73__I4 = inst46__O;
  assign inst47__I0 = inst1__O[1];
  assign inst0__I[4] = inst47__O;
  assign inst48__in = next_full__O;
  assign inst49__I1 = inst48__out;
  assign inst49__I0 = wen;
  assign inst55__I1 = inst49__O;
  assign inst5__clk = CLK;
  assign inst76__I0[3:0] = inst5__rdata[3:0];
  assign inst76__I1[3:0] = inst5__rdata[3:0];
  assign inst76__I2[3:0] = inst5__rdata[3:0];
  assign inst76__I3[3:0] = inst5__rdata[3:0];
  assign inst76__I4[3:0] = inst5__rdata[3:0];
  assign inst76__I5[3:0] = inst5__rdata[3:0];
  assign inst76__I6[3:0] = inst5__rdata[3:0];
  assign inst76__I7[3:0] = inst5__rdata[3:0];
  assign inst5__wdata[3:0] = wdata[3:0];
  assign inst5__wen = inst71__O;
  assign inst51__I1[1:0] = inst50__O[1:0];
  assign inst72__I5[1:0] = inst50__O[1:0];
  assign inst75__I5 = inst51__O;
  assign inst52__in = next_empty__O;
  assign inst53__I1 = inst52__out;
  assign inst53__I0 = ren;
  assign inst54__in = inst53__O;
  assign inst55__I2 = inst54__out;
  assign inst55__I0 = inst1__O[1];
  assign inst0__I[5] = inst55__O;
  assign inst56__in = next_full__O;
  assign inst57__I1 = inst56__out;
  assign inst57__I0 = wen;
  assign inst58__in = inst57__O;
  assign inst63__I1 = inst58__out;
  assign inst59__in = next_empty__O;
  assign inst60__I1 = inst59__out;
  assign inst60__I0 = ren;
  assign inst63__I2 = inst60__O;
  assign inst62__I0[1:0] = inst61__O[1:0];
  assign inst74__I6[1:0] = inst61__O[1:0];
  assign inst73__I6 = inst62__O;
  assign inst63__I0 = inst1__O[1];
  assign inst0__I[6] = inst63__O;
  assign inst64__in = next_full__O;
  assign inst65__I1 = inst64__out;
  assign inst65__I0 = wen;
  assign inst66__in = inst65__O;
  assign inst70__I1 = inst66__out;
  assign inst67__in = next_empty__O;
  assign inst68__I1 = inst67__out;
  assign inst68__I0 = ren;
  assign inst69__in = inst68__O;
  assign inst70__I2 = inst69__out;
  assign inst7__in = next_full__O;
  assign inst8__I1 = inst7__out;
  assign inst70__I0 = inst1__O[1];
  assign inst0__I[7] = inst70__O;
  assign inst71__I0 = inst0__O[0];
  assign inst71__I1 = inst0__O[1];
  assign inst71__I2 = inst0__O[4];
  assign inst71__I3 = inst0__O[5];
  assign inst72__I0[1:0] = inst9__O[1:0];
  assign inst73__I3 = next_empty__O;
  assign inst73__I7 = next_empty__O;
  assign next_empty__I = inst73__O;
  assign inst75__I3 = next_full__O;
  assign inst75__I7 = next_full__O;
  assign next_full__I = inst75__O;
  assign rdata[3:0] = inst76__O[3:0];
  assign inst77__I0 = next_full__O;
  assign inst77__I1 = next_full__O;
  assign inst77__I2 = next_full__O;
  assign inst77__I3 = next_full__O;
  assign inst77__I4 = next_full__O;
  assign inst77__I5 = next_full__O;
  assign inst77__I6 = next_full__O;
  assign inst77__I7 = next_full__O;
  assign full = inst77__O;
  assign inst78__I0 = next_empty__O;
  assign inst78__I1 = next_empty__O;
  assign inst78__I2 = next_empty__O;
  assign inst78__I3 = next_empty__O;
  assign inst78__I4 = next_empty__O;
  assign inst78__I5 = next_empty__O;
  assign inst78__I6 = next_empty__O;
  assign inst78__I7 = next_empty__O;
  assign empty = inst78__O;
  assign inst8__I0 = wen;
  assign next_empty__CLK = CLK;
  assign next_full__CLK = CLK;

endmodule //Fifo
