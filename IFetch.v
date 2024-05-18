`timescale 1ns / 1ps

module IFetch(
    input wire clk,
    input wire rst,
    input wire branch,
    input wire zero,
    input wire [31:0] imm32,
    output wire [31:0] inst
);
    // PC寄存器
    reg [31:0] pc;
    // 地址指向指令存储器
    wire [13:0] addra;

    // 初始值
    initial begin
        pc = 32'h00000000;
    end

    // 地址计算
    assign addra = pc[15:2];

    // 指令存储器实例化
    prgrom urom (
        .clka(clk),
        .addra(addra),
        .douta(inst)
    );

    // 在时钟负沿更新PC
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
