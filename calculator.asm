#410921334 - Sifiso Lucolo Dhlamini - Midterm Q1
		.data
line  :  .asciiz "===================================================================================================\n"
prompt: .asciiz "Enter your calculation and use equal sign to indicate end. \n Each operand and number on newline  \n Press enter after every input (number or operand).\n No spaces are allowed or needed \n e.g “14 ENTER + ENTER 6 ENTER * ENTER 3 ENTER = ENTER”): \n"
instruction :  .asciiz " Addition Operator is (+)\n Negative Operator is (-)\n Multiplication is (*)\n Division is (/)\n Modulus or remainder (%)\n"
invalidOp :   .asciiz "\nError!!!Invalid operator entered'\n"
promptNum: .asciiz "Enter integer: "
newLine: .asciiz "\n"
promptOperand: .asciiz "Enter Operand: "
	.align 4
arrayNum: .space 400        	# "array" of 40 numbers
operand: .space 3 #3bytes to accomodate '\n' character, which I will negelect, but want to capture, to remove from buffer
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
        addi $a2, $a1, 4
             
# looping and taking input until 0 is entered
check_operand:  
 	
 	#keep track of iterator to argument in a2
 	add $a2, $a2, 0
 	
 	#load a string with operand + '\n' captured on keyboard stroke (3bytes)
 	li $v0, 8
	la $a0, operand
	li $a1, 3
	syscall
	
	li $t0, 0
	lb $t2, operand($t0) #only get the operan and leave out the '\n' (index 0 = $t0)		
        
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
	addi $a2, $a2, 0
	# loading base address of array
	
	#get next number from user
        li $v0, 5 
        syscall
        move $t1, $v0
        	 
        sw $t1, arrayNum($a2)
        addi $a2, $a2, 4			
	j check_operand
funcSub:
	addi $a2, $a2, 0
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall	
        move $t1, $v0
        
	mul $t3, $t1, -1
        sw $t3, arrayNum($a2) 
        addi $a2, $a2, 4
		
	j check_operand
funcMult:
	subi $a2, $a2, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall        
       	move $t5, $v0
        
        lw $t4, arrayNum($a2)
        mul $t3, $t4, $t5
        sw $t3, arrayNum($a2)
        addi $a2, $a2, 4 
		
	j check_operand
funcDiv:
	subi $a2, $a2, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 
        syscall
        move $t1, $v0	
        
	lw $t4, arrayNum($a2)
        div $t3, $t4, $t1
        sw $t3, arrayNum($a1)
        addi $a2, $a2, 4 
		
	j check_operand
funcMod:
	subi $a2, $a2, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        move $t1, $v0
        
	lw $t4, arrayNum($a2)
        div $s4, $t1
        mfhi $t2
        sw $t2, arrayNum($a2)
        addi $a2, $a2, 4  
		
	j check_operand

consolidate_prep:
	move $t1, $a2
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
