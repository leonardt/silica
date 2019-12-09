module Downsample
(
  output [16-1:0] data_out_data,
  output data_in_ready,
  output data_out_valid,
  input data_in_valid,
  input [16-1:0] data_in_data,
  input data_out_ready,
  input CLK,
  input RESET
);

  reg keep;
  reg [5-1:0] y;
  reg [5-1:0] y_next;
  reg [5-1:0] x;
  reg [5-1:0] x_next;
  reg yield_state;
  reg yield_state_next;

  initial begin
    x = 0;
    y = 0;
  end


  always @(y or x or data_in_valid or data_in_data or data_out_ready or CLK or RESET or yield_state) begin
    x_next = x;
    y_next = y;
    if(yield_state == 0) begin
      if(y_next == 31) begin
        y_next = 0;
        x_next = 0;
        keep = (x_next % 2 == 0) & (y_next % 2 == 0);
        data_out_valid = keep & data_in_valid;
        data_out_data = data_in_data;
        data_in_ready = data_out_ready | ~keep;
        if(data_in_ready & data_in_valid) begin
          if(x_next == 31) begin
            yield_state_next = 0;
          end else begin
            x_next = x_next + 1;
            yield_state_next = 1;
          end
        end else begin
          yield_state_next = 1;
        end
      end else begin
        y_next = y_next + 1;
        x_next = 0;
        keep = (x_next % 2 == 0) & (y_next % 2 == 0);
        data_out_valid = keep & data_in_valid;
        data_out_data = data_in_data;
        data_in_ready = data_out_ready | ~keep;
        if(data_in_ready & data_in_valid) begin
          if(x_next == 31) begin
            yield_state_next = 0;
          end else begin
            x_next = x_next + 1;
            yield_state_next = 1;
          end
        end else begin
          yield_state_next = 1;
        end
      end
    end else begin
      keep = (x_next % 2 == 0) & (y_next % 2 == 0);
      data_out_valid = keep & data_in_valid;
      data_out_data = data_in_data;
      data_in_ready = data_out_ready | ~keep;
      if(data_in_ready & data_in_valid) begin
        if(x_next == 31) begin
          yield_state_next = 0;
        end else begin
          x_next = x_next + 1;
          yield_state_next = 1;
        end
      end else begin
        yield_state_next = 1;
      end
    end
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      y_next = 0;
      x_next = 0;
      keep = (x_next % 2 == 0) & (y_next % 2 == 0);
      data_out_valid = keep & data_in_valid;
      data_out_data = data_in_data;
      data_in_ready = data_out_ready | ~keep;
      if(data_in_ready & data_in_valid) begin
        if(x_next == 31) begin
          yield_state_next = 0;
        end else begin
          x_next = x_next + 1;
          yield_state_next = 1;
        end
      end else begin
        yield_state_next = 1;
      end
      y <= y_next;
      x <= x_next;
      yield_state <= yield_state_next;
    end else begin
      y <= y_next;
      x <= x_next;
      yield_state <= yield_state_next;
    end
  end


endmodule
