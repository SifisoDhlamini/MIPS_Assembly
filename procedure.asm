.data
	message: .asciiz "Hi everybody \nMy name is Sifiso. \n"

.text
	#caller
	main:
		jal displayMessage #function call
	
	# Tell the system that the program is done
	li $v0, 10
	syscall
	
	#callee procedure
	displayMessage:
		li $v0, 4
		la $a0, message
		syscall
		
		jr $ra