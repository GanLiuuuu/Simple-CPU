# 将半精度浮点数的十进制向下取整并存储回寄存器a0的程序

# 定义存储数据的内存地址
.data
src_addr: .word 0xc100    # 16 位的半精度浮点数，假设为-2.5: 11000001 00000000 （0000c100） 现在是2.5：01000001 00000000 （00004100）

# 程序入口
.text
.globl main
main:
    # 加载半精度浮点数到 t0 寄存器
    la a1, src_addr
    lw t0, 0(a1)
    li a1,0
    
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
    bnez t1, negative
    # 目前我的t1是1bit的符号位，t2是5bit的原始指数位，t3是11bit的隐含的1整数位加上10bit尾数位

    
positive:
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
    beqz t6, positive_no_round
positive_no_round:
    j end  # 跳转到程序结束部分

	
	
     
negative:   
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
    beqz t6, negative_nodownbound  # 如果小数部分为0，不用向上取整  
    #这里没有通过检测那么需要向下取整
    addi t5, t5, 1
negative_nodownbound:
    neg t5, t5  # 取负，得到负数的结果
    j end	   

  
        
                    
end:
	mv a0,t5
	li a7, 1
	ecall
	
    
    

    

    
    
    
    


