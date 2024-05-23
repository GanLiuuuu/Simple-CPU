
`include "variables.vh"
module TOP(
    input clk,
    input rst_n,
    input[15:0] switches,
    output wire  M_MemtoReg,
    output wire M_RegWrite,
    output wire EX_RegWrite,
    output wire[31:0] ID_PC,
    output wire[31:0] M_Dout,
    output wire[`REGWIDTH-1:0] PCout,
    output wire [4:0]  ID_WriteReg,
    output wire[4:0] EX_WriteReg,
    output wire[4:0] M_WriteReg,
    output wire forward1,
    output wire forward2,
    output wire[`REGWIDTH-1:0] ReadData1,
    output wire[`REGWIDTH-1:0] ReadData2,
    output wire [`REGWIDTH-1:0] imm,
    output wire flushEX,
    output wire[`ALUOPWIDTH-1:0] ID_ALUOp,
    output wire[`ALUSRCWIDTH-1:0] ID_ALUSrc,//choose operand2, 0 for register data, 1 for imm data, 2 for four
    output wire[`ALUSRCWIDTH-1:0] ID_ALUSrc1,//choose operand1, 0 for registerdata, 1 for PC, 2 for zero

    output wire[4:0] ReadReg1,
    output wire[4:0] ReadReg2,
    output wire[31:0] forwarddata1,
    output wire[31:0] forwarddata2,
    output wire[31:0] EX_Data1,
    output wire[31:0] EX_Data2,
    output wire [31:0]EX_ALUResult,
    output wire [15:0] LED,
    output wire cpu_clk,
    output wire[`REGWIDTH-1:0] pPC,
    output wire[`REGWIDTH-1:0] inst,
    output wire stall,
    output wire flush,
    output wire PCsel
    );

    
    
    wire rst;
    assign rst = rst_n;
    wire MemWrite;
    
    wire zero;
    wire Branch;
    wire en;
    
    reg[2:0] state;
    always @(negedge clk, posedge rst)begin
        if(rst)begin
            state <= 3'b0;
        end
        else begin 
            state <= state + 1;
        end
    end
wire rst_filtered;

assign cpu_clk = state[1];
wire[`ALUOPWIDTH-1:0] ALUOp;
wire[`ALUSRCWIDTH-1:0] ALUSrc;//choose operand2, 0 for register data, 1 for imm data, 2 for four
wire[`ALUSRCWIDTH-1:0] ALUSrc1;//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
wire PCSrc;//choose the first operand, 0 for PC, 1 for rs1
wire MemRead;

wire MemtoReg;
wire RegWrite;
wire[`REGWIDTH-1:0] WriteData;


wire[`REGWIDTH-1:0] MemData;
wire[`REGWIDTH-1:0] dout;

wire[1:0] length;
wire sign;
wire en_reg;
wire[31:0] M_din;


wire EX_MemtoReg;


wire [31:0]M_ALUResult;
wire [31:0] W_Dout;





