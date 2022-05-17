`timescale 1ns/1ps

module oneBitFullAdder(
    input src1,
    input src2,
    input cin,
    output sum,
    output cout
);

wire w1, w2, w3, w4;

assign w4 = src1 ^ src2;
assign sum = w4 ^ cin;

assign w1 = src1 & src2;
assign w2 = src1 & cin;
assign w3 = src2 & cin;
assign cout = w1 | w2 | w3;

endmodule


module Adder(
    input  [32-1:0] src1_i,
    input  [32-1:0] src2_i,
    output reg [32-1:0] sum_o
);

/* Write your code HERE */
wire tmpCin[33];
wire result[33];

assign tmpCin[0] = 1'b0;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin: myAdder
        oneBitFullAdder Adder(src1_i[i], src2_i[i], tmpCin[i], result[i], tmpCin[i+1]);
    end
endgenerate

integer j;
always @(*) begin
    for (j = 0; j < 32; j = j + 1) begin
        sum_o[j] <= result[j];
    end
end
endmodule
