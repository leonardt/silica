`define TIMEOUT 1<<20
`define SOH 8'h1
`define EOT 8'h4
`define ACK 8'h6
`define NAK 8'h15
`define ASCIC 8'h43
`define MAX_TIME (1<<16-1)
/*
//This module behaves as the xmodem sender.
module xmodem_host(
    input clk,
 
    //Interface to outside world.
    input send_data,
    input [7:0] data_length, //in multiples of 128 bytes. Available on the clock cycle that send_data is valid. 
    output [7:0] data_addr, //Which of the 'data_length' 128 byte chuncks
    output [6:0] byte_addr, //Which byte of the 128 byte chunk
    input [7:0] data, //  0 latency available from data_addr, and byte_addr
    output done, //Indicates the data was successfully sent
 
    //Interface to xmodem_receiver
    output tx,
    input rx
);

    localparam WAIT_FOR_SEND = 2'h0,
               WAIT_FOR_HOST = 2'h1,
               SEND_MESSAGE = 2'h2,
               WAIT_FOR_MESSAGE = 2'h3;
    
    always @(*) begin
        get_response = 1'b0;
        case(CS):
            WAIT_FOR_SEND begin
                NS = send_data ? WAIT_FOR_HOST : WAIT_FOR_SEND;
                get_response = send_data;
            end
            WAIT_FOR_HOST begin
                NS = host_ready ? SEND_MESSAGE : WAIT_FOR_HOST;
            end
            SEND_MESSAGE begin
                NS = WAIT_FOR_MESSAGE;
            end
            WAIT_FOR_MESSAGE begin
                NS = message_sent ? WAIT_FOR_RESPONSE : WAIT_FOR_MESSAGE;
                get_response = message_sent;
            end
            WAIT_FOR_RESPONSE begin
                NS = message_done ? (is_last ? WAIT_FOR_SEND : SEND_MESSAGE) : WAIT_FOR_MESSAGE;
            end
    end

    reg [7:0] data_addr_cur;
    
    wire send_message;
    assign send_message = (CS==SEND_MESSAGE);
    assign done = message_sent & is_list;


    wire get_response;
    wire saw_ACK;
    wire saw_NAK
    wire saw_C;
    wire timed_out;
    wire [7:0] response;
    wire response_valid;
    assign saw_ACK = response_valid & (response == `ACK)
    assign saw_NAK = response_valid & (response == `NAK)
    assign saw_C = response_valid & (response == `ASCIC)

    byte_rx byte_rx_inst(
        .clk(clk),
        .get_response(get_response),
        .data(response),
        .data_valid(response_valid),
        .rx(rx)
    )


endmodule


//triggered by get_response, then returns the data
module byte_rx(
    input clk,
    input get_response,
    output reg [7:0] data,
    output data_valid,

    input rx,
)

endmodule
*/

//This will send a full message
module message_tx(
    input clk,
    input send_message,
    input [7:0] data_addr,
    output message_sent,
       
    output [6:0] byte_addr,
    input [7:0] data,
 
    output tx
);



    localparam WAIT=0,
               SEND_SOH=1,
               SEND_DP1=2,
               SEND_DP2=3,
               SEND_DATA=4,
               SEND_CHECKSUM=5;

    reg [3:0] CS = WAIT;
    reg [3:0] NS;

    reg [6:0] data_cnt = 7'h0;
    reg [6:0] data_cnt_next;
    assign byte_addr = data_cnt;
   
    wire is_last;
    assign is_last = (data_cnt == 7'h7f);

    wire uart_send;
    wire uart_ready;
    
    reg [7:0] check_sum = 8'h0;
    reg [7:0] check_sum_next;

    reg [7:0] uart_byte;
    always @(*) begin
        data_cnt_next = 7'h0;
        check_sum_next = 8'h0;
        message_sent = 1'b0;
        uart_send = 1'b0;
        uart_byte = 8'h0;
        case(CS)
            WAIT : begin
                NS = send_message ? SEND_SOH : WAIT;
                uart_send = send_message;
                uart_byte = `SOH;
            end
            SEND_SOH : begin
                NS = uart_ready ? SEND_DP1 : SEND_SOH;
                uart_send = uart_ready;
                uart_byte = data_addr;
            end
            SEND_DP1 : begin
                NS = uart_ready ? SEND_DP2 : SEND_DP1;
                uart_send = uart_ready;
                uart_byte = ~data_addr;
            end
            SEND_DP2 : begin
                NS = uart_ready ? SEND_DATA : SEND_DP2;
                uart_send = uart_ready;
                uart_byte = data;
                check_sum_next = data;
            end
            SEND_DATA : begin
                NS = uart_ready & is_last ? SEND_CHECKSUM : SEND_DATA;
                uart_send = uart_ready;
                uart_byte = uart_ready & is_last ? check_sum : data;
                check_sum_next = uart_ready ? (data + check_sum) : check_sum;
                data_cnt_next = uart_ready ? data_cnt + 1'b1 : data_cnt;
            end
            SEND_CHECKSUM : begin
                NS = uart_ready ? WAIT : SEND_CHECKSUM;
                message_sent = uart_ready;
            end
            default : begin
                NS = 4'hx;
            end
        endcase
            
    end
    
    always @(posedge clk) begin
        CS <= NS;
        check_sum <= check_sum_next;
        data_cnt <= data_cnt_next;
    end

    uart_tx uart_tx_inst (
        .clk(clk), 
        .data(uart_byte), 
        .valid(uart_send), 
        .tx(tx), 
        .ready(uart_ready)
    );
    
endmodule

module uart_tx(
    input clk, 
    input [7:0] data, 
    input valid, 
    output tx, 
    output ready
);
    reg [7:0] message;
    reg [2:0] send_cnt = 3'h0; //Was not initialized. 
    reg [1:0] state = 2'h0;
    always @(posedge clk) begin
        case (state)
            2'h0: 
                if (valid) begin
                    message <= data;
                    tx <= 1'b0;  // start bit
                    state <= 2'h1;
                    send_cnt <= 3'h7;
                    ready <= 1'b0;
                end else begin
                    tx <= 1'b1;
                    state <= 2'h0;
                    ready <= 1'b1;
                end
            2'h1:
                begin
                    ready <= 1'b0;
                    tx <= message[send_cnt];
                    send_cnt <= send_cnt - 1'b1;
                    state <= (send_cnt > 0) ? 2'h1 : 2'h2;
                end
            2'h2:
                begin
                    ready <= 1'b0;
                    tx <= 1'b1; // end bit
                    state <= 2'h0;
                end
            default: begin
                ready <= 1'bx;
                tx <= 1'bx; // end bit
                state <= 2'hx;

            end
        endcase
    end
endmodule
