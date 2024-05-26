.data

.text
li s3,0xfffff000#base address of swithches
li s4,0xfffff010#base address of LED
li s5,0xfffff020#base address of button
li s6,0xfffff030#base address of seg




#按下开关：0->1->0转换，通过loop1和loop2
loop_1: 
    lh t1, 0(s5)
    bne t1, zero, loop_1 # 如果不等于0，则跳转到loop_1
    #等于0，则通过
loop_2:
    lh t1, 0(s5)       
    beq t1, zero, loop_2
    #等于1，通过
    
    #到这里已经按下了确认键
     lb t3, 8(s3)         #输入测试样例到 t3
     xor a0, a0, a0       # a0清零,用于计数
     
    #跳转到对应的测试样例
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
    addi a0, a0, 1 
        
    






tb0_1:
    lh t1, 0(s5)       
    bne t1, zero, tb0_1
tb0_2:
    lh t1, 0(s5)       
    beq t1, zero, tb0_2

    lb a0, 0(s3)     # 读取按钮输入
    # 计算前导零的个数
    li t0, 8         # 位数
    li t1, 0         # 前导零计数器

count_leading_zeros:
    srli a1, a0, 7   # 右移7位取得目前的最高位
    slli a0, a0, 1   # 左移1位
    addi t0, t0, -1  # 位数减1
    beqz a1, increment  # 如果最高位是0，跳转到increment
    j done           # 否则跳转到done

increment:
    addi t1, t1, 1   # 计数器加1
    bnez t0, count_leading_zeros  # 如果还没有遍历完所有位，继续循环
done:
    sw t1, 0(s4)     # 输出前导零计数结果到LED


tb0_3:
    lh t1, 0(s5)       
    bne t1, zero, tb0_3
tb0_4:
    lh t1, 0(s5)       
    beq t1, zero, tb0_4
    
    #按下确认
    lh t4, 0(s3)       # 输入加载到t4
    sh t4, 0(s4)       # 输出到led
    
    j loop_1

	
		
			
      
                

tb1_1:
    lh t1, 0(s5)       
    bne t1, zero, tb1_1
tb1_2:
    lh t1, 0(s5)       
    beq t1, zero, tb1_2
    
    
    #按下确认读取数据
    lhu t0, 0(s3)   
    # 将 16 位半精度浮点数拓展为 32 位单精度浮点数
    srli t1, t0, 15   # 将 t0 向右移动 15 位，第 16 位移动到最低位,t1现在存符号位
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0先左移17位顶掉符号位，然后右移26位传到t2中，t2现在存指数未更改bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0左移5位顶掉指数，右移22位得到10位的尾数位,t3现在存储着尾数部分
    addi t2, t2, -15 #在减掉bias之后我的原始指数位存在t2中

    li t4, 1              # 尾数加上隐含的1
    slli t4, t4, 10
    add t3, t3, t4 #现在t3中存着包括整数位的1.几几几，我需要根据我的真实指数对这个部分求出来整数部分和小数部分，如果在用真实指数调过数位后的小数部分不是0那么向上取整
    beqz t1, positive1
    # 目前我的t1是1bit的符号位，t2是5bit的原始指数位，t3是11bit的隐含的1整数位加上10bit尾数位

    
negative1:
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz t6, negative_no_round1  # 如果小数部分为0，不用向下取整
    # 小数部分不为0，不需要减1
    #sub t5, t5, t4  # t5 = t5 - 1
negative_no_round1:
    # 最终结果是负数
    neg t5, t5  # 取负，得到负数的结果
    j end1  # 跳转到程序结束部分

	   
    
positive1:   
	# 如果是正数的话我首先需要确认在哪些尾数能够通过尾数的值求得一个整数的值，然后判断剩下的尾数是不是全0，
	# 如果不是全0的话那么向上取整，如果是全0的话那么直接输出得到的整数即可
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz t6, positive_noupperbound1  # 如果小数部分为0，不用向上取整
    
    #这里没有通过检测那么需要向上取整
    addi t5, t5, 1
    
    
positive_noupperbound1:
    j end1	   
    
end1:
	mv a0,t5
	sh a0, 0(s4)


