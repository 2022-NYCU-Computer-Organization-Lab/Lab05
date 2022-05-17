`timescale 1ns/1ps
module IDEXE_register (
    input clk_i,
    input rst_i,
    input [31:0] instr_i,
    input [2:0] WB_i,
    input [1:0] Mem_i   ,
    input [2:0] Exe_i,
    input [31:0] data1_i,
    input [31:0] data2_i,
    input [31:0] immgen_i,
    input [3:0] alu_ctrl_instr,
    input [4:0] WBreg_i,
    input [31:0] pc_add4_i,

    output reg [31:0] instr_o,
    output reg [2:0] WB_o,
    output reg [1:0] Mem_o,
    output reg [2:0] Exe_o,
    output reg [31:0] data1_o,
    output reg [31:0] data2_o,
    output reg [31:0] immgen_o,
    output reg [3:0] alu_ctrl_input,
    output reg [4:0] WBreg_o,
    output reg [31:0] pc_add4_o
);
/* Write your code HERE */
endmodule
