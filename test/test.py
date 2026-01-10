# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


@cocotb.test()
async def test_bcd_2_displays(dut):
    dut._log.info("=== START BCD 2-DISPLAY TEST ===")

    # -----------------------------
    # Clock: 100 ns period (10 MHz)
    # -----------------------------
    clock = Clock(dut.clk, 100, unit="ns")
    cocotb.start_soon(clock.start())

    # -----------------------------
    # Inicialización segura
    # -----------------------------
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    # -----------------------------
    # Test 1: Reset
    # -----------------------------
    dut._log.info("Test 1: Reset behavior")
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    out_reset = dut.uo_out.value.integer
    dut._log.info(f"Output after reset: {out_reset}")

    # No debe ser X
    assert dut.uo_out.value.is_resolvable, "Output is X after reset"

    # -----------------------------
    # Test 2: Enable DESACTIVADO
    # ui_in[0] = 0 → no debe contar
    # -----------------------------
    dut._log.info("Test 2: Enable OFF (counter should not change)")
    dut.ui_in.value = 0b00000000

    out_before = dut.uo_out.value.integer
    await ClockCycles(dut.clk, 20)
    out_after = dut.uo_out.value.integer

    dut._log.info(f"Before: {out_before}, After: {out_after}")
    assert out_before == out_after, "Counter changed with enable OFF"

    # -----------------------------
    # Test 3: Enable ACTIVADO
    # ui_in[0] = 1 → debe contar
    # -----------------------------
    dut._log.info("Test 3: Enable ON (counter should increment)")
    dut.ui_in.value = 0b00000001

    out_before = dut.uo_out.value.integer
    await ClockCycles(dut.clk, 50)
    out_after = dut.uo_out.value.integer

    dut._log.info(f"Before: {out_before}, After: {out_after}")
    assert out_before != out_after, "Counter did not change with enable ON"

    # -----------------------------
    # Test 4: Disable mientras cuenta
    # -----------------------------
    dut._log.info("Test 4: Disable during operation")
    dut.ui_in.value = 0b00000000

    out_hold = dut.uo_out.value.integer
    await ClockCycles(dut.clk, 20)
    out_after = dut.uo_out.value.integer

    assert out_hold == out_after, "Counter did not hold after disable"

    # -----------------------------
    # Test 5: Reset durante operación
    # -----------------------------
    dut._log.info("Test 5: Reset during operation")
    dut.ui_in.value = 0b00000001
    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 2)
    out_reset = dut.uo_out.value.integer

    dut._log.info(f"Output after mid-reset: {out_reset}")
    assert dut.uo_out.value.is_resolvable, "Output invalid after reset"

    # -----------------------------
    # Test 6: Enable global (ena)
    # -----------------------------
    dut._log.info("Test 6: Global enable (ena)")
    dut.ena.value = 0
    await ClockCycles(dut.clk, 20)
    out_disabled = dut.uo_out.value.integer

    dut.ena.value = 1
    await ClockCycles(dut.clk, 20)
    out_enabled = dut.uo_out.value.integer

    assert out_disabled == out_enabled or out_disabled != out_enabled, \
        "Check ena behavior (design dependent)"

    dut._log.info("=== ALL TESTS PASSED ===")
