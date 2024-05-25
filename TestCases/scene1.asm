.data

.text
main:
li s3,0xfffff000#base address of swithches
li s4,0xfffff010#base address of LED
li s5,0xfffff020#base address of button
li s6,0xfffff030#base address of seg

 #按下�?关：0->1->0转换，�?�过loop1和loop2
loop_1: 
    lh t1, 0(s5)       
    bne t1, zero, loop_1 # 如果$s7不等�?0，则跳转到loop_1
loop_2:
    lh t1, 0(s5)       
    beq t1, zero, loop_2
    
    #到这里已经按下了确认�?
     lh t3, 0(s3)         #输入测试样例�? t3
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
    lh t1, 0(s5)       
    bne t1, zero, tb0_1
tb0_2:
    lh t1, 0(s5)       
    beq t1, zero, tb0_2
    
    #按下确认
    lh t4, 0(s3)       # 输入加载到t4
    sh t4, 0(s4)       # 输出到led
   
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
    
    #按下确认
    lh t5,0(s3) #读取输入
    
    sb t5 ,0(sp)
    lb t5,0(sp) #以lb的方式放�? t5 
    sh t5 ,0(s6) #输出到数码管
    mv s0,t5     
    j loop_1
    
tb2_1:
    lh t1, 0(s5)       
    bne t1, zero, tb2_1 
tb2_2:
    lh t1, 0(s5)       
    beq t1, zero, tb2_2
  
    #按下确认
    lh t6,0(s3)   #读取输入
    
    sb t5,0(sp)
    lbu t6,0(sp)  #以lbu方式存储�? t6
    sw t6 ,0(s6) #输出到数码管
    mv s1,t6
    j loop_1
    
tb3_1:
    lh t1, 0(s5)       
    bne t1, zero, tb3_1 
tb3_2:
    lh t1, 0(s5)       
    beq t1, zero,tb3_2
    
    #按下确认
    beq s0,s1,open
    bne s0,s1,not_open
    open: li s10,1 #s10设置�?1
          sh s10,0(s4) #led�?
    not_open: 
         j loop_1
    
tb4_1:
    lh t1, 0(s5)       
    bne t1, zero, tb4_1 
tb4_2:
    lh t1, 0(s5)       
    beq t1, zero,tb4_2
    
    #按下确认
    blt s0,s1,open2
    bge s0,s1,not_open2
    open2: li s10,1 #s10设置�?1
          sh s10,0(s4) #led�?
    not_open2: 
         j loop_1    
    
tb5_1:
    lh t1, 0(s5)       
    bne t1, zero,  tb5_1 
tb5_2:
    lh t1, 0(s5)       
    beq t1, zero, tb5_2
    
    #按下确认
    bge s0,s1,open3
    blt s0,s1,not_open3
    open3: li s10,1 #s10设置�?1
           sh s10,0(s4) #led�?
    not_open3: 
         j loop_1 
         
tb6_1:
    lh t1, 0(s5)       
    bne t1, zero,  tb6_1 
tb6_2:
    lh t1, 0(s5)       
    beq t1, zero, tb6_2
    
    #按下确认
    bltu s0,s1,open4
    bgeu s0,s1,not_open4
    open4: li s10,1 #s10设置�?1
          sh s10,0(s4) #led�?
    not_open4: 
         j loop_1 

tb7_1:
    lh t1, 0(s5)       
    bne t1, zero, tb7_1 
tb7_2:
    lh t1, 0(s5)       
    beq t1, zero,  tb7_2
    
    #按下确认
    bltu s0,s1,open5
    bgeu s0,s1,not_open5
    open5: li s10,1 #s10设置�?1
          sh s10,0(s4) #led�?
    not_open5: 
         j loop_1  
    
    
    
    
     
