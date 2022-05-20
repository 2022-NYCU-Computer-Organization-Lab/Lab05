`timescale 1ns/1ps

module Decoder(
    input [32-1:0]  instr_i,
    output reg         Branch,
    output reg         ALUSrc,
    output reg         RegWrite,
    output reg [2-1:0] ALUOp,
    output reg         MemRead,
    output reg         MemWrite,
    // output reg         MemtoReg,
    output reg [2-1:0] WriteBack,
    output reg         Jump
);

//Internal Signals
wire    [7-1:0]     opcode;
wire    [3-1:0]     funct3;
wire    [3-1:0]     Instr_field;
wire    [9:0]       Ctrl_o;

/* Write your code HERE */
assign opcode = instr_i[6:0];
always @(*) begin
    RegWrite <= (opcode == 7'b0110011) ? 1'b1 :
                (opcode == 7'b0010011) ? 1'b1 :
                (opcode == 7'b0000011) ? 1'b1 :
                (opcode == 7'b1101111) ? 1'b1 :
                1'b0;
end

always @(*) begin
    Branch <=   (opcode == 7'b1100011) ? 1'b1 :
                1'b0;
end

always @(*) begin
    Jump <=     (opcode == 7'b1101111) ? 1'b1 :
                1'b0;
end

// WriteBack :
//  2'b00 : ALUresult
//  2'b01 : MEMWB_DM
//  2'b10 : pc_add4
always @(*) begin
    WriteBack <=    (opcode == 7'b0110011) ? 2'b00 :
                    (opcode == 7'b0010011) ? 2'b00 :
                    (opcode == 7'b0000011) ? 2'b01 :
                    (opcode == 7'b1101111) ? 2'b10 :
                    2'b00;
end

always @(*) begin
    MemRead =   (opcode == 7'b0000011) ? 1'b1 :
                1'b0;
end

always @(*) begin
    MemWrite =  (opcode == 7'b0100011) ? 1'b1 :
                1'b0;
end

always @(*) begin
    ALUSrc =    (opcode == 7'b0010011) ? 1'b1 :
                (opcode == 7'b0000011) ? 1'b1 :
                (opcode == 7'b0100011) ? 1'b1 :
                1'b0;
end

always @(*) begin
    ALUOp =     (opcode == 7'b0110011) ? 2'b10 :
                (opcode == 7'b0010011) ? 2'b11 :
                (opcode == 7'b0000011) ? 2'b00 :
                (opcode == 7'b0100011) ? 2'b00 :
                (opcode == 7'b1100011) ? 2'b01 :
                2'b00;
end

endmodule
