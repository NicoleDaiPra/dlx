addui $t1, $zero, 0x2222
addui $t2, $zero, 0x3333
addui $t3, $zero, 0x4444
loop:
beq $t2, $t3, equal
bne $t2, $t3, noteq
noteq:
addui $t2, $t2, 0x1111
j loop 
equal:
sub $t4, $t2, $t2
beqz $t4, eqzero
eqzero:
bgtz $t4, lastb
addui $t4, #1
bnez $t4, eqzero
lastb:
blez $t1, stop
bltz $t2, stop
bgez $t2, stop
stop:
j stop