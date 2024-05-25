# 定义一个全局变量来保存入栈和出栈的次数
.data
.global stack_count
stack_count: .data 0





.text
main:
    li a7, 5
    ecall
    li a1, 1              # 设置当前斐波那契数列的值为1
    li a2, 0              # 设置上一个斐波那契数列的值为0
    jal fib_count     

    # 输出出入栈的次数
    la t0, stack_count
    lw t1, 0(t0)
    mv a0,t1
    li a7, 1
    ecall
    
    # 退出程序
    li a7, 10             # 退出程序
    ecall


fib_count:
    # 参数：a0 - 输入数据
    #       a1 - 当前斐波那契数列的值
    #       a2 - 上一个斐波那契数列的值
    la t0, stack_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    li t1, 0
    li t0, 0
    
    
    addi sp, sp, -4      # 入栈
    sw ra, 4(sp)         # 保存返回地址

    # 计算下一个斐波那契数列的值
    mv a4, a1
    add a1, a1, a2
    mv a2, a4
    li a4, 0       
    # 检查是否小于输入数据
    bge a1, a0, end_fib   # 如果当前斐波那契数列的值大于等于输入数据，则结束递归
    # 如果小于输入数据，则递归调用fib_count函数
    jal ra, fib_count     # 递归调用fib_count

end_fib:
    # 出栈
    
    la t0, stack_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    li t1, 0
    li t0, 0
    
    lw ra, 4(sp)
    addi sp, sp, 4       # 出栈
    jr ra





