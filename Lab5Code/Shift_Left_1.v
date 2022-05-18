`timescale 1ns/1ps

module Shift_Left_1(
    input  		[32-1:0] data_i,
    output reg  [32-1:0] data_o
    );
/* Write your code HERE */
integer i;
always @(*) begin
    data_o[0] <= 1'b0;
    for (i = 1; i < 32; i = i + 1) begin
        data_o[i] <= data_i[i-1];
    end
end
endmodule
