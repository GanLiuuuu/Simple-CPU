`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module switch(input clk,                      
               input rst,                      // Reset
               input IORead,                   // IO sign
               input SwitchCtrl,               // Switch ctrl
               input [1:0] switchaddr,         // Switch address
               input [15:0] switch,            // Switch
               output reg [15:0] switchrdata); // Switch read data
    
    always@(negedge clk or posedge rst) begin
        if (rst) begin
            switchrdata <= 16'h0000;
        end
        else if (SwitchCtrl && IORead) begin
            if (switchaddr == 2'b00)
                switchrdata[15:0] <= switch[15:0];
            else if (switchaddr == 2'b10)
                switchrdata[15:0] <= { 8'h00, switch[15:8] };
            else
                switchrdata <= switchrdata;
        end
        else begin
            switchrdata <= switchrdata;
        end
    end
endmodule