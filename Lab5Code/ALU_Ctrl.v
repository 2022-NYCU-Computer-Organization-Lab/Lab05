`timescale 1ns/1ps

module ALU_Ctrl(
    input       [4-1:0] instr,
    input       [2-1:0] ALUOp,
    output reg  [4-1:0] ALU_Ctrl_o
);
/* Write your code HERE */
wire [2:0] func3, I30;
assign func3 = instr[2:0];
assign I30 = instr[3];

always @ (*) begin
    ALU_Ctrl_o =    (I30 == 1'b0 && func3 == 3'b000 && ALUOp == 2'b10) ? 4'b0010 : // Add
                    (I30 == 1'b0 && func3 == 3'b111 && ALUOp == 2'b10) ? 4'b0000 : // And
                    (I30 == 1'b0 && func3 == 3'b110 && ALUOp == 2'b10) ? 4'b0001 : // Or
                    (I30 == 1'b1 && func3 == 3'b000 && ALUOp == 2'b10) ? 4'b0110 : // Sub
                    (I30 == 1'b0 && func3 == 3'b100 && ALUOp == 2'b10) ? 4'b0011 : // Xor
                    (I30 == 1'b0 && func3 == 3'b010 && ALUOp == 2'b10) ? 4'b0111 : // Slt
                    (func3 == 3'b000 && ALUOp == 2'b11) ? 4'b0010 : // Addi
                    (func3 == 3'b010 && ALUOp == 2'b11) ? 4'b0100 : // Slti
                    (I30 == 1'b0 && func3 == 3'b001 && ALUOp == 2'b11) ? 4'b0101 : // Slli
                    (func3 == 3'b010 && ALUOp == 2'b00) ? 4'b0010 : // Lw and Sw
                    (func3 == 3'b000 && ALUOp == 2'b01) ? 4'b0110 : // Beq
                    4'b0000;
end

endmodule
