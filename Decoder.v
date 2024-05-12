`include "variables.v"

module Decoder(
input clk,
input rst,
input[`REGWIDTH-1:0] instruction,
input[`REGWIDTH-1:0] WriteData,
input Write,
output reg[`REGWIDTH-1:0] imm,
output reg [`REGWIDTH-1:0] ReadData1,
output reg [`REGWIDTH-1:0] ReadData2
);
reg[`REGWIDTH-1:0] register[0:`REGWIDTH-1];
reg[`OPWIDTH-1:0] opcode;
reg[4:0] ReadReg1;
reg[4:0] ReadReg2;
reg[4:0] WriteReg;
reg RegWrite;

always@(*) begin
opcode = instruction[`REGWIDTH-1:0];
RegWrite = 1'b0;
case(opcode)
    `RTYPE:
    begin
        //R-type
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = instruction[24:20];
        imm = 32'b0;
        WriteReg[4:0] = instruction[11:7];
        if(WriteReg==5'b0)begin
            RegWrite = 1'b1;
        end
    end
    `IARITH:
    begin
        //I-type arithmatic
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = 5'b0;
        imm[31:0] = {{20{instruction[31]}},instruction[31:20]};
        WriteReg[4:0] = instruction[11:7];
        if(WriteReg==5'b0)begin
                RegWrite = 1'b1;
        end
    end
    `ILOAD:
    begin
        //I-type load
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = 5'b0;
        imm[31:0] = {{20{instruction[31]}},instruction[31:20]};
         WriteReg[4:0] = instruction[11:7];
         if(WriteReg==5'b0)begin
             RegWrite = 1'b1;
         end
    end
    `STYPE:
    begin
        //S-type
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = instruction[24:20];
        imm[31:0] = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
        RegWrite = 1'b0;
        WriteReg = 5'b0;
    end
    `BTYPE:
    begin
        //B-type
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = instruction[24:20];
        imm = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
         WriteReg[4:0] = 5'b0;
    end
    `JAL:
    begin
        //jal
        ReadReg1[4:0] = 5'b0;
        ReadReg2[4:0] = 5'b0;
        imm = {{11{instruction[31]}},instruction[31], instruction[19:12], instruction[20],instruction[30:21],1'b0};
        WriteReg[4:0] = instruction[11:7];
        if(WriteReg==5'b0)begin
            RegWrite = 1'b1;
        end
    end
    `JALR:
    begin
        //jalr
        ReadReg1[4:0] = instruction[19:15];
        ReadReg2[4:0] = 5'b0;
        imm[31:0] = {20'b0,instruction[31:20]};
        WriteReg[4:0] = instruction[11:7];
        if(WriteReg==5'b0)begin
            RegWrite = 1'b1;
        end
    end
    `LUI:
    begin
        //lui
        ReadReg1[4:0] = 5'b0;
        ReadReg2[4:0] = 5'b0;
        imm = {instruction[31:12],11'b0};
         WriteReg[4:0] = instruction[11:7];
         if(WriteReg==5'b0)begin
             RegWrite = 1'b1;
         end
    end
    `AUIPC:
    begin
        //auipc
        ReadReg1[4:0] = 5'b0;
        ReadReg2[4:0] = 5'b0;
        imm = {instruction[31:12],11'b0};
         WriteReg[4:0] = instruction[11:7];
         if(WriteReg==5'b0)begin
             RegWrite = 1'b1;
         end
    end
    `ECALL:
    begin
        ReadReg1[4:0] = 5'b0;
        ReadReg2[4:0] = 5'b0;
        imm[31:0] = 32'b0;
         WriteReg[4:0] = instruction[11:7]; 
         if(WriteReg==5'b0)begin
             RegWrite = 1'b1;
         end  
    end
endcase
ReadData1 = register[ReadReg1];
ReadData2 = register[ReadReg2];
end
    
always@(posedge clk) begin
    if(!rst)begin
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
        if(Write==1'b1 && RegWrite==1'b0) register[WriteReg]<=WriteData;
    end
end


endmodule
