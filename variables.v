//ALUOp
`define LS 3'b000
`define BRANCH 3'b001
`define R 3'b010
`define I 3'b111
`define J 3'b100
`define U 3'b101 
//ALUSrc1
`define ALUSRCWIDTH 2
`define REG 0
`define PC 1
`define ZERO 2
`define IMM 1
`define FOUR 2
//pcsrc
`define PPC 0
`define RS 1
//opcode:
`define RTYPE 7'b0110011
`define IARITH 7'b0010011
`define ILOAD 7'b0000011
`define STYPE 7'b0100011
`define BTYPE 7'b1100011
`define JAL 7'b1101111 
`define JALR 7'b1100111
`define LUI 7'b0110111
`define AUIPC 7'b0010111
`define ECALL 7'b1110011
//width:
`define REGWIDTH 32
`define CTRLWIDTH 4
`define ALUOPWIDTH 3
`define OPWIDTH 7
