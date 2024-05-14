`include "variables.vh"
module getWriteData(
    input mux_signal,
    input[`REGWIDTH-1:0] ReadData,
    input[`REGWIDTH-1:0] ALUResult,
    output[`REGWIDTH-1:0] WriteData
);
assign WriteData = (mux_signal = 1) ? ReadData : ALUResult;
endmodule
