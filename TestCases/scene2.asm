.data

.text
li s3,0xfffff000#base address of swithches
li s4,0xfffff010#base address of LED
li s5,0xfffff020#base address of button
li s6,0xfffff030#base address of seg




#���¿��أ�0->1->0ת����ͨ��loop1��loop2
loop_1: 
    lh t1, 0(s5)
    bne t1, zero, loop_1 # ���������0������ת��loop_1
    #����0����ͨ��
loop_2:
    lh t1, 0(s5)       
    beq t1, zero, loop_2
    #����1��ͨ��
    
    #�������Ѿ�������ȷ�ϼ�
     lb t3, 8(s3)         #������������� t3
     xor a0, a0, a0       # a0����,���ڼ���
     
    #��ת����Ӧ�Ĳ�������
    beq t3, a0, tb0_1  
    addi a0, a0, 1     
    beq t3, a0, tb1_1  
    addi a0, a0, 1     
    beq t3, a0, tb2_1  
    addi a0, a0, 1     
    beq t3, a0, tb3_1  
    addi a0, a0, 1        
    beq t3, a0, tb4_1   
    addi a0, a0, 1    
    beq t3, a0, tb5_1   
    addi a0, a0, 1       
    beq t3, a0, tb6_1  
    addi a0, a0, 1    
    beq t3, a0, tb7_1






tb0_1:
    lh t1, 0(s5)       
    bne t1, zero, tb0_1
tb0_2:
    lh t1, 0(s5)       
    beq t1, zero, tb0_2

    lb a0, 0(s3)     # ��ȡ��ť����
    # ����ǰ����ĸ���
    li t0, 8         # λ��
    li t1, 0         # ǰ���������

count_leading_zeros:
    srli a1, a0, 7   # ����7λȡ��Ŀǰ�����λ
    slli a0, a0, 1   # ����1λ
    beqz a1, increment  # ������λ��0����ת��increment
    j done           # ������ת��done

increment:
    addi t1, t1, 1   # ��������1
    addi t0, t0, -1  # λ����1
    bnez t0, count_leading_zeros  # �����û�б���������λ������ѭ��
done:
    sw t1, 0(s4)     # ���ǰ������������LED


tb0_3:
    lh t1, 0(s5)       
    bne t1, zero, tb0_3
tb0_4:
    lh t1, 0(s5)       
    beq t1, zero, tb0_4
    
    #����ȷ��
    lh t4, 0(s3)       # ������ص�t4
    sh t4, 0(s4)       # �����led
    
    j loop_1
	







tb1_1:
    lh t1, 0(s5)       
    bne t1, zero, tb1_1
tb1_2:
    lh t1, 0(s5)       
    beq t1, zero, tb1_2
    
    
    #����ȷ�϶�ȡ����
    lb t0, 0(s3)   
    # �� 16 λ�뾫�ȸ�������չΪ 32 λ�����ȸ�����
    srli t1, t0, 15   # �� t0 �����ƶ� 15 λ���� 16 λ�ƶ������λ,t1���ڴ����λ
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0������17λ��������λ��Ȼ������26λ����t2�У�t2���ڴ�ָ��δ����bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0����5λ����ָ��������22λ�õ�10λ��β��λ,t3���ڴ洢��β������
    addi t2, t2, -15 #�ڼ���bias֮���ҵ�ԭʼָ��λ����t2��

    li t4, 1              # β������������1
    slli t4, t4, 10
    add t3, t3, t4 #����t3�д��Ű�������λ��1.������������Ҫ�����ҵ���ʵָ�����������������������ֺ�С�����֣����������ʵָ��������λ���С�����ֲ���0��ô����ȡ��
    beqz t1, positive1
    # Ŀǰ�ҵ�t1��1bit�ķ���λ��t2��5bit��ԭʼָ��λ��t3��11bit��������1����λ����10bitβ��λ

    
negative1:
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz t6, negative_no_round1  # ���С������Ϊ0����������ȡ��
    # С�����ֲ�Ϊ0������Ҫ��1
    #sub t5, t5, t4  # t5 = t5 - 1
negative_no_round1:
    # ���ս���Ǹ���
    neg t5, t5  # ȡ�����õ������Ľ��
    j end1  # ��ת�������������

	   
    
positive1:   
	# ����������Ļ���������Ҫȷ������Щβ���ܹ�ͨ��β����ֵ���һ��������ֵ��Ȼ���ж�ʣ�µ�β���ǲ���ȫ0��
	# �������ȫ0�Ļ���ô����ȡ���������ȫ0�Ļ���ôֱ������õ�����������
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz t6, positive_noupperbound1  # ���С������Ϊ0����������ȡ��
    
    #����û��ͨ�������ô��Ҫ����ȡ��
    addi t5, t5, 1
    
    
