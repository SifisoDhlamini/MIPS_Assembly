.data
	num1: .word 20
	num2: .word 8
.text
	lw $s0, num1
	lw $s1, num2
	
	sub $t0, $s0, $s1 #$t0 = $s0 - $s1 (20 - 8)
	
	li $v0, 1 #get ready to print an integer
	move $a0, $t0 #move the value of $to to $a0
	syscall
	