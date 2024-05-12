`timescale 1ns / 1ps
//输入PC寄存器的地址，从ROM中读取到我的地址的输出32bit的指令

module IF (
    input wire clk,             // 时钟信号
    input wire rst,             // 复位信号
    input wire [14:0] PC,       // 程序计数器
    output reg [31:0] instruction // 输出指令
);

wire [31:0] rom_data;  // 用于从 ROM 模块获取的指令

instructionROM inst_rom (
    .clka(clk),
    .addra(PC),
    .douta(rom_data)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        instruction <= 32'b0;   // 复位时将指令置零
    end else begin
        instruction <= rom_data; // 从 ROM 模块获取指令
    end
end

endmodule









