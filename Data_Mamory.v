`timescale 1ns / 1ps

module Data_Mamory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
    );
    
    // 内部变量
        reg [31:0] internal_data;
        reg [31:0] dout_reg;
    
        // 连接RAM模块
        RAM ram (
            .addra(addr[13:0]),
            .clka(clk),
            .dina(din),
            .douta(internal_data),
            .wea(MemWrite)
        );
    
        // 读写控制
        always @(posedge clk) begin
            if (MemRead) begin
                dout_reg <= internal_data;
            end
        end
        
        assign dout = dout_reg;   
    
endmodule
