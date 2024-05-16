`timescale 1ns / 1ps

module PC(

    input[31:0]  Addr_result,            // 来自ALU,为ALU计算出的跳转地址(beq)
    input        clock,           //时钟
    input        reset,           //复位信号高电平有效
    input        Branch,               // 来自controller（判断是否是beq）
    input        Zero,                  //来自ALU（判断是否相等）
     
    output[31:0] branch_base_addr,   // 有条件跳转指令，该值为PC，送往ALU
    output reg [31:0] PC
    );
    reg [31:0] Next_PC = 32'b0;
    assign PC_plus_4 = PC + 4;
    assign branch_base_addr = PC;
    always @* begin
        if(((Branch == 1) && (Zero == 1 )))  //跳转
            Next_PC = Addr_result;
        else 
            Next_PC = PC_plus_4; // PC+4
    end

    always @(negedge clock or posedge reset) begin
        if(reset == 1)
            PC <= 32'b0;
        else
            PC <= Next_PC;
    end
endmodule
