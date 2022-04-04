.data
	myNum: .word 40

.text
	li $v0, 1 #prepare to print out a word
	lw $a0, myNum #load word to register $a0
	syscall #do it