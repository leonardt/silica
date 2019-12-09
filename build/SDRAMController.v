module enable(input CLK, input RESET, input [3:0] n, output CE);
reg [3:0] count;

always @(posedge CLK or negedge RESET) begin
    if (!RESET) begin
        count <= 4'hf;
    end else begin
        count <= count == 0 ? n : count - 1;
    end
end

assign CE = count == 0;

endmodule
module _SDRAMController
(
  output [5-1:0] state,
  output reg [8-1:0] cmd,
  output [4-1:0] n,
  input [10-1:0] refresh_cnt,
  input rd_enable,
  input wr_enable,
  input CLK,
  input RESET,
  input CE
);

  reg [8-1:0] cmd_next;
  reg [5-1:0] yield_state;
  reg [5-1:0] yield_state_next;

  always @(cmd or refresh_cnt or rd_enable or wr_enable or CLK or RESET or CE or yield_state) begin
    cmd_next = cmd;
    if(yield_state == 5'b01000) begin
      cmd_next = 8'b10010001;
      n = 0;
      yield_state_next = 5'b01001;
    end else if(yield_state == 5'b01001) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00101;
    end else if(yield_state == 5'b00101) begin
      cmd_next = 8'b10001000;
      n = 0;
      yield_state_next = 5'b01010;
    end else if(yield_state == 5'b01010) begin
      cmd_next = 8'b10111000;
      n = 7;
      yield_state_next = 5'b01011;
    end else if(yield_state == 5'b01011) begin
      cmd_next = 8'b10001000;
      n = 0;
      yield_state_next = 5'b01100;
    end else if(yield_state == 5'b01100) begin
      cmd_next = 8'b10111000;
      n = 7;
      yield_state_next = 5'b01101;
    end else if(yield_state == 5'b01101) begin
      cmd_next = 8'b1000000x;
      n = 0;
      yield_state_next = 5'b01110;
    end else if(yield_state == 5'b01110) begin
      cmd_next = 8'b10111000;
      n = 1;
      yield_state_next = 5'b01111;
    end else if(yield_state == 5'b01111) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00000;
    end else if(yield_state == 5'b00000) begin
      if(refresh_cnt >= 519) begin
        cmd_next = 8'b10010001;
        n = 0;
        yield_state_next = 5'b00001;
      end else if(wr_enable) begin
        cmd_next = 8'b10011xxx;
        n = 0;
        yield_state_next = 5'b11000;
      end else if(rd_enable) begin
        cmd_next = 8'b10011xxx;
        n = 0;
        yield_state_next = 5'b10000;
      end else begin
        cmd_next = 8'b10111000;
        n = 0;
        yield_state_next = 5'b00000;
      end
    end else if(yield_state == 5'b00001) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00010;
    end else if(yield_state == 5'b00010) begin
      cmd_next = 8'b10001000;
      n = 0;
      yield_state_next = 5'b00011;
    end else if(yield_state == 5'b00011) begin
      cmd_next = 8'b10111000;
      n = 7;
      yield_state_next = 5'b00100;
    end else if(yield_state == 5'b00100) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00000;
    end else if(yield_state == 5'b11000) begin
      cmd_next = 8'b10111000;
      n = 1;
      yield_state_next = 5'b11001;
    end else if(yield_state == 5'b11001) begin
      cmd_next = 8'b10100xx1;
      n = 0;
      yield_state_next = 5'b11010;
    end else if(yield_state == 5'b11010) begin
      cmd_next = 8'b10111000;
      n = 1;
      yield_state_next = 5'b11011;
    end else if(yield_state == 5'b11011) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00000;
    end else if(yield_state == 5'b10000) begin
      cmd_next = 8'b10111000;
      n = 1;
      yield_state_next = 5'b10001;
    end else if(yield_state == 5'b10001) begin
      cmd_next = 8'b10101xx1;
      n = 0;
      yield_state_next = 5'b10010;
    end else if(yield_state == 5'b10010) begin
      cmd_next = 8'b10111000;
      n = 1;
      yield_state_next = 5'b10011;
    end else if(yield_state == 5'b10011) begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b10100;
    end else begin
      cmd_next = 8'b10111000;
      n = 0;
      yield_state_next = 5'b00000;
    end
  end


  always @(posedge CLK or negedge RESET) begin
    if(~RESET) begin
      cmd <= 8'b10111000;
      yield_state <= 5'b01000;
    end else begin
      if(CE) begin
        cmd <= cmd_next;
        yield_state <= yield_state_next;
      end 
    end
  end

  assign state = yield_state;

endmodule
module SDRAMController (input CLK, input RESET, output [7:0] cmd, input rd_enable, input [9:0] refresh_cnt, output [4:0] state, input wr_enable);
wire [7:0] _SDRAMController_inst0_cmd;
wire [3:0] _SDRAMController_inst0_n;
wire [4:0] _SDRAMController_inst0_state;
wire enable_inst0_CE;
_SDRAMController _SDRAMController_inst0(.CE(enable_inst0_CE), .CLK(CLK), .RESET(RESET), .cmd(_SDRAMController_inst0_cmd), .n(_SDRAMController_inst0_n), .rd_enable(rd_enable), .refresh_cnt(refresh_cnt), .state(_SDRAMController_inst0_state), .wr_enable(wr_enable));
enable enable_inst0(.CE(enable_inst0_CE), .CLK(CLK), .RESET(RESET), .n(_SDRAMController_inst0_n));
assign cmd = _SDRAMController_inst0_cmd;
assign state = _SDRAMController_inst0_state;
endmodule

