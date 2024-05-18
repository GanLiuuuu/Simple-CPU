module MemOrIO_tb();

    reg mRead, mWrite, ioRead, ioWrite;
    reg [31:0] addr_in, m_rdata, r_rdata;
    reg [15:0] io_rdata_switch, io_rdata_btn;
    wire [31:0] addr_out, r_wdata;
    wire LEDCtrlhigh, LEDCtrllow, SwitchCtrl, SegCtrl;

    MemOrIO umio (
        .mRead(mRead),
        .mWrite(mWrite),
        .ioRead(ioRead),
        .ioWrite(ioWrite),
        .m_rdata(m_rdata),
        .r_rdata(r_rdata),
        .addr_in(addr_in),
        .io_rdata_switch(io_rdata_switch),
        .io_rdata_btn(io_rdata_btn),
        .addr_out(addr_out),
        .r_wdata(r_wdata),
        .write_data(),
        .LEDCtrlhigh(LEDCtrlhigh),
        .LEDCtrllow(LEDCtrllow),
        .SwitchCtrl(SwitchCtrl),
        .SegCtrl(SegCtrl)
    );

    initial begin
        m_rdata = 32'hffff_0001;
        r_rdata = 32'h0f0f_0f0f;
        addr_in = 32'h4;
        io_rdata_switch = 16'hffff;
        io_rdata_btn = 16'h0000;
        mRead = 1'b0;
        mWrite = 1'b0;
        ioRead = 1'b0;
        ioWrite = 1'b0;

        #10;
        mRead = 1'b0;
        mWrite = 1'b1;
        ioRead = 1'b0;
        ioWrite = 1'b0;
        addr_in = 32'hffff_fc60;

        #10;
        mRead = 1'b0;
        mWrite = 1'b0;
        ioRead = 1'b0;
        ioWrite = 1'b1;
        addr_in = 32'hffff_fc70;

        #10;
        mRead = 1'b1;
        mWrite = 1'b0;
        ioRead = 1'b0;
        ioWrite = 1'b0;
        addr_in = 32'h0000_0004;

        #10;
        $finish;
    end

endmodule
