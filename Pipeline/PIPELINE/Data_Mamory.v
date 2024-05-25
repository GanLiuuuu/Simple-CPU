`timescale 1ns / 1ps

module Data_Mamory(
    input [1:0] in_length,//0 for b, 1 for h, 2 for w
    input in_sign,//0 for unsigned
    input clk,
    input hdw_clk,
    input rst,
    input MemtoReg,
    input RegWrite,
    input in_MemRead,
    input in_MemWrite,
    input [4:0] EX_WriteReg,
    input[31:0] EX_ALUResult,
    input [31:0] in_addr,
    input [31:0] in_din,
    input [15:0] io_rdata_switch,
    input buttonOn,
    output reg [31:0] dout,
    output reg [15:0] LED,
    output reg[31:0] M_din,
    output wire[31:0] M_dout,
    output reg M_MemtoReg,
    output reg M_RegWrite,
    output reg[4:0] M_WriteReg,
    output reg[31:0] M_ALUResult
    );
    reg[1:0] length;
    reg sign;
    reg MemRead;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] din;
    assign M_dout = dout;
    
    always @(negedge clk, posedge rst)begin
        if(rst)begin
            M_din <= 32'd0;
            M_MemtoReg <= 1'b0;
            M_RegWrite <= 1'b0;
            M_WriteReg <= 5'd0;
            M_ALUResult <= 32'd0;
            length <= 2'b00;
            sign<=1'b0;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            addr <= 32'd0;
            din <= 32'd0;
        end
        else begin
            M_din<= in_din;
            M_MemtoReg <= MemtoReg;
            M_RegWrite <= RegWrite;
            M_WriteReg <= EX_WriteReg;
            M_ALUResult <= EX_ALUResult;
            length <= in_length;
            sign <= in_sign;
            MemRead <= in_MemRead;
            MemWrite <= in_MemWrite;
            addr <= in_addr;
            din <= in_din;
        end
    end
    wire[15:0] tmp3;
    wire read_mem;
    assign read_mem = (addr[31]==1) ? 1'b0 : 1'b1;
    wire write_mem;
    assign write_mem = (addr[31]!=1'b1 && MemWrite==1'b1) ? 1'b1:1'b0;
    // 锟节诧拷锟斤拷锟斤拷
    wire [31:0] tmp;
    wire [31:0] tmp1;
    wire [31:0] read_data;
    wire [31:0] write_data;
    wire[3:0] a;
    assign a = addr[3:0];
    wire[31:0] tmp2;
    assign tmp2 = {16'd0,io_rdata_switch[15:0]} >>> a;
    assign tmp = (read_mem)?tmp1:tmp2;
    assign read_data= (addr[31]==1&&addr[5]==1'b1)?{31'd0,buttonOn}:(length==2'b10)? tmp : (length==2'b01&&sign==1'b1)? {{16{tmp[15]}},tmp[15:0]}:(length==2'b01&&sign==1'b0)?{16'd0,tmp[15:0]}:(length==2'b00&&sign==1'b1)?{{24{tmp[7]}},tmp[7:0]}:{24'd0,tmp[7:0]};
    assign write_data=(length==2'b10)? din : (length==2'b01)? {16'd0,din[15:0]}:{24'd0,din[7:0]};

   //data written back to led
    assign tmp3 = write_data[15:0]<<<a;
    RAM ram (
        .addra(addr[13:0]),
        .clka(hdw_clk),
        .dina(write_data),
        .douta(tmp1),
        .wea(write_mem)
    );
    //read data
    always @(*)begin
        dout=read_data;
    end
    always @(posedge clk,posedge rst) begin
        if(!write_mem && MemWrite)begin
            LED[15:0]<=tmp3[15:0];
        end
        if(rst)begin
            LED <= 16'd0;
        end
    end
        
 
    
endmodule
