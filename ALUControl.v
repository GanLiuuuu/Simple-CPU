`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/23 14:32:40
// Design Name: 
// Module Name: ALUControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUControl(
input[31:0] instruction,
input[1:0] ALUOp,
output reg[3:0] ALUControl
    );
    //0010: add
    //0110: subtract
    //
always @(*) begin
case(ALUOp)
2'b00:
ALUControl = 4'b0010;
2'b01:
ALUControl = 4'b0110;
2'b10:
    begin
        //func7,func3
        case({instruction[31:25],instruction[14:12]})
            10'b0000000000:ALUControl = 4'b0010;//add
            10'b0100000000: ALUControl = 4'b0110;//subtrct
            10'b0000000111:ALUControl = 4'b0000;//And
            10'b0000000001:ALUControl = 4'b0001;//Or
        endcase
    end
endcase
end
endmodule
