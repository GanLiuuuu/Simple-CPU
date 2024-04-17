`timescale 1ns / 1ps

module ALU(
    input ALUsrc,
    input[2:0] ALUop,
    input[31:0] ReadData1,
    input[31:0] ReadData2,
    output reg[31:0] imm,
    output reg  zero,
    output reg [31:0] out
    );

// 内部信号声明
reg[31:0] A = ReadData1;
reg[31:0] B;
MUX mux(ALUsrc,ReadData2,imm,B);
wire [31:0] AddResult;
wire [31:0] SubResult;

// ALU的实现
assign AddResult = A + B; // 加法运算
assign SubResult = A - B; // 减法运算


always @*
begin
    case (ALUop)
        3'b000: out = AddResult; // 加法
        3'b001: out = SubResult; // 减法
        
        default: out = 8'b00000000; // 默认输出零
    endcase
    zero = (out == 8'b00000000) ? 1'b1 : 1'b0; // 判断结果是否为零
end

endmodule
