`timescale 1ns/1ps
module IFID_register (
    input clk_i,
    input rst_i,
    input flush,
    input write,
    input [31:0] address_i,
    input [31:0] instr_i,
    input [31:0] pc_add4_i,
    output reg [31:0] address_o,
    output reg [31:0] instr_o,
    output reg [31:0] pc_add4_o
);
/* Write your code HERE */
/*
    if clk come
        1. if rst == 0: all reset to 0
        2. if flush == 1: all flush to 0
        3. write = 1: load
        else: remain
*/

always @(posedge clk_i) begin
    if (~rst_i) begin
        address_o   <= 0;
        instr_o     <= 0;
        pc_add4_o   <= 0;
    end
    else if (flush == 1'b1) begin
        address_o   <= 0;
        instr_o     <= 0;
        pc_add4_o   <= 0;
    end
    else if ( write == 1'b1 ) begin
        address_o   <= address_i;
        instr_o     <= instr_i;
        pc_add4_o   <= pc_add4_i;
    end
    // else remain
end

endmodule
