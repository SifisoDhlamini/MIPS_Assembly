	.data
	buffer: .space 12
line  :  .asciiz "===================================================================================================\n"
prompt: .asciiz "Enter your calculation and equal sign to indicate end. \n Each operand and number on newline. \n New line will be automatically added for you after Operand. \n Press Enter after every number you input. \n No spaces\n e.g “14 / + / 6 / */ 3 / = /” (symbol “/” indicates next line not input): \n"
instruction :  .asciiz " Addition Operator is (+)\n Negative Operator is (-)\n Multiplication is (*)\n Division is (/)\n Modulus or remainder (%)\n"
invalidOp :   .asciiz "\nError!!!Invalid operator entered'\n"
promptNum: .asciiz "Enter integer: "
newLine: .asciiz "\n"
promptOperand: .asciiz "Enter Operand: "
	.align 4
arrayNum: .space 400        	# "array" of 40 numbers
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
        #la $a0, arrayNum
        li $a1, 0 
        
        #get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall
        #move $t1, $v0
        
        sw $v0, arrayNum($a1) 
        addi $a1, $a1, 4
             
# looping and taking input until 0 is entered
check_operand:  
        #get operand from user
        li $v0, 12
 	syscall
 	move $t2, $v0 # save operator
 	
 	#move to new line
 	li $v0, 4
 	la $a0, newLine
	syscall	
 	
	add $a1, $a1, 0
	
        
        beq $t2, '=', consolidate_prep #stop loopif input  is '='
        beq $t2, '+', funcAdd
        beq $t2, '-', funcSub
        beq $t2, '/', funcDiv
        beq $t2, '*', funcMult
        beq $t2, '%', funcMod        
        
        j invalid
        
invalid:
 	# Prompt for invalid input
 	li $v0, 4
 	la $a0, invalidOp
 	syscall
 	 	
 	j end 
        	
funcAdd:
	addi $a1, $a1, 0
	# loading base address of array
	
	#get next number from user
        li $v0, 5 
        syscall
        move $t1, $v0
        	 
        sw $t1, arrayNum($a1)
        addi $a1, $a1, 4			
	j check_operand
funcSub:
	addi $a1, $a1, 0
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall	
        move $t1, $v0
        
	mul $t3, $t1, -1
        sw $t3, arrayNum($a1) 
        addi $a1, $a1, 4
		
	j check_operand
funcMult:
	subi $a1, $a1, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall        
       	move $t5, $v0
        
        lw $t4, arrayNum($a1)
        mul $t3, $t4, $t5
        sw $t3, arrayNum($a1)
        addi $a1, $a1, 4 
		
	j check_operand
funcDiv:
	subi $a1, $a1, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall
        move $t1, $v0	
        
	lw $t4, arrayNum($a1)
        div $t3, $t4, $t1
        sw $t3, arrayNum($a1)
        addi $a1, $a1, 4 
		
	j check_operand
funcMod:
	subi $a1, $a1, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        move $t1, $v0
        
	lw $t4, arrayNum($a1)
        div $s4, $t1
        mfhi $t2
        sw $t2, arrayNum($a1)
        addi $a1, $a1, 4  
		
	j check_operand

consolidate_prep:
	move $t1, $a1
	li $t2, 0
	li $a3, 0
consolidate_addAll:
	bge $t2, $t1, print_end
	lw $t4, arrayNum($t2)
	add $a3, $a3, $t4
	addi	$t2, $t2, 4
	j consolidate_addAll
print_end:
	li	$v0, 4
	la	$a0, line
	syscall
	
	li $v0, 1
	move $a0, $a3
	syscall
	
	j end	
	
end:
       		li $v0, 10
        	syscall 
