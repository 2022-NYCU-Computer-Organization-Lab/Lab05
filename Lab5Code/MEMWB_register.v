`timescale 1ns/1ps
module MEMWB_register (
    input clk_i,
    input rst_i,
    input [2:0] WB_i,
    input [31:0] DM_i,
    input [31:0] alu_ans_i,
    input [4:0] WBreg_i,
    input [31:0] pc_add4_i,

    output reg [2:0] WB_o,
    output reg [31:0] DM_o,
    output reg [31:0] alu_ans_o,
    output reg [4:0] WBreg_o,
    output reg [31:0] pc_add4_o
);
/* Write your code HERE */
always @(posedge clk_i) begin
    if (~rst_i) begin
        WB_o <= 0;
        DM_o <= 0;
        alu_ans_o <= 0;
        WBreg_o <= 0;
        pc_add4_o <= 0;
    end
    else begin
        WB_o <= WB_i;
        DM_o <= DM_i;
        alu_ans_o <= alu_ans_i;
        WBreg_o <= WBreg_i;
        pc_add4_o <= pc_add4_i;
    end
end
endmodule
