.data
 .align 4
.text
main:
    li t0 ,0xfffffc00   #初始化t0
 
 #led 在 0x60/64
 #确认在 0x74
 #数码管在 0x68
 #按下开关：0->1->0转换，通过loop1和loop2
 loop_1: 
    lw t1, 0x74(t0)       
    bne t1, zero, loop_1 # 如果$s7不等于0，则跳转到loop_1
loop_2:
    lw t1, 0x74(t0)       
    beq t1, zero, loop_2
    
    #到这里已经按下了确认键
     lw t3, 0x70(t0) #输入测试样例到 t3
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
    
tb0_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb1_1
tb0_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb1_2
    
    #按下确认
    lw t4, 0x70(t0)       # 输入加载到t4
    sw t4, 0x60(t0)       # 输出到led
   
tb0_3:
    lw t1, 0x74(t0)       
    bne t1, zero, tb0_3
tb0_4:
    lw t1, 0x74(t0)       
    beq t1, zero, tb0_4 
    
    #按下确认
    lw t4, 0x70(t0)       # 输入加载到t4
    sw t4, 0x64(t0)       # 输出到led
    
    j loop_1

tb1_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb1_1
tb1_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb1_2
    
    #按下确认
    lb t4,0x70(t0)  #输入a到 t4
    sw t4 ,0x68(t0) #输出到数码管
    addi s0,t4,0 #a存到s0
    
    j loop_1
    
tb2_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb2_1 
tb2_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb2_2
    
    #按下确认
    lbu t4,0x70(t0)  #输入a到 t4
    sw t4 ,0x68(t0) #输出到数码管
    addi s1,t4,0 #b的值存到s1
    
    j loop_1
    
tb3_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb3_1 
tb3_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb3_2
    
    #按下确认
    beq s0,s1,open
    bne s0,s1,not_open
    open: li s10,1 #s10设置成1
          sw s10,0x60(t0) #led亮
    not_open: 
         j loop_1
    
tb4_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb4_1 
tb4_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb4_2
    
    #按下确认
    blt s0,s1,open2
    bge s0,s1,not_open2
    open2: li s10,1 #s10设置成1
          sw s10,0x60(t0) #led亮
    not_open2: 
         j loop_1    
    
tb5_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb5_1 
tb5_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb5_2
    
    #按下确认
    bge s0,s1,open3
    blt s0,s1,not_open3
    open3: li s10,1 #s10设置成1
          sw s10,0x60(t0) #led亮
    not_open3: 
         j loop_1 
         
tb6_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb6_1 
tb6_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb6_2
    
    #按下确认
    bltu s0,s1,open4
    bgeu s0,s1,not_open4
    open4: li s10,1 #s10设置成1
          sw s10,0x60(t0) #led亮
    not_open4: 
         j loop_1 

tb7_1:
    lw t1, 0x74(t0)       
    bne t1, zero, tb7_1 
tb7_2:
    lw t1, 0x74(t0)       
    beq t1, zero, tb7_2
    
    #按下确认
    bltu s0,s1,open5
    bgeu s0,s1,not_open5
    open5: li s10,1 #s10设置成1
          sw s10,0x60(t0) #led亮
    not_open5: 
         j loop_1  
    
    
    
    
     
