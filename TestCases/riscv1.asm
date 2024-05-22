.data
# input_data: .byte 0x00


.text
# la a1, input_data
# lw a0, 0(a1)
# li a1, 0
li a1, 0xfffff000
lw a0, 0(a1)
li a1, 0

 # 计算前导零的个数
li t0, 8          # 位数
li t1, 0          # 前导零计数器

count_leading_zeros:
    srli a1, a0, 7     # 右移7位从而取得目前的最高的数字
    slli a0, a0, 1
    beqz a1, increment   # 如果最低位是0，跳转到increment标签
    j done            # 否则跳转到done标签

increment:
    addi t1, t1, 1    # 计数器加1
    addi t0, t0, -1
    bnez t0, count_leading_zeros  # 如果还没有遍历完所有位，继续循环

done:
    # 输出前导零的个数
    #li a7, 1          # 使用系统调用编号 1 输出整数
    #mv a0, t1
    #ecall

    # 退出程序
    #li a7, 10         # 使用系统调用编号 10 退出程序
    #ecall
    li a1, 0xfffff010
    sw a0, 0(a1)