tb1_3:
    lh t1, 0(s5)       
    bne t1, zero, tb1_3 
tb1_4:
    lh t1, 0(s5)       
    beq t1, zero, tb1_4
    #按下确认    
    j loop_1
    















tb2_1:
    lh t1, 0(s5)       
    bne t1, zero, tb2_1
tb2_2:
    lh t1, 0(s5)       
    beq t1, zero, tb2_2
    
    
    #按下确认读取数据
    lhu t0, 0(s3)
    # 将半精度浮点数的十进制向下取整并存储回寄存器a0的程序
    # 加载半精度浮点数到 t0 寄存器
    
    # 将 16 位半精度浮点数拓展为 32 位单精度浮点数
    srli t1, t0, 15   # 将 t0 向右移动 15 位，第 16 位移动到最低位,t1现在存符号位
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0先左移17位顶掉符号位，然后右移26位传到t2中，t2现在存指数未更改bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0左移5位顶掉指数，右移22位得到10位的尾数位,t3现在存储着尾数部分
    addi t2, t2, -15 #在减掉bias之后我的原始指数位存在t2中

    li t4, 1              # 尾数加上隐含的1
    slli t4, t4, 10
    add t3, t3, t4 #现在t3中存着包括整数位的1.几几几，我需要根据我的真实指数对这个部分求出来整数部分和小数部分，如果在用真实指数调过数位后的小数部分不是0那么向上取整
    bnez t1, negative2
    # 目前我的t1是1bit的符号位，t2是5bit的原始指数位，t3是11bit的隐含的1整数位加上10bit尾数位

    
positive2:
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz t6, positive_no_round2
positive_no_round2:
    j end2  # 跳转到程序结束部分

	
	
     
negative2:   
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz t6, negative_nodownbound2  # 如果小数部分为0，不用向上取整  
    #这里没有通过检测那么需要向下取整
    addi t5, t5, 1
negative_nodownbound2:
    neg t5, t5  # 取负，得到负数的结果
    j end2	   
                 
end2:
	mv a0,t5
        sh a0, 0(s4)
	


tb2_3:
    lh t1, 0(s5)       
    bne t1, zero, tb2_3 
tb2_4:
    lh t1, 0(s5)       
    beq t1, zero, tb2_4
    #按下确认    
    j loop_1






tb3_1:
    lh t1, 0(s5)       
    bne t1, zero, tb3_1
tb3_2:
    lh t1, 0(s5)       
    beq t1, zero, tb3_2
    
    
    #按下确认读取数据
    lhu t0, 0(s3)
    # 将半精度浮点数的十进制四舍五入取整并存储回寄存器a0的程序

    
    # 将 16 位半精度浮点数拓展为 32 位单精度浮点数
    srli t1, t0, 15   # 将 t0 向右移动 15 位，第 16 位移动到最低位,t1现在存符号位
    
    slli t0, t0, 17
    srli t2, t0, 27 #t0先左移17位顶掉符号位，然后右移26位传到t2中，t2现在存指数未更改bias
    
    slli t0, t0, 5
    srli t3, t0, 22 #t0左移5位顶掉指数，右移22位得到10位的尾数位,t3现在存储着尾数部分
    addi t2, t2, -15 #在减掉bias之后我的原始指数位存在t2中

    li t4, 1              # 尾数加上隐含的1
    slli t4, t4, 10
    add t3, t3, t4 #现在t3中存着包括整数位的1.几几几，我需要根据我的真实指数对这个部分求出来整数部分和小数部分，如果在用真实指数调过数位后的小数部分不是0那么向上取整
    bnez t1, negative3
    # 目前我的t1是1bit的符号位，t2是5bit的原始指数位，t3是11bit的隐含的1整数位加上10bit尾数位

    
positive3:
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli a6, t6, 31 #a6存储着0.5位的数字，如果0.5位有数字那么我就正数的绝对值我就向上取整
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz a6, positive_no_round3
    
    addi t5, t5, 1
    
positive_no_round3:
    j end3  # 跳转到程序结束部分

	
	
     
