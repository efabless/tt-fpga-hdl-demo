`default_nettype none

module tt_um_fpga_hdl_demo (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    assign uo_out[7:4] = 4'b0;
    assign uo_out[2] = 1'b0;

    // Parameters
    parameter NUM_BYTES = 4; // Number of bytes to send
    parameter BYTE_SEQ = {8'hA5, 8'h5A, 8'h3C, 8'hC3}; // Example byte sequence

    // State definition
    localparam IDLE = 2'b00,
               SEND_BYTE = 2'b01,
               WAIT_DONE = 2'b10,
               NOT_USED = 2'b11;

    // SPI Master instantiation
    reg start_spi;
    reg [7:0] data_to_send;
    wire [7:0] data_received;
    wire done_spi;

    spi_master spi_master_inst(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_spi),
        .data_in(data_to_send),
        .data_out(data_received),
        .done(done_spi),
        .sclk(uo_out[3]),
        .mosi(uo_out[1]),
        .miso(uo_in[0]),
        .cs(uo_out[0])
    );

    // State machine for controlling SPI master to send a sequence of bytes
    reg [1:0] state;
    reg [3:0] byte_index; // Counter for the bytes in the sequence

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            byte_index <= 0;
            start_spi <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (byte_index < NUM_BYTES) begin
                        data_to_send <= BYTE_SEQ[8*byte_index +: 8]; // Select the next byte to send
                        start_spi <= 1;
                        state <= SEND_BYTE;
                    end
                end
                SEND_BYTE: begin
                    start_spi <= 0; // Only pulse start
                    state <= WAIT_DONE;
                end
                WAIT_DONE: begin
                    if (done_spi) begin
                        byte_index <= byte_index + 1; // Move to the next byte
                        state <= IDLE;
                    end
                end
                NOT_USED: begin
                end
            endcase
        end
    end

endmodule
