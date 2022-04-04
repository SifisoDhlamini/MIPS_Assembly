.data

.text
	addi $t0, $zero, 2000
	addi, $t1, $zero, 10
	
	mult $t0, $t1
	
	mflo $s0 #move from lo register (the product of $t0 and $t1
	
	li $v0, 1
	add $a0, $zero, $s0
	syscall