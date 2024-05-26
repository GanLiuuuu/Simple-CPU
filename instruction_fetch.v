`timescale 1ns / 1ps

module instruction_fetch(
   input wire clk,             // 鏃堕挓淇″彿
   input wire rst,             // 澶嶄綅淇″彿
   input wire [31:0] PC,       // 绋嬪簭璁℃暟鍣�
   output [31:0] instruction // 杈撳嚭鎸囦护
    );
    
    instructionROM inst_rom (
        .clka(clk),
        .addra(PC[15:2]),
        .douta(instruction)
    );
    


endmodule
