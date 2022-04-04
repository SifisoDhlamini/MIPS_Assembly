#all data of a function (variables)
.data
	myMessage: .asciiz "Hello World \n"

#instructions
.text
	li $v0, 4 #load immediately (get ready to print something
	la $a0, myMessage #load the address of my message to the register
	syscall #do it now