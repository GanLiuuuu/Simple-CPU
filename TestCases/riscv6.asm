# ����һ��ȫ�ֱ�����������ջ�ͳ�ջ�Ĵ���
.data
.global stack_count
stack_count: .data 0





.text
main:
    li a7, 5
    ecall
    li a1, 1              # ���õ�ǰ쳲��������е�ֵΪ1
    li a2, 0              # ������һ��쳲��������е�ֵΪ0
    jal fib_count     

    # �������ջ�Ĵ���
    la t0, stack_count
    lw t1, 0(t0)
    mv a0,t1
    li a7, 1
    ecall
    
    # �˳�����
    li a7, 10             # �˳�����
    ecall


fib_count:
    # ������a0 - ��������
    #       a1 - ��ǰ쳲��������е�ֵ
    #       a2 - ��һ��쳲��������е�ֵ
    la t0, stack_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    li t1, 0
    li t0, 0
    
    
    addi sp, sp, -4      # ��ջ
    sw ra, 4(sp)         # ���淵�ص�ַ

    # ������һ��쳲��������е�ֵ
    mv a4, a1
    add a1, a1, a2
    mv a2, a4
    li a4, 0       
    # ����Ƿ�С����������
    bge a1, a0, end_fib   # �����ǰ쳲��������е�ֵ���ڵ����������ݣ�������ݹ�
    # ���С���������ݣ���ݹ����fib_count����
    jal ra, fib_count     # �ݹ����fib_count

end_fib:
    # ��ջ
    
    la t0, stack_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    li t1, 0
    li t0, 0
    
    lw ra, 4(sp)
    addi sp, sp, 4       # ��ջ
    jr ra





