`include "variables.vh"
module TOP(
    input clk,
    input rst_a,
    input[15:0] switches,
   // output[`REGWIDTH-1:0] out,//used for debuging
    output  [15:0] LED,
    
    // UART
     input start_pg,//active high
     input rx,//receive data by uart
     output tx// send data by uart
    );
   wire rst;
   assign  rst=~rst_a;
    //uart
    wire upg_clk,upg_clk_w;
    wire upg_wen_w;  //Uart write out enable
    wire upg_done_w;  //Uart rx data have done
   //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_w;
    //data to program_rom of dmemory32
    wire [31:0] upg_dat_w;
    wire spg_bufg;
     BUFG U1 (.I(start_pg),.O(spg_bufg) );// 消抖
     // Generate UART Programmer reset sig
     reg upg_rst;
     always @(posedge clk) begin
          if (spg_bufg) upg_rst <= 0;
          if (rst) upg_rst <= 1;
      end
      //used for other modules which don't relate to UART
      wire rst_in;
      assign rst_in = rst | !upg_rst;
        uart_bmpg_0 uart (
          .upg_clk_i(upg_clk),
          .upg_rst_i(upg_rst),
          .upg_rx_i(rx),
  
          .upg_clk_o(upg_clk_w),
          .upg_wen_o(upg_wen_w),
          .upg_adr_o(upg_adr_w),
          .upg_dat_o(upg_dat_w),
          .upg_done_o(upg_done_w),
          .upg_tx_o(tx)
      );
     
      
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
assign en = (state[2:1]==2'b00) ? 1'b1 : 1'b0;
assign en_reg = (state==3'b110)? 1'b1:1'b0;
assign rst_filtered = rst;
getWriteData GetWriteData(.mux_signal(MemtoReg), .ReadData(MemData), .ALUResult(ALUResult), .WriteData(WriteData));
PC pc(.en(en),.Addr_result(PCout), .clock(cpu_clk), .reset(rst_filtered), .Branch(Branch), .Zero(zero),  .PC(pPC));
instruction_fetch iFetch(.clk(cpu_clk), .rst(rst_filtered), .PC(pPC), .instruction(inst)
,.upg_rst_i(upg_rst),
.upg_clk_i(upg_clk_w),
.upg_wen_i(upg_wen_w & !upg_adr_w[14]),
.upg_adr_i(upg_adr_w[13:0]),
.upg_dat_i(upg_dat_w),
.upg_done_i(upg_done_w)
);
Controller controller(.length(length), .sign(sign),.inst(inst),.Branch(Branch), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite));
Decoder decoder(.en(en_reg),.clk(cpu_clk), .rst(rst_in), .instruction(inst), .WriteData(WriteData), .Write(RegWrite), .imm(imm), .ReadData1(ReadData1), .ReadData2(ReadData2));
ALU alu(.PCin(pPC), .ALUSrc(ALUSrc), .ALUSrc1(ALUSrc1), .PCSrc(PCSrc), .ALUOp(ALUOp), .funct3(inst[14:12]), .funct7(inst[31:25]), .ReadData1(ReadData1), .ReadData2(ReadData2), .imm32(imm), .zero(zero), .ALUResult(ALUResult), .PCout(PCout));
Data_Mamory dma(.length(length), .sign(sign),.clk(cpu_clk), .rst(rst_in), .io_rdata_switch(switches),.LED(LED), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALUResult), .din(ReadData2), .dout(MemData)
  ,  .upg_rst_i(upg_rst),
     .upg_clk_i(upg_clk_w),
     .upg_wen_i(upg_wen_w & upg_adr_w[14]),
     .upg_adr_i(upg_adr_w[13:0]),
     .upg_dat_i(upg_dat_w),
     .upg_done_i(upg_done_w));
cpuclk divclk (
      .clk_in1(clk),// from fpga 100Mhz
     // .clk_out1(cpu_clk),//cpu clock 23Mhz
      .clk_out1(upg_clk) //urat clock 10Mhz
     );
assign out=ALUResult;
endmodule
