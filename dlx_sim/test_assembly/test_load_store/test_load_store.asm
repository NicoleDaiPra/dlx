addui $t1, $zero, 0x12fa
addui $t2, $zero, #50
sb 100($zero), $t1
sh 150($t2), $t1
sw 200($t2), $t1
lb $t3, 150($t2)
lh $t4, 200($t2)
lw $t5, 200($t2)
lbu $t6, 150($t2)
lhu $t7, 100($t2)
stop:
j stop
