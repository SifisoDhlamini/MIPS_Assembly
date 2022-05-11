#410921334 - Sifiso Lucolo Dhlamini - Midterm Q1
		.data
line  :  .asciiz "===================================================================================================\n"
prompt: .asciiz "Enter your calculation and use equal sign to indicate end. \n Each operand and number on newline  \n Press enter after every input (number or operand).\n No spaces are allowed or needed \n e.g “14 ENTER + ENTER 6 ENTER * ENTER 3 ENTER = ENTER”): \n"
instruction :  .asciiz " Addition Operator is (+)\n Negative Operator is (-)\n Multiplication is (*)\n Division is (/)\n Modulus or remainder (%)\n Power of (^)\n + sqrt of next number (#)\n  - sqrt of of ($)\n* sqrt of next number (&)\n/ sqrt of next number (@)\nFIRST ENTERED NUMBER CAN NOT BE SQUARED\n"
invalidOp :   .asciiz "\nError!!!Invalid operator entered'\n"
promptNum: .asciiz "Enter integer: "
newLine: .asciiz "\n"
promptOperand: .asciiz "Enter Operand: "
	.align 4
arrayNum: .space 400        	# "array" of 40 numbers
operand: .space 3 #3bytes to accomodate '\n' character, which I will negelect, but want to capture, to remove from buffer
      	.text
.globl main
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
        beq $t2, '^', funcPow 
        beq $t2, '!', funcFact
        beq $t2, '#', plusSqrt
        beq $t2, '$', minSqrt 
        beq $t2, '&', multSqrt 
        beq $t2, '@', divSqrt      
        
        j invalid
        
invalid:
 	# Prompt for invalid input
 	li $v0, 4
 	la $a0, invalidOp
 	syscall
 	 	
 	j end 
        	
funcAdd:
	
	#get next number from user
        li $v0, 5 
        syscall
        move $t1, $v0
        	 
        sw $t1, arrayNum($a2)
        addi $a2, $a2, 4			
	j check_operand
funcSub:	
	
	#get first number from user
        li $v0, 5 
        syscall	
        move $t1, $v0
        
	mul $t3, $t1, -1
        sw $t3, arrayNum($a2) 
        addi $a2, $a2, 4
		
	j check_operand
funcMult:
	# keeping track of iterator
	subi $a2, $a2, 4
	
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
	# keeping track of iterator
	subi $a2, $a2, 4
	
	#get first number from user
        li $v0, 5 
        syscall
        move $t1, $v0	
        
	lw $t4, arrayNum($a2)
        div $t3, $t4, $t1
        sw $t3, arrayNum($a2)
        addi $a2, $a2, 4 
		
	j check_operand
funcMod:
	# keeping track of iterator
	subi $a2, $a2, 4
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        move $t1, $v0
        
	lw $t4, arrayNum($a2)
        div $t4, $t1
        mfhi $t2
        sw $t2, arrayNum($a2)
        addi $a2, $a2, 4  
		
	j check_operand

funcPow:
	subi $a2, $a2, 4
	# loading base address of array
	
	#get first number from user
        li $v0, 5 #load immidiatel the user input (integer)
        syscall	
        move $t1, $v0
        
        lw $t4, arrayNum($a2) #get last value in array and store in $t4
        beq $t1, 0, ifZero
        addi $t2, $t1, 0
        addi $t5, $t4, 0       
        b greaterThanZero
        
        #if number after power sign is greater than zero
        greaterThanZero:
        	beq $t2, 1, endPow
        	mul $t4, $t4, $t5
        	subi $t2, $t2, 1
        	sw $t4, arrayNum($a2)
        	b greaterThanZero       
        
        #anything to the power zero is one, so change last value to 1 (one)
        ifZero:	  
		addi $t2, $zero, 1
		sw $t2, arrayNum($a2)		
		b endPow
	
	endPow:
		addi $a2, $a2, 4	
		j check_operand
		
		
funcFact:
	subi $a2, $a2, 4
	# loading base address of array
        
        lw $t4, arrayNum($a2) #get last value in array and store in $t4
        subi $t5, $t4, 1       
        b calc
        
        #if number after power sign is greater than zero
        calc:
        	beq $t5, 1, endFact
        	mul $t4, $t4, $t5
        	subi $t5, $t5, 1
        	sw $t4, arrayNum($a2)
        	b calc       
	
	endFact:
		addi $a2, $a2, 4	
		j check_operand