positive_noupperbound1:
    j end1	   
    
end1:
	mv a0,t5
	sw a0, 0(s4)


tb1_3:
    lh t1, 0(s5)       
    bne t1, zero, tb1_3 
tb1_4:
    lh t1, 0(s5)       
    beq t1, zero, tb1_4
    #����ȷ��    
    j loop_1
    















tb2_1:
    lh t1, 0(s5)       
    bne t1, zero, tb2_1
tb2_2:
    lh t1, 0(s5)       
    beq t1, zero, tb2_2
    
    
    #����ȷ�϶�ȡ����
    lb t0, 0(s3)
    # ���뾫�ȸ�������ʮ��������ȡ�����洢�ؼĴ���a0�ĳ���
    # ���ذ뾫�ȸ������� t0 �Ĵ���
    
    # �� 16 λ�뾫�ȸ�������չΪ 32 λ�����ȸ�����
    srli t1, t0, 15   # �� t0 �����ƶ� 15 λ���� 16 λ�ƶ������λ,t1���ڴ����λ
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0������17λ��������λ��Ȼ������26λ����t2�У�t2���ڴ�ָ��δ����bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0����5λ����ָ��������22λ�õ�10λ��β��λ,t3���ڴ洢��β������
    addi t2, t2, -15 #�ڼ���bias֮���ҵ�ԭʼָ��λ����t2��

    li t4, 1              # β������������1
    slli t4, t4, 10
    add t3, t3, t4 #����t3�д��Ű�������λ��1.������������Ҫ�����ҵ���ʵָ�����������������������ֺ�С�����֣����������ʵָ��������λ���С�����ֲ���0��ô����ȡ��
    bnez t1, negative2
    # Ŀǰ�ҵ�t1��1bit�ķ���λ��t2��5bit��ԭʼָ��λ��t3��11bit��������1����λ����10bitβ��λ

    
positive2:
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz t6, positive_no_round2
positive_no_round2:
    j end2  # ��ת�������������

	
	
     
negative2:   
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz t6, negative_nodownbound2  # ���С������Ϊ0����������ȡ��  
    #����û��ͨ�������ô��Ҫ����ȡ��
    addi t5, t5, 1
negative_nodownbound2:
    neg t5, t5  # ȡ�����õ������Ľ��
    j end2	   
                 
end2:
	mv a0,t5
        sw a0, 0(s4)
	


tb2_3:
    lh t1, 0(s5)       
    bne t1, zero, tb2_3 
tb2_4:
    lh t1, 0(s5)       
    beq t1, zero, tb2_4
    #����ȷ��    
    j loop_1












tb3_1:
    lh t1, 0(s5)       
    bne t1, zero, tb3_1
tb3_2:
    lh t1, 0(s5)       
    beq t1, zero, tb3_2
    
    
    #����ȷ�϶�ȡ����
    lb t0, 0(s3)
    # ���뾫�ȸ�������ʮ������������ȡ�����洢�ؼĴ���a0�ĳ���

    
    # �� 16 λ�뾫�ȸ�������չΪ 32 λ�����ȸ�����
    srli t1, t0, 15   # �� t0 �����ƶ� 15 λ���� 16 λ�ƶ������λ,t1���ڴ����λ
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0������17λ��������λ��Ȼ������26λ����t2�У�t2���ڴ�ָ��δ����bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0����5λ����ָ��������22λ�õ�10λ��β��λ,t3���ڴ洢��β������
    addi t2, t2, -15 #�ڼ���bias֮���ҵ�ԭʼָ��λ����t2��

    li t4, 1              # β������������1
    slli t4, t4, 10
    add t3, t3, t4 #����t3�д��Ű�������λ��1.������������Ҫ�����ҵ���ʵָ�����������������������ֺ�С�����֣����������ʵָ��������λ���С�����ֲ���0��ô����ȡ��
    bnez t1, negative3
    # Ŀǰ�ҵ�t1��1bit�ķ���λ��t2��5bit��ԭʼָ��λ��t3��11bit��������1����λ����10bitβ��λ

    
positive3:
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli a6, t6, 31 #a6�洢��0.5λ�����֣����0.5λ��������ô�Ҿ������ľ���ֵ�Ҿ�����ȡ��
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz a6, positive_no_round3
    
    addi t5, t5, 1
    
