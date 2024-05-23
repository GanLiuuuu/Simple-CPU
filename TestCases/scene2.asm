.text
li t6,0xfffff000#base address of swithches
li t5,0xfffff010#base address of LED
test101:
#li a7,5
#ecall
lh a0,0(t6)
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
sh a0,0(t6)
j test101
#li a7,1
#ecall
