`timescale 1ns / 1ps

module digital_presenter(
    input clk,
    input rst,
    input [31:0] input_32bit,
    output reg [7:0] digital_light,
    output reg [7:0] seg_en
);

    reg [3:0] digit;
    reg [2:0] digit_sel;
    wire [7:0] segment_output;

    seven_segment_display ssd (
        .digit(digit),
        .segments(segment_output)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sel <= 3'b000;
            seg_en <= 8'b00000001;//默认输出是8，给第一个灯亮灯
        end else begin
            digit_sel <= digit_sel + 1;
            seg_en <= {seg_en[6:0], seg_en[7]};  // 循环左移，激活下一个数码管
        end
    end

    always @* begin
        case (digit_sel)
            3'b000: digit = input_32bit[3:0];
            3'b001: digit = input_32bit[7:4];
            3'b010: digit = input_32bit[11:8];
            3'b011: digit = input_32bit[15:12];
            3'b100: digit = input_32bit[19:16];
            3'b101: digit = input_32bit[23:20];
            3'b110: digit = input_32bit[27:24];
            3'b111: digit = input_32bit[31:28];
            
            default: digit = 4'b0000;
        endcase
        digital_light = segment_output;
    end

endmodule
