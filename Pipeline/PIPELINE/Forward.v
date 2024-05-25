

module Forward(
input[4:0] rs1,
input[4:0] rs2,
input[4:0] W_rd,

input[4:0] preprerd,
input[4:0] prerd,
input[4:0] EX_rd,
input W_RegWrite,
input W_MemtoReg,
input M_RegWrite,
input M_MemtoReg,
input EX_RegWrite,
input EX_MemtoReg,
input[31:0] prepreMemDout,
input[31:0] prepreALUResult,
input[31:0] preMemDout,
input[31:0] preALUResult,
input[31:0] ALUResult,
output reg forward1,forward2,
output reg[31:0] forwarddata1,
output reg[31:0] forwarddata2,
output reg stall,
output reg flush
    );
    always @(*)begin
        if(EX_MemtoReg&&(EX_rd==rs1||EX_rd==rs2)&&prerd!=5'b00000)begin
            stall = 1'b1;
            flush = 1'b1;
        end
        else begin
            stall = 1'b0;
            flush = 1'b0;
        end
        forwarddata1 = 32'd0;
        forwarddata2 = 32'd0;
        forward1 = 1'b0;
        forward2 = 1'b0;

        if(M_RegWrite && prerd != 5'b00000 && (rs1 == prerd || rs2 == prerd)) begin
            if(rs1 == prerd) begin forwarddata1 =(M_MemtoReg == 1 ? preMemDout : prepreALUResult); forward1= 1; end 
            if(rs2 == prerd) begin forwarddata2 =(M_MemtoReg == 1 ? preMemDout : prepreALUResult); forward2= 1; end
        end
        if(EX_RegWrite && EX_rd!= 5'b00000 && (rs1 == EX_rd || rs2 == EX_rd))begin
            if(rs1 == EX_rd) begin forwarddata1 =(ALUResult); forward1= 1; end 
            if(rs2 == EX_rd) begin forwarddata2 =(ALUResult); forward2= 1; end
        end
 
    end
endmodule
