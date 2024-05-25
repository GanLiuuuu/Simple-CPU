`include "variables.vh"
`include "ALUvariables.vh"

module ALU(
    input[`REGWIDTH-1:0] PCin,
    input[1:0] ALUSrc,
    input[1:0] ALUSrc1,
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
// 鍐呴儴淇″彿澹版槑
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
    assign BranchType = (ALUOp==`BRANCH) ? (funct3==3'b100) ? `LT: (funct3==3'b101) ? `GE : (funct3==3'b001) ? `NE:`EQ : `EQ;//compute
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
(control == `XORControl)? XorRes : SHIRFTRes;
assign zero = (ALUOp==`J||(BranchType==`EQ && ALUResult==32'b0)) ? 1'b1 : (BranchType==`NE && ALUResult!=32'b0)?1'b1 : (BranchType==`LT && ALUResult<0) ? 1'b1 : (BranchType==`GE && ALUResult >= 0) ? 1'b1 : (BranchType==`LTU && ($unsigned(operand1)-$unsigned(operand2))<0) ? 1'b1: (BranchType==`GEU && ($unsigned(operand1)-$unsigned(operand2))>=0) ? 1'b1 : 1'b0;
assign PCout = operand3+operand4;
endmodule
