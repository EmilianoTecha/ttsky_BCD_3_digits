/*
 * Copyright (c) 2026 Emiliano Alcala
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_emiliano_bcd_display (
    input  wire [7:0] ui_in,    // no usados
    output wire [7:0] uo_out,   // seg_units
    input  wire [7:0] uio_in,   // no usados
    output wire [7:0] uio_out,  // seg_tens
    output wire [7:0] uio_oe,   // habilitación IOs
    input  wire       ena,      // siempre 1
    input  wire       clk,      // reloj
    input  wire       rst_n      // reset activo bajo
);

    // -------------------------------
    // Reset activo alto para el diseño
    // -------------------------------
    wire rst = ~rst_n;

    // -------------------------------
    // Señales internas
    // -------------------------------
    wire [6:0] seg_units;
    wire [6:0] seg_tens;
    wire [6:0] seg_hundreds; // no usado externamente

    // -------------------------------
    // Instancia del diseño principal
    // -------------------------------
    top_bcd_display dut (
        .clk(clk),
        .rst(rst),
        .seg_units(seg_units),
        .seg_tens(seg_tens),
        .seg_hundreds(seg_hundreds)
    );

    // -------------------------------
    // Mapeo a pines Tiny Tapeout
    // -------------------------------
    assign uo_out[6:0]  = seg_units;
    assign uo_out[7]    = 1'b0;

    assign uio_out[6:0] = seg_tens;
    assign uio_out[7]   = 1'b0;

    assign uio_oe       = 8'b1111_1111; // todos como salida

    // -------------------------------
    // Evitar warnings por señales no usadas
    // -------------------------------
    wire _unused = &{ui_in, uio_in, ena, seg_hundreds, 1'b0};

endmodule
