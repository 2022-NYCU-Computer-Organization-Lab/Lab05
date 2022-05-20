`timescale 1ns/1ps
module Pipeline_CPU(
    clk_i,
    rst_i
);

//I/O port
input         clk_i;
input         rst_i;

// Again, these are the signals TAs forgot to gave us
wire [32-1:0] Imm_4 = 4;
wire [32-1:0] Imm_0 = 0;
wire [32-1:0] instr;
wire hazard_control_output_select;
wire [24-1:0] Mux_control_dontcare_i, Mux_control_dontcare_o;
wire [8-1:0] Mux_control_o;

//Internal Signals
wire [31:0] PC_i;
wire [31:0] PC_o;
wire [31:0] MUXMemtoReg_o;
wire [31:0] ALUResult;
wire [31:0] MUXALUSrc_o;
wire [31:0] Decoder_o;
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] Imm_Gen_o;
wire [31:0] ALUSrc1_o;
wire [31:0] ALUSrc2_o;
wire [7:0]  MUX_control_o;

wire [31:0] PC_Add_Immediate;
wire [1:0] ALUOp;
wire PC_write;
wire ALUSrc;
wire RegWrite;
wire Branch;
wire MUXControl; // generated by hazard detection unit
wire Jump;
wire [31:0] SL1_o;
wire [3:0] ALU_Ctrl_o;
wire ALU_zero;
wire Branch_zero;
wire MUXPCSrc;
wire [31:0] DM_o;
wire MemRead, MemWrite;
wire [1:0] WriteBack;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] PC_Add4;

//Pipeline Register Signals
//IFID
wire [31:0] IFID_PC_o;
wire [31:0] IFID_Instr_o;
wire IFID_Write;
wire IFID_Flush;
wire [31:0]IFID_PC_Add4_o;

//IDEXE
wire [31:0] IDEXE_Instr_o;
wire [2:0] IDEXE_WB_o;
wire [1:0] IDEXE_Mem_o;
wire [2:0] IDEXE_Exe_o;
wire [31:0] IDEXE_PC_o;
wire [31:0] IDEXE_RSdata_o;
wire [31:0] IDEXE_RTdata_o;
wire [31:0] IDEXE_ImmGen_o;
wire [3:0] IDEXE_Instr_30_14_12_o;
wire [4:0] IDEXE_Instr_11_7_o;
wire [31:0]IDEXE_PC_add4_o;

//EXEMEM
wire [31:0] EXEMEM_Instr_o;
wire [2:0] EXEMEM_WB_o;
wire [1:0] EXEMEM_Mem_o;
wire [31:0] EXEMEM_PCsum_o;
wire EXEMEM_Zero_o;
wire [31:0] EXEMEM_ALUResult_o;
wire [31:0] EXEMEM_RTdata_o;
wire [4:0]  EXEMEM_Instr_11_7_o;
wire [31:0] EXEMEM_PC_Add4_o;

//MEMWB
wire [2:0] MEMWB_WB_o;
wire [31:0] MEMWB_DM_o;
wire [31:0] MEMWB_ALUresult_o;
wire [4:0]  MEMWB_Instr_11_7_o;
wire [31:0] MEMWB_PC_Add4_o;

assign MUXPCSrc = (Branch & Branch_zero) | Jump;
assign IFID_Flush = (Branch & Branch_zero) | Jump;

// IF
MUX_2to1 MUX_PCSrc(
    .data0_i(PC_Add4),
    .data1_i(PC_Add_Immediate),
    .select_i(MUXPCSrc),
    .data_o(PC_i)
);

// PC_write
ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite(PC_write),
    .pc_i(PC_i),
    .pc_o(PC_o)
);

Adder PC_plus_4_Adder(
    .src1_i(PC_o),
    .src2_i(Imm_4),
    .sum_o(PC_Add4)
);

Instr_Memory IM(
    .addr_i(PC_o),
    .instr_o(instr)
);

IFID_register IFtoID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IFID_Flush),
    .write(IFID_Write),
    .address_i(PC_o),
    .instr_i(instr),
    .pc_add4_i(PC_Add4),
    .address_o(IFID_PC_o),
    .instr_o(IFID_Instr_o),
    .pc_add4_o(IFID_PC_Add4_o)
);

// ID
Hazard_detection Hazard_detection_obj(
    .IFID_regRs(IFID_Instr_o[19:15]),
    .IFID_regRt(IFID_Instr_o[24:20]),
    .IDEXE_regRd(IDEXE_Instr_11_7_o),
    .IDEXE_memRead(IDEXE_Mem_o[1:1]),
    .PC_write(PC_write),
    .IFID_write(IFID_Write),
    .control_output_select(hazard_control_output_select)
);

MUX_2to1 MUX_control(
    .data0_i({Mux_control_dontcare_i, RegWrite, WriteBack, MemRead, MemWrite, ALUSrc, ALUOp}), // This should be Decoder's stuff
    .data1_i(Imm_0),
    .select_i(hazard_control_output_select),
    .data_o({Mux_control_dontcare_o, Mux_control_o})
);

Decoder Decoder(
    .instr_i(IFID_Instr_o),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .WriteBack(WriteBack),
    .Jump(Jump)
);

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(IFID_Instr_o[19:15]),
    .RTaddr_i(IFID_Instr_o[24:20]),
    .RDaddr_i(MEMWB_Instr_11_7_o),
    .RDdata_i(MUXMemtoReg_o),
    .RegWrite_i(MEMWB_WB_o[2:2]), // This should come from MEMWB register_o
    .RSdata_o(RSdata_o),
    .RTdata_o(RTdata_o)
);

Equal equal(
    .src1(RSdata_o),
    .src2(RTdata_o),
    .zero(Branch_zero)
);

Imm_Gen ImmGen(
    .instr_i(IFID_Instr_o),
    .Imm_Gen_o(Imm_Gen_o)
);

Shift_Left_1 SL1(
    .data_i(Imm_Gen_o),
    .data_o(SL1_o)
);

Adder Branch_Adder(
    .src1_i(IFID_PC_o),
    .src2_i(Imm_Gen_o),
    .sum_o(PC_Add_Immediate)
);

IDEXE_register IDtoEXE(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(IFID_Instr_o),
    .WB_i(Mux_control_o[7:5]),
    .Mem_i(Mux_control_o[4:3]),
    .Exe_i(Mux_control_o[2:0]),
    .data1_i(RSdata_o),
    .data2_i(RTdata_o),
    .immgen_i(Imm_Gen_o),
    .alu_ctrl_instr({IFID_Instr_o[30:30], IFID_Instr_o[14:12]}),
    .WBreg_i({IFID_Instr_o[11:7]}),
    .pc_add4_i(IFID_PC_Add4_o),
    .instr_o(IDEXE_Instr_o),
    .WB_o(IDEXE_WB_o),
    .Mem_o(IDEXE_Mem_o),
    .Exe_o(IDEXE_Exe_o),
    .data1_o(IDEXE_RSdata_o),
    .data2_o(IDEXE_RTdata_o),
    .immgen_o(IDEXE_ImmGen_o),
    .alu_ctrl_input(IDEXE_Instr_30_14_12_o),
    .WBreg_o(IDEXE_Instr_11_7_o),
    .pc_add4_o(IDEXE_PC_add4_o)
);

// EXE
MUX_2to1 MUX_ALUSrc(
    .data0_i(ALUSrc2_o),
    .data1_i(IDEXE_ImmGen_o),
    .select_i(IDEXE_Exe_o[2:2]),
    .data_o(MUXALUSrc_o)
);

ForwardingUnit FWUnit(
    .IDEXE_RS1(IDEXE_Instr_o[19:15]),
    .IDEXE_RS2(IDEXE_Instr_o[24:20]),
    .EXEMEM_RD(EXEMEM_Instr_11_7_o),
    .MEMWB_RD(MEMWB_Instr_11_7_o),
    .EXEMEM_RegWrite(EXEMEM_WB_o[2:2]),
    .MEMWB_RegWrite(MEMWB_WB_o[2:2]),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

MUX_3to1 MUX_ALU_src1(
    .data0_i(IDEXE_RSdata_o),
    .data1_i(MUXMemtoReg_o),
    .data2_i(EXEMEM_ALUResult_o),
    .select_i(ForwardA),
    .data_o(ALUSrc1_o)
);

MUX_3to1 MUX_ALU_src2(
    .data0_i(IDEXE_RTdata_o),
    .data1_i(MUXMemtoReg_o),
    .data2_i(EXEMEM_ALUResult_o),
    .select_i(ForwardB),
    .data_o(ALUSrc2_o)
);

ALU_Ctrl ALU_Ctrl(
    .instr(IDEXE_Instr_30_14_12_o),
    .ALUOp(IDEXE_Exe_o[1:0]),
    .ALU_Ctrl_o(ALU_Ctrl_o)
);

alu alu(
    .rst_n(rst_i),
    .src1(ALUSrc1_o),
    .src2(MUXALUSrc_o),
    .ALU_control(ALU_Ctrl_o),
    .result(ALUResult),
    .zero(ALU_zero)
);

EXEMEM_register EXEtoMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(IDEXE_Instr_o),
    .WB_i(IDEXE_WB_o),
    .Mem_i(IDEXE_Mem_o),
    .zero_i(ALU_zero),
    .alu_ans_i(ALUResult),
    .rtdata_i(ALUSrc2_o),
    .WBreg_i(IDEXE_Instr_11_7_o),
    .pc_add4_i(IDEXE_PC_add4_o),
    .instr_o(EXEMEM_Instr_o),
    .WB_o(EXEMEM_WB_o),
    .Mem_o(EXEMEM_Mem_o),
    .zero_o(EXEMEM_Zero_o),
    .alu_ans_o(EXEMEM_ALUResult_o),
    .rtdata_o(EXEMEM_RTdata_o),
    .WBreg_o(EXEMEM_Instr_11_7_o),
    .pc_add4_o(EXEMEM_PC_Add4_o)
);

// MEM
Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(EXEMEM_ALUResult_o),
    .data_i(EXEMEM_RTdata_o),
    .MemRead_i(EXEMEM_Mem_o[1:1]),
    .MemWrite_i(EXEMEM_Mem_o[0:0]),
    .data_o(DM_o)
);

MEMWB_register MEMtoWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .WB_i(EXEMEM_WB_o),
    .DM_i(DM_o),
    .alu_ans_i(EXEMEM_ALUResult_o),
    .WBreg_i(EXEMEM_Instr_11_7_o),
    .pc_add4_i(EXEMEM_PC_Add4_o),
    .WB_o(MEMWB_WB_o),
    .DM_o(MEMWB_DM_o),
    .alu_ans_o(MEMWB_ALUresult_o),
    .WBreg_o(MEMWB_Instr_11_7_o),
    .pc_add4_o(MEMWB_PC_Add4_o)
);

// WB
MUX_3to1 MUX_MemtoReg(
    .data0_i(MEMWB_ALUresult_o),
    .data1_i(MEMWB_DM_o),
    .data2_i(MEMWB_PC_Add4_o),
    .select_i(MEMWB_WB_o[1:0]),
    .data_o(MUXMemtoReg_o)
);

endmodule
