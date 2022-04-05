.data
	prompt: .asciiz "Enter your age: "
	message: .asciiz "Your age is: "
.text
	#prompt the user to enter age:
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Get the user:s age
	li $v0, 5
	syscall
	
	#store result in $t0
	move $t0, $v0
	
	# display 
	li $v0, 4
	la $a0, message
	syscall
	
	#print or show the age
	li $v0, 1
	move $a0, $t0
	syscall
	