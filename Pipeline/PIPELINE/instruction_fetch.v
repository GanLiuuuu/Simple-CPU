`timescale 1ns / 1ps

module instruction_fetch(
   input wire clk,             // 时钟信号
   input wire rst,             // 复位信号
   input wire [31:0] PC,       // 程序计数�?
   output [31:0] instruction // 输出指令
    );

    instructionROM inst_rom (
        .clka(clk),
        .addra(PC[15:2]),
        .douta(instruction)
    );
    


endmodule
