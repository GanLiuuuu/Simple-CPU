`timescale 1ns / 1ps
module Toptb();
reg rst;
reg clk;
wire[31:0] out;
reg[15:0] switches;
wire[15:0] LED;

TOP top(clk,rst,switches,out,LED);
initial begin
    switches = 16'b0;
    clk = 1'b0;
    rst = 1'b1;
    #5 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule
