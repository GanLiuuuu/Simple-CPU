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
wire[31:0] WriteData;
Controller ctl(instruction,Branch,ALUOp,ALUSrc,ALUSrc1,PCSrc,MemRead,MemWrite,MemtoReg,RegWrite);
ALU alu(PC,ALUSrc,ALUSrc1,PCSrc,ALUOp,instruction[14:12],instruction[31:25], ReadData1, ReadData2, imm32, zero, ALUResult,PCout);
//不涉及对内存的处理
//PC值为默认的0
Decoder decoder(clk,rst,instruction,WriteData,RegWrite,imm32,ReadData1,ReadData2);

initial begin
    clk = 1'b0;
    rst = 1'b1;

    #20 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule