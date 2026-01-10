<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 2-digit BCD counter with 7-segment display decoding, designed for the SkyWater 130 nm process and prepared for Tiny Tapeout submission.

The design includes an internal clock divider that generates a slower counting tick from the main system clock. On each valid tick, a decimal counter increments its value when the enable signal is active. The counter resets to zero when the active-low reset (`rst_n`) is asserted.

The binary counter value is converted to Binary-Coded Decimal (BCD) using a combinational shift-and-add-3 algorithm, producing separate BCD digits for tens and units. Each BCD digit is then decoded into its corresponding 7-segment representation.

The outputs drive two 7-segment displays, allowing the visualization of decimal values from 00 to 99. The design is fully synchronous and uses only synthesizable RTL constructs, making it suitable for ASIC implementation.

## How to test

The design is verified using a cocotb-based testbench. The test environment provides a system clock, applies reset conditions, and controls the enable signal through the input pins.

During simulation, the following behaviors are verified:
- Proper reset behavior (counter returns to zero)
- No counting when the enable signal is inactive
- Correct counting when the enable signal is active
- Stable outputs when the enable signal is deasserted
- Correct recovery from reset during operation

All stimulus and verification logic is handled in Python using cocotb, while the Verilog testbench only instantiates the design under test.

Explain how to use your project

### External hardware

This design is intended to be used with external 7-segment displays. Each display requires seven output signals corresponding to segments A through G.

The outputs can be connected directly to common-cathode or common-anode displays using appropriate current-limiting resistors, depending on the display type. No external multiplexing circuitry is required, as each digit is driven independently.

A system clock source and reset signal must be provided externally. The enable signal can be driven by a push button or logic input to control when the counter is active.

