`timescale 1ns / 1ps

module System(
    input en,
    input reset,
    input enable,
    output reg active,
    output reg [31:0] sys_inst
);
    reg[3:0] count;
    reg[31:0] instructions[0:13];
    reg enable_d1; // 上一个时钟周期的使能信号值
    reg [3:0] count;
    always @(posedge en or posedge reset) begin
        if (reset) begin
            count <= 8'b0;   // 复位时计数器清零
            active <= 0;     // 复位时计数器停止活动
            enable_d1 <= 0;  // 复位时上一个时钟周期的使能信号为低
        end else begin
            enable_d1 <= enable; // 记录上一个时钟周期的使能信号值

            if (enable && !enable_d1) begin
                count <= 8'b0;   // 当使能信号上升沿且计数器处于非活动状态时，将计数器清零
                active <= 1;     // 计数器重新激活
            end else if (enable && count == 4'd13) begin
                count <= 8'b0;   // 达到指定次数时计数器清零
                active <= 0;     // 计数器停止活动
            end else begin
                count <= count + 1; // 正常计数
                active <= 1;        // 计数器处于活动状态
            end
        end
    end
    always @(posedge en or posedge reset) begin
        if(reset == 1)begin
            instructions[0] <= 32'd0;
            instructions[1] <= 32'hfffff2b7;
            instructions[2] <= 32'h00028293;
            instructions[3] <= 32'hfffff337;
            instructions[4] <= 32'h01030313;
            instructions[5] <= 32'h00088463;
            instructions[6] <=32'h00c0006f;
            instructions[7] <=32'h00029503;
            instructions[8] <= 32'h0080006f;
            instructions[9] <= 32'h00a31023;
            instructions[10] <= 32'd0;
            instructions[11] <= 32'd0;
            instructions[12] <= 32'd0;
            instructions[13] <= 32'd0;
        end
    end
    always@(*) begin
        sys_inst = instructions[count];
    end
endmodule
