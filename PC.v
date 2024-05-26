`timescale 1ns / 1ps

module PC(
    input en,
    input[31:0]  Addr_result,            // 鏉ヨ嚜ALU,涓篈LU璁＄畻鍑虹殑璺宠浆鍦板潃(beq)
    input        clock,           //鏃堕�?
    input        reset,           //澶嶄綅淇″彿楂樼數骞虫湁鏁�
    input        Branch,               // 鏉ヨ嚜controller锛堝垽鏂槸鍚︽槸beq锛�
    input        Zero,                  //鏉ヨ嚜ALU锛堝垽鏂槸鍚︾浉绛夛級
     
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    wire [31:0] Next_PC;
    assign Next_PC = ((Branch == 1) && (Zero == 1 ))?Addr_result:PC_plus_4;
    assign PC_plus_4 = PC + 4;


    always @(posedge en or posedge reset) begin
        if(reset == 1)
            PC = 32'd0;
        else if(en)
            PC = Next_PC;
    end
endmodule
