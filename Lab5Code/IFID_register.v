`timescale 1ns/1ps
module IFID_register (
    input clk_i,
    input rst_i,
    input flush,
    input [31:0] address_i,
    input [31:0] instr_i,
    input [31:0] pc_add4_i,
    output reg [31:0] address_o,
    output reg [31:0] instr_o,
    output reg [31:0] pc_add4_o
);
/* Write your code HERE */
// 感覺 flush 對 IFID_register 內部沒什麼關西啊，主要是外面的 control 要全 0

always @(*) begin
    address_o   = address_i;
    instr_o     = instr_i;
    pc_add4_o   = pc_add4_i;
end

endmodule
