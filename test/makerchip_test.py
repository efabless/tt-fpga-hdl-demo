# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

# Test bench for Tiny Tapeout for any design using the following Makerchip-compatible interface.
# The IOs are:
#   Inputs: none
#   Outputs:
#      uo_out[0]: passed: 1 bit output, set to 1 when the test passes
#      uo_out[1]: failed: 1 bit output, set to 1 when the test fails

@cocotb.test()
async def test_makerchip(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0

  await ClockCycles(dut.clk, 10)
  
  dut.rst_n.value = 1

  # run until passed or failed or max cycles
  max_cyc = 1000
  cyc = 0
  while cyc < max_cyc:
    
    await ClockCycles(dut.clk, 1)

    # Pass blindly after 20 cycles.
    passed = cyc > 20
    failed = False
    # You might connect passed/failed from Makerchip to uo_out pins, e.g.:
    # passed = dut.uo_out.value & 1
    # failed = dut.uo_out.value & 2
    if passed:
      dut._log.info("Passed")
      break

    assert not failed

    cyc += 1
    assert cyc < max_cyc
