`include "variables.vh"

module Decoder(
input[31:0] PC,
input flush,
input stall,
input en,
input clk,
input rst,
input[`REGWIDTH-1:0] inst,
input[`REGWIDTH-1:0] M_WriteData,
input M_RegWrite,
input M_MemtoReg,
input[4:0] M_WriteReg,
input[31:0] M_Dout,
output wire [`REGWIDTH-1:0] imm,
output wire [`REGWIDTH-1:0] ReadData1,
output wire [`REGWIDTH-1:0] ReadData2,
output reg[31:0] ID_PC,
output wire[4:0] ID_WriteReg,
output    wire[`ALUOPWIDTH-1:0] ID_ALUOp,
output    wire[`ALUSRCWIDTH-1:0] ID_ALUSrc,//choose operand2, 0 for register data, 1 for imm data, 2 for four
output    wire[`ALUSRCWIDTH-1:0] ID_ALUSrc1,//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
output    wire ID_PCSrc,//choose the first operand, 0 for PC, 1 for rs1
output    wire ID_MemRead,
output    wire ID_MemWrite,
output    wire ID_MemtoReg,
output    wire ID_RegWrite,
output    wire ID_sign,
 output   wire[1:0] ID_length,
 output    wire ID_Branch,
 output  wire[4:0] ReadReg1,
 output wire[4:0] ReadReg2,
output reg[31:0] ID_inst,
output [31:0]WB_Dout,
output reg W_RegWrite,
output reg W_MemtoReg,
output reg[4:0] W_rd
);
reg[4:0] W_WriteReg;
reg[`REGWIDTH-1:0] W_WriteData;
always@(negedge clk,posedge rst)begin
    if(rst)begin
        W_WriteReg <= 5'd0;
        W_WriteData <= 32'd0;
        W_RegWrite <= 1'd0;
        W_MemtoReg <= 1'd0;
        W_rd <= 5'd0;
    end
    else begin
            W_WriteReg <= M_WriteReg;
           W_WriteData <= M_WriteData;
           W_RegWrite <= M_RegWrite;
           W_MemtoReg <= M_MemtoReg;
           W_rd <= M_WriteReg;
    end
end

reg[31:0] instruction;
always@(negedge clk,posedge rst)begin
    if(rst||flush)begin
        instruction <=32'd0;
        ID_PC <= 32'd0;
        ID_inst <= 32'd0;
    end
    else if(stall) begin
        instruction <= instruction;
        ID_PC <= ID_PC;
        ID_inst <= ID_inst;
    end
    else begin
        instruction <= inst;
        ID_PC <= PC;
        ID_inst <= inst;
    end
    
end
wire[`OPWIDTH-1:0] opcode;

assign ID_WriteReg = instruction[11:7];
assign opcode = instruction[`OPWIDTH-1:0];
assign ReadReg1 = (opcode==`RTYPE||opcode==`IARITH||opcode==`ILOAD||opcode==`STYPE||opcode==`BTYPE||opcode==`JALR)?instruction[19:15]:5'd0;
assign ReadReg2 = (opcode==`RTYPE||opcode==`STYPE||opcode==`BTYPE)?instruction[24:20]:5'b0;
assign imm = (opcode == `IARITH||opcode == `ILOAD) ?{{20{instruction[31]}},instruction[31:20]}:(opcode==`LUI||opcode==`AUIPC)?{instruction[31:12],12'b0}:(opcode==`STYPE)?{{20{instruction[31]}},instruction[31:25],instruction[11:7]}:(opcode==`BTYPE)?{{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}:(opcode==`JAL)?{{11{instruction[31]}},instruction[31], instruction[19:12], instruction[20],instruction[30:21],1'b0}:(opcode==`JALR)?{20'b0,instruction[31:20]}:32'b0;
Registers registers(en,clk,rst,W_RegWrite,ReadReg1,ReadReg2,W_WriteReg,M_Dout,W_WriteData,ReadData1,ReadData2,WB_Dout);
Controller controller(.length(ID_length), .sign(ID_sign),.inst(instruction),.Branch(ID_Branch), .ALUOp(ID_ALUOp), .ALUSrc(ID_ALUSrc), .ALUSrc1(ID_ALUSrc1), .PCSrc(ID_PCSrc), .MemRead(ID_MemRead), .MemWrite(ID_MemWrite), .MemtoReg(ID_MemtoReg), .RegWrite(ID_RegWrite));
    

endmodule
