`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module MemOrIO(input mRead,                  // Read memory, from Controller
               input mWrite,                 // Write memory, from Controller
               input IORead,                 // Read IO, from Controller
               input IOWrite,                // Read IO, from Controller
               
               input[31:0] addr_in,          // From Alu_result in ALU
               output[31:0] addr_out,        // Address to Data-Memory
               
               input[31:0] m_rdata,          // Data read from Data-Memory
               input[15:0] io_rdata,         // Data read from IO, 16 bits
               output[31:0] r_wdata,         // Data to Decoder(register file)
               
               input[31:0] r_rdata,          // Data read from Decoder(register file)
               output reg [31:0] write_data, // Data to memory or I/O
               output reg [31:0] write_data_seg, // Data to I/O
               output LEDCtrl,               // LED Chip Select
               output SEGCtrl,               // SEG Chip Select
               output SwitchCtrl);           // Switch Chip Select
    
    assign addr_out   = addr_in;
    assign r_wdata    = (IORead == 1)?{16'h0000,io_rdata}:m_rdata; // may from memory or I/O, if from I/O, it is rdata's lower 16bit
    assign LEDCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0110)?1'b1:1'b0; // ledCtrl, 1 is effective;
    assign SEGCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0101)?1'b1:1'b0; //segCtrl, 1 is effective
    assign SwitchCtrl = (IORead == 1'b1 && addr_in[7:4] == 4'b0111)?1'b1:1'b0; //switchCtrl, 1 is effective
    
    always @*begin
        if ((mWrite == 1'b1)||(IOWrite == 1'b1)) begin
            write_data = ((mWrite == 1'b1)?r_rdata:{16'h0000,r_rdata[15:0]});
            write_data_seg = {16'h0000,r_rdata[15:0]};
            end
        else begin
            write_data = 32'hZZZZ_ZZZZ;
            write_data_seg = 32'hZZZZ_ZZZZ;
        end
    end
endmodule