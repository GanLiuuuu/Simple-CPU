`timescale 1ns / 1ps

module ALU(
    input ALUsrc,
    input[1:0] ALUOp,
    input[31:0] instruction,
    input[31:0] ReadData1,
    input[31:0] ReadData2,
    output reg[31:0] imm,
    output reg  zero,
    output reg [31:0] out
    );

// 内部信号声明
reg[31:0] A = ReadData1;
reg[31:0] B;
wire[3:0] ALUControl;
ALUControl a(instruction,ALUOp,ALUControl);
MUX mux(ALUsrc,ReadData2,imm,B);
wire [31:0] AddResult;
wire [31:0] SubResult;

// ALU的实现
assign AddResult = A + B; // 加法运算
assign SubResult = A - B; // 减法运算
assign AndRes = A & B;
assign OrRes = A | B;


always @*
begin
    case (ALUControl)
        4'b0010: out = AddResult; // 加法
        4'b0110: out = SubResult; // 减法
        4'b0000: out = AndRes;
        4'b0001: out = OrRes;
        default: out = 8'b00000000; // 默认输出零
    endcase
    zero = (out == 8'b00000000) ? 1'b1 : 1'b0; // 判断结果是否为零
end

endmodule
