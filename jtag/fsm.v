
module fsm(input tms, output [3:0] state, input CLK, input RESET);


reg [3:0] curr_state;
reg [3:0] next_state;
assign state = curr_state;


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin

        curr_state <= 15;

    end else begin
        curr_state <= next_state;

    end
end
always @(*) begin

    if (state == 15) begin
        if ((tms == 0)) begin
            next_state = 12;
        end else begin
            next_state = 15;
        end
    end else if (state == 12) begin
        if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
    end else if (state == 7) begin
        if ((tms == 1)) begin
            next_state = 4;
        end else begin
            next_state = 6;
        end
    end else if (state == 4) begin
        if ((tms == 1)) begin
            next_state = 15;
        end else begin
            next_state = 14;
        end
    end else if (state == 6) begin
        if ((tms == 1)) begin
            next_state = 1;
        end else begin
            next_state = 2;
        end
    end else if (state == 2) begin
        if ((tms == 1)) begin
            next_state = 1;
        end else begin
            next_state = 2;
        end
    end else if (state == 1) begin
        if ((tms == 0)) begin
            next_state = 3;
        end else begin
            next_state = 5;
        end
    end else if (state == 5) begin
        if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
    end else if (state == 3) begin
        if ((tms == 0)) begin
            next_state = 3;
        end else begin
            next_state = 0;
        end
    end else if (state == 0) begin
        if ((tms == 0)) begin
            next_state = 2;
        end else begin
            next_state = 5;
        end
    end else if (state == 14) begin
        if ((tms == 1)) begin
            next_state = 9;
        end else begin
            next_state = 10;
        end
    end else if (state == 10) begin
        if ((tms == 1)) begin
            next_state = 9;
        end else begin
            next_state = 10;
        end
    end else if (state == 9) begin
        if ((tms == 0)) begin
            next_state = 11;
        end else begin
            next_state = 13;
        end
    end else if (state == 13) begin
        if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
    end else if (state == 11) begin
        if ((tms == 0)) begin
            next_state = 11;
        end else begin
            next_state = 8;
        end
    end else if (state == 8) begin
        if ((tms == 0)) begin
            next_state = 10;
        end else begin
            next_state = 13;
        end
    end
end
endmodule
    