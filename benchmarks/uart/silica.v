

module uart_transmitter
(
  output tx,
  input [8-1:0] data,
  input valid,
  input CLK,
  input RESET
);

  reg [8-1:0] message;
  reg [8-1:0] message_next;
  reg [3-1:0] i;
  reg [3-1:0] i_next;
  reg [2-1:0] yield_state;
  reg [2-1:0] yield_state_next;

  always @(message or i or data or valid or CLK or RESET or yield_state) begin
    i_next = i;
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
      i_next = 7;
      tx = message_next[i_next];
      yield_state_next = 2;
    end else if(i_next == 0) begin
      tx = 1;
      yield_state_next = 0;
    end else begin
      i_next = i_next - 1;
      tx = message_next[i_next];
      yield_state_next = 2;
    end
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      i <= 0;
      yield_state <= 0;
    end else begin
      message <= message_next;
      i <= i_next;
      yield_state <= yield_state_next;
    end
  end


endmodule

