`timescale 1ns/1ps

module Imm_Gen(
    input      [31:0] instr_i,
    output reg [31:0] Imm_Gen_o
);

//Internal Signals
wire    [7-1:0] opcode;
wire    [2:0]   func3;
wire    [3-1:0] Instr_field;

assign opcode = instr_i[6:0];
assign func3  = instr_i[14:12];

/* Write your code HERE */
if ( opcode[6:0] == 7'b0010011 and func3 == 3'b000 ) begin // I-type, addi
    Imm_Gen_o = {{20{instr_i[31]}}, instr_i[31:20]};
end
else if ( opcode[6:0] == 7'b0000011 ) begin // I-type, load
    Imm_Gen_o = {{20{instr_i[31]}}, instr_i[31:20]};
end
else if ( opcode[6:0] == 7'b0010011 and func3 == 3'b010 ) begin  // I-type, slti
    Imm_Gen_o = {{20{instr_i[31]}}, instr_i[31:20]};
end 
else if ( opcode[6:0] == 7'b0010011 and func3 == 3'b001 ) begin  // I-type, slli
    Imm_Gen_o = {{27{instr_i[24]}}, instr_i[24:20]};
end
else if ( opcode[6:0] == 7'b0100011 ) begin // S-type
    Imm_Gen_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
end
else if ( opcode[6:0] == 7'b1100011 ) begin // SB-type
    Imm_Gen_o = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
end
else if ( opcode[6:0] == 7'b1101111 ) begin // jal - UJ-type, need left shift 1!!
    Imm_Gen_o = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
end
else if ( opcode[6:0] == 7'b1100111 ) begin // jalr - I-type
    Imm_Gen_o = Imm_Gen_o= {{20{instr_i[31]}}, instr_i[31:20]};
end

endmodule
