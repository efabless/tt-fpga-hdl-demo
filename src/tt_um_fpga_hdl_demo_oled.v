`default_nettype none

module tt_um_fpga_hdl_demo_oled (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    assign uo_out[2] = 1'b1;

    oled_controller oled (
        .clk(clk),
        .reset(~rst_n),
        .data_in(data_to_send),
        .write_enable(write_enable),
        .buffer_full(),
        .spi_cs(uo_out[0]),
        .spi_clk(uo_out[3]),
        .spi_mosi(uo_out[1]),
        .oled_dc(uo_out[4]),
        .oled_res(uo_out[5]),
        .oled_vbat(uo_out[6]),
        .oled_vdd(uo_out[7])
    );

    // Parameters
    parameter CLK_FREQ = 20_000_000; // System clock frequency
    parameter DELAY_500MS = CLK_FREQ / 2; // Number of clock cycles for 500ms delay


    reg [7:0] data_to_send;
    reg write_enable;
    reg [3:0] state; // Simple state machine for sending "hello"
    reg [31:0] delay_counter; // Counter for the initial delay

    // ASCII values for "hello"
    localparam H = 8'h68;
    localparam E = 8'h65;
    localparam L = 8'h6C;
    localparam O = 8'h6F;

    // State definitions
    localparam STATE_DELAY = 0,
               STATE_SEND_H = 1,
               STATE_SEND_E = 2,
               STATE_SEND_L1 = 3,
               STATE_SEND_L2 = 4,
               STATE_SEND_O = 5,
               STATE_DONE = 6;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= STATE_DELAY;
            data_to_send <= 8'd0;
            write_enable <= 1'b0;
            delay_counter <= 0;
        end else begin
            case (state)
                STATE_DELAY: begin
                    if (delay_counter < DELAY_500MS) begin
                        delay_counter <= delay_counter + 1;
                    end else begin
                        state <= STATE_SEND_H; // Move to next state after delay
                    end
                end
                STATE_SEND_H: begin
                    data_to_send <= H;
                    write_enable <= 1'b1;
                    state <= STATE_DELAY;
                    // state <= STATE_SEND_E;
                end
                STATE_SEND_E: begin
                    data_to_send <= E;
                    write_enable <= 1'b1; // Assert write_enable briefly
                    state <= STATE_SEND_L1;
                end
                STATE_SEND_L1: begin
                    data_to_send <= L;
                    write_enable <= 1'b1;
                    state <= STATE_SEND_L2;
                end
                STATE_SEND_L2: begin
                    data_to_send <= L;
                    write_enable <= 1'b1;
                    state <= STATE_SEND_O;
                end
                STATE_SEND_O: begin
                    data_to_send <= O;
                    write_enable <= 1'b1;
                    state <= STATE_DONE;
                end
                STATE_DONE: begin
                    // Finish sending, hold in done state
                    write_enable <= 1'b0;
                end
                default: state <= STATE_DELAY;
            endcase
            if (state != STATE_DELAY) begin
                // Ensure write_enable is only asserted for one cycle
                write_enable <= 1'b0;
            end
        end
    end

endmodule
