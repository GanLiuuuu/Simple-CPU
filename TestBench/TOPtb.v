`timescale 1ns / 1ps
module Toptb();
reg rst;
reg clk;
wire[31:0] out;
TOP top(clk,rst,out);
initial begin
    clk = 1'b0;
    rst = 1'b1;
    #30 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule
