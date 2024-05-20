`include "variables.vh"


module Registers(
    input wire en,
    input  wire clk,
	input  wire rst,
	input   Write,
	input  wire [4:0]  ReadReg1,
    input  wire [4:0]  ReadReg2,
    input  wire [4:0]  WriteReg, 
	input[`REGWIDTH-1:0] WriteData,
    output  [`REGWIDTH-1:0] ReadData1,
    output  [`REGWIDTH-1:0] ReadData2
    );
    reg[`REGWIDTH-1:0] register[`REGWIDTH-1:0];
    assign ReadData1 = register[ReadReg1];
    assign ReadData2 = register[ReadReg2];
    always@(posedge en,posedge rst) begin
        if(rst)begin
                //reset
                register[0]<=32'b0;
                register[1]<=32'b0;
                register[2]<=32'b0;
                register[3]<=32'b0;
                register[4]<=32'b0;
                register[5]<=32'b0;
                register[6]<=32'b0;
                register[7]<=32'b0;
                register[8]<=32'b0;
                register[9]<=32'b0;
                register[10]<=32'b0;
                register[11]<=32'b0;
                register[12]<=32'b0;
                register[13]<=32'b0;
                register[14]<=32'b0;
                register[15]<=32'b0;
                register[16]<=32'b0;
                register[17]<=32'b0;
                register[18]<=32'b0;
                register[19]<=32'b0;
                register[20]<=32'b0;
                register[21]<=32'b0;
                register[22]<=32'b0;
                register[23]<=32'b0;
                register[24]<=32'b0;
                register[25]<=32'b0;
                register[26]<=32'b0;
                register[27]<=32'b0;
                register[28]<=32'b0;
                register[29]<=32'b0;
                register[30]<=32'b0;
                register[31]<=32'b0;
                
        end
        else begin
            if(Write==1'b1 && WriteReg!=5'b0) register[WriteReg]<=WriteData;
        end
    end
endmodule