plusSqrt:		
	li $v0, 5				#Receive said input
	syscall
	move $a0, $v0
	
	move $t4, $zero			#Move variables to t registers
	move $t1, $a0
	
	addi $t0, $zero, 1		#Set $t0 to 1
	sll $t0, $t0, 30		#Bit Shift $t0 left by 30
	
	#For loop
	loop1p:
		slt $t2, $t1, $t0
		beq $t2, $zero, loop2p	
		nop
		
		srl $t0, $t0, 2			#Shift $t0 right by 2
		j loop1p
		
	loop2p:
		beq $t0, $zero, returnp	
		nop
		
		add $t3, $t4, $t0		#if $t0 != zero add t0 and t4 into t3
		slt $t2, $t1, $t3		
		beq $t2, $zero, else1p	
		nop
		
		srl $t4, $t4, 1			#shift $t4 right by 1
		j loopEndp
		
	else1p:
		sub $t1, $t1, $t3		#Decrement $t1 by $t3
		srl $t4, $t4, 1			#Shift $t4 right by 1
		add $t4, $t4, $t0		#then add $t0 to that
		
	loopEndp:
		srl $t0, $t0, 2			#shift $t0 to the right
		j loop2p
		
	returnp:	
		sw $t4, arrayNum($a2) 
        	addi $a2, $a2, 4
        	
		j check_operand

minSqrt:		
	li $v0, 5				#Receive said input
	syscall
	move $a0, $v0
	
	move $t4, $zero			#Move variables to t registers
	move $t1, $a0
	
	addi $t0, $zero, 1		#Set $t0 to 1
	sll $t0, $t0, 30		#Bit Shift $t0 left by 30
	
	#For loop
	loop1m:
		slt $t2, $t1, $t0
		beq $t2, $zero, loop2m	
		nop
		
		srl $t0, $t0, 2			#Shift $t0 right by 2
		j loop1m
		
	loop2m:
		beq $t0, $zero, returnm	
		nop
		
		add $t3, $t4, $t0		#if $t0 != zero add t0 and t4 into t3
		slt $t2, $t1, $t3		
		beq $t2, $zero, else1m	
		nop
		
		srl $t4, $t4, 1			#shift $t4 right by 1
		j loopEndm
		
	else1m:
		sub $t1, $t1, $t3		#Decrement $t1 by $t3
		srl $t4, $t4, 1			#Shift $t4 right by 1
		add $t4, $t4, $t0		#then add $t0 to that
		
	loopEndm:
		srl $t0, $t0, 2			#shift $t0 to the right
		j loop2m
		
	returnm:	
		mul $t3, $t4, -1
		sw $t3, arrayNum($a2) 
        	addi $a2, $a2, 4
        	
		j check_operand

multSqrt:
	subi $a2, $a2, 4
	
	li $v0, 5				#Receive said input
	syscall
	move $a0, $v0
	
	move $t4, $zero			#Move variables to t registers
	move $t1, $a0
	
	addi $t0, $zero, 1		#Set $t0 to 1
	sll $t0, $t0, 30		#Bit Shift $t0 left by 30
	
	#For loop
	loop1:
		slt $t2, $t1, $t0
		beq $t2, $zero, loop2	
		nop
		
		srl $t0, $t0, 2			#Shift $t0 right by 2
		j loop1
		
	loop2:
		beq $t0, $zero, return	
		nop
		
		add $t3, $t4, $t0		#if $t0 != zero add t0 and t4 into t3
		slt $t2, $t1, $t3		
		beq $t2, $zero, else1	
		nop
		
		srl $t4, $t4, 1			#shift $t4 right by 1
		j loopEnd
		
	else1:
		sub $t1, $t1, $t3		#Decrement $t1 by $t3
		srl $t4, $t4, 1			#Shift $t4 right by 1
		add $t4, $t4, $t0		#then add $t0 to that
		
	loopEnd:
		srl $t0, $t0, 2			#shift $t0 to the right
		j loop2
		
	return:
		lw $t5, arrayNum($a2)
        	mul $t3, $t4, $t5
        	sw $t3, arrayNum($a2)
        	addi $a2, $a2, 4 
		
		j check_operand	
		
divSqrt:
	subi $a2, $a2, 4
	
	li $v0, 5				#Receive said input
	syscall
	move $a0, $v0
	
	move $t4, $zero			#Move variables to t registers
	move $t1, $a0
	
	addi $t0, $zero, 1		#Set $t0 to 1
	sll $t0, $t0, 30		#Bit Shift $t0 left by 30
	
	#For loop
	loop1d:
		slt $t2, $t1, $t0
		beq $t2, $zero, loop2d	
		nop
		
		srl $t0, $t0, 2			#Shift $t0 right by 2
		j loop1d
		
	loop2d:
		beq $t0, $zero, returnd	
		nop
		
		add $t3, $t4, $t0		#if $t0 != zero add t0 and t4 into t3
		slt $t2, $t1, $t3		
		beq $t2, $zero, else1d	
		nop
		
		srl $t4, $t4, 1			#shift $t4 right by 1
		j loopEndd
		
	else1d:
		sub $t1, $t1, $t3		#Decrement $t1 by $t3
		srl $t4, $t4, 1			#Shift $t4 right by 1
		add $t4, $t4, $t0		#then add $t0 to that
		
	loopEndd:
		srl $t0, $t0, 2			#shift $t0 to the right
		j loop2d
		
	returnd:
		lw $t5, arrayNum($a2)
        	div $t3, $t5, $t4
        	sw $t3, arrayNum($a2)
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
