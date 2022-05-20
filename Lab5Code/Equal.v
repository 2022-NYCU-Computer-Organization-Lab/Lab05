`timescale 1ns/1ps

module Equal(
    input        [32-1:0]   src1,          // 32 bits source 1          (input)
    input        [32-1:0]   src2,          // 32 bits source 2          (input)
    output reg              zero           // 1 bit when the output is 0, zero must be set (output)
);


/* Write your code HERE */
always @(*) begin
    zero = (src1 == src2) ? 1'b1 : 1'b0;
end

endmodule
