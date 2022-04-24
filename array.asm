.data
 N:.asciiz "Enter integers. Each on new line. Enter 0 (zero) to stop:\n"
 myArray: .space 12
Space:.asciiz " "
.text
	prompt:
	# prompt for N numbers to print
		li $v0, 4
        	la $a0, N
        	syscall
        	
        	j get_num
        	
        get_num:
        	#save user input of type integer to $v0
        	li $v0, 5
        	syscall	
        	
        	move $a0, $v0	
        	
        	jal while
        	
        	while:
        		beq $a0,$zero,end
        		
        		jal  get_num
        		
        		
        end:
       		li $v0, 10
        	syscall