negative3:   
    # 计算 2^t2
    li t4, 1
    sll t4, t4, t2  # t4 = 2^t2

    # 提取整数部分（包括隐含的1）
    li t6, 10
    sub t6, t6, t2
    srl t5, t3, t6  # 取出整数部分，t5 = t3 >> (10 - t2)
    li t6, 0

    # 剩下的小数部分
    li a4, 22
    add a4, a4, t2 
    sll t6, t3, a4  # t6 = t3 << (32 - (10 - t2))
    srli a6, t6, 31 #a6存储着0.5位的数字，如果0.5位有数字那么我就负数的绝对值我就向下取整
    srli t6, t6, 22  # 保留小数部分的高10位（移除不需要的部分）

    # 检查小数部分是否为0
    beqz a6, negative_nodownbound3  # 如果a6小数的0.5位是0，那么不动，如果是1的话那么对绝对值加1
    #这里没有通过检测那么需要向下取整
    addi t5, t5, 1
    
negative_nodownbound3:
    neg t5, t5  # 取负，得到负数的结果
    j end3	   

  
        
                    
end3:
	mv a0,t5
        sh a0, 0(s4)
   

tb3_3:
    lh t1, 0(s5)       
    bne t1, zero, tb3_3 
tb3_4:
    lh t1, 0(s5)       
    beq t1, zero, tb3_4
    #按下确认    
    j loop_1








tb4_1:
    lh t1, 0(s5)       
    bne t1, zero, tb4_1
tb4_2:
    lh t1, 0(s5)       
    beq t1, zero, tb4_2
    
    
    #按下确认读取第一个数据
    lw t0, 0(s3)

tb4_3:
    lh t1, 0(s5)       
    bne t1, zero, tb4_3 
tb4_4:
    lh t1, 0(s5)       
    beq t1, zero, tb4_4
    #按下确认读取第二个数据
    lw t2, 0(s3)
    
    
     # 对 a 和 b 进行加法运算
    add t3, t0, t2



    # 检查是否有进位
    li t4, 0xFF
    and t4, t4, t3  # 保留低8位
    srli t5, t3, 8  # 提取进位位
    beqz t5, end4
    
    add t3, t4, t5  # 将进位累加到低8位和中
    # 取反
    not t3, t3
    li t4, 0xff
    and t3, t4, t3 # 保留t3的低8位在t3中

end4:
    # 输出结果
    mv a0, t3   
    sw a0, 0(s4)


tb4_5:
    lh t1, 0(s5)       
    bne t1, zero, tb4_3 
tb4_6:
    lh t1, 0(s5)       
    beq t1, zero, tb4_4
    #按下确认跳转
    j loop_1






tb5_1:
    lh t1, 0(s5)       
    bne t1, zero, tb5_1
tb5_2:
    lh t1, 0(s5)       
    beq t1, zero, tb5_2
#读取数据从s3位置
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
    #按下确认    
    j loop_1
    
    
    
    
   
    
     
      
        
    

tb6_1:
    lh t1, 0(s5)       
    bne t1, zero, tb6_1
tb6_2:
    lh t1, 0(s5)       
    beq t1, zero, tb6_2
    

    
    lhu a2, 0(s3)
    li a0, 0                # 初始化a为0
    li a1, 1                # 初始化b为1
    li a6, 0                # 用a6初始化为入栈的次数
    li a7, 0                # 用a7初始化为出栈的次数
    li s7, 0      # 初始化s7寄存器的基地址是0，然后我会从这个地方往上增长存数据
    jal ra, fib_count6      # 调用 fib_count 函数


      
# 递归函数：计算不大于输入数字的斐波那契数的个数
# a0: 当前斐波那契数a
# a1: 下一个斐波那契数b
# a2: 输入数字n
# 返回值：a0 中的不大于输入数字的斐波那契数的个数
fib_count6:
    sw ra, 0(s7)           # 保存返回地址
    addi s7, s7, 4
    sw a0, 0(s7)           # 保存参数a
    addi s7, s7, 4
    sw a1, 0(s7)            # 保存参数b
    addi s7, s7, 4
    sw a2, 0(s7)            # 保存参数n
    addi s7, s7, 4

    addi a6, a6, 1          # 入栈次数 +1
    bgt a0, a2, return_zero6 # 如果当前斐波那契数大于n，则返回0
    add a3, a0, a1          # 计算下一个斐波那契数：a3 = a + b
    mv t2, a1               # 保存a1到t2
    mv t3, a3               # 保存a3到t3

    # 递归调用 fib_count(b, a+b, n)
    mv a0, t2
    mv a1, t3
    jal ra, fib_count6       # 递归调用

