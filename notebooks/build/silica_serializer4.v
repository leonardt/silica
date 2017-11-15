

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

module Register5_0001 (
  input  CLK,
  input [4:0] I,
  output [4:0] O
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

endmodule //Register5_0001

module Or5x16 (
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  input [15:0] I4,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_orr)
  wire [4:0] inst0__in;
  wire  inst0__out;
  coreir_orr #(.width(5)) inst0(
    .in(inst0__in),
    .out(inst0__out)
  );

  //Wire declarations for instance 'inst1' (Module coreir_orr)
  wire [4:0] inst1__in;
  wire  inst1__out;
  coreir_orr #(.width(5)) inst1(
    .in(inst1__in),
    .out(inst1__out)
  );

  //Wire declarations for instance 'inst10' (Module coreir_orr)
  wire [4:0] inst10__in;
  wire  inst10__out;
  coreir_orr #(.width(5)) inst10(
    .in(inst10__in),
    .out(inst10__out)
  );

  //Wire declarations for instance 'inst11' (Module coreir_orr)
  wire [4:0] inst11__in;
  wire  inst11__out;
  coreir_orr #(.width(5)) inst11(
    .in(inst11__in),
    .out(inst11__out)
  );

  //Wire declarations for instance 'inst12' (Module coreir_orr)
  wire [4:0] inst12__in;
  wire  inst12__out;
  coreir_orr #(.width(5)) inst12(
    .in(inst12__in),
    .out(inst12__out)
  );

  //Wire declarations for instance 'inst13' (Module coreir_orr)
  wire [4:0] inst13__in;
  wire  inst13__out;
  coreir_orr #(.width(5)) inst13(
    .in(inst13__in),
    .out(inst13__out)
  );

  //Wire declarations for instance 'inst14' (Module coreir_orr)
  wire [4:0] inst14__in;
  wire  inst14__out;
  coreir_orr #(.width(5)) inst14(
    .in(inst14__in),
    .out(inst14__out)
  );

  //Wire declarations for instance 'inst15' (Module coreir_orr)
  wire [4:0] inst15__in;
  wire  inst15__out;
  coreir_orr #(.width(5)) inst15(
    .in(inst15__in),
    .out(inst15__out)
  );

  //Wire declarations for instance 'inst2' (Module coreir_orr)
  wire [4:0] inst2__in;
  wire  inst2__out;
  coreir_orr #(.width(5)) inst2(
    .in(inst2__in),
    .out(inst2__out)
  );

  //Wire declarations for instance 'inst3' (Module coreir_orr)
  wire [4:0] inst3__in;
  wire  inst3__out;
  coreir_orr #(.width(5)) inst3(
    .in(inst3__in),
    .out(inst3__out)
  );

  //Wire declarations for instance 'inst4' (Module coreir_orr)
  wire [4:0] inst4__in;
  wire  inst4__out;
  coreir_orr #(.width(5)) inst4(
    .in(inst4__in),
    .out(inst4__out)
  );

  //Wire declarations for instance 'inst5' (Module coreir_orr)
  wire [4:0] inst5__in;
  wire  inst5__out;
  coreir_orr #(.width(5)) inst5(
    .in(inst5__in),
    .out(inst5__out)
  );

  //Wire declarations for instance 'inst6' (Module coreir_orr)
  wire [4:0] inst6__in;
  wire  inst6__out;
  coreir_orr #(.width(5)) inst6(
    .in(inst6__in),
    .out(inst6__out)
  );

  //Wire declarations for instance 'inst7' (Module coreir_orr)
  wire [4:0] inst7__in;
  wire  inst7__out;
  coreir_orr #(.width(5)) inst7(
    .in(inst7__in),
    .out(inst7__out)
  );

  //Wire declarations for instance 'inst8' (Module coreir_orr)
  wire [4:0] inst8__in;
  wire  inst8__out;
  coreir_orr #(.width(5)) inst8(
    .in(inst8__in),
    .out(inst8__out)
  );

  //Wire declarations for instance 'inst9' (Module coreir_orr)
  wire [4:0] inst9__in;
  wire  inst9__out;
  coreir_orr #(.width(5)) inst9(
    .in(inst9__in),
    .out(inst9__out)
  );

  //All the connections
  assign O[0] = inst0__out;
  assign O[1] = inst1__out;
  assign O[10] = inst10__out;
  assign O[11] = inst11__out;
  assign O[12] = inst12__out;
  assign O[13] = inst13__out;
  assign O[14] = inst14__out;
  assign O[15] = inst15__out;
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
  assign inst0__in[2] = I2[0];
  assign inst0__in[3] = I3[0];
  assign inst0__in[4] = I4[0];
  assign inst1__in[0] = I0[1];
  assign inst1__in[1] = I1[1];
  assign inst1__in[2] = I2[1];
  assign inst1__in[3] = I3[1];
  assign inst1__in[4] = I4[1];
  assign inst10__in[0] = I0[10];
  assign inst10__in[1] = I1[10];
  assign inst10__in[2] = I2[10];
  assign inst10__in[3] = I3[10];
  assign inst10__in[4] = I4[10];
  assign inst11__in[0] = I0[11];
  assign inst11__in[1] = I1[11];
  assign inst11__in[2] = I2[11];
  assign inst11__in[3] = I3[11];
  assign inst11__in[4] = I4[11];
  assign inst12__in[0] = I0[12];
  assign inst12__in[1] = I1[12];
  assign inst12__in[2] = I2[12];
  assign inst12__in[3] = I3[12];
  assign inst12__in[4] = I4[12];
  assign inst13__in[0] = I0[13];
  assign inst13__in[1] = I1[13];
  assign inst13__in[2] = I2[13];
  assign inst13__in[3] = I3[13];
  assign inst13__in[4] = I4[13];
  assign inst14__in[0] = I0[14];
  assign inst14__in[1] = I1[14];
  assign inst14__in[2] = I2[14];
  assign inst14__in[3] = I3[14];
  assign inst14__in[4] = I4[14];
  assign inst15__in[0] = I0[15];
  assign inst15__in[1] = I1[15];
  assign inst15__in[2] = I2[15];
  assign inst15__in[3] = I3[15];
  assign inst15__in[4] = I4[15];
  assign inst2__in[0] = I0[2];
  assign inst2__in[1] = I1[2];
  assign inst2__in[2] = I2[2];
  assign inst2__in[3] = I3[2];
  assign inst2__in[4] = I4[2];
  assign inst3__in[0] = I0[3];
  assign inst3__in[1] = I1[3];
  assign inst3__in[2] = I2[3];
  assign inst3__in[3] = I3[3];
  assign inst3__in[4] = I4[3];
  assign inst4__in[0] = I0[4];
  assign inst4__in[1] = I1[4];
  assign inst4__in[2] = I2[4];
  assign inst4__in[3] = I3[4];
  assign inst4__in[4] = I4[4];
  assign inst5__in[0] = I0[5];
  assign inst5__in[1] = I1[5];
  assign inst5__in[2] = I2[5];
  assign inst5__in[3] = I3[5];
  assign inst5__in[4] = I4[5];
  assign inst6__in[0] = I0[6];
  assign inst6__in[1] = I1[6];
  assign inst6__in[2] = I2[6];
  assign inst6__in[3] = I3[6];
  assign inst6__in[4] = I4[6];
  assign inst7__in[0] = I0[7];
  assign inst7__in[1] = I1[7];
  assign inst7__in[2] = I2[7];
  assign inst7__in[3] = I3[7];
  assign inst7__in[4] = I4[7];
  assign inst8__in[0] = I0[8];
  assign inst8__in[1] = I1[8];
  assign inst8__in[2] = I2[8];
  assign inst8__in[3] = I3[8];
  assign inst8__in[4] = I4[8];
  assign inst9__in[0] = I0[9];
  assign inst9__in[1] = I1[9];
  assign inst9__in[2] = I2[9];
  assign inst9__in[3] = I3[9];
  assign inst9__in[4] = I4[9];

