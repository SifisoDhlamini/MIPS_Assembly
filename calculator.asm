	.data
line  :  .asciiz "===================================================================================================\n"
prompt: .asciiz "Enter your calculation and equal sign to indicate end. Each operand and number on newline e.g “14 / + / 6 / * / 3 / = /” (symbol “/” indicates next line not input): \n"
instruction :  .asciiz " Addition Operator is (+)\n Negative Operator is (-)\n Multiplication is (*)\n Division is (/)\n"
invalidOp :   .asciiz "\nError!!!Invalid operator entered'\n"
promptNum: .asciiz "Enter integer: "
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
        la $a0, arrayNum
        li $a1, 0 
        
        #get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall
        move $t1, $v0
        
        sll $t0, $a1, 2 
        add $t0, $t0, $a0 
        sw $t1, 0($t0) 
        addi $a1, $a1, 1
             
# looping and taking input until 0 is entered
check_operand:  
        #get operand from user
        li $v0, 12
 	syscall
 	move $s2, $v0
 	# save operator
	#move $s1,$v0
	add $a1, $a1, 0
        
        beq $s2, '=', consolidate_prep #stop loopif input  is '='
        beq $s2, '+', funcAdd
        beq $s2, '-', funcSub
        beq $s2, '/', funcDiv
        beq $s2, '*', funcMult
        beq $s2, '%', funcMod        
        
        j invalid
        
invalid:
 	# Prompt for invalid input
 	li $v0, 4
 	la $a0, invalidOp
 	syscall
 	 	
 	j end 
        	
funcAdd:
	add $a1, $a1, 0
	# loading base address of array
	la $a0, arrayNum
	
	#get next number from user
        li $v0, 5 
        syscall
        move $t1, $v0
        	
	sll $t0, $a1, 2 
        add $t0, $t0, $a0 
        sw $t1, 0($t0)
        add $a1, $a1, 1			
	j check_operand
funcSub:
	add $a1, $a1, 0
	# loading base address of array
	la $a0, arrayNum
	
	#get first number from user
        li $v0, 5 
        syscall	
        move $t1, $v0
        
	mul $t3, $t1, -1
	sll $t0, $a1, 2
        add $t0, $t0, $a0 
        sw $t3, 0($t0) 
        add $a1, $a1, 1
		
	j check_operand
funcMult:
	add $a1, $a1, 0
	# loading base address of array
	la $a0, arrayNum
	
	#get first number from user
        li $v0, 5 
        syscall        
       	move $t5, $v0
        
	sll $t0, $a1, 1 
        add $t0, $t0, $a0 
        lw $t4, 0($t0)
        mul $t3, $t4, $t5
        sw $t3, 0($t0) 
		
	j check_operand
funcDiv:
	add $a1, $a1, 0
	# loading base address of array
	la $a0, arrayNum
	
	#get first number from user
        li $v0, 5 
        syscall
        move $t1, $v0	
        
	sll $t0, $a1, 1 
        add $t0, $t0, $a0 
        lw $t4, 0($t0)
        div $t3, $t4, $t1
        sw $t3, 0($t0) 
		
	j check_operand
funcMod:
	add $a1, $a1, 0
	# loading base address of array
	la $a0, arrayNum
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        move $t1, $v0
        
	sll $t0, $a1, 1 
        add $t0, $t0, $a0 
        lw $s4, 0($t0)
        div $s4, $t1
        mfhi $t2
        sw $t2, 0($t0) 
		
	j check_operand

consolidate_prep:
	la $t0, arrayNum
	move $t1, $a1
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
	
end:
       		li $v0, 10
        	syscall 
