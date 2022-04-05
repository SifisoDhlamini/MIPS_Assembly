.data
	newLine: .asciiz "\n"

.text
	#caller
	main:
		addi $s0, $zero, 10
		
		jal increaseMyRegister
		
		#print a new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		#print value
		li $v0, 1
		move $a0, $s0
		syscall
	
	# Tell the system that the program is done
	li $v0, 10
	syscall
	
	#callee procedure
	increaseMyRegister:
		addi $sp, $sp, -4 #reserve 4 bytes in stack to pointer
		sw $s0, 0($sp) # store $so in the first space allocated in the stack
		
		addi $s0, $s0, 30
		
		# print new value in function
		li $v0, 1
		move $a0, $s0
		syscall
		
		lw $s0, 0($sp) #restore value of $s0
		addi $sp, $sp, 4 # restore pointer to original position
		
		jr $ra # return to main
		