module Switch (
    input clk,
    input rst,
    input SwitchCtrl,
    input [23:0] switch_rdata,

    output [15:0] switch_wdata  //  传入给memorio的data
);
    reg [15:0] sw_data;
    assign switch_wdata = sw_data;
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            sw_data <= 0;
        end else if (SwitchCtrl) begin
            sw_data[15:0] <= {8'h00, switch_rdata[7:0]}; 
        end else begin
            sw_data <= sw_data;
        end
    end
endmodule