positive_no_round3:
    j end3  # ��ת�������������

	
	
     
negative3:   
    # ���� 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # ��ȡ�������֣�����������1��
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # ȡ���������֣�t5 = t3 >> (10 - t2)
    li t6, 0

    # ʣ�µ�С������
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli a6, t6, 31 #a6�洢��0.5λ�����֣����0.5λ��������ô�Ҿ͸����ľ���ֵ�Ҿ�����ȡ��
    srli t6, t6, 22  # ����С�����ֵĸ�10λ���Ƴ�����Ҫ�Ĳ��֣�

    # ���С�������Ƿ�Ϊ0
    beqz a6, negative_nodownbound3  # ���a6С����0.5λ��0����ô�����������1�Ļ���ô�Ծ���ֵ��1
    #����û��ͨ�������ô��Ҫ����ȡ��
    addi t5, t5, 1
    
negative_nodownbound3:
    neg t5, t5  # ȡ�����õ������Ľ��
    j end3	   

  
        
                    
end3:
	mv a0,t5
        sw a0, 0(s4)
   

tb3_3:
    lh t1, 0(s5)       
    bne t1, zero, tb3_3 
tb3_4:
    lh t1, 0(s5)       
    beq t1, zero, tb3_4
    #����ȷ��    
    j loop_1




















tb4_1:
    lh t1, 0(s5)       
    bne t1, zero, tb4_1
tb4_2:
    lh t1, 0(s5)       
    beq t1, zero, tb4_2
    
    
    #����ȷ�϶�ȡ��һ������
    lw t0, 0(s3)

tb4_3:
    lh t1, 0(s5)       
    bne t1, zero, tb4_3 
tb4_4:
    lh t1, 0(s5)       
    beq t1, zero, tb4_4
    #����ȷ�϶�ȡ�ڶ�������
    lw t2, 0(s3)
    
    
     # �� a �� b ���мӷ�����
    add t3, t0, t2



    # ����Ƿ��н�λ
    li t4, 0xFF
    and t4, t4, t3  # ������8λ
    srli t5, t3, 8  # ��ȡ��λλ
    beqz t5, end4
    
    add t3, t4, t5  # ����λ�ۼӵ���8λ����
    # ȡ��
    not t3, t3
    li t4, 0xff
    and t3, t4, t3 # ����t3�ĵ�8λ��t3��

end4:
    # ������
    mv a0, t3   
    sw a0, 0(s4)


tb4_5:
    lh t1, 0(s5)       
    bne t1, zero, tb4_3 
tb4_6:
    lh t1, 0(s5)       
    beq t1, zero, tb4_4
    #����ȷ����ת
    j loop_1






tb5_1:
    lh t1, 0(s5)       
    bne t1, zero, tb5_1
tb5_2:
    lh t1, 0(s5)       
    beq t1, zero, tb5_2
#��ȡ���ݴ�s3λ��
lh a0,0(s3)
srli a0,a0,4
add t0,x0,a0
li t1,255
and a0,t0,t1
slli a0,a0,24
li t1, 65280
and t2, t0,t1
slli t2,t2,8
or a0,a0,t2
li t1, 16711680
and t2,t0,t1
srai t2,t2,8
or a0,a0,t2
srai t0,t0,24
li t1,255
and t0,t0,t1
or a0,t0,a0
srli a0,a0,16
sh a0,0(s4)



tb5_3:
    lh t1, 0(s5)       
    bne t1, zero, tb5_3 
tb5_4:
    lh t1, 0(s5)       
    beq t1, zero, tb5_4
    #����ȷ��    
    j loop_1
    
    
    
    
    
    


tb6_1:
    lh t1, 0(s5)       
    bne t1, zero, tb6_1
tb6_2:
    lh t1, 0(s5)       
    beq t1, zero, tb6_2
    

    # ��ȡ��������
    lw a2, 0(s3)
    li a0, 0                # ��ʼ��aΪ0
    li a1, 1                # ��ʼ��bΪ1
    li a6, 0                # ��a6��ʼ��Ϊ��ջ�Ĵ���
    li a7, 0                # ��a7��ʼ��Ϊ��ջ�Ĵ���
    jal ra, fib_count6       # ���� fib_count ����
    j done6


