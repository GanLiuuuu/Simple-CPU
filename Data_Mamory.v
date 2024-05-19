`timescale 1ns / 1ps

module Data_Mamory(
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
    // 锟节诧拷锟斤拷锟斤拷
    wire [31:0] internal_data;

    // 锟斤拷锟斤拷RAM模锟斤拷
    RAM ram (
        .addra(addr[13:0]),
        .clka(clk),
        .dina(din),
        .douta(internal_data),
        .wea(write_mem)
    );
    //read data
    always @(negedge clk,posedge rst)begin
        if(rst)begin
            dout <= 32'b0;
        end
        else begin
                if(read_mem)begin
                    dout <= {15'b0,io_rdata_switch};
                end
                else begin
                    dout <= internal_data;
                end
        end
        
    end
    always @(posedge clk,posedge rst) begin
        if(!write_mem && MemWrite)begin
            LED<=din[15:0];
        end
        if(rst)begin
            LED <= 16'b0;
        end
    end
        
 
    
endmodule
