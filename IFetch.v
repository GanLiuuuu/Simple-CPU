`timescale 1ns / 1ps

module IFetch(
    input wire clk,
    input wire rst,
    input wire branch,
    input wire zero,
    input wire [31:0] imm32,
    output wire [31:0] inst
);
    // PC�Ĵ���
    reg [31:0] pc;
    // ��ַָ��ָ��洢��
    wire [13:0] addra;

    // ��ʼֵ
    initial begin
        pc = 32'h00000000;
    end

    // ��ַ����
    assign addra = pc[15:2];

    // ָ��洢��ʵ����
    prgrom urom (
        .clka(clk),
        .addra(addra),
        .douta(inst)
    );

    // ��ʱ�Ӹ��ظ���PC
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 32'h00000000;
        end else begin
            if (branch && zero) begin
                pc <= pc + imm32;
            end else begin
                pc <= pc + 32'h4;
            end
        end
    end

endmodule
