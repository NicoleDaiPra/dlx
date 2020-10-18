addui $sp, $zero, #1024 ; initialize the stack pointer: it will point to the top element of the stack
addui $t0, $zero, dest; although labels are on 26 bits this one fits also in 16
addui $t3, $zero, #2
jr $t0 ; jump to an address stored into a register
add $t1, $zero, $zero ; not performed 
add $t1, $zero, $zero ; not performed 
add $t1, $zero, $zero ; not performed 
dest:
addui $t2, $t2, #1 ;7
addui $a0, $zero, #3 ; parameter to be passed to the procedure
addi $s0, $zero, #10 ; value used to check if it will be preserved
jal proc
j stop
proc: 
add $fp, $zero, $sp ; 12 - save the stack pointer into the frame pointer
subi $sp, $sp, #4 ; manually update of the stack pointer 1020
sw 0($sp), $gp ; save the registers
subi $sp, $sp, #4 ; 1016
sw 0($sp), $s0  
subi $sp, $sp, #4 ; 1012
sw 0($sp), $s1 
subi $sp, $sp, #4 ; 1008
sw 0($sp), $s2  
subi $sp, $sp, #4 ; 1004
sw 0($sp), $s3 
subi $sp, $sp, #4 ; 1000
sw 0($sp), $s4 
subi $sp, $sp, #4 ; 996
sw 0($sp), $s5  
subi $sp, $sp, #4 ; 992
sw 0($sp), $s6   
subi $sp, $sp, #4 ; 988
sw 0($sp), $s7 
loop:
addui $t4, $t4, #1 ; 0x1f
bne $t4, $t3, loop ; first time taken, second time not takenn
add $v0, $zero, $t4 ; 0x21 - return value
lw $s7, 0($sp)
addi $sp, $sp, #4 ; 992
lw $s6, 0($sp)
addi $sp, $sp, #4 ; 996
lw $s5, 0($sp)
addi $sp, $sp, #4 ; 1000
lw $s4, 0($sp)
addi $sp, $sp, #4 ; 1004
lw $s3, 0($sp)
addi $sp, $sp, #4 ; 1008
lw $s2, 0($sp)
addi $sp, $sp, #4 ; 1012
lw $s1, 0($sp)
addi $sp, $sp, #4 ; 1016
lw $s0, 0($sp)
addi $sp, $sp, #4 ; 1020
lw $gp, 0($sp)
addi $sp, $sp, #4 ; 1024
jr $ra
stop:
j stop
