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
        .data_in(),
        .write_enable(),
        .buffer_full(),
        .spi_cs(uo_out[0]),
        .spi_clk(uo_out[3]),
        .spi_mosi(uo_out[1]),
        .oled_dc(uo_out[4]),
        .oled_res(uo_out[5]),
        .oled_vbat(uo_out[6]),
        .oled_vdd(uo_out[7])
    );

endmodule
