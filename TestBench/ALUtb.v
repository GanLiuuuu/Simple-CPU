`timescale 1ns / 1ps
module ALUtb();
reg[31:0] instruction;
reg[31:0] PC;
wire[31:0] PCout;
reg clk;
reg rst;
wire Branch;
wire[2:0] ALUOp;
wire[1:0] ALUSrc;
wire[1:0] ALUSrc1;
wire PCSrc;//choose the first operand, 0 for PC, 1 for rs1
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire RegWrite;
wire[31:0] ReadData1;
wire[31:0] ReadData2;
wire[31:0] imm32;
wire zero;
wire[31:0] ALUResult;



Controller ctl(instruction,Branch,ALUOp,ALUSrc,ALUSrc1,PCSrc,MemRead,MemWrite,MemtoReg,RegWrite);
ALU alu(PC,ALUSrc,ALUSrc1,PCSrc,ALUOp,instruction[14:12],instruction[31:25], ReadData1, ReadData2, imm32, zero, ALUResult,PCout);
//不涉及对内存的处理
//PC值为默认的0
Decoder decoder(clk,rst,instruction,ALUResult,RegWrite,imm32,ReadData1,ReadData2);

initial begin
    clk = 1'b0;
    rst = 1'b1;
    instruction = 32'b0;
    PC = 32'b0;
    #20 rst = 1'b0;
    
    
    //lix1,1,lix2,2, li x3,3
    #20 instruction = 32'b00000000000100001000000010010011;
    #20 instruction = 32'b00000000001000010000000100010011;
    #20 instruction = 32'b00000000001000001000000110110011;
    //lix1,10,lix2,2,sll x3,x1,x2
    #20 instruction = 32'b00000000101000000000000010010011;
    #20 instruction = 32'b00000000001000000000000100010011;
    #20 instruction = 32'b00000000001000001001000110110011;
    //jal,8 addi x3,x3,1
    #20 instruction = 32'b00000000100000000000000111101111;
    #20 instruction = 32'b00000000000100011000000110010011;
    //
    #20 instruction = 32'b00011000011010100000000110110111;
    #20 instruction = 32'b00011000011010100000001000010111;
end
always begin #10 clk = ~clk; end
endmodule
