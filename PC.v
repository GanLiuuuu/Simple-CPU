`timescale 1ns / 1ps

module PC(

    input[31:0]  Addr_result,            // 閺夈儴鍤淎LU,娑撶瘓LU鐠侊紕鐣婚崙铏规畱鐠哄疇娴嗛崷鏉挎絻(beq)
    input        clock,           //閺冨爼鎸?
    input        reset,           //婢跺秳缍呮穱鈥冲娇妤傛鏁搁獮铏箒閺侊拷
    input        Branch,               // 閺夈儴鍤渃ontroller閿涘牆鍨介弬顓熸Ц閸氾附妲竍eq閿涳拷
    input        Zero,                  //閺夈儴鍤淎LU閿涘牆鍨介弬顓熸Ц閸氾妇娴夌粵澶涚礆
     
    output[31:0] branch_base_addr,   // 閺堝娼禒鎯扮儲鏉烆剚瀵氭禒銈忕礉鐠囥儱锟介棿璐烶C閿涘矂锟戒礁绶欰LU
    output reg [31:0] PC
    );
    wire[31:0] PC_plus_4;

    reg [31:0] Next_PC = 32'b0;
    assign PC_plus_4 = PC + 4;
    assign branch_base_addr = PC;
    always @* begin
        if(((Branch == 1) && (Zero == 1 )))  //鐠哄疇娴?
            Next_PC = Addr_result;
        else 
            Next_PC = PC_plus_4; // PC+4
    end

    always @(posedge clock or posedge reset) begin
        if(reset == 1)
            PC <= 32'd0;
        else
            PC <= Next_PC;
    end
endmodule
