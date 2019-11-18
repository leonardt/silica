

module uart_transmitter
(
  output tx,
  input [8-1:0] data,
  input valid,
  input CLK,
  input RESET
);

  reg [3-1:0] i;
  reg [8-1:0] message;
  reg [8-1:0] message_next;
  reg [4-1:0] yield_state;
  reg [4-1:0] yield_state_next;

  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_next = message;
    if(yield_state == 0) begin
      if(valid) begin
        message_next = data;
        tx = 0;
        yield_state_next = 1;
      end else begin
        tx = 1;
        yield_state_next = 0;
      end
    end else if(yield_state == 1) begin
      tx = message_next[7];
      yield_state_next = 2;
    end else if(yield_state == 2) begin
      tx = message_next[6];
      yield_state_next = 3;
    end else if(yield_state == 3) begin
      tx = message_next[5];
      yield_state_next = 4;
    end else if(yield_state == 4) begin
      tx = message_next[4];
      yield_state_next = 5;
    end else if(yield_state == 5) begin
      tx = message_next[3];
      yield_state_next = 6;
    end else if(yield_state == 6) begin
      tx = message_next[2];
      yield_state_next = 7;
    end else if(yield_state == 7) begin
      tx = message_next[1];
      yield_state_next = 8;
    end else if(yield_state == 8) begin
      tx = message_next[0];
      yield_state_next = 9;
    end else begin
      tx = 1;
      yield_state_next = 0;
    end
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      yield_state <= 0;
    end else begin
      message <= message_next;
      yield_state <= yield_state_next;
    end
  end


endmodule

