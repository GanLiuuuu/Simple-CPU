`timescale 1ns / 1ps

module PC(
    input stall,
    input flush,
    input en,
    input[31:0]  Addr_result,            // 鏉ヨ嚜ALU,涓篈LU璁＄畻鍑虹殑璺宠浆鍦板潃(beq)
    input        clock,           //鏃堕�?
    input        reset,           //澶嶄綅淇″彿楂樼數骞虫湁鏁�
    input        PCsel,                //鏉ヨ嚜ALU锛堝垽鏂槸鍚︾浉绛夛級
     
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;
    wire [31:0] Next_PC;
    reg mid_PCsel;
    reg[31:0] mid_Addr_result;
    assign Next_PC = (mid_PCsel)?mid_Addr_result:PC_plus_4;
    assign PC_plus_4 = PC + 4;
    always@(negedge clock,posedge reset)begin
        if(reset)begin
            mid_PCsel <= 1'b0;
            mid_Addr_result <= 32'd0;
               
        end
        else begin
            mid_PCsel <= PCsel;
            mid_Addr_result <=Addr_result;
        end
    end
    always @(negedge clock or posedge reset) begin
        if(reset == 1)begin
            PC <= 32'd0;
            end
        else if(!stall)begin
            PC <= Next_PC;
            end
            else begin
                PC <= PC;
            end
    end
endmodule