`include "variables.v"
//����PC�Ĵ����ĵ�ַ����ROM�ж�ȡ���ҵĵ�ַ�����32bit��ָ��

module IF (
    input wire clk,             // ʱ���ź�
    input wire rst,             // ��λ�ź�
    input wire [14:0] PC,       // ���������
    output reg [`REGWIDTH-1:0] instruction // ���ָ��
);

wire [31:0] rom_data;  // ���ڴ� ROM ģ���ȡ��ָ��

instructionROM inst_rom (
    .clka(clk),
    .addra(PC),
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









