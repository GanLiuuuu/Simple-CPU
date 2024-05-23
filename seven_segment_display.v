`timescale 1ns / 1ps

module seven_segment_display(
    input [3:0] digit,
    output reg [7:0] segments
    );
    always@* begin
        case(digit)
            4'h0: segments = 8'b1111_1100;
            4'h1: segments = 8'b0110_0000;
            4'h2: segments = 8'b1101_1010;
            4'h3: segments = 8'b1111_0010;
            
            4'h4: segments = 8'b0110_0110;
            4'h5: segments = 8'b1011_0110;
            4'h6: segments = 8'b1011_1110;
            4'h7: segments = 8'b1110_0000;

            4'h8: segments = 8'b1111_1110;
            4'h9: segments = 8'b1110_0110;
            4'hA: segments = 8'b1110_1110;
            4'hB: segments = 8'b0011_1100;
            
            4'hC: segments = 8'b1001_1100;
            4'hD: segments = 8'b0111_1010;
            4'hE: segments = 8'b1001_1110;
            4'hF: segments = 8'b1000_1110;                                    
            
        endcase
    end
    
    
    
endmodule
