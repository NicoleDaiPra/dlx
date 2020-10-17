addui $t1, $zero, 0x2222 ;0
addui $t2, $zero, 0x3333 ;1
addui $t3, $zero, 0x4444 ;2
loop:
beq $t2, $t3, equal ;3
bne $t2, $t3, noteq ;4
noteq:
addui $t2, $t2, 0x1111 ;5
j loop ;6
equal:
sub $t4, $t2, $t2 ;7
beqz $t4, eqzero ;8
eqzero:
bgtz $t4, lastb ;9
addui $t4, $t4, #1 ;10
bnez $t4, eqzero ;11
lastb:
blez $t1, stop ;12
bltz $t2, stop ;13
bgez $t2, stop ;14
stop:
j stop ;15