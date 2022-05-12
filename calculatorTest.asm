.data
str1:	.asciiz	"\n\n------- Illegal input -------\n"
str2:	.asciiz	"value: "
str3:	.asciiz	"\toper: "
str5:	.asciiz	"enter: "
strnewl:.asciiz	"\n"

	.text
	.globl main
main:
	li $s5, 0					# global var. new value.	
	li $s6, 0					# global var. current value.	
	li $s7, ' '					# global var. current oper.
loop:
	jal prtstat
	li $v0, 5					# read an integer
	syscall
	beq $v0, -1000, Thousand	# if typed -1000
	bne $s7, 20, NotEmpty
	move $s6, $v0
	j loop
NotEmpty:	
	move $s5, $v0
	move $a0, $s6				# moves $s registers into $a registers
	move $a1, $s7				# for calculation
	move $a2, $s5
	jal cal_fun
	move $s6, $v0				# moves result into current value
	j loop
Thousand:
	li $v0, 12
	syscall
	add $s7, $v0, $0
	j loop

done:
	li $v0, 10					# exit
	syscall
	
#-----------------------------------
# just prints whatever in $s5, $s6, $s7
#-----------------------------------
prtstat:
	li $v0,4
	la $a0, strnewl
	syscall

	li $v0,4
	la $a0, str2
	syscall
	ori	$a0,$s6, 0
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, str3
	syscall
	ori	$a0,$s7, 0
	li $v0, 11
	syscall

	li $v0,4
	la $a0, strnewl
	syscall

	li $v0,4
	la $a0, str5
	syscall

	jr	$ra
	
#-----------------------------------
# Called when a calculation is needed and returns in $v0 the result.
# Error checking done by the caller and the values are valid.
# The first value, the operator, and the second value in $a0, $a1, and $a2.
# Handles simple things like +,-*,/ inside this function.
# Calls gcf and calnchoosek for @ and &. 
#-----------------------------------
cal_fun:
	addi $sp, $sp, -4			# store in stack
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	beq $a1, 43, addcal			#If inputted char matches
	beq $a1, 45, subcal			# valid function, jumps to it
	beq $a1, 42, mulcal
	beq $a1, 47, divcal
	beq $a1, 64, gcfcal
	beq $a1, 38, chocal			# n choose k
	li $s7, ' '					# if inputted char not valid, sets blank, exits
	j endcal

addcal:
	add $v0, $a0, $a2
	j endcal

subcal:
	sub $v0, $a0, $a2
	j endcal

mulcal:
	mul $v0, $a0, $a2
	j endcal

divcal:
	beq $a2, $0, errormsg		# divide by zero check
	div $v0, $a0, $a2
	j endcal

gcfcal:
	beq $a0, $0, errormsg		# checks if either values are zero
	beq $a2, $0, errormsg
	move $a1, $a2
	jal gcf
	j endcal

chocal:
	bgt $a2, $a0, errormsg		# Won't compute if k > n
	blt $a0, 0, errormsg		# Won't compute negative numbers
	blt $a2, 0, errormsg
	bgt $a0, 30, errormsg		# n can't be larger than 30
	move $a1, $a2
	jal calnchoosek
	j endcal

errormsg:						# jumped here if error is detected
	li $v0, 4       			# syscall 4 (print_str)
	move $t5, $a0
	la $a0, str1
	syscall
	#move $v0, $t5
	li $v0, 0					# global var. current value.	
	li $s7, ' '					# global var. current oper.
	j endcal

endcal:
	lw $a2, 0($sp)				# restore stack
	addi $sp, $sp, 4
	lw $a1, 0($sp)				
	addi $sp, $sp, 4
	lw $a0, 0($sp)				
	addi $sp, $sp, 4
	lw $ra, 0($sp)				
	addi $sp, $sp, 4
	jr $ra
	
	
#-----------------------------------
# returns in $v0 the greatest common factor between two values
# $a0 and $a1 are the two values
#-----------------------------------
gcf:
	addi $sp, $sp, -4			# store in stack
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	bne $a1, $zero, L1			# go to L1 if b isn't zero
	j EXIT						# jump to exit

L1:
	beq  $a1, $zero, EXIT		# branch loop
	move $t0, $a1				# temp = b
	rem $a1, $a0, $a1			# $a1 = $a0 % $a1
	move $a0, $t0				# a0 = temp
	j L1
EXIT:
	move $v0, $a0				# stores result in $v0
	
	lw $a1, 0($sp)				# restore stack		
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4	
	jr	$ra
	
	
#-----------------------------------
# returns in $v0 C(n,k)
# $a0 is n and $a1 is k
#-----------------------------------
calnchoosek:					# n!/(k!(n-k)!)
	addi $sp, $sp, -4			# store in stack
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)

	mtc1 $a0, $f4				# $f4 gets $a0
	cvt.d.w $f4, $f4
	mtc1 $a1, $f6				# $f6 gets $a1
	cvt.d.w $f6, $f6
	
	li.d $f2, 1.0				# counter
	li.d $f0, 1.0				#  storage for multiplication
	li.d $f20, 1.0				# constant 1
nfact:							# factoralizing n
	mul.d $f0, $f0, $f2			# $f0 is !n
	add.d $f2, $f2, $f20
	c.le.d $f2, $f4
	bc1t nfact

	li.d $f2, 1.0				# counter
	li.d $f10, 1.0				# storage for multiplication
kloop:							# factoralizing k
	mul.d $f10, $f10, $f2		# $f10 is !k
	add.d $f2, $f2, $f20
	c.le.d $f2, $f6
	bc1t kloop

	sub.d $f12, $f4, $f6		# n-k
	li.d $f2, 1.0				# counter
	li.d $f14, 1.0				# storage for multiplication
diffact:						# factoralizing n-k
	mul.d $f14, $f14, $f2		# !n-k
	add.d $f2, $f2, $f20
	c.le.d $f2, $f12
	bc1t diffact
								# creates unified divisor, then n! divided by that
	mul.d $f2, $f10, $f14		# fact(k) * fact(n-k)
	div.d $f16, $f0, $f2		# n choose k result
	cvt.w.d $f16, $f16
	mfc1 $v0, $f16
	
	lw $a1, 0($sp)				# restore stack
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra	