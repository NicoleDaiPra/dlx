addui $t1, $zero, 0x12fa
addui $t2, $zero, #50
sb $t1, 100($zero)
sh $t1, 150($t2)
sw $t1, 200($t2)
lb $t3, 150($t2)
lh $t4, 200($t2)
lw $t5, 200($t2)
lbu $t6, 100($t2)
lhu $t7, 100($t2)

