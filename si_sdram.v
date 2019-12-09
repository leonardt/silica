

module SDRAMController
(
  output [5-1:0] state,
  output reg [8-1:0] cmd,
  input [10-1:0] refresh_cnt,
  input rd_enable,
  input wr_enable,
  input CLK,
  input RESET
);

  reg [8-1:0] cmd_next;
  reg [4-1:0] _;
  reg [4-1:0] __next;
  reg [5-1:0] yield_state;
  reg [5-1:0] yield_state_next;

  always @(cmd or _ or refresh_cnt or rd_enable or wr_enable or CLK or RESET or yield_state) begin
    __next = _;
    cmd_next = cmd;
    if(yield_state == 5'b01000) begin
      if(__next == 0) begin
        cmd_next = 8'b10010001;
        yield_state_next = 5'b01001;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b01000;
      end
    end else if(yield_state == 5'b01001) begin
      cmd_next = 8'b10111000;
      yield_state_next = 5'b00101;
    end else if(yield_state == 5'b00101) begin
      cmd_next = 8'b10001000;
      yield_state_next = 5'b01010;
    end else if(yield_state == 5'b01010) begin
      __next = 7;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b01011;
    end else if(yield_state == 5'b01011) begin
      if(__next == 0) begin
        cmd_next = 8'b10001000;
        yield_state_next = 5'b01100;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b01011;
      end
    end else if(yield_state == 5'b01100) begin
      __next = 7;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b01101;
    end else if(yield_state == 5'b01101) begin
      if(__next == 0) begin
        cmd_next = 8'b1000000x;
        yield_state_next = 5'b01110;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b01101;
      end
    end else if(yield_state == 5'b01110) begin
      __next = 1;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b01111;
    end else if(yield_state == 5'b01111) begin
      if(__next == 0) begin
        cmd_next = 8'b10111000;
        yield_state_next = 5'b00000;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b01111;
      end
    end else if(yield_state == 5'b00000) begin
      if(refresh_cnt >= 519) begin
        cmd_next = 8'b10010001;
        yield_state_next = 5'b00001;
      end else if(wr_enable) begin
        cmd_next = 8'b10011xxx;
        yield_state_next = 5'b11000;
      end else if(rd_enable) begin
        cmd_next = 8'b10011xxx;
        yield_state_next = 5'b10000;
      end else begin
        cmd_next = 8'b10111000;
        yield_state_next = 5'b00000;
      end
    end else if(yield_state == 5'b00001) begin
      cmd_next = 8'b10111000;
      yield_state_next = 5'b00010;
    end else if(yield_state == 5'b00010) begin
      cmd_next = 8'b10001000;
      yield_state_next = 5'b00011;
    end else if(yield_state == 5'b00011) begin
      __next = 7;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b00100;
    end else if(yield_state == 5'b00100) begin
      if(__next == 0) begin
        cmd_next = 8'b10111000;
        yield_state_next = 5'b00000;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b00100;
      end
    end else if(yield_state == 5'b11000) begin
      __next = 1;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b11001;
    end else if(yield_state == 5'b11001) begin
      if(__next == 0) begin
        cmd_next = 8'b10100xx1;
        yield_state_next = 5'b11010;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b11001;
      end
    end else if(yield_state == 5'b11010) begin
      __next = 1;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b11011;
    end else if(yield_state == 5'b11011) begin
      if(__next == 0) begin
        cmd_next = 8'b10111000;
        yield_state_next = 5'b00000;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b11011;
      end
    end else if(yield_state == 5'b10000) begin
      __next = 1;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b10001;
    end else if(yield_state == 5'b10001) begin
      if(__next == 0) begin
        cmd_next = 8'b10101xx1;
        yield_state_next = 5'b10010;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b10001;
      end
    end else if(yield_state == 5'b10010) begin
      __next = 1;
      cmd_next = 8'b10111000;
      yield_state_next = 5'b10011;
    end else if(yield_state == 5'b10011) begin
      if(__next == 0) begin
        cmd_next = 8'b10111000;
        yield_state_next = 5'b10100;
      end else begin
        __next = __next - 1;
        cmd_next = 8'b10111000;
        yield_state_next = 5'b10011;
      end
    end else begin
      cmd_next = 8'b10111000;
      yield_state_next = 5'b00000;
    end
  end


  always @(posedge CLK or negedge RESET) begin
    if(~RESET) begin
      _ <= 0;
      _ <= 15;
      cmd <= 8'b10111000;
      yield_state <= 5'b01000;
    end else begin
      cmd <= cmd_next;
      _ <= __next;
      yield_state <= yield_state_next;
    end
  end

  assign state = yield_state;

endmodule

