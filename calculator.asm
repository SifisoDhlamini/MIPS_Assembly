	.data
arrayNum: .space 400        	# "array" of 40 numbers
division: .byte '/'
multiplication: .byte '*'
addition: .byte '+'
subtraction: .byte '-'
stop: .byte '='
line  :  .asciiz "===================================================================================================\n"
prompt: .asciiz "Enter your calculation and equal sign to indicate end. Each operand and number on newline e.g “14 / + / 6 / * / 3 / = /” (symbol “/” indicates next line not input): \n"
instruction :  .asciiz " Addition Operator is (+)\n Negative Operator is (-)\n Multiplication is (*)\n Division is (/)\n"
promptNum: .asciiz "Enter integer (e.g 1 or 22 or 100): "
promptOp: .asciiz "Enter operand (+, -, *, /(integer division drops remainder), sqrt, % (modulus), ^(power): "
invalidOp :   .asciiz "\nError!!!Invalid operator entered'n"
newline:	.asciiz	"\n"		# a newline string.
      	.text
main:
	# printing prompt line
	li $v0, 4
	la $a0, line
	syscall
	
	#printing prompt
        la $a0, prompt
        li $v0, 4
        syscall
        
        # printing instruction
        la $a0, instruction
        li $v0, 4
        syscall
        
        # printing prompt line
        li $v0, 4
	la $a0, line
	syscall
        
        # loading base address of array and initializing iterator
        la $a0, arrayNum
        li $a1, 0 
        
        #get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall
        
        sll $t0, $a1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        sw $v0, 0($t0) #insert user input at arrayNum[current_i] 
        
               
	j calculate

calculate:
	add $v1, $v1, $zero
	jal check_operand
	beq $v0, -1, end
	beq $v0, -2, consolidate	 
	
	j calculate 

# looping and taking input until 0 is entered
check_operand:        
        #get operand from user
        li $v0, 12
 	syscall
 	# save operator
	move $s1,$v0
	addi $v1, $v1, 0 
        
        beq $s1, '=', end_loop_input #stop loopif input  is '='
        beq $s1, '+', funcAdd
        beq $s1, '-', funcSub
        beq $s1, '/', funcDiv
        beq $s1, '*', funcMult
        beq $s1, '%', funcMod        
        
        j invalid
        
invalid:
 	# Prompt for invalid input
 	li $v0, 4
 	la $a0, invalidOp
 	syscall
 	
 	addi $v1, $zero, 0
 	addi $v0, $zero, -1
 	
 	jr $ra  
end:
       		li $v0, 10
        	syscall 
        	
end_loop_input:
	addi $v1, $v1, 0
	addi $v0, $zero, -2
		
	jr $ra
funcAdd:
	addi $v1, $v1, 0
	# loading base address of array
	la $a0, arrayNum
	add $v1, $v1, $zero
	
	
	#get next number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall
        	
	
	sll $t0, $v1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        sw $v0, 4($t0) #insert user input at arrayNum[current_i]
        
	addi $v1, $v1, 1
	addi $v0, $zero, 1
		
	jr $ra
funcSub:
	# loading base address of array
	la $a0, arrayNum
	add $v1, $v1, $zero
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        
	mul $t3, $v0, -1
	sll $t0, $v1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        sw $t3, 4($t0) #insert user input at arrayNum[current_i]
        
	addi $v1, $v1, 1
	addi $v0, $zero, 1
		
	jr $ra
funcMult:
	# loading base address of array
	la $a0, arrayNum
	add $v1, $v1, $zero
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        
       	move $t5, $v0
        
	sll $t0, $v1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        lw $t4, 0($t0)
        mul $t3, $t4, $t5
        sw $t3, 0($t0) #insert user input at arrayNum[current_i]
      
	addi $v1, $v1, 0
	addi $v0, $zero, 1
		
	jr $ra
funcDiv:
	# loading base address of array
	la $a0, arrayNum
	add $v1, $v1, $zero
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        
	sll $t0, $v1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        lw $t5 , 4($t0)
        lw $t4, 0($t0)
        div $t3, $t4, $t5
        sw $t3, 0($t0) #insert user input at arrayNum[current_i]
        
	addi $v1, $v1, 0
	addi $v0, $zero, 1
		
	jr $ra
funcMod:
	# loading base address of array
	la $a0, arrayNum
	add $v1, $v1, $zero
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        
	sll $t0, $v1, 2 # create temporal variable that will fit a number
        add $t0, $t0, $a0 #point $t0 to the current psition in arrayNum
        lw $t5 , 4($t0)
        lw $t4, 0($t0)
        div $t3, $t4, $t5
        sw $t3, 0($t0) #insert user input at arrayNum[current_i]
        
	addi $v1, $v1, 0
	addi $v0, $zero, 1
		
	jr $ra
consolidate:
consolidate_prep:
	la $t0, arrayNum
	move $t1, $v1
	li $t2, 0
	li $a3, 0
consolidate_addAll:
	bge $t2, $t1, print_end
	lw $t4, 0($t0)
	add $a3, $a3, $t4
	addi	$t0, $t0, 4
	addi	$t2, $t2, 1
	j consolidate_addAll
print_end:
	li	$v0, 4
	la	$a0, line
	syscall
	
	li $v0, 1
	move $a0, $a3
	syscall
	
	j end	

	
	
		
	
	
	
