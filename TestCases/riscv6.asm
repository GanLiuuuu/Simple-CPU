.data
input_num:    .word 20       # 输入数字，假设为20
stack_count:  .word 0        # 记录入栈次数
unstack_count:.word 0        # 记录出栈次数
result:      .word 0         # 存放结果


.text

main:
    li t6,0xfffff000#base address of swithches
    li t5,0xfffff010#base address of LED

    #la a2, input_num        # 读取输入数字
    lw a2, 0(t6)
    li a0, 0                # 初始化a为0
    li a1, 1                # 初始化b为1
    jal ra, fib_count       # 调用 fib_count 函数
    j done


# 递归函数：计算不大于输入数字的斐波那契数的个数
# a0: 当前斐波那契数a
# a1: 下一个斐波那契数b
# a2: 输入数字n
# 返回值：a0 中的不大于输入数字的斐波那契数的个数
fib_count:
    addi sp, sp, -20        # 入栈，开辟栈空间
    sw ra, 16(sp)           # 保存返回地址
    sw a0, 12(sp)           # 保存参数a
    sw a1, 8(sp)            # 保存参数b
    sw a2, 4(sp)            # 保存参数n

    la t0, stack_count      # 读取当前入栈次数
    lw t1, 0(t0)
    addi t1, t1, 1          # 入栈次数 +1
    sw t1, 0(t0)

    bgt a0, a2, return_zero # 如果当前斐波那契数大于n，则返回0

    add a3, a0, a1          # 计算下一个斐波那契数：a3 = a + b
    mv t2, a1               # 保存a1到t2
    mv t3, a3               # 保存a3到t3

    # 递归调用 fib_count(b, a+b, n)
    mv a0, a1
    mv a1, a3
    jal ra, fib_count       # 递归调用
    addi t1, a0, 1          # count = 1 + fib_count(b, a+b, n)

return_zero:
    la t0, unstack_count    # 读取当前出栈次数
    lw t2, 0(t0)
    addi t2, t2, 1          # 出栈次数 +1
    sw t2, 0(t0)

    lw ra, 16(sp)           # 恢复返回地址
    lw a0, 12(sp)           # 恢复参数a
    lw a1, 8(sp)            # 恢复参数b
    lw a2, 4(sp)            # 恢复参数n
    addi sp, sp, 20         # 出栈，释放栈空间
    ret



    
done:
    la t0, stack_count
    lw t1, 0(t0)
    la t0, unstack_count
    lw t2, 0(t0)
    add a0, t1, t2
    
    sw a0, 0(t5)
    #li a7, 1
    #ecall
               
