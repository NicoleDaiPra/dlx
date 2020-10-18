addui $t0, $zero, dest; although labels are on 26 bits this one fits also in 16
addui $t2, $t2, #1
addui $a0, $zero, #3 ; parameter to be passed to the procedure
addui $t3, $zero, #2
jalr $t0
j stop 
dest:
; pushes and pops are skipped
loop:
addui $t4, $t4, #1
bne $t4, $t3, loop
add $v0, $zero, $t4 ; return value
jr $ra
stop:
j stop
