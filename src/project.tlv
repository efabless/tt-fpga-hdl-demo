\m5_TLV_version 1d: tl-x.org
\m5

   // *******************************************
   // * For ChipCraft Course                    *
   // * Replace this file with your own design. *
   // *******************************************

   use(m5-1.0)
   var(target, ASIC)   /// Note, the FPGA CI flow will set this to FPGA.
\SV
/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    m5_if_eq(m5_target, FPGA, ['/']['*'])   // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    m5_if_eq(m5_target, FPGA, ['*']['/'])
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in;  // Example: ou_out is ui_in
  m5_if_eq(m5_target, FPGA, ['/']['*'])   // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
  assign uio_out = 0;
  assign uio_oe  = 0;
  m5_if_eq(m5_target, FPGA, ['*']['/'])

endmodule
