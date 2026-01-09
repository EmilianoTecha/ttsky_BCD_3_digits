module bin8_to_bcd(
    input  wire [9:0] bin,
    output reg  [3:0] hun,
    output reg  [3:0] ten,
    output reg  [3:0] uni
);
    integer i;
    reg [19:0] shift; 

    always @(*) begin
        shift = 0;
        shift[9:0] = bin;

        for (i = 0; i < 8; i = i + 1) begin
            if (shift[11:8] >= 5) shift[11:8] = shift[11:8] + 3;
            if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 3;
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;

            shift = shift << 1;
        end

        hun = shift[19:16];
        ten = shift[15:12];
        uni = shift[11:8];
    end
endmodule
