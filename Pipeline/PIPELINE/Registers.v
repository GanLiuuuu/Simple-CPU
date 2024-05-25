`include "variables.vh"


module Registers(
    input wire en,
    input  wire clk,
	input  wire rst,
	input   Write,
	input  wire [4:0]  ReadReg1,
    input  wire [4:0]  ReadReg2,
    input  wire [4:0]  WriteReg, 
    input wire[31:0] M_Dout,
	input[`REGWIDTH-1:0] WriteData,
    output wire  [`REGWIDTH-1:0] ReadData1,
    output wire [`REGWIDTH-1:0] ReadData2,
    output reg  [31:0] WB_Dout
    );
    reg[`REGWIDTH-1:0] register[`REGWIDTH-1:0];
//    always@(negedge clk, posedge rst)begin
//        if(rst)begin
//            ReadData1 = 32'd0;
//            ReadData2 = 32'd0;
//        end
//        else begin
//            ReadData2 = register[ReadReg2];
//            ReadData1 = register[ReadReg1];
//        end
            
//    end
    assign ReadData1 = register[ReadReg1];
    assign ReadData2 = register[ReadReg2];
    always@(negedge clk,posedge rst)begin
        if(rst)begin
            WB_Dout <= 32'd0;
            
        end
        else begin
            WB_Dout <= M_Dout;
        end
    end
    always@(posedge clk,posedge rst) begin
        if(rst)begin
                //reset
                register[0]<=32'd0;
                register[1]<=32'd0;
                register[2]<=32'd0;
                register[3]<=32'd0;
                register[4]<=32'd0;
                register[5]<=32'd0;
                register[6]<=32'd0;
                register[7]<=32'd0;
                register[8]<=32'd0;
                register[9]<=32'd0;
                register[10]<=32'd0;
                register[11]<=32'd0;
                register[12]<=32'd0;
                register[13]<=32'd0;
                register[14]<=32'd0;
                register[15]<=32'd0;
                register[16]<=32'd0;
                register[17]<=32'd0;
                register[18]<=32'd0;
                register[19]<=32'd0;
                register[20]<=32'd0;
                register[21]<=32'd0;
                register[22]<=32'd0;
                register[23]<=32'd0;
                register[24]<=32'd0;
                register[25]<=32'd0;
                register[26]<=32'd0;
                register[27]<=32'd0;
                register[28]<=32'd0;
                register[29]<=32'd0;
                register[30]<=32'd0;
                register[31]<=32'd0;
                
        end
        else begin
            if(Write==1'b1 && WriteReg!=5'd0) register[WriteReg]<=WriteData;
        end
    end
endmodule
