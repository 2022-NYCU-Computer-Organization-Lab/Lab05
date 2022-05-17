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
endmodule
