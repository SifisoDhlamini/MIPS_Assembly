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
		jal printValue
	
	# Tell the system that the program is done
	li $v0, 10
	syscall
	
	#callee procedure
	increaseMyRegister:
		addi $sp, $sp, -8 #reserve 8 bytes in stack to pointer (2 addresses
		sw $s0, 0($sp) # store $so in the first space allocated in the stack
		sw $ra, 4($sp) # store return address
		
		addi $s0, $s0, 30
		
		# print new value in function (nested procedure)
		jal printValue
		
		lw $s0, 0($sp) #restore value of $s0
		lw $ra, 4($sp) #give return address on the stack
		addi $sp, $sp, 4 # restore pointer to original position
		
		jr $ra # return to main
	
	printValue:
		li $v0, 1
		move $a0, $s0
		syscall
		
		jr $ra
		
