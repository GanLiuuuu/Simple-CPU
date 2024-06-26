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
    output reg [15:0] LED,
    
    // UART Programmer Pinouts 
     input upg_rst_i,  // UPG reset (Active High)
     input upg_clk_i,  // UPG ram_clk_i (10MHz) 
     input upg_wen_i,  // UPG write enable 
     input [13:0] upg_adr_i,  // UPG write address 
     input [31:0] upg_dat_i,  // UPG write data 
     input upg_done_i  // 1 if programming is finished
    );  
    wire[15:0] tmp3;
    wire read_mem;
    assign read_mem = (addr[31]==1) ? 1'b0 : 1'b1;
    wire write_mem;
    assign write_mem = (addr[31]!=1'b1 && MemWrite==1'b1) ? 1'b1:1'b0;
    // 閿熻妭璇ф嫹閿熸枻鎷烽敓鏂ゆ嫹
    wire [31:0] tmp;
    wire [31:0] tmp1;
    wire [31:0] read_data;
    wire [31:0] write_data;
    wire[3:0] a;
    assign a = addr[3:0];
    wire[31:0] tmp2;
    assign tmp2 = {16'd0,io_rdata_switch[15:0]} >>> a;
    assign tmp = (read_mem)?tmp1:tmp2;
    assign read_data= (length==2'b10)? tmp : (length==2'b01&&sign==1'b1)? {{16{tmp[15]}},tmp[15:0]}:(length==2'b01&&sign==1'b0)?{16'd0,tmp[15:0]}:(length==2'b00&&sign==1'b1)?{{24{tmp[7]}},tmp[7:0]}:{24'd0,tmp[7:0]};
    assign write_data=(length==2'b10)? din : (length==2'b01)? {16'd0,din[15:0]}:{24'd0,din[7:0]};


      //data written back to led
     assign tmp3 = write_data[15:0]<<<a;
    
        // CPU work on normal mode when kickOff is 1. 
        //CPU work on Uart communicate mode when kickOff is 0.
         wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
         RAM ram (
             .clka(kickOff ? clk : upg_clk_i),
             .wea(kickOff ? write_mem : upg_wen_i),
             .addra(kickOff ? addr[13:0] : upg_adr_i),
             .dina(kickOff ? write_data : upg_dat_i),
             .douta(tmp1)
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
            always @(negedge clk,posedge rst) begin
                if(!write_mem && MemWrite)begin
                    LED[15:0]<=tmp3[15:0];
                end
                if(rst)begin
                    LED <= 16'b0;
                end
            end
        
 
    
endmodule
