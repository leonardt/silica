module downsample_verilog(
    input data_in_valid,
    input [15:0] data_in_data,
    output data_in_ready,
    output data_out_valid,
    output [15:0] data_out_data,
    input data_out_ready,
    input CLK
);
reg [4:0] x;
reg [4:0] y;
reg [4:0] x_next;
reg [4:0] y_next;


assign data_out_valid = (x % 2 == 0) & (y % 2 == 0) & data_in_valid;
assign data_in_ready = data_out_ready;
assign data_out_data = data_in_data;

always @(*) begin
    if (data_in_valid & data_out_ready) begin
        x_next = x + 1;
        if (x == 31) begin
            y_next = y + 1;
        end else begin
            y_next = y;
        end
    end else begin
        x_next = x;
        y_next = y;
    end
end


always @(posedge CLK) begin
    x <= x_next;
    y <= y_next;
end
endmodule
