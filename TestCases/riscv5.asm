.data
src_addr1: .byte 0xc1   # 假设第一个输入数 a = 0x41 11000001   c1 11000001
src_addr2: .byte 0xc2   # 假设第二个输入数 b = 0x42 11000010   c2 11000010

.text
.globl main
main:

    # 加载第一个8位数 a 到 t0 寄存器
    la t1, src_addr1
    lb t0, 0(t1)
    # 加载第二个8位数 b 到 t2 寄存器
    la t1, src_addr2
    lb t2, 0(t1)
    
    
    li t1, 0xfffff000
    lb t0, 0(a1)
    li t1, 0
    
    li t1, 0xfffff000
    lb t2, 0(a1)
    li t1, 0
    
    
    
    
    
    
    
    
    
    # 对 a 和 b 进行加法运算
    add t3, t0, t2



    # 检查是否有进位
    li t4, 0xFF
    and t4, t4, t3  # 保留低8位
    srli t5, t3, 8  # 提取进位位
    beqz t5, end
    
    add t3, t4, t5  # 将进位累加到低8位和中
    # 取反
    not t3, t3


end:
    # 输出结果
    mv a0, t3
    li a7, 1
    ecall
    #li a7, 10
    #ecall
    
    li a1, 0xfffff010
    sw a0, 0(a1)
