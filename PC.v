`timescale 1ns / 1ps

module PC(
    input en,
    input[31:0]  Addr_result,            // 閺夈儴鍤淎LU,娑撶瘓LU鐠侊紕鐣婚崙铏规畱鐠哄疇娴嗛崷鏉挎絻(beq)
    input        clock,           //閺冨爼鎸?
    input        reset,           //婢跺秳缍呮穱鈥冲娇妤傛鏁搁獮铏箒閺侊拷
    input        Branch,               // 閺夈儴鍤渃ontroller閿涘牆鍨介弬顓熸Ц閸氾附妲竍eq閿涳拷
    input        Zero,                  //閺夈儴鍤淎LU閿涘牆鍨介弬顓熸Ц閸氾妇娴夌粵澶涚礆
     
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    wire [31:0] Next_PC;
    assign Next_PC = ((Branch == 1) && (Zero == 1 ))?Addr_result:PC_plus_4;
    assign PC_plus_4 = PC + 4;


    always @(posedge en or posedge reset) begin
        if(reset == 1)
            PC = 32'd0;
        else if(en)
            PC = Next_PC;
    end
endmodule
