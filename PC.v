`timescale 1ns / 1ps

module PC(
    input en,
    input[31:0]  Addr_result,            // transmit address from ALU
    input        clock,           // clock cycle
    input        reset,           //reset is useable when at high 
    input        Branch,               // 鏉ヨ嚜controller锛堝垽鏂槸鍚︽槸beq锛�
    input        Zero,                  //鏉ヨ嚜ALU锛堝垽鏂槸鍚︾浉绛夛級
     input ecall,
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    wire [31:0] Next_PC;
    assign Next_PC = ((Branch == 1) && (Zero == 1 ))?Addr_result:PC_plus_4;
    assign PC_plus_4 = PC + 4;


    always @(posedge en or posedge reset) begin
        if(reset == 1)
            PC = 32'd0;
        else if(ecall)
            PC = PC;
        else if(en)
            PC = Next_PC;
    end
endmodule
