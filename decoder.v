`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/16 13:13:45
// Design Name: 
// Module Name: decoder
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


module decoder(
input[31:0] instruction,
output reg[4:0] ReadReg1,
output reg[4:0] ReadReg2,
output reg[4:0] WriteReg,
output reg[31:0] imm,
output reg RegWrite,
output reg[31:0] ReadData1,
output reg[31:0] ReadData2
    );
    reg[6:0] opcode;
always@(*) begin
opcode = instruction[6:0];
case(opcode)
7'b0110011:
begin
    //R-type
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = instruction[24:20];
    imm = 32'b0;
    RegWrite = 1'b1;
    WriteReg[4:0] = instruction[11:7];
end
7'b0010011:
begin
    //I-type arithmatic
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = 5'b0;
    imm[31:0] = {{20{instruction[31]}},instruction[31:20]};
    RegWrite = 1'b1;
     WriteReg[4:0] = instruction[11:7];
end
7'b0000011:
begin
    //I-type load
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = 5'b0;
    imm[31:0] = {{20{instruction[31]}},instruction[31:20]};
    RegWrite = 1'b1;
     WriteReg[4:0] = instruction[11:7];
end
7'b0100011:
begin
    //S-type
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = instruction[24:20];
    imm[31:0] = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    RegWrite = 1'b0;
    WriteReg = 5'b0;
end
7'b1100011:
begin
    //B-type
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = instruction[24:20];
    imm = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
    RegWrite = 1'b0;
     WriteReg[4:0] = 5'b0;
end
7'b1101111:
begin
    //jal
    ReadReg1[4:0] = 5'b0;
    ReadReg2[4:0] = 5'b0;
    imm = {{11{instruction[31]}},instruction[31], instruction[19:12], instruction[20],instruction[30:21],1'b0};
    RegWrite = 1'b1;
     WriteReg[4:0] = instruction[11:7];
end
7'b1100111:
begin
    //jalr
    ReadReg1[4:0] = instruction[19:15];
    ReadReg2[4:0] = 5'b0;
    imm[31:0] = {{20{instruction[31]}},instruction[31:20]};
    RegWrite = 1'b1;
     WriteReg[4:0] = instruction[11:7];
end
7'b0110111:
begin
    //lui
    ReadReg1[4:0] = 5'b0;
    ReadReg2[4:0] = 5'b0;
    imm = {instruction[31:12],11'b0};
    RegWrite = 1'b1;
     WriteReg[4:0] = instruction[11:7];
end
endcase
end
    
endmodule
