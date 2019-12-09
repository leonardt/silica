module DownsampleChannel
(
  output data_out_valid,
  output data_in_ready,
  output [16-1:0] data_out_data,
  input [16-1:0] data_in_data,
  input data_in_valid,
  input data_out_ready,
  input CLK
);

  reg [16-1:0] data;
  reg [16-1:0] data_next;
  reg [5-1:0] x;
  reg [5-1:0] x_next;
  reg [5-1:0] y;
  reg [5-1:0] y_next;
  reg keep;
  reg keep_next;
  reg [3-1:0] yield_state;
  reg [3-1:0] yield_state_next;

  initial begin
    x = 0;
    x_next = 0;
    y = 0;
    y_next = 0;
    yield_state = 0;
  end


  always @(*) begin
    keep_next = keep;
    y_next = y;
    x_next = x;
    data_next = data;
    if(yield_state == 0) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      y_next = 0;
      x_next = 0;
      keep_next = (x_next % 2 == 0) & (y_next % 2 == 0);
      if(keep_next & ~data_out_ready | ~data_in_valid) begin
        yield_state_next = 2;
      end else begin
        data_in_ready = 1;
        if(data_in_valid) begin
          data_next = data_in_data;
          if(keep_next) begin
            data_out_valid = 1;
            data_out_data = data_next;
            if(data_out_ready) begin
              yield_state_next = 5;
            end 
          end else begin
            yield_state_next = 5;
          end
        end 
      end
    end else if(yield_state == 1) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      y_next = 0;
      x_next = 0;
      keep_next = (x_next % 2 == 0) & (y_next % 2 == 0);
      if(keep_next & ~data_out_ready | ~data_in_valid) begin
        yield_state_next = 2;
      end else begin
        data_in_ready = 1;
        if(data_in_valid) begin
          data_next = data_in_data;
          if(keep_next) begin
            data_out_valid = 1;
            data_out_data = data_next;
            if(data_out_ready) begin
              yield_state_next = 5;
            end 
          end else begin
            yield_state_next = 5;
          end
        end 
      end
    end else if(yield_state == 2) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      if(keep_next & ~data_out_ready | ~data_in_valid) begin
        yield_state_next = 2;
      end else begin
        data_in_ready = 1;
        if(data_in_valid) begin
          data_next = data_in_data;
          if(keep_next) begin
            data_out_valid = 1;
            data_out_data = data_next;
            if(data_out_ready) begin
              yield_state_next = 5;
            end 
          end else begin
            yield_state_next = 5;
          end
        end 
      end
    end else if(yield_state == 3) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      data_in_ready = 1;
      if(data_in_valid) begin
        data_next = data_in_data;
        if(keep_next) begin
          data_out_valid = 1;
          data_out_data = data_next;
          if(data_out_ready) begin
            yield_state_next = 5;
          end else begin
            yield_state_next = 4;
          end
        end else begin
          yield_state_next = 5;
        end
      end else begin
        yield_state_next = 3;
      end
    end else if(yield_state == 4) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      data_out_valid = 1;
      data_out_data = data_next;
      if(data_out_ready) begin
        yield_state_next = 5;
      end else begin
        yield_state_next = 4;
      end
    end else if(yield_state == 5) begin
      data_in_ready = 0;
      data_out_valid = 0;
      data_out_data = 0;
      if(x_next == 31) begin
        if(y_next == 31) begin
          y_next = 0;
          x_next = 0;
          keep_next = (x_next % 2 == 0) & (y_next % 2 == 0);
          if(keep_next & ~data_out_ready | ~data_in_valid) begin
            yield_state_next = 2;
          end else begin
            data_in_ready = 1;
            if(data_in_valid) begin
              data_next = data_in_data;
              if(keep_next) begin
                data_out_valid = 1;
                data_out_data = data_next;
                if(data_out_ready) begin
                  yield_state_next = 5;
                end 
              end else begin
                yield_state_next = 5;
              end
            end 
          end
        end else begin
          y_next = y_next + 1;
          x_next = 0;
          keep_next = (x_next % 2 == 0) & (y_next % 2 == 0);
          if(keep_next & ~data_out_ready | ~data_in_valid) begin
            yield_state_next = 2;
          end else begin
            data_in_ready = 1;
            if(data_in_valid) begin
              data_next = data_in_data;
              if(keep_next) begin
                data_out_valid = 1;
                data_out_data = data_next;
                if(data_out_ready) begin
                  yield_state_next = 5;
                end 
              end else begin
                yield_state_next = 5;
              end
            end 
          end
        end
      end else begin
        x_next = x_next + 1;
        keep_next = (x_next % 2 == 0) & (y_next % 2 == 0);
        if(keep_next & ~data_out_ready | ~data_in_valid) begin
          yield_state_next = 2;
        end else begin
          data_in_ready = 1;
          if(data_in_valid) begin
            data_next = data_in_data;
            if(keep_next) begin
              data_out_valid = 1;
              data_out_data = data_next;
              if(data_out_ready) begin
                yield_state_next = 5;
              end 
            end else begin
              yield_state_next = 5;
            end
          end 
        end
      end
    end 
  end


  always @(posedge CLK) begin
    data = data_next;
    x = x_next;
    y = y_next;
    keep = keep_next;
    yield_state = yield_state_next;
  end


endmodule
