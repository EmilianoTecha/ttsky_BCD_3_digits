module top_bcd_display(
    input  wire clk,     // reloj principal
    input  wire rst,     // reset
    output wire [6:0] seg_hundreds,
    output wire [6:0] seg_tens,
    output wire [6:0] seg_units
);

    // -------------------------------
    // Divisor para contar a 4 Hz
    // -------------------------------
    reg [23:0] div;
    wire tick;  

    // Suponiendo clk = 50 MHz
    // 50e6 / 4 = 12,500,000 cuentas
    localparam DIV_MAX = 5_000_000 - 1;

    always @(posedge clk or posedge rst) begin
        if (rst)
            div <= 0;
        else if (div == DIV_MAX)
            div <= 0;
        else
            div <= div + 1;
    end

    assign tick = (div == DIV_MAX);

    // -------------------------------
    // Contador 0–255
    // -------------------------------
    reg [9:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else if (tick)
            counter <= (counter == 999) ? 0 : counter + 1;
    end

    // -------------------------------
    // Binario a BCD (3 dígitos)
    // -------------------------------
    wire [3:0] bcd_hundreds;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_units;

    bin8_to_bcd B2BCD (
        .bin(counter),
        .hun(bcd_hundreds),
        .ten(bcd_tens),
        .uni(bcd_units)
    );

    // -------------------------------
    // Decodificadores 7 segmentos
    // -------------------------------
    sevenseg_decoder D0 (.bcd(bcd_units),    .seg(seg_units));
    sevenseg_decoder D1 (.bcd(bcd_tens),     .seg(seg_tens));
    sevenseg_decoder D2 (.bcd(bcd_hundreds), .seg(seg_hundreds));

endmodule
