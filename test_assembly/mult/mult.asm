addui $t1, $zero, 0x2222
addui $t2, $zero, 0x3333
addui $t3, $zero, 0x4444
slli $t1, $t1, #16
slli $t2, $t2, #16
mult $t1, $t2
mfhi $t4
mflo $t5
mult $t1, $t3
mult $t2, $t3
add $t8, $t2, $t3
mfhi $t6
mflo $t7
stop:
j stop