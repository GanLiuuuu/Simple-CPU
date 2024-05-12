`timescale 1ns / 1ps

module PC(

    input[31:0]  Addr_result,            // ����ALU,ΪALU���������ת��ַ(beq)
    input        clock,           //ʱ��
    input        reset,           //��λ�źŸߵ�ƽ��Ч
    input        Branch,               // ����controller���ж��Ƿ���beq��
    input        Zero,                  //����ALU���ж��Ƿ���ȣ�
     
    output[31:0] branch_base_addr,   // ��������תָ���ֵΪPC������ALU
    output [31:0] PC_plus_4,        // PC + 4;
    output reg [31:0] PC = 32'b0
    );
    reg [31:0] Next_PC = 32'b0;
    assign PC_plus_4 = PC + 4;
    assign branch_base_addr = PC;
    always @* begin
        if((Branch == 1) && (Zero == 1 ))   //beqָ������ת
            Next_PC = Addr_result;
        else 
            Next_PC = PC_plus_4; // PC+4
    end

    always @(negedge clock or posedge reset) begin
        if(reset == 1)
            PC <= 32'b0;
        else
            PC <= Next_PC;
    end
endmodule