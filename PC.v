`timescale 1ns / 1ps

module PC(
    input en,
    input[31:0]  Addr_result,           // 来自ALU,为ALU计算出的跳转地址(beq)
    input        clock,          //时钟
    input        reset,              //复位信号高电平有效
    input        Branch,                // 来自controller（判断是否是beq）
    input        Zero,                  //来自ALU（判断是否相等）
     
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    wire [31:0] Next_PC;
    assign Next_PC = ((Branch == 1) && (Zero == 1 ))?Addr_result:PC_plus_4;
    assign PC_plus_4 = PC + 4;


    always @(posedge en or posedge reset) begin
        if(reset == 1)
            PC <= 32'd0;
        else if(en)
            PC <= Next_PC;
    end
endmodule
