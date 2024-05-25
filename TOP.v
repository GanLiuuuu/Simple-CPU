
`include "variables.vh"
module TOP(
    input clk,
    input rst_a,
    input[15:0] switches,
   // output[`REGWIDTH-1:0] out,//used for debuging
    output  [15:0] LED,
    output[7:0] digital_light,
    output[7:0] digital_light1,

    output[7:0] seg_en,
    input button
    );
    wire rst;
    assign rst=~rst_a;
    wire[15:0] input_32bit;
    assign input_32bit = LED;
    digital_presenter dp(clk,rst,input_32bit,digital_light,seg_en[3:0]);
    wire[15:0] input_32bit1;
    assign input_32bit1 = {16{LED[15]}};
    digital_presenter dp1(clk,rst,input_32bit1,digital_light1,seg_en[7:4]);
     wire[`REGWIDTH-1:0] pPC;
     wire[`REGWIDTH-1:0] inst;
     wire [`REGWIDTH-1:0] imm;
     wire zero;
     wire Branch;
     wire en;
     wire[`REGWIDTH-1:0] PCout;
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
wire cpu_clk;
assign cpu_clk = state[1];
wire[`ALUOPWIDTH-1:0] ALUOp;
wire[`ALUSRCWIDTH-1:0] ALUSrc;//choose operand2, 0 for register data, 1 for imm data, 2 for four
wire[`ALUSRCWIDTH-1:0] ALUSrc1;//choose operand1, 0 for registerdata, 1 for PC, 2 for zero
wire PCSrc;//choose the first operand, 0 for PC, 1 for rs1
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire RegWrite;
wire[`REGWIDTH-1:0] WriteData;

wire[`REGWIDTH-1:0] ReadData1;
wire[`REGWIDTH-1:0] ReadData2;
wire[`REGWIDTH-1:0] MemData;
wire[`REGWIDTH-1:0] dout;

wire[`REGWIDTH-1:0] ALUResult;

wire[1:0] length;
wire sign;

wire en_reg;
reg stop;
wire ecall;
assign en = (state[2:1]==2'b00) ? 1'b1 : 1'b0;
assign en_reg = (state==3'b110)? 1'b1:1'b0;
assign rst_filtered = rst;
    wire buttonOn;
    wire button_o;
   BUFG U1(.I(button), .O(button_o));
    assign buttonOn = button_o;
// assign buttonOn = switches[0];
//key_filter fli(
//clk,
//rst,
//button,
//buttonOn
//);
stop = 1'b0;
getWriteData GetWriteData(.mux_signal(MemtoReg), .ReadData(MemData), .ALUResult(ALUResult), .WriteData(WriteData));
PC pc(.stop(stop),.en(en),.Addr_result(PCout), .clock(cpu_clk), .reset(rst_filtered), .Branch(Branch), .Zero(zero),  .PC(pPC));
instruction_fetch iFetch(.clk(cpu_clk), .rst(rst_filtered), .PC(pPC), .instruction(inst));
Controller controller(.stop(ecall),.length(length), .sign(sign),.inst(inst),.Branch(Branch), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite));
Decoder decoder(.en(en_reg),.clk(cpu_clk), .rst(rst), .instruction(inst), .WriteData(WriteData), .Write(RegWrite), .imm(imm), .ReadData1(ReadData1), .ReadData2(ReadData2));
ALU alu(.PCin(pPC), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .ALUOp(ALUOp), .funct3(inst[14:12]), .funct7(inst[31:25]), .ReadData1(ReadData1), .ReadData2(ReadData2), .imm32(imm), .zero(zero), .ALUResult(ALUResult), .PCout(PCout));
Data_Mamory dma(.buttonOn(buttonOn),.length(length), .sign(sign),.clk(cpu_clk), .rst(rst), .io_rdata_switch(switches),.LED(LED), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUResult), .din(ReadData2), .dout(MemData));
assign out=ALUResult;
endmodule
