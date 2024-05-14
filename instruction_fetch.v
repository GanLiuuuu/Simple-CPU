`timescale 1ns / 1ps

module instruction_fetch(
   input wire clk,             // ʱ���ź�
   input wire rst,             // ��λ�ź�
   input wire [31:0] PC,       // ���������
   output reg [31:0] instruction // ���ָ��
    );
    wire [31:0] rom_data;  // ���ڴ� ROM ģ���ȡ��ָ��
    
    instructionROM inst_rom (
        .clka(clk),
        .addra(PC[13:0]),
        .douta(rom_data)
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction <= 32'b0;   // ��λʱ��ָ������
        end else begin
            instruction <= rom_data; // �� ROM ģ���ȡָ��
        end
    end   

endmodule