return_zero6:
    addi a7, a7, 1          # 出栈次数 +1

    addi s7, s7, -4
    lw a2, 0(s7)           
    addi s7, s7, -4
    lw a1, 0(s7)           
    addi s7, s7, -4
    lw a0, 0(s7)  
    addi s7, s7, -4     
    lw ra, 0(s7)                  
    blt a6, a7, return_zero6

done6:
    add a0, a6, a6
    sh a0, 0(s4)


tb6_3:
    lh t1, 0(s5)       
    bne t1, zero, tb6_3
tb6_4:
    lh t1, 0(s5)       
    beq t1, zero, tb6_4
    
    #按下确认
    lh t4, 0(s3)       # 输入加载到t4
    sh t4, 0(s4)       # 输出到led  
    j loop_1


    
    
    

               
                              
                                                            


    

tb7_1:
    lh t1, 0(s5)       
    bne t1, zero, tb7_1
tb7_2:
    lh t1, 0(s5)       
    beq t1, zero, tb7_2
    

    
    lhu a2, 0(s3)
    li a0, 0                # 初始化a为0
    li a1, 1                # 初始化b为1
    li a6, 0                # 用a6初始化为入栈的次数
    li a7, 0                # 用a7初始化为出栈的次数
    li s7, 0      # 初始化s7寄存器的基地址是0，然后我会从这个地方往上增长存数据
    li s8, 15000000 # 循环展示的次数上限
    li t6, 0 # t6作为循环展示的计数器
    jal ra, fib_count7      # 调用 fib_count 函数


      
# 递归函数：计算不大于输入数字的斐波那契数的个数
# a0: 当前斐波那契数a
# a1: 下一个斐波那契数b
# a2: 输入数字n
# 返回值：a0 中的不大于输入数字的斐波那契数的个数
fib_count7:
    sw ra, 0(s7)           # 保存返回地址
    addi s7, s7, 4
    sw a0, 0(s7)           # 保存参数a
    loop_a7:
    	addi t6, t6, 1
    	sh a0, 0(s4)
    	blt t6, s8, loop_a7
    
    li t6, 0	
    addi s7, s7, 4
    sw a1, 0(s7)            # 保存参数b
    loop_b7:
    	addi t6, t6, 1
    	sh a1, 0(s4)
    	blt t6, s8, loop_b7
    
    li t6, 0
    addi s7, s7, 4
    sw a2, 0(s7)            # 保存参数n
    addi s7, s7, 4
    loop_n7:
    	addi t6, t6, 1
    	sh a2, 0(s4)
    	blt t6, s8, loop_n7
    li t6, 0

    addi a6, a6, 1          # 入栈次数 +1
    bgt a0, a2, return_zero7 # 如果当前斐波那契数大于n，则返回0
    add a3, a0, a1          # 计算下一个斐波那契数：a3 = a + b
    mv t2, a1               # 保存a1到t2
    mv t3, a3               # 保存a3到t3

    # 递归调用 fib_count(b, a+b, n)
    mv a0, t2
    mv a1, t3
    jal ra, fib_count7       # 递归调用

return_zero7:
    addi a7, a7, 1          # 出栈次数 +1

    addi s7, s7, -4
    lw a2, 0(s7)           
    addi s7, s7, -4
    lw a1, 0(s7)           
    addi s7, s7, -4
    lw a0, 0(s7)  
    addi s7, s7, -4     
    lw ra, 0(s7) 
    blt a7, a6, return_zero7             
    

done7:
    add a0, a6, a6
    sh a0, 0(s4)

loop_needed:
    j loop_needed

loop7_need:
    j loop7_need


tb7_3:
    lh t1, 0(s5)       
    bne t1, zero, tb7_3
tb7_4:
    lh t1, 0(s5)       
    beq t1, zero, tb7_4
    
