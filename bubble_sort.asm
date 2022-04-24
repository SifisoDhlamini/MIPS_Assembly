.data
array: .space 400
prompt: .asciiz "Enter elements of array (0 to stop): \n"
output: .asciiz "After sorted in ascending order: \n"
.text
        # printing promt line
        la $a0, prompt
        li $v0, 4
        syscall
        
        # loading base address of array
        la $a0, array
        li $a1, 0
        
# looping and taking input until 0 is entered
loop_input:
        li $v0, 5
        syscall
        beq $v0, 0, end_loop_input
        sll $t0, $a1, 2
        add $t0, $t0, $a0
        sw $v0, 0($t0)
        addi $a1, $a1, 1
        j loop_input
end_loop_input:
        # saving number of elements of stack
        addi $sp, $sp, -4
        sw $a1, 0($sp)
        # calling recursive bubble sort
        jal bubblesort_recursive
        # load number of elements back from stack
        lw $a1, 0($sp)
        addi $sp, $sp, 4
        
        # printing output line
        li $v0, 4
        la $a0, output
        syscall
        
        # loading array base address
        la $s0, array
        # initializing counter
        li $t0, 0
# loop to print array values
loop_print:
        beq $t0, $a1, exit
        sll $t1, $t0, 2
        addi $t0, $t0, 1
        add $t1, $t1, $s0
        # accessing and printing array value
        lw $a0, 0($t1)
        li $v0, 1
        syscall
        
        # print space
        li $a0, 32
        li $v0, 11
        syscall
        
        j loop_print

# terminating program
exit:
        li $v0, 10
        syscall
        
# function that receives $a0 = array base address
# $a1 = size of the array
# sort the array recursively using bubble sort
bubblesort_recursive:
        # if n==1, base case, return
        beq $a1, 1, base_case
        # else loop
        li $t0, 0
        addi $t1, $a1, -1
func_loop:
        bge $t0, $t1, end_func_loop
        sll $t2, $t0, 2
        add $t2, $t2, $a0
        lw $t4, 0($t2)
        lw $t5, 4($t2)
        addi $t0, $t0, 1
        bgt $t4, $t5, swap
        j func_loop
end_func_loop:
        addi $a1, $a1, -1
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal bubblesort_recursive
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
swap:
        sw $t4, 4($t2)
        sw $t5, 0($t2)
        j func_loop
base_case:
        jr $ra