endmodule //Or5x16

module Register16 (
  input  CLK,
  input [15:0] I,
  output [15:0] O
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

  //Wire declarations for instance 'inst12' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst12__CLK;
  wire  inst12__I;
  wire  inst12__O;
  DFF_init0_has_ceFalse_has_resetFalse inst12(
    .CLK(inst12__CLK),
    .I(inst12__I),
    .O(inst12__O)
  );

  //Wire declarations for instance 'inst13' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst13__CLK;
  wire  inst13__I;
  wire  inst13__O;
  DFF_init0_has_ceFalse_has_resetFalse inst13(
    .CLK(inst13__CLK),
    .I(inst13__I),
    .O(inst13__O)
  );

  //Wire declarations for instance 'inst14' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst14__CLK;
  wire  inst14__I;
  wire  inst14__O;
  DFF_init0_has_ceFalse_has_resetFalse inst14(
    .CLK(inst14__CLK),
    .I(inst14__I),
    .O(inst14__O)
  );

  //Wire declarations for instance 'inst15' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst15__CLK;
  wire  inst15__I;
  wire  inst15__O;
  DFF_init0_has_ceFalse_has_resetFalse inst15(
    .CLK(inst15__CLK),
    .I(inst15__I),
    .O(inst15__O)
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
  assign inst12__CLK = CLK;
  assign inst12__I = I[12];
  assign O[12] = inst12__O;
  assign inst13__CLK = CLK;
  assign inst13__I = I[13];
  assign O[13] = inst13__O;
  assign inst14__CLK = CLK;
  assign inst14__I = I[14];
  assign O[14] = inst14__O;
  assign inst15__CLK = CLK;
  assign inst15__I = I[15];
  assign O[15] = inst15__O;
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

endmodule //Register16

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

module __silica_BufferSerializer4 (
  input [4:0] I,
  output [4:0] O
);
  //All the connections
  assign O[4:0] = I[4:0];

endmodule //__silica_BufferSerializer4

module and16_wrapped (
  input [15:0] I0,
  input [15:0] I1,
  output [15:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [15:0] inst0__in0;
  wire [15:0] inst0__in1;
  wire [15:0] inst0__out;
  coreir_and #(.width(16)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[15:0] = I0[15:0];
  assign inst0__in1[15:0] = I1[15:0];
  assign O[15:0] = inst0__out[15:0];

endmodule //and16_wrapped

module SilicaOneHotMux516 (
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  input [15:0] I4,
  output [15:0] O,
  input [4:0] S
);
  //Wire declarations for instance 'inst0' (Module Or5x16)
  wire [15:0] inst0__I0;
  wire [15:0] inst0__I1;
  wire [15:0] inst0__I2;
  wire [15:0] inst0__I3;
  wire [15:0] inst0__I4;
  wire [15:0] inst0__O;
  Or5x16 inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .I2(inst0__I2),
    .I3(inst0__I3),
    .I4(inst0__I4),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and16_wrapped)
  wire [15:0] inst1__I0;
  wire [15:0] inst1__I1;
  wire [15:0] inst1__O;
  and16_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and16_wrapped)
  wire [15:0] inst2__I0;
  wire [15:0] inst2__I1;
  wire [15:0] inst2__O;
  and16_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //Wire declarations for instance 'inst3' (Module and16_wrapped)
  wire [15:0] inst3__I0;
  wire [15:0] inst3__I1;
  wire [15:0] inst3__O;
  and16_wrapped inst3(
    .I0(inst3__I0),
    .I1(inst3__I1),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module and16_wrapped)
  wire [15:0] inst4__I0;
  wire [15:0] inst4__I1;
  wire [15:0] inst4__O;
  and16_wrapped inst4(
    .I0(inst4__I0),
    .I1(inst4__I1),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module and16_wrapped)
  wire [15:0] inst5__I0;
  wire [15:0] inst5__I1;
  wire [15:0] inst5__O;
  and16_wrapped inst5(
    .I0(inst5__I0),
    .I1(inst5__I1),
    .O(inst5__O)
  );

  //All the connections
  assign inst0__I0[15:0] = inst1__O[15:0];
  assign inst0__I1[15:0] = inst2__O[15:0];
  assign inst0__I2[15:0] = inst3__O[15:0];
  assign inst0__I3[15:0] = inst4__O[15:0];
  assign inst0__I4[15:0] = inst5__O[15:0];
  assign O[15:0] = inst0__O[15:0];
  assign inst1__I0[15:0] = I0[15:0];
  assign inst2__I0[15:0] = I1[15:0];
  assign inst3__I0[15:0] = I2[15:0];
  assign inst4__I0[15:0] = I3[15:0];
  assign inst5__I0[15:0] = I4[15:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
  assign inst1__I1[10] = S[0];
  assign inst1__I1[11] = S[0];
  assign inst1__I1[12] = S[0];
  assign inst1__I1[13] = S[0];
  assign inst1__I1[14] = S[0];
  assign inst1__I1[15] = S[0];
  assign inst1__I1[2] = S[0];
  assign inst1__I1[3] = S[0];
  assign inst1__I1[4] = S[0];
  assign inst1__I1[5] = S[0];
  assign inst1__I1[6] = S[0];
  assign inst1__I1[7] = S[0];
  assign inst1__I1[8] = S[0];
  assign inst1__I1[9] = S[0];
  assign inst2__I1[0] = S[1];
  assign inst2__I1[1] = S[1];
  assign inst2__I1[10] = S[1];
  assign inst2__I1[11] = S[1];
  assign inst2__I1[12] = S[1];
  assign inst2__I1[13] = S[1];
  assign inst2__I1[14] = S[1];
  assign inst2__I1[15] = S[1];
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
  assign inst3__I1[12] = S[2];
  assign inst3__I1[13] = S[2];
  assign inst3__I1[14] = S[2];
  assign inst3__I1[15] = S[2];
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
  assign inst4__I1[12] = S[3];
  assign inst4__I1[13] = S[3];
  assign inst4__I1[14] = S[3];
  assign inst4__I1[15] = S[3];
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
  assign inst5__I1[12] = S[4];
  assign inst5__I1[13] = S[4];
  assign inst5__I1[14] = S[4];
  assign inst5__I1[15] = S[4];
  assign inst5__I1[2] = S[4];
  assign inst5__I1[3] = S[4];
  assign inst5__I1[4] = S[4];
  assign inst5__I1[5] = S[4];
  assign inst5__I1[6] = S[4];
  assign inst5__I1[7] = S[4];
  assign inst5__I1[8] = S[4];
  assign inst5__I1[9] = S[4];

endmodule //SilicaOneHotMux516

module Serializer4 (
  input  CLK,
  input [15:0] I_0,
  input [15:0] I_1,
  input [15:0] I_2,
  input [15:0] I_3,
  output [15:0] O
);
  //Wire declarations for instance 'bit_const_GND' (Module corebit_const)
  wire  bit_const_GND__out;
  corebit_const #(.value(0)) bit_const_GND(
    .out(bit_const_GND__out)
  );

  //Wire declarations for instance 'inst0' (Module __silica_BufferSerializer4)
  wire [4:0] inst0__I;
  wire [4:0] inst0__O;
  __silica_BufferSerializer4 inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register5_0001)
  wire  inst1__CLK;
  wire [4:0] inst1__I;
  wire [4:0] inst1__O;
  Register5_0001 inst1(
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

  //Wire declarations for instance 'inst3' (Module Register16)
  wire  inst3__CLK;
  wire [15:0] inst3__I;
  wire [15:0] inst3__O;
  Register16 inst3(
    .CLK(inst3__CLK),
    .I(inst3__I),
    .O(inst3__O)
  );

  //Wire declarations for instance 'inst4' (Module Register16)
  wire  inst4__CLK;
  wire [15:0] inst4__I;
  wire [15:0] inst4__O;
  Register16 inst4(
    .CLK(inst4__CLK),
    .I(inst4__I),
    .O(inst4__O)
  );

  //Wire declarations for instance 'inst5' (Module Register16)
  wire  inst5__CLK;
  wire [15:0] inst5__I;
  wire [15:0] inst5__O;
  Register16 inst5(
    .CLK(inst5__CLK),
    .I(inst5__I),
    .O(inst5__O)
  );

  //Wire declarations for instance 'inst6' (Module SilicaOneHotMux516)
  wire [15:0] inst6__I0;
  wire [15:0] inst6__I1;
  wire [15:0] inst6__I2;
  wire [15:0] inst6__I3;
  wire [15:0] inst6__I4;
  wire [15:0] inst6__O;
  wire [4:0] inst6__S;
  SilicaOneHotMux516 inst6(
    .I0(inst6__I0),
    .I1(inst6__I1),
    .I2(inst6__I2),
    .I3(inst6__I3),
    .I4(inst6__I4),
    .O(inst6__O),
    .S(inst6__S)
  );

  //Wire declarations for instance 'inst7' (Module SilicaOneHotMux516)
  wire [15:0] inst7__I0;
  wire [15:0] inst7__I1;
  wire [15:0] inst7__I2;
  wire [15:0] inst7__I3;
  wire [15:0] inst7__I4;
  wire [15:0] inst7__O;
  wire [4:0] inst7__S;
  SilicaOneHotMux516 inst7(
    .I0(inst7__I0),
    .I1(inst7__I1),
    .I2(inst7__I2),
    .I3(inst7__I3),
    .I4(inst7__I4),
    .O(inst7__O),
    .S(inst7__S)
  );

  //Wire declarations for instance 'inst8' (Module SilicaOneHotMux516)
  wire [15:0] inst8__I0;
  wire [15:0] inst8__I1;
  wire [15:0] inst8__I2;
  wire [15:0] inst8__I3;
  wire [15:0] inst8__I4;
  wire [15:0] inst8__O;
  wire [4:0] inst8__S;
  SilicaOneHotMux516 inst8(
    .I0(inst8__I0),
    .I1(inst8__I1),
    .I2(inst8__I2),
    .I3(inst8__I3),
    .I4(inst8__I4),
    .O(inst8__O),
    .S(inst8__S)
  );

  //Wire declarations for instance 'inst9' (Module SilicaOneHotMux516)
  wire [15:0] inst9__I0;
  wire [15:0] inst9__I1;
  wire [15:0] inst9__I2;
  wire [15:0] inst9__I3;
  wire [15:0] inst9__I4;
  wire [15:0] inst9__O;
  wire [4:0] inst9__S;
  SilicaOneHotMux516 inst9(
    .I0(inst9__I0),
    .I1(inst9__I1),
    .I2(inst9__I2),
    .I3(inst9__I3),
    .I4(inst9__I4),
    .O(inst9__O),
    .S(inst9__S)
  );

  //All the connections
  assign inst1__I[0] = bit_const_GND__out;
  assign inst0__I[4:0] = inst1__O[4:0];
  assign inst6__S[4:0] = inst0__O[4:0];
  assign inst7__S[4:0] = inst0__O[4:0];
  assign inst8__S[4:0] = inst0__O[4:0];
  assign inst9__S[4:0] = inst0__O[4:0];
  assign inst1__CLK = CLK;
  assign inst2__I0 = inst1__O[0];
  assign inst2__I1 = inst1__O[4];
  assign inst1__I[1] = inst2__O;
  assign inst3__CLK = CLK;
  assign inst3__I[15:0] = inst6__O[15:0];
  assign inst6__I1[15:0] = inst3__O[15:0];
  assign inst6__I2[15:0] = inst3__O[15:0];
  assign inst6__I3[15:0] = inst3__O[15:0];
  assign inst9__I1[15:0] = inst3__O[15:0];
  assign inst4__CLK = CLK;
  assign inst4__I[15:0] = inst7__O[15:0];
  assign inst7__I1[15:0] = inst4__O[15:0];
  assign inst7__I2[15:0] = inst4__O[15:0];
  assign inst7__I3[15:0] = inst4__O[15:0];
  assign inst9__I2[15:0] = inst4__O[15:0];
  assign inst5__CLK = CLK;
  assign inst5__I[15:0] = inst8__O[15:0];
  assign inst8__I1[15:0] = inst5__O[15:0];
  assign inst8__I2[15:0] = inst5__O[15:0];
  assign inst8__I3[15:0] = inst5__O[15:0];
  assign inst9__I3[15:0] = inst5__O[15:0];
  assign inst6__I0[15:0] = I_1[15:0];
  assign inst6__I4[15:0] = I_1[15:0];
  assign inst7__I0[15:0] = I_2[15:0];
  assign inst7__I4[15:0] = I_2[15:0];
  assign inst8__I0[15:0] = I_3[15:0];
  assign inst8__I4[15:0] = I_3[15:0];
  assign inst9__I0[15:0] = I_0[15:0];
  assign inst9__I4[15:0] = I_0[15:0];
  assign O[15:0] = inst9__O[15:0];
  assign inst1__I[2] = inst1__O[1];
  assign inst1__I[3] = inst1__O[2];
  assign inst1__I[4] = inst1__O[3];

endmodule //Serializer4
