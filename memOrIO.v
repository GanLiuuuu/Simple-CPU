module MemOrIO (
    input clk,
    input rst,
    input mRead,  // read memory, from control32 
    input mWrite,  // write memory, from control32 
    input [31:0] data_in,  // data read from idecode32(register file) 
    input [31:0] addr_in,  // from alu_result in executs32 

    input [15:0] io_rdata_switch,  // data read from switch,16 bits
    output reg [31:0] data_out,
    output reg [15:0] LED; 
    

);
    always @(posedge clk, posedge rst)begin
        if(rst)begin

        end
        else begin
        end
    end

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
