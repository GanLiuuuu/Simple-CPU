module LED (
    input clk,  // ʱ���ź�
    input rst,  // ��λ�ź�
    input LEDCtrllow,  // ��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�   

    input LEDCtrlhigh,  // ��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź� 

    input [15:0] ledwdata,  //  д��LEDģ������ݣ�ע��������ֻ��16��

    output reg [23:0] ledout  //  ������������24λLED�ź�
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledout <= 24'h000000;
        end else if (LEDCtrllow) begin
            ledout[23:0] <= {ledout[23:16], ledwdata[15:0]};
        end else if (LEDCtrlhigh) begin
            ledout[23:0] <= {ledwdata[7:0], ledout[15:0]};
        end else begin
            ledout <= ledout;
        end
    end
endmodule