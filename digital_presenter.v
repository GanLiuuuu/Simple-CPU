`timescale 1ns / 1ps

module digital_presenter(
    input clk,
    input rst,
    input [16:0] input_16bit,
    output reg [7:0] digital_light,
    output reg [3:0] seg_en
);

    reg [3:0] digit;
    reg [1:0] digit_sel;
    wire [7:0] segment_output;

    seven_segment_display ssd (
        .digit(digit),
        .segments(segment_output)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sel <= 2'b00;
            seg_en <= 4'b1110;//默认输出是8，给第一个灯亮灯
        end else begin
            digit_sel <= digit_sel + 1;
            seg_en <= {seg_en[2:0], seg_en[3]};  // 循环左移，激活下一个数码管
        end
    end

    always @* begin
        case (digit_sel)
            2'b00: digit = input_32bit[3:0];
            2'b01: digit = input_32bit[7:4];
            2'b10: digit = input_32bit[11:8];
            2'b11: digit = input_32bit[15:12];
            
            
            default: digit = 4'b0000;
        endcase
        digital_light = segment_output;
    end

endmodule
