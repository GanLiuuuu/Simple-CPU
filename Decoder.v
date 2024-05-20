`include "variables.vh"

module Decoder(
input clk,
input rst,
input[`REGWIDTH-1:0] instruction,
input[`REGWIDTH-1:0] WriteData,
input Write,
output [`REGWIDTH-1:0] imm,
output  [`REGWIDTH-1:0] ReadData1,
output  [`REGWIDTH-1:0] ReadData2
);

wire[`OPWIDTH-1:0] opcode;
wire[4:0] ReadReg1;
wire[4:0] ReadReg2;
wire[4:0] WriteReg;
assign opcode = instruction[`OPWIDTH-1:0];
assign ReadReg1 = (opcode==`RTYPE||opcode==`IARITH||opcode==`ILOAD||opcode==`STYPE||opcode==`BTYPE||opcode==`JALR)?instruction[19:15]:5'b0;
assign ReadReg2 = (opcode==`RTYPE||opcode==`STYPE||opcode==`BTYPE)?instruction[24:20]:5'b0;
assign WriteReg = (opcode==`STYPE||opcode==`BTYPE) ? 5'b0 : instruction[11:7];
  assign imm = (opcode == `IARITH||opcode == `ILOAD) ?{{20{instruction[31]}},instruction[31:20]}:(opcode==`LUI||opcode==`AUIPC)?{instruction[31:12],12'b0}:(opcode==`STYPE)?{{20{instruction[31]}},instruction[31:25],instruction[11:7]}:(opcode==`BTYPE)?{{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}:(opcode==`JAL)?{{11{instruction[31]}},instruction[31], instruction[19:12], instruction[20],instruction[30:21],1'b0}:(opcode==`JALR)?{20'b0,instruction[31:20]}:32'b0;
Registers registers(clk,rst,Write,ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2);


endmodule
