.data

.text
	#caller
	main:
		addi $a1, $zero, 50
		addi $a2, $zero, 100
		
		jal addNumbers #function call
		
		
		li $v0, 1 #prepare to print
		addi $a0, $v1, 0 #assign return value to $a0
		syscall
	
	# Tell the system that the program is done
	li $v0, 10
	syscall
	
	#callee procedure
	addNumbers:
		add $v1, $a1, $a2
		
		jr $ra