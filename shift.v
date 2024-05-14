`include "variables.v"
`include "ALUvariables.v"
module shift(
    input shift_dir,
    input shift_type,
    input[`REGWIDTH-1:0] rs1,
    input[`REGWIDTH-1:0] rs2,
    output [`REGWIDTH-1:0] rd
);

assign rd = (shift_dir == `SHIRFTRIGHT && shift_type == `SHIRFTLOGIC) ? (rs1 >> rs2) :
            (shift_dir == `SHIRFTRIGHT) ? (rs1 >>> rs2) : (rs1 << rs2);

endmodule
