`include "variables.v"
`include "ALUvariables.v"

module ALU(
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
// 内部信号声明
wire[`REGWIDTH-1:0] AddResult;
wire[`REGWIDTH-1:0] SubResult;
wire[`REGWIDTH-1:0] AndRes;
wire[`REGWIDTH-1:0] OrRes;
wire[`REGWIDTH-1:0] XorRes;
wire[`REGWIDTH-1:0] SHIRFTRes;

wire[2:0] BranchType;


wire[`REGWIDTH-1:0] operand1;
wire[`REGWIDTH-1:0] operand2;
wire[`REGWIDTH-1:0] operand3;
wire[`REGWIDTH-1:0] operand4;
wire[`CTRLWIDTH-1:0] control;
wire shift_dir,//1 for right
wire shift_type // if it is 1, then is logical shift

assign operand1 = (ALUSrc1 == `REG) ? ReadData1 : (ALUSrc1 == `ZERO) ? 32'd0 : PCin;
assign operand2 = (ALUSrc == `IMM) ? imm32 : (ALUSrc == `REG) ? ReadData2 : 32'd4;
assign operand3 = (PCSrc==`PPC) ? PCin : ReadData1;
assign operand4 = imm32;
assign shift_dir = (funct3==3'b101) ? `SHIRFTRIGHT : 1'b0;
assign shift_type = (funct7==7'b0100000) ? 1'b0 : `SHIRFTLOGIC;
assign BranchType = (ALUOp==`BRANCH) ? (funct3==3'b100) ? `LT: (funct3==3'b101) ? `GE : (funct3==3'b001) ? `NE:`EQ : `EQ
//compute
assign AddResult = operand1 + operand2; // add
assign SubResult = operand1 - operand2; // sub
assign AndRes = operand1 & operand2;//and
assign OrRes = operand1 | operand2;//or
assign XorRes = operand1 ^ operand2;
shift s(shift_dir,shift_type,operand1,operand2,SHIRFTRes);

//get control signal
assign control = (ALUOp==`R) ?
(
    ({funct7,funct3}==`ADDfunc) ? `ADDControl :
    ({funct7,funct3}==`SUBfunc) ? `SUBControl :
    ({funct7,funct3}==`ANDfunc) ? `ANDControl : 
    ({funct7,funct3}==`ORfunc) ? `ORControl : 
    ({funct7,funct3}==`XORfunc)?`XORControl: 
    ({funct7,funct3}==`SLLfunc)?`SHIRFTControl :
    ({funct7,funct3}==`SRAfunc)?`SHIRFTControl :
    ({funct7,funct3}==`SRLfunc)?`SHIRFTControl : `SUBControl
)
:
(ALUOP==`I) ? 
(
    (funct3==3'b000) ? `ADDControl:
    (funct3==3'b100) ? `XORControl:
    (funct3==3'b110) ? `ORControl:
    (funct3==3'b010) ? `SUBControl:
    (funct3==3'b011) ? `SUBControl: `SHIRFTControl
):
(ALUOp==`BRANCH) ? `SUBControl : `ADDControl;

//assign result
assign ALUResult = 
(control==`ADDControl) ? AddResult :
(control==`SUBControl) ? SubResult : 
(control==`ANDControl) ? AndRes :
(control==`ORControl)? OrRes : 
(control == `XORControl)? XorRes : SHIRFTRes;
assign zero = (BranchType==`EQ && ALUResult==32'b0) ? 1'b1 : (BranchType==`NE && ALUResult!=32'b0)?1'b1 : (BranchType==`LT && ALUResult<0) ? 1'b1 : (BranchType==`Ge && ALUResult >= 0) ? 1'b1 : (BranchType==`LTU && ($unsigned(operand1)-$unsigned(operand2))<0) ? 1'b1: (BranchType==`GEU && ($unsigned(operand1)-$unsigned(operand2))>=0) ? 1'b1 : 1'b0;
assign PCout = operand3+operand4;
endmodule
