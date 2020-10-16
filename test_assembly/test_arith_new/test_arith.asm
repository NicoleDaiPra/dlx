addi $t1, $zero, #50
subi $t2, $zero, #60
addui $t3, $zero, 0x2000
subui $t4, $zero, 0x000f
addi $t5, $zero, 0x0fff
add $t6, $t1, $t2
addu $t7, $t3, $t4
sub $t8, $t1, $t2
subu $t9, $t3, $t4
andi $t9, $t5, 0x0002
ori $t6, $t5, 0x4000
xori $t8, $t5, 0x00f0
slli $t6, $t1, #10
srli $t7, $t2, #20
srai $t8, $t3, #10
srai $t9, $t2, #30
addi $t0, $zero, #10
sll $t9, $t1, $t0
addi $t5, $zero, #20
srl $t6, $t2, $t5
addi $t7, $zero, #30
sra $t8, $t3, $t7
sra $t9, $t2, $t0
stop: 
j stop
