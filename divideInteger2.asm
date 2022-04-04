.data

.text
	addi $t0, $zero, 30
	addi, $t1, $zero, 8
	
	#div $s0, $t0, 10 - One way to divide $t0/10
	div $t0, $t1 #result saved in low (lo) register 
	mflo $s0 #quotient saved from lo to $s0
	mfhi $s1 #remainder saved from hi to $s1
		
	li $v0, 1
	#add $a0, $zero, $s0 #print quotient
	add $a0, $zero, $s1 #print remainder
	syscall