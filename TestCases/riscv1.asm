.data
# input_data: .byte 0x00


.text
# la a1, input_data
# lw a0, 0(a1)
# li a1, 0
li a1, 0xfffff000
lw a0, 0(a1)
li a1, 0

 # ����ǰ����ĸ���
li t0, 8          # λ��
li t1, 0          # ǰ���������

count_leading_zeros:
    srli a1, a0, 7     # ����7λ�Ӷ�ȡ��Ŀǰ����ߵ�����
    slli a0, a0, 1
    beqz a1, increment   # ������λ��0����ת��increment��ǩ
    j done            # ������ת��done��ǩ

increment:
    addi t1, t1, 1    # ��������1
    addi t0, t0, -1
    bnez t0, count_leading_zeros  # �����û�б���������λ������ѭ��

done:
    # ���ǰ����ĸ���
    #li a7, 1          # ʹ��ϵͳ���ñ�� 1 �������
    #mv a0, t1
    #ecall

    # �˳�����
    #li a7, 10         # ʹ��ϵͳ���ñ�� 10 �˳�����
    #ecall
    li a1, 0xfffff010
    sw a0, 0(a1)

