`include "variables.vh"

module Controller(
    input[`REGWIDTH-1:0] inst,
    output Branch,
    output[`ALUOPWIDTH-1:0] ALUOp,
    output[`ALUSRCWIDTH-1:0] ALUSrc,//choose operand2, 0 for register data, 1 for imm data, 2 for four
    output[`ALUSRCWIDTH-1:0] ALUSrc1,//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
    output PCSrc,//choose the first operand, 0 for PC, 1 for rs1
    output MemRead,
    output MemWrite,
    output MemtoReg,
    output RegWrite,
    output sign,
    output[1:0] length,
    output wire stop
);
wire[`OPWIDTH-1:0] opcode;
assign opcode = inst[`OPWIDTH-1:0];
assign stop = (opcode == `ECALL) ? 1'b1: 1'b0;
assign PCSrc = (opcode == `JALR) ? `RS: `PPC;
assign Branch = (opcode==`BTYPE || opcode == `JAL || opcode == `JALR) ? 1'b1 : 1'b0;
assign ALUOp = (opcode==`RTYPE) ? `R : (opcode==`IARITH) ? `I : (opcode == `ILOAD ||opcode==`STYPE) ? `LS : (opcode==`BTYPE) ? `BRANCH : (opcode==`JAL || opcode==`JALR) ? `J : `U;
assign MemRead = (opcode==`ILOAD) ? 1'b1 : 1'b0;
assign MemWrite = (opcode==`STYPE) ? 1'b1:1'b0;
assign RegWrite = (opcode == `STYPE || opcode == `BTYPE || opcode==`ECALL) ? 1'b0 : 1'b1;
assign MemtoReg = (opcode==`ILOAD) ? 1'b1: 1'b0;
assign ALUSrc = (opcode==`RTYPE||opcode==`BTYPE) ? `REG : (opcode==`IARITH || opcode == `ILOAD || opcode ==`STYPE||opcode==`LUI ||opcode==`AUIPC) ? `IMM:`FOUR;
assign ALUSrc1 = (opcode==`RTYPE||opcode==`IARITH||opcode==`ILOAD||opcode==`STYPE||opcode==`BTYPE)?`REG:(opcode==`LUI) ? `ZERO : `PC;
assign sign = (inst[14:12]==3'b001||inst[14:12]==3'b010||inst[14:12]==3'b100||inst[14:12]==3'b101)?1'b0:1'b1;
assign length = (inst[14:12]==3'b010)?2'b10:(inst[14:12]==3'b101||inst[14:12]==3'b001)?2'b01:2'b00;
endmodule