assign en = (state[2:1]==2'b00) ? 1'b1 : 1'b0;
assign en_reg = (state==3'b110)? 1'b1:1'b0;
assign rst_filtered = rst;

wire[31:0] M_WriteData;

//REGSTER STORES
assign EX_Data1 = (forward1==1'b1) ? forwarddata1 : ReadData1;
assign EX_Data2 = (forward2==1'b1) ? forwarddata2 : ReadData2;
getWriteData GetWriteData(.mux_signal(M_MemtoReg), .ReadData(MemData), .ALUResult(M_ALUResult), .WriteData(M_WriteData));
PC pc(
.stall(stall),
.en(en),
.flush(flush),
.Addr_result(PCout), 
.clock(cpu_clk), 
.reset(rst_filtered), 
.PCsel(PCsel),  
.PC(pPC));

instruction_fetch iFetch(
.clk(cpu_clk), 
.rst(rst_filtered), 
.PC(pPC), 
.instruction(inst));

wire ID_PCSrc;//choose the first operand, 0 for PC, 1 for rs1
wire ID_MemRead;
wire ID_MemWrite;
wire ID_MemtoReg;
wire ID_RegWrite;
wire ID_sign;
wire[1:0] ID_length;
wire ID_Branch;
wire[31:0] ID_inst;
Decoder decoder(
    .M_WriteReg(M_WriteReg),
    .M_WriteData(M_WriteData),
    .flush(flush),
    .stall(stall),
    .en(en_reg),
    .clk(cpu_clk), 
    .rst(rst), 
    .inst(inst),
    .M_RegWrite(M_RegWrite), 
    .M_Dout(M_Dout),
    //output
    .imm(imm), 
    .ReadData1(ReadData1), 
    .ReadData2(ReadData2),
    .PC(pPC),
    .ReadReg1(ReadReg1),
    .ReadReg2(ReadReg2),
    .ID_PC(ID_PC),
    .ID_WriteReg(ID_WriteReg),
    .ID_ALUOp(ID_ALUOp),
    .ID_ALUSrc(ID_ALUSrc),//choose operand2, 0 for register data, 1 for imm data, 2 for four
    .ID_ALUSrc1(ID_ALUSrc1),//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
    .ID_PCSrc(ID_PCSrc),//choose the first operand, 0 for PC, 1 for rs1
    .ID_MemRead(ID_MemRead),
    .ID_MemWrite(ID_MemWrite),
    .ID_MemtoReg(ID_MemtoReg),
    .ID_RegWrite(ID_RegWrite),
    .ID_sign(ID_sign),
    .ID_length(ID_length),
    .ID_Branch(ID_Branch),
    .ID_inst(ID_inst),
    .WB_Dout(W_Dout)
);
wire EX_MemWrite;
wire EX_MemRead;
wire[1:0] EX_length;
wire EX_sign;
wire[31:0] EX_ReadData2;
ALU alu(
    .flush(flushEX),
    .stall(stall),
    .MemtoReg(ID_MemtoReg),
    .RegWrite(ID_RegWrite),
    .ID_length(ID_length),
    .ID_sign(ID_sign),
    .ID_WriteReg(ID_WriteReg),
    .clk(cpu_clk),
    .rst(rst),
    .in_PCin(ID_PC), 
    .in_ALUSrc(ID_ALUSrc), 
    .in_ALUSrc1(ID_ALUSrc1), 
    .in_PCSrc(ID_PCSrc), 
    .in_ALUOp(ID_ALUOp), 
    .in_funct3(ID_inst[14:12]), 
    .in_funct7(ID_inst[31:25]), 
    .in_ReadData1(EX_Data1), 
    .in_ReadData2(EX_Data2), 
    .in_imm32(imm), 
    .ID_MemWrite(ID_MemWrite),
    .ID_MemRead(ID_MemRead),
    //output
    .zero(zero), 
    .ALUResult(EX_ALUResult),
    .EX_flush(flush),
    .EX_sign(EX_sign),
    .Ex_MemtoReg(EX_MemtoReg),
    .Ex_RegWrite(EX_RegWrite),
    .PCout(PCout),
    .EX_MemWrite(EX_MemWrite),
    .EX_MemRead(EX_MemRead),
    .EX_length(EX_length),
    .EX_WriteReg(EX_WriteReg),
    .EX_ReadData2(EX_ReadData2),
    .PCsel(PCsel)
);

Data_Mamory dma(
    .EX_WriteReg(EX_WriteReg),
    .EX_ALUResult(EX_ALUResult),
    .MemtoReg(EX_MemtoReg),
    .RegWrite(EX_RegWrite),
    .in_length(EX_length), 
    .in_sign(EX_sign),
    .clk(cpu_clk), 
    .rst(rst), 
    .io_rdata_switch(switches),
    .in_MemRead(EX_MemRead), 
    .in_MemWrite(EX_MemWrite),
    .in_addr(EX_ALUResult), 
    .in_din(EX_ReadData2),
    //output
    .LED(LED), 
    .M_MemtoReg(M_MemtoReg),
    .M_RegWrite(M_RegWrite),
    .dout(MemData), 
    .M_din(M_din), 
    .M_dout(M_Dout),
    .M_WriteReg(M_WriteReg),
    .M_ALUResult(M_ALUResult)
    
 );

Forward forward(
.rs1(ReadReg1),
.rs2(ReadReg2),
.preprerd(M_WriteReg),
.prerd(EX_WriteReg),
.prepreRegWrite(M_RegWrite),
.prepreMemtoReg(M_MemtoReg),
.preRegWrite(EX_RegWrite),
.preMemtoReg(EX_MemtoReg),
.prepreMemDout(M_Dout),
.prepreALUResult(M_ALUResult),
.preMemDout(M_Dout),
.preALUResult(EX_ALUResult),
//output
.forward1(forward1),
.forward2(forward2),
.forwarddata1(forwarddata1),
.forwarddata2(forwarddata2),
.stall(stall),
.flush(flushEX)
);







endmodule

