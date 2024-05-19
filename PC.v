`timescale 1ns / 1ps

module PC(

    input[31:0]  Addr_result,            // 鏉ヨ嚜ALU,涓篈LU璁＄畻鍑虹殑璺宠浆鍦板潃(beq)
    input        clock,           //鏃堕挓
    input        reset,           //澶嶄綅淇″彿楂樼數骞虫湁鏁�
    input        Branch,               // 鏉ヨ嚜controller锛堝垽鏂槸鍚︽槸beq锛�
    input        Zero,                  //鏉ヨ嚜ALU锛堝垽鏂槸鍚︾浉绛夛級
     
    output[31:0] branch_base_addr,   // 鏈夋潯浠惰烦杞寚浠わ紝璇ュ�间负PC锛岄�佸線ALU
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    reg [31:0] Next_PC = 32'b0;
    assign PC_plus_4 = PC + 4;
    assign branch_base_addr = PC;
    always @* begin
        if(((Branch == 1) && (Zero == 1 )))  //璺宠浆
            Next_PC = Addr_result;
        else 
            Next_PC = PC_plus_4; // PC+4
    end

    always @(posedge clock or posedge reset) begin
        if(reset == 1)
            PC <= 32'b0;
        else
            PC <= Next_PC;
    end
endmodule
