module ALUtb();
reg[31:0] instruction;
reg[31:0] PC;
wire[31:0] PCout;
reg clk;
reg rst;
wire Branch;
wire[31:0] ALUOp;
wire[31:0] ALUSrc;
wire[31:0] ALUSrc1;
output PCSrc;//choose the first operand, 0 for PC, 1 for rs1
output MemRead;
output MemWrite;
output MemtoReg;
output RegWrite;
Controller ctl(inst,Branch,ALUOp,ALUSrc,ALUSrc1,PCSrc,MemRead,MemWrite,MemtoReg,RegWrite);
//不涉及对内存的处理
//PC值为默认的0

 ALU(
    input[`REGWIDTH-1:0] PCin,
    input ALUSrc,
    input ALUSrc1,
    input PCSrc,
    input[`ALUOPWIDTH-1:0] ALUOp,
    input[2:0] funct3,
    input[6:0] funct7,
    input[`REGWIDTH-1:0] ReadData1,
    input[`REGWIDTH-1:0] ReadData2,
    input[`REGWIDTH-1:0] imm32,
    output zero,
    output[`REGWIDTH-1:0] ALUResult,
    output[`REGWIDTH-1:0] PCout
);
 Decoder(
input clk,
input rst,
input[`REGWIDTH-1:0] instruction,
input[`REGWIDTH-1:0] WriteData,
input Write,
output reg[`REGWIDTH-1:0] imm,
output reg [`REGWIDTH-1:0] ReadData1,
output reg [`REGWIDTH-1:0] ReadData2
);
initial begin
    clk = 1'b0;
    rst = 1'b1;

    #20 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule