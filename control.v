module control(
    input[31:0] instruction,
    output reg  Branch,
    output reg[1:0] ALUOp,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg RegWrite
);
reg[6:0] opcode;
always @(*) begin
opcode = instruction[6:0];
case(opcode)
    
    7'b0110011:
    //R
    begin
        Branch = 1'b0;
        ALUOp = 2'b10;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;

    end
    7'b0010011:
    begin
        //I-type arithmatic
        Branch = 1'b0;
        ALUOp = 2'b10;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    7'b0000011:
    begin
        //I-type load
        Branch = 1'b0;
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b1;
    end
    7'b0100011:
    begin
        //S-type
        Branch = 1'b0;
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
    end
    7'b1100011:
    begin
        //B-type
        if(instruction[14:12]==3'b0)begin
                MemtoReg = 1'b0;
                Branch = 1'b1;
                ALUOp = 2'b01;
                ALUSrc = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
        end
        else begin
            MemtoReg = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b01;
            ALUSrc = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            RegWrite = 1'b0;
        end
    end
    7'b1101111:
    begin
        //jal
        //todo
        MemtoReg = 1'b0;
        Branch = 1'b1;
        ALUOp = 2'b10;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
    end
    7'b1100111:
    begin
        //jalr
        //todo
        Branch = 1'b0;
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    7'b0110111:
    begin
        //lui
        Branch = 1'b0;
        ALUOp = 2'b10;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    7'b0010111:
    begin
        //auipc
        Branch = 1'b0;
        ALUOp = 2'b10;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;
    end
    7'b1110011:
    begin
        //ecall, ebreak
        Branch = 1'b0;
        ALUOp = 2'b10;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b1;
        MemtoReg = 1'b0;  
    end
endcase
end
endmodule
