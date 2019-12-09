

module dma
(
  output reg cam_stream_rsc_vld,
  output reg ARVALID,
  output reg error_read_response,
  output reg [8-1:0] cam_stream_rsc_dat,
  output reg [2-1:0] ARBURST,
  output reg [8-1:0] ARLENGTH,
  output reg RREADY,
  output reg [3-1:0] ARSIZE,
  output reg [8-1:0] ARADDR,
  input start_pulse,
  input [8-1:0] addr_input,
  input cam_stream_rsc_rdy,
  input [10-1:0] ctrlreg_width,
  input [10-1:0] ctrlreg_height,
  input [64-1:0] RDATA,
  input RVALID,
  input ARREADY,
  input CLK,
  input RESET
);

  reg [3-1:0] ARSIZE_next;
  reg cam_stream_rsc_vld_next;
  reg error_read_response_next;
  reg ARVALID_next;
  reg [5-1:0] j;
  reg [5-1:0] j_next;
  reg [64-1:0] data;
  reg [64-1:0] data_next;
  reg [10-1:0] num_requests;
  reg [10-1:0] num_requests_next;
  reg [2-1:0] ARBURST_next;
  reg [4-1:0] k;
  reg [4-1:0] k_next;
  reg [8-1:0] ARLENGTH_next;
  reg RREADY_next;
  reg [8-1:0] cam_stream_rsc_dat_next;
  reg [8-1:0] ARADDR_next;
  reg [10-1:0] i;
  reg [10-1:0] i_next;
  reg [3-1:0] yield_state;
  reg [3-1:0] yield_state_next;

  initial begin
    i = 0;
    j = 0;
    k = 0;
  end


  always @(ARSIZE or cam_stream_rsc_vld or error_read_response or ARVALID or j or data or num_requests or ARBURST or k or ARLENGTH or RREADY or cam_stream_rsc_dat or ARADDR or i or start_pulse or addr_input or cam_stream_rsc_rdy or ctrlreg_width or ctrlreg_height or RDATA or RVALID or ARREADY or CLK or RESET or yield_state) begin
    i_next = i;
    ARADDR_next = ARADDR;
    cam_stream_rsc_dat_next = cam_stream_rsc_dat;
    RREADY_next = RREADY;
    ARLENGTH_next = ARLENGTH;
    k_next = k;
    ARBURST_next = ARBURST;
    num_requests_next = num_requests;
    data_next = data;
    j_next = j;
    ARVALID_next = ARVALID;
    error_read_response_next = error_read_response;
    cam_stream_rsc_vld_next = cam_stream_rsc_vld;
    ARSIZE_next = ARSIZE;
    if(yield_state == 0) begin
      if(start_pulse) begin
        num_requests_next = ctrlreg_width * ctrlreg_height >> 7;
        i_next = 0;
        if(i_next < num_requests_next) begin
          ARADDR_next = ARADDR_next + 128;
          ARVALID_next = 1;
          if(~ARREADY) begin
            yield_state_next = 1;
          end else begin
            yield_state_next = 2;
          end
        end else begin
          ARADDR_next = 0;
          ARBURST_next = 1;
          ARSIZE_next = 3;
          ARLENGTH_next = 15;
          ARVALID_next = 0;
          RREADY_next = 0;
          cam_stream_rsc_vld_next = 0;
          cam_stream_rsc_dat_next = 0;
          yield_state_next = 0;
        end
      end else begin
        ARADDR_next = 0;
        ARBURST_next = 1;
        ARSIZE_next = 3;
        ARLENGTH_next = 15;
        ARVALID_next = 0;
        RREADY_next = 0;
        cam_stream_rsc_vld_next = 0;
        cam_stream_rsc_dat_next = 0;
        yield_state_next = 0;
      end
    end else if(yield_state == 1) begin
      if(~ARREADY) begin
        yield_state_next = 1;
      end else begin
        yield_state_next = 2;
      end
    end else if(yield_state == 2) begin
      ARVALID_next = 0;
      j_next = 0;
      RREADY_next = 1;
      if(~RVALID) begin
        yield_state_next = 3;
      end else begin
        yield_state_next = 4;
      end
    end else if(yield_state == 3) begin
      if(~RVALID) begin
        yield_state_next = 3;
      end else begin
        yield_state_next = 4;
      end
    end else if(yield_state == 4) begin
      RREADY_next = 0;
      data_next = RDATA;
      k_next = 0;
      cam_stream_rsc_dat_next = data_next[0:9];
      data_next = data_next >> 8;
      cam_stream_rsc_vld_next = 1;
      if(~cam_stream_rsc_rdy) begin
        yield_state_next = 5;
      end else begin
        yield_state_next = 6;
      end
    end else if(yield_state == 5) begin
      if(~cam_stream_rsc_rdy) begin
        yield_state_next = 5;
      end else begin
        yield_state_next = 6;
      end
    end else begin
      cam_stream_rsc_vld_next = 0;
      k_next = k_next + 1;
      if(k_next < 8) begin
        cam_stream_rsc_dat_next = data_next[0:9];
        data_next = data_next >> 8;
        cam_stream_rsc_vld_next = 1;
        if(~cam_stream_rsc_rdy) begin
          yield_state_next = 5;
        end else begin
          yield_state_next = 6;
        end
      end else begin
        j_next = j_next + 1;
        if(j_next < 16) begin
          RREADY_next = 1;
          if(~RVALID) begin
            yield_state_next = 3;
          end else begin
            yield_state_next = 4;
          end
        end else begin
          i_next = i_next + 1;
          if(i_next < num_requests_next) begin
            ARADDR_next = ARADDR_next + 128;
            ARVALID_next = 1;
            if(~ARREADY) begin
              yield_state_next = 1;
            end else begin
              yield_state_next = 2;
            end
          end else begin
            ARADDR_next = 0;
            ARBURST_next = 1;
            ARSIZE_next = 3;
            ARLENGTH_next = 15;
            ARVALID_next = 0;
            RREADY_next = 0;
            cam_stream_rsc_vld_next = 0;
            cam_stream_rsc_dat_next = 0;
            yield_state_next = 0;
          end
        end
      end
    end
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      ARADDR_next = 0;
      ARBURST_next = 1;
      ARSIZE_next = 3;
      ARLENGTH_next = 15;
      ARVALID_next = 0;
      RREADY_next = 0;
      cam_stream_rsc_vld_next = 0;
      cam_stream_rsc_dat_next = 0;
      yield_state_next = 0;
      ARSIZE <= ARSIZE_next;
      cam_stream_rsc_vld <= cam_stream_rsc_vld_next;
      error_read_response <= error_read_response_next;
      ARVALID <= ARVALID_next;
      j <= j_next;
      data <= data_next;
      num_requests <= num_requests_next;
      ARBURST <= ARBURST_next;
      k <= k_next;
      ARLENGTH <= ARLENGTH_next;
      RREADY <= RREADY_next;
      cam_stream_rsc_dat <= cam_stream_rsc_dat_next;
      ARADDR <= ARADDR_next;
      i <= i_next;
      yield_state <= yield_state_next;
    end else begin
      ARSIZE <= ARSIZE_next;
      cam_stream_rsc_vld <= cam_stream_rsc_vld_next;
      error_read_response <= error_read_response_next;
      ARVALID <= ARVALID_next;
      j <= j_next;
      data <= data_next;
      num_requests <= num_requests_next;
      ARBURST <= ARBURST_next;
      k <= k_next;
      ARLENGTH <= ARLENGTH_next;
      RREADY <= RREADY_next;
      cam_stream_rsc_dat <= cam_stream_rsc_dat_next;
      ARADDR <= ARADDR_next;
      i <= i_next;
      yield_state <= yield_state_next;
    end
  end


endmodule

