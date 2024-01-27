`default_nettype none

module tt_um_fpga_hdl_demo_oled (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    assign uo_out[2] = 1'b1;

    PmodOLED_PowerOn oled (
        .clk(clk),
        .rst_n(rst_n),
        .oled_cs(uo_out[0]),
        .oled_sclk(uo_out[3]),
        .oled_sdin(uo_out[1]),
        .oled_sdout(ui_in[0]),
        .oled_dc(uo_out[4]),
        .oled_res(uo_out[5]),
        .oled_vbat(uo_out[6]),
        .oled_vdd(uo_out[7])
    );

endmodule
