`timescale 1ns/1ps
module IDEXE_register (
    input clk_i,
    input rst_i,
    input [31:0] instr_i,
    input [2:0] WB_i,
    input [1:0] Mem_i,
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
always @(posedge clk_i) begin
    if (~rst_i) begin
        instr_o <= 0;
        WB_o <= 0;
        Mem_o <= 0;
        Exe_o <= 0;
        data1_o <= 0;
        data2_o <= 0;
        immgen_o <= 0;
        alu_ctrl_input <= 0;
        WBreg_o <= 0;
        pc_add4_o <= 0;
    end
    else begin
        instr_o <= instr_i;
        WB_o <= WB_i;
        Mem_o <= Mem_i;
        Exe_o <= Exe_i;
        data1_o <= data1_i;
        data2_o <= data2_i;
        immgen_o <= immgen_i;
        alu_ctrl_input <= alu_ctrl_instr;
        WBreg_o <= WBreg_i;
        pc_add4_o <= pc_add4_i;
    end
end
endmodule
