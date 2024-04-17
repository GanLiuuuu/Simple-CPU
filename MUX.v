module MUX (
    input wire sel,
    input wire[31:0] ReadData2,
    input wire[31:0] imm,
    output wire out
);

assign out = sel ? b : a;

endmodule
