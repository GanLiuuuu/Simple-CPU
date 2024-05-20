`timescale 1ns / 1ps

module Data_Mamory(
    input [1:0] length,//0 for b, 1 for h, 2 for w
    input sign,//0 for unsigned
    input clk,
    input rst,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] din,
    input [15:0] io_rdata_switch,
    output reg [31:0] dout,
    output reg [15:0] LED
    );
    wire read_mem;
    assign read_mem = (addr[31]==1) ? 1'b1 : 1'b0;
    wire write_mem;
    assign write_mem = (addr[31]!=1'b1 && MemWrite==1'b1) ? 1'b1:1'b0;
    // 閿熻妭璇ф嫹閿熸枻鎷烽敓鏂ゆ嫹
    wire [31:0] tmp;
    wire [31:0] tmp1;
    wire [31:0] read_data;
    wire [31:0] write_data;
    assign tmp = (read_mem)?tmp1:{16'd0,io_rdata_switch};
    assign read_data= (length==2'b10)? tmp : (length==2'b01&&sign==1'b1)? {{16{tmp[15]}},tmp[15:0]}:(length==2'b01&&sign==1'b0)?{16'd0,tmp[15:0]}:(length==2'b00&&sign==1'b1)?{{24{tmp[7]}},tmp[7:0]}:{24'd0,tmp[7:0]};
    assign write_data=(length==2'b10)? din : (length==2'b01)? {16'd0,din[15:0]}:{24'd0,din[7:0]};

    RAM ram (
        .addra(addr[13:0]),
        .clka(clk),
        .dina(write_data),
        .douta(tmp1),
        .wea(write_mem)
    );
    //read data
    always @(negedge clk,posedge rst)begin
        if(rst)begin
            dout <= 32'd0;
        end
        else begin
             dout<=read_data;
        end
        
    end
    always @(posedge clk,posedge rst) begin
        if(!write_mem && MemWrite)begin
            LED<=write_data[15:0];
        end
        if(rst)begin
            LED <= 16'b0;
        end
    end
        
 
    
endmodule