# �ݹ麯�������㲻�����������ֵ�쳲��������ĸ���
# a0: ��ǰ쳲�������a
# a1: ��һ��쳲�������b
# a2: ��������n
# ����ֵ��a0 �еĲ������������ֵ�쳲��������ĸ���
fib_count6:
    addi sp, sp, -20        # ��ջ������ջ�ռ�
    sw ra, 16(sp)           # ���淵�ص�ַ
    sw a0, 12(sp)           # �������a
    sw a1, 8(sp)            # �������b
    sw a2, 4(sp)            # �������n


    addi a6, a6, 1          # ��ջ���� +1


    bgt a0, a2, return_zero6 # �����ǰ쳲�����������n���򷵻�0

    add a3, a0, a1          # ������һ��쳲���������a3 = a + b
    mv t2, a1               # ����a1��t2
    mv t3, a3               # ����a3��t3

    # �ݹ���� fib_count(b, a+b, n)
    mv a0, a1
    mv a1, a3
    jal ra, fib_count6       # �ݹ����
    addi t1, a0, 1          # count = 1 + fib_count(b, a+b, n)

return_zero6:
    addi a7, a7, 1          # ��ջ���� +1


    lw ra, 16(sp)           # �ָ����ص�ַ
    lw a0, 12(sp)           # �ָ�����a
    lw a1, 8(sp)            # �ָ�����b
    lw a2, 4(sp)            # �ָ�����n
    addi sp, sp, 20         # ��ջ���ͷ�ջ�ռ�
    ret



    
done6:
    add a0, t6, a7
    sw a0, 0(s4)



tb6_3:
    lh t1, 0(s5)       
    bne t1, zero, tb6_3 
tb6_4:
    lh t1, 0(s5)       
    beq t1, zero, tb6_4
    #����ȷ��    
    j loop_1
    
    
    
    
    
    
    
tb7_1:
    lh t1, 0(s5)       
    bne t1, zero, tb7_1
tb7_2:
    lh t1, 0(s5)       
    beq t1, zero, tb7_2
    

    # ��ȡ��������
    lw a2, 0(s3)
    li a0, 0                # ��ʼ��aΪ0
    li a1, 1                # ��ʼ��bΪ1
    li a6, 0                # ��a6��ʼ��Ϊ��ջ�Ĵ���
    li a7, 0                # ��a7��ʼ��Ϊ��ջ�Ĵ���
    jal ra, fib_count7       # ���� fib_count ����
    j done7


# �ݹ麯�������㲻�����������ֵ�쳲��������ĸ���
# a0: ��ǰ쳲�������a
# a1: ��һ��쳲�������b
# a2: ��������n
# ����ֵ��a0 �еĲ������������ֵ�쳲��������ĸ���
fib_count7:
    li t1, 43500000# ��t1��ѭ��չʾ�Ĵ���
    
    addi sp, sp, -20        # ��ջ������ջ�ռ�
    sw ra, 16(sp)           # ���淵�ص�ַ
    sw a0, 12(sp)           # �������a
    sw a1, 8(sp)            # �������b
    sw a2, 4(sp)            # �������n
    loop_in_a07:# ����������Ҫչʾÿ������Ĳ���2-3s��ѭ��������loop_number
    	li t2, 0
    	sw a0, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a07
    loop_in_a17:	
    	li t2, 0
    	sw a1, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a17
    loop_in_a27:	
    	li t2, 0
    	sw a2, 0(t5)
    	addi t2, t2, 1
    	ble t2, t1, loop_in_a27
    li t0, 0
    li t1, 0
    li t2, 0# ��ʼ����������



    addi a6, a6, 1          # ��ջ���� +1


    bgt a0, a2, return_zero7 # �����ǰ쳲�����������n���򷵻�0

    add a3, a0, a1          # ������һ��쳲���������a3 = a + b
    mv t2, a1               # ����a1��t2
    mv t3, a3               # ����a3��t3

    # �ݹ���� fib_count(b, a+b, n)
    mv a0, a1
    mv a1, a3
    jal ra, fib_count7       # �ݹ����
    addi t1, a0, 1          # count = 1 + fib_count(b, a+b, n)

return_zero7:
    addi a7, a7, 1          # ��ջ���� +1


    lw ra, 16(sp)           # �ָ����ص�ַ
    lw a0, 12(sp)           # �ָ�����a
    lw a1, 8(sp)            # �ָ�����b
    lw a2, 4(sp)            # �ָ�����n
    addi sp, sp, 20         # ��ջ���ͷ�ջ�ռ�
    ret

 
done7:
    add a0, a6, a7
    sw a0, (s4)


tb7_3:
    lh t1, 0(s5)       
    bne t1, zero, tb7_3 
tb7_4:
    lh t1, 0(s5)       
    beq t1, zero, tb7_4
    #����ȷ��    
    j loop_1 
    
       
          
             
                


