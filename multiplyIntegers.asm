.data
	num1: .word 10
	num2: .word 20

.text
	# mul takes 3 registers
	# mult takes 2 registers
	# sll very iffecient but inflexible
	addi $s0, $zero, 10 # $s0 = 0 + 10
	addi $s1, $zero, 20 # $s0 = 0 + 20
	
	mul $t0, $s0, $s1 # $t0 = $s0 * $s1
	
	li $v0, 1
	add $a0, $zero, $t0
	syscall