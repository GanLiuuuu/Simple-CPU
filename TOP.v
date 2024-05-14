
`include "variables.v"
module TOP(
    input clk,
    input PC,
    input rst,
    output[`REGWIDTH-1:0] out
    );
wire[`REGWIDTH-1:0] inst; 
wire rst_filtered;
wire Branch;
wire[`ALUOPWIDTH-1:0] ALUOp;
wire[`ALUSRCWIDTH-1:0] ALUSrc;//choose operand2, 0 for register data, 1 for imm data, 2 for four
wire[`ALUSRCWIDTH-1:0] ALUSrc1;//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
wire PCSrc;//choose the first operand, 0 for PC, 1 for rs1
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire RegWrite;
wire[`REGWIDTH-1:0] WriteData;
wire [`REGWIDTH-1:0] imm;
wire[`REGWIDTH-1:0] ReadData1;
wire[`REGWIDTH-1:0] ReadData2;
wire[`REGWIDTH-1:0] MemData;
wire[`REGWIDTH-1:0] dout;


wire zero;
wire[`REGWIDTH-1:0] ALUResult;
wire[`REGWIDTH-1:0] PCout;
wire[`REGWIDTH-1:0] cur_PC;
wire[`REGWIDTH-1:0] PC;

getWriteData GetWriteData(.mux_signal(MemtoReg), .ReadData(MemData), .ALUResult(ALUResult), .dout(WriteData));

PC pc(.Addr_result(PCout), .clock(clk), .reset(rst_filtered), .Branch(Branch), .Zero(zero), .branch_base_addr(cur_PC),  .PC(PC));
instruction_fetch iFetch(.clk(clk), .rst(rst_filtered), .PC(PC), .instruction(inst));
Controller controller(.inst(inst),.Branch(Branch), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite));
Decoder decoder(.clk(clk), .rst(rst), .instruction(instruction), .WriteData(WriteData), .Write(RegWrite), .imm(imm), .ReadData1(ReadData1), .ReadData2(ReadData2));
ALU alu(.PCin(cur_PC), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .ALUOp(ALUOp), .funct3(inst[14:12]), .funct7(inst[31:25]), .ReadData1(ReadData1), .ReadData2(ReadData2), .imm32(imm), .zero(zero), .ALUResult(ALUResult), .PCout(PCout));
Data_Mamory dma(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUResult), .din(ReadData2), .dout(MemData));
assign out=ALUResult;
endmodule

