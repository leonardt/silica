

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

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

module or10_wrapped (
  input [9:0] I0,
  input [9:0] I1,
  output [9:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [9:0] inst0__in0;
  wire [9:0] inst0__in1;
  wire [9:0] inst0__out;
  coreir_or #(.width(10)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[9:0] = I0[9:0];
  assign inst0__in1[9:0] = I1[9:0];
  assign O[9:0] = inst0__out[9:0];

endmodule //or10_wrapped

module __silica_BufferPISO (
  input [1:0] I,
  output [1:0] O
);
  //All the connections
  assign O[1:0] = I[1:0];

endmodule //__silica_BufferPISO

module and10_wrapped (
  input [9:0] I0,
  input [9:0] I1,
  output [9:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [9:0] inst0__in0;
  wire [9:0] inst0__in1;
  wire [9:0] inst0__out;
  coreir_and #(.width(10)) inst0(
    .in0(inst0__in0),
    .in1(inst0__in1),
    .out(inst0__out)
  );

  //All the connections
  assign inst0__in0[9:0] = I0[9:0];
  assign inst0__in1[9:0] = I1[9:0];
  assign O[9:0] = inst0__out[9:0];

endmodule //and10_wrapped

module SilicaOneHotMux210 (
  input [9:0] I0,
  input [9:0] I1,
  output [9:0] O,
  input [1:0] S
);
  //Wire declarations for instance 'inst0' (Module or10_wrapped)
  wire [9:0] inst0__I0;
  wire [9:0] inst0__I1;
  wire [9:0] inst0__O;
  or10_wrapped inst0(
    .I0(inst0__I0),
    .I1(inst0__I1),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module and10_wrapped)
  wire [9:0] inst1__I0;
  wire [9:0] inst1__I1;
  wire [9:0] inst1__O;
  and10_wrapped inst1(
    .I0(inst1__I0),
    .I1(inst1__I1),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module and10_wrapped)
  wire [9:0] inst2__I0;
  wire [9:0] inst2__I1;
  wire [9:0] inst2__O;
  and10_wrapped inst2(
    .I0(inst2__I0),
    .I1(inst2__I1),
    .O(inst2__O)
  );

  //All the connections
  assign inst0__I0[9:0] = inst1__O[9:0];
  assign inst0__I1[9:0] = inst2__O[9:0];
  assign O[9:0] = inst0__O[9:0];
  assign inst1__I0[9:0] = I0[9:0];
  assign inst2__I0[9:0] = I1[9:0];
  assign inst1__I1[0] = S[0];
  assign inst1__I1[1] = S[0];
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
  assign inst2__I1[2] = S[1];
  assign inst2__I1[3] = S[1];
  assign inst2__I1[4] = S[1];
  assign inst2__I1[5] = S[1];
  assign inst2__I1[6] = S[1];
  assign inst2__I1[7] = S[1];
  assign inst2__I1[8] = S[1];
  assign inst2__I1[9] = S[1];

endmodule //SilicaOneHotMux210

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

module Register10 (
  input  CLK,
  input [9:0] I,
  output [9:0] O
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

endmodule //Register10

module PISO (
  input  CLK,
  input  LOAD,
  output  O,
  input [9:0] PI,
  input  SI
);
  //Wire declarations for instance 'inst0' (Module __silica_BufferPISO)
  wire [1:0] inst0__I;
  wire [1:0] inst0__O;
  __silica_BufferPISO inst0(
    .I(inst0__I),
    .O(inst0__O)
  );

  //Wire declarations for instance 'inst1' (Module Register10)
  wire  inst1__CLK;
  wire [9:0] inst1__I;
  wire [9:0] inst1__O;
  Register10 inst1(
    .CLK(inst1__CLK),
    .I(inst1__I),
    .O(inst1__O)
  );

  //Wire declarations for instance 'inst2' (Module SilicaOneHotMux210)
  wire [9:0] inst2__I0;
  wire [9:0] inst2__I1;
  wire [9:0] inst2__O;
  wire [1:0] inst2__S;
  SilicaOneHotMux210 inst2(
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
  assign inst1__I[9:0] = inst2__O[9:0];
  assign inst2__I0[9:0] = PI[9:0];
  assign inst3__I0 = inst1__O[9];
  assign inst3__I1 = inst1__O[9];
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
  assign inst2__I1[8] = inst1__O[7];
  assign inst2__I1[9] = inst1__O[8];

endmodule //PISO
