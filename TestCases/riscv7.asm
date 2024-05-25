.data
input_num:    .word 20       # �������֣�����Ϊ20
stack_count:  .word 0        # ��¼��ջ����
unstack_count:.word 0        # ��¼��ջ����
result:      .word 0         # ��Ž��
loop_number: .word 43500000


.text

main:
    li t6,0xfffff000#base address of swithches
    li t5,0xfffff010#base address of LED
	
    la a2, input_num        # ��ȡ��������
    lw a2, 0(a2)
    li a0, 0                # ��ʼ��aΪ0
    li a1, 1                # ��ʼ��bΪ1
    jal ra, fib_count       # ���� fib_count ����
    j done


# �ݹ麯�������㲻�����������ֵ�쳲��������ĸ���
# a0: ��ǰ쳲�������a
# a1: ��һ��쳲�������b
# a2: ��������n
# ����ֵ��a0 �еĲ������������ֵ�쳲��������ĸ���
fib_count:
    la t0, loop_number
    lw t1, 0(t0)# ��t1��ѭ��չʾ�Ĵ���
    
    addi sp, sp, -20        # ��ջ������ջ�ռ�
    sw ra, 16(sp)           # ���淵�ص�ַ
    sw a0, 12(sp)           # �������a
    sw a1, 8(sp)            # �������b
    sw a2, 4(sp)            # �������n
    loop_in_a0:# ����������Ҫչʾÿ������Ĳ���2-3s��ѭ��������loop_number
    	li t2, 0
    	sw a0, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a0
    loop_in_a1:	
    	li t2, 0
    	sw a1, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a0
    loop_in_a2:	
    	li t2, 0
    	sw a2, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a0	
    li t0, 0
    li t1, 0
    li t2, 0# ��ʼ����������


    la t0, stack_count      # ��ȡ��ǰ��ջ����
    lw t1, 0(t0)
    addi t1, t1, 1          # ��ջ���� +1
    sw t1, 0(t0)

    bgt a0, a2, return_zero # �����ǰ쳲�����������n���򷵻�0

    add a3, a0, a1          # ������һ��쳲���������a3 = a + b
    mv t2, a1               # ����a1��t2
    mv t3, a3               # ����a3��t3

    # �ݹ���� fib_count(b, a+b, n)
    mv a0, a1
    mv a1, a3
    jal ra, fib_count       # �ݹ����
    addi t1, a0, 1          # count = 1 + fib_count(b, a+b, n)

return_zero:
    la t0, unstack_count    # ��ȡ��ǰ��ջ����
    lw t2, 0(t0)
    addi t2, t2, 1          # ��ջ���� +1
    sw t2, 0(t0)

    lw ra, 16(sp)           # �ָ����ص�ַ
    lw a0, 12(sp)           # �ָ�����a
    lw a1, 8(sp)            # �ָ�����b
    lw a2, 4(sp)            # �ָ�����n
    addi sp, sp, 20         # ��ջ���ͷ�ջ�ռ�
    ret

 
done:
    la t0, stack_count
    lw t1, 0(t0)
    la t0, unstack_count
    lw t2, 0(t0)
    add a0, t1, t2
    sw a0, (t5) # �ѽ������t5led�Ļ�׼��ַλ��
    li a7, 1
    ecall
               
