
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    output        Jump, Zero,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,
    output        ALUR31
);

wire [31:0] PCNext, PC1, PCPlus4, PCTarget, auipc, laupc;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;




// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero);

//lui/auipc
adder #(32)     auipc_adder(PC, {Instr[31:12], 12'b0}, auipc);
mux2 #(32)     auipc_mux(auipc, {Instr[31:12], 12'b0}, Instr[5], laupc);

mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 #(32)     pcmux_jump(PCNext, ALUResult, Jump, PC1);

// next PC logic
reset_ff #(32) pcreg(clk, reset, PC1, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);

//result  
mux4 #(32)     resultmux(ALUResult, ReadData, PCPlus4,laupc, ResultSrc, Result);

assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

assign ALUR31 = ALUResult[31];

endmodule

