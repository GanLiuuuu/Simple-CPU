`timescale 1ns / 1ps

module instruction_fetch(
   input wire clk,             // ʱ���ź�
   input wire rst,             // ��λ�ź�
   input wire [31:0] PC,       // ���������
   output [31:0] instruction // ���ָ��
    );
    
    instructionROM inst_rom (
        .clka(clk),
        .addra(PC[15:2]),
        .douta(instruction)
    );
    


endmodule
