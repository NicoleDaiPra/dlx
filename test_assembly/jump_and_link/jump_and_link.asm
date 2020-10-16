addui $sp, $zero, #1024 ; initialize the stack pointer: it will point to the top element of the stack
addui $t0, $zero, dest; although labels are on 26 bits this one fits also in 16
jr $t0 ; jump to an address stored into a register
add $t1, $zero, $zero ; performed
add $t1, $zero, $zero ; not performed
add $t1, $zero, $zero ; not performed
dest:
addui $t2, $t2, #1
addui $a0, $zero, #3 ; parameter to be passed to the procedure
addi $s0, $zero, #10 ; value used to check if it will be preserved
jal #12
j stop
proc: 
add $fp, $zero, $sp ; save the stack pointer into the frame pointer
subi $sp, $sp, #4 ; manually update of the stack pointer
sw 0($sp), $gp ; save the registers
subi $sp, $sp, #4
sw 0($sp), $s0  
subi $sp, $sp, #4
sw 0($sp), $s1 
subi $sp, $sp, #4
sw 0($sp), $s2  
subi $sp, $sp, #4
sw 0($sp), $s3 
subi $sp, $sp, #4
sw 0($sp), $s4 
subi $sp, $sp, #4
sw 0($sp), $s5 
subi $sp, $sp, #4
sw 0($sp), $s6  
subi $sp, $sp, #4
sw 0($sp), $s7 
loop:
addui $t4, $t4, #1
bne $t4, $t3, loop
add $v0, $zero, $t4 ; return value
lw $s7, 0($sp)
addi $sp, $sp, #4
lw $s6, 0($sp)
addi $sp, $sp, #4
lw $s5, 0($sp)
addi $sp, $sp, #4
lw $s4, 0($sp)
addi $sp, $sp, #4
lw $s3, 0($sp)
addi $sp, $sp, #4
lw $s2, 0($sp)
addi $sp, $sp, #4
lw $s1, 0($sp)
addi $sp, $sp, #4
lw $s0, 0($sp)
addi $sp, $sp, #4
j $ra
stop:
j stop
