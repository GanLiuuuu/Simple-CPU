`define ADDfunc 10'b0000000000
`define SUBfunc 10'b0100000000
`define ANDfunc 10'b0000000111
`define ORfunc  10'b0000000110
`define XORfunc 10'b0000000100
`define SLLfunc 10'b0000000001
`define SRLfunc 10'b0000000101
`define SRAfunc 10'b0100000101 

`define ADDControl 4'b0010
`define SUBControl 4'b0110
`define ANDControl 4'b0000
`define ORControl 4'b0001
`define XORControl 4'b0011
`define SHIRFTControl 4'b1111

`define SHIRFTRIGHT 1'b1
`define SHIRFTLOGIC 1'b1
//branch type
`define EQ 3'b000
`define NE 3'b001
`define LT 3'b100
`define GE 3'b101
`define LTU 3'b110
`define GEU 3'b111
