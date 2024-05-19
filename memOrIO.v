module MemOrIO (
    input mRead,  // read memory, from control32 
    input mWrite,  // write memory, from control32 
    input ioRead,  // read IO, from control32 
    input ioWrite,  // write IO, from control32 
    input [31:0] m_rdata,  // data read from memory 
    input [31:0] r_rdata,  // data read from idecode32(register file) 
    input [31:0] addr_in,  // from alu_result in executs32 

    input [15:0] io_rdata_switch,  // data read from switch,16 bits
    input io_rdata_btn,

    output [31:0] addr_out,  // address to memory 
    output [31:0] r_wdata,  // data to idecode32(register file) 

    output reg [31:0] write_data,  // data to memory or I/O（m_wdata, io_wdata） 

    output LEDCtrlhigh,  // LED Chip Select
    
    output SwitchCtrl,  //拨码开关
    output SegCtrl  //七段数码显示管

);

    assign addr_out = addr_in;
    wire ck_in;

    wire [3:0] low_addr = addr_in[3:0];
    reg [15:0] io_rdata;

    assign r_wdata = mRead ? m_rdata : {16'h0000, io_rdata};
    assign LEDCtrlhigh = (ioWrite && low_addr == 4'h0) ? 1'b1 :1'b0;
    assign SegCtrl = (ioWrite && low_addr == 4'h8) ?  1'b1 : 1'b0;

    assign SwitchCtrl = (ioRead && low_addr == 4'h0) ?  1'b1 :1'b0;
    assign ckin = (ioRead && low_addr == 4'h4) ?  1'b1 :1'b0;


    always @(*) begin
        if (SwitchCtrl) begin
            io_rdata = io_rdata_switch;
        end else if (ckin) begin
            io_rdata = {15'b0, io_rdata_btn};
        end
    end

    always @(*) begin
        if (mWrite || ioWrite) begin
            write_data = r_rdata;
        end else begin
            write_data = 32'hZZZZZZZZ;
        end
    end
endmodule
