.data
src_addr1: .byte 0xc1   # �����һ�������� a = 0x41 11000001   c1 11000001
src_addr2: .byte 0xc2   # ����ڶ��������� b = 0x42 11000010   c2 11000010

.text
.globl main
main:

    # ���ص�һ��8λ�� a �� t0 �Ĵ���
    la t1, src_addr1
    lb t0, 0(t1)
    # ���صڶ���8λ�� b �� t2 �Ĵ���
    la t1, src_addr2
    lb t2, 0(t1)
    
    
    li t1, 0xfffff000
    lb t0, 0(a1)
    li t1, 0
    
    li t1, 0xfffff000
    lb t2, 0(a1)
    li t1, 0
    
    
    
    
    
    
    
    
    
    # �� a �� b ���мӷ�����
    add t3, t0, t2



    # ����Ƿ��н�λ
    li t4, 0xFF
    and t4, t4, t3  # ������8λ
    srli t5, t3, 8  # ��ȡ��λλ
    beqz t5, end
    
    add t3, t4, t5  # ����λ�ۼӵ���8λ����
    # ȡ��
    not t3, t3


end:
    # ������
    mv a0, t3
    li a7, 1
    ecall
    #li a7, 10
    #ecall
    
    li a1, 0xfffff010
    sw a0, 0(a1)
