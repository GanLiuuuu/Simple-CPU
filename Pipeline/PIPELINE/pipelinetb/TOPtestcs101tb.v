`timescale 1ns / 1ps
`include "variables.vh"
`include "ALUvariables.vh"
module TOPtestcs101tb();
wire forward1;
wire forward2;
reg rst;
reg clk;
wire[4:0] ID_WriteReg;
 wire[4:0] EX_WriteReg;
     wire[4:0] M_WriteReg;
     wire[`REGWIDTH-1:0] PCout;
     wire[31:0] ID_PC;
     wire[31:0] M_Dout;
     wire M_MemtoReg;
     wire M_RegWrite;
wire cpu_clk;
wire[31:0] out;
reg[15:0] switches;
wire[15:0] LED;
wire[31:0] inst;
wire[31:0] pc;
wire flush;wire stall;wire PCsel;
wire[31:0] EX_Data1;
wire[31:0] EX_Data2;
wire[31:0] forwarddata1;
wire[31:0] forwarddata2;
wire[4:0] ReadReg1;
wire[4:0] ReadReg2;
wire[`ALUOPWIDTH-1:0] ID_ALUOp;
wire[`ALUSRCWIDTH-1:0] ID_ALUSrc;//choose operand2, 0 for register data, 1 for imm data, 2 for four
wire[`ALUSRCWIDTH-1:0] ID_ALUSrc1;//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
wire flushEX;
wire [31:0] imm;
wire[31:0] ReadData1;
wire[31:0] ReadData2;
wire preRegWrite;
reg button;

  wire[4:0] W_rd;
     wire [31:0] W_Dout;
     wire ID_MemtoReg;
     wire EX_MemtoReg;
TOP top(clk,rst,switches,button,W_rd,W_Dout,ID_MemtoReg,EX_MemtoReg,M_MemtoReg,M_RegWrite,preRegWrite,ID_PC,M_Dout,PCout, ID_WriteReg,EX_WriteReg,M_WriteReg,forward1,forward2,ReadData1,ReadData2,imm,flushEX,ID_ALUOp,ID_ALUSrc,ID_ALUSrc1,ReadReg1,ReadReg2,forwarddata1,forwarddata2,EX_Data1,EX_Data2,out,LED,cpu_clk,pc,inst,stall,flush,PCsel);
initial begin
    switches = 16'b0001_0010_0011_0000;
    clk = 1'b0;
    rst = 1'b1;
    button = 1'b0;
    #5 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule