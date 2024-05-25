`include "variables.vh"
`include "ALUvariables.vh"

module ALU(
    input clk,
    input rst,
    input stall,
    input flush,
    input MemtoReg,
    input RegWrite,
    input [1:0] ID_length,//0 for b, 1 for h, 2 for w
    input ID_sign,
    input [4:0]ID_WriteReg,
    input[`REGWIDTH-1:0] in_PCin,
    input[1:0] in_ALUSrc,
    input[1:0] in_ALUSrc1,
    input in_PCSrc,
    input[`ALUOPWIDTH-1:0] in_ALUOp,
    input[2:0] in_funct3,
    input[6:0] in_funct7,
    input[`REGWIDTH-1:0] in_ReadData1,
    input[`REGWIDTH-1:0] in_ReadData2,
    input[`REGWIDTH-1:0] in_imm32,
    input ID_MemWrite,
    input ID_MemRead,
    output zero,
    output[`REGWIDTH-1:0] ALUResult,
    output[`REGWIDTH-1:0] PCout,
    
    output reg Ex_MemtoReg,
    output reg Ex_RegWrite,
    output reg EX_sign,
    output reg EX_MemWrite,
    output reg EX_MemRead,
    output reg[1:0] EX_length,
    output EX_flush,
    output reg[4:0] EX_WriteReg,
    output reg[31:0] EX_ReadData2,
    output PCsel
);
    reg [`REGWIDTH-1:0] ReadData1;
    reg [`REGWIDTH-1:0] ReadData2;
    always@(negedge clk, posedge rst)begin
        if(rst||flush)begin
            Ex_MemtoReg<=1'b0;
            Ex_RegWrite<=1'b0;
            EX_sign <= 1'b0;
            EX_length <= 2'b00;
            EX_MemWrite <= 1'b0;
            EX_MemRead <= 1'b0;
            EX_WriteReg <= 5'd0;
            EX_ReadData2 <= 32'd0;
        end
        else begin
            if(!stall)begin
               Ex_MemtoReg<=MemtoReg;
               Ex_RegWrite<=RegWrite; 
               EX_length <= ID_length;
               EX_sign <= ID_sign;
               EX_MemWrite <= ID_MemWrite;
               EX_MemRead <= ID_MemRead;
               EX_WriteReg <= ID_WriteReg;
               EX_ReadData2 <= in_ReadData2;
            end
        end
    end
    reg [`REGWIDTH-1:0] PCin;
    reg [1:0] ALUSrc;
    reg [1:0] ALUSrc1;
    reg  PCSrc;
    reg [`ALUOPWIDTH-1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    
    reg [`REGWIDTH-1:0] imm32;
    always@(negedge clk,posedge rst)begin
        if(rst||flush)begin
            PCin<=32'd0;
            ALUSrc<=2'd0;
            ALUSrc1<=2'd0;
            PCSrc<=1'b0;
            ALUOp<=3'd0;
            funct3<=3'd0;
            funct7<=7'd0;
            ReadData1<=32'd0;
            ReadData2<=32'd0;
            imm32<=32'd0;
        end
        else if(!stall)begin
            PCin<=in_PCin;
            ALUSrc<=in_ALUSrc;
            ALUSrc1<=in_ALUSrc1;
            PCSrc<=in_PCSrc;
            ALUOp<=in_ALUOp;
            funct3<=in_funct3;
            funct7<=in_funct7;
            ReadData1<=in_ReadData1;
            ReadData2<=in_ReadData2;
            imm32<=in_imm32;
        end
    end
// 内部信号声明
wire[`REGWIDTH-1:0] AddResult;
wire[`REGWIDTH-1:0] SubResult;
wire[`REGWIDTH-1:0] AndRes;
wire[`REGWIDTH-1:0] OrRes;
wire[`REGWIDTH-1:0] XorRes;
wire[`REGWIDTH-1:0] SHIRFTRes;
wire[`REGWIDTH-1:0] four;
assign four = 32'b00000000000000000000000000000100;
wire[2:0] BranchType;
wire[`CTRLWIDTH-1:0] control;
wire[`REGWIDTH-1:0] operand1;
wire[`REGWIDTH-1:0] operand2;

wire[`REGWIDTH-1:0] operand3;
wire[`REGWIDTH-1:0] operand4;
wire shift_dir;//1 for right
wire shift_type; // if it is 1, then is logical shift

assign operand1 = (ALUSrc1 == `REG) ? ReadData1 : (ALUSrc1 == `ZERO) ? 32'd0 : PCin;
assign operand2 = (ALUSrc == `IMM && ALUOp==`I && ({funct7,funct3}==`SLLfunc||{funct7,funct3}==`SRAfunc||{funct7,funct3}==`SRLfunc)) ? {27'b0,imm32[4:0]} :(ALUSrc==`IMM) ? imm32 : (ALUSrc == `REG) ? ReadData2 : four;
assign operand3 = (PCSrc==`PPC) ? PCin : ReadData1;
assign operand4 = imm32;
assign shift_dir = (funct3==3'b101) ? `SHIRFTRIGHT : 1'b0;
assign shift_type = (funct7==7'b0100000) ? 1'b0 : `SHIRFTLOGIC;
assign BranchType = (ALUOp==`BRANCH) ? (funct3==3'b100) ? `LT: (funct3==3'b101) ? `GE : (funct3==3'b001) ? `NE:`EQ : `EQ;
//compute
assign AddResult = operand1 + operand2; // add
assign SubResult = operand1 - operand2; // sub
assign AndRes = operand1 & operand2;//and
assign OrRes = operand1 | operand2;//or
assign XorRes = operand1 ^ operand2;
shift s(shift_dir,shift_type,operand1,operand2,SHIRFTRes);

//get control signal
assign control =
    (ALUOp==`R&&{funct7,funct3}==`ADDfunc) ? `ADDControl :
    (ALUOp==`R&&{funct7,funct3}==`SUBfunc) ? `SUBControl :
    (ALUOp==`R&&{funct7,funct3}==`ANDfunc) ? `ANDControl : 
    (ALUOp==`R&&{funct7,funct3}==`ORfunc) ? `ORControl : 
    (ALUOp==`R&&{funct7,funct3}==`XORfunc)?`XORControl: 
    (ALUOp==`R&&{funct7,funct3}==`SLLfunc)?`SHIRFTControl :
    (ALUOp==`R&&{funct7,funct3}==`SRAfunc)?`SHIRFTControl :
    (ALUOp==`R&&{funct7,funct3}==`SRLfunc)?`SHIRFTControl :
    (ALUOp==`R)? `SUBControl:
    (ALUOp==`I&&funct3==3'b000) ? `ADDControl:
    (ALUOp==`I&&funct3==3'b100) ? `XORControl:
    (ALUOp==`I&&funct3==3'b110) ? `ORControl:
    (ALUOp==`I&&funct3==3'b010) ? `SUBControl:
    (ALUOp==`I&&funct3==3'b011) ? `SUBControl:
    (ALUOp==`I)? `SHIRFTControl:
    (ALUOp==`BRANCH) ? `SUBControl : `ADDControl;

//assign result
assign ALUResult = 
(control==`ADDControl) ? AddResult :
(control==`SUBControl && funct3==3'b010 && SubResult>=0) ? 32'd0:
(control==`SUBControl && funct3==3'b010 && SubResult<0) ? 32'd1:
(control==`SUBControl && funct3==3'b011 && $unsigned(operand1)-$unsigned(operand2)>=0)?32'd0:
(control==`SUBControl && funct3==3'b011 && $unsigned(operand1)-$unsigned(operand2)<0)?32'd1:
(control==`SUBControl) ? SubResult : 
(control==`ANDControl) ? AndRes :
(control==`ORControl)? OrRes : 
(control == `XORControl)? XorRes : 
(control==`SHIRFTControl)?SHIRFTRes:32'd0;
assign zero = (ALUOp==`J||(BranchType==`EQ && ALUResult==32'b0)) ? 1'b1 : (BranchType==`NE && ALUResult!=32'b0)?1'b1 : (BranchType==`LT && ALUResult<0) ? 1'b1 : (BranchType==`GE && ALUResult >= 0) ? 1'b1 : (BranchType==`LTU && ($unsigned(operand1)-$unsigned(operand2))<0) ? 1'b1: (BranchType==`GEU && ($unsigned(operand1)-$unsigned(operand2))>=0) ? 1'b1 : 1'b0;
assign PCout = operand3+operand4;
assign EX_flush = ((ALUOp==`J||ALUOp==`BRANCH)&&PCout!=PCin+32'd4)?1'b1:1'b0;
assign PCsel = EX_flush;
endmodule
