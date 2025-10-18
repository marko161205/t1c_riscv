module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [1:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000; // addition
        2'b01: ALUControl = 4'b0001; // subtraction
        default: begin
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // R-type SUB detection: need both funct7[5] and opcode[5] = 1
                    if (funct7b5 & opb5) ALUControl = 4'b0001; // SUB
                    else                 ALUControl = 4'b0000; // ADD / ADDI
                end
                3'b111: ALUControl = 4'b0010; // AND/ANDI
                3'b110: ALUControl = 4'b0011; // OR/ORI
                3'b001: ALUControl = 4'b0100; // SLL/SLLI
                3'b010: ALUControl = 4'b0101; // SLT/SLTI (signed)
                3'b011: ALUControl = 4'b0110; // SLTU/SLTIU (unsigned)
                3'b100: ALUControl = 4'b0111; // XOR/XORI
                3'b101: begin
                    // For shifts (funct3 == 101) use funct7b5 alone:
                    // funct7b5=1 -> SRA / SRAI, funct7b5=0 -> SRL / SRLI
                    if (funct7b5) ALUControl = 4'b1001; // SRA / SRAI
                    else           ALUControl = 4'b1000; // SRL / SRLI
                end
                default: ALUControl = 4'bxxxx;
            endcase
        end
    endcase
end

endmodule
