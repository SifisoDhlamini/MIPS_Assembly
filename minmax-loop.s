#
# ���ɬO�Ӧ��Ψ� loop �]���Ψ� procedure call ���d�ҵ{���A���j�a�ѦҡC�o�{����X
# ��J����ƼƦC���̤p�ȻP�̤j�ȡA�M��L�X�h�C���L�o�Ҥl�S�Ψ� array�A�@�~�i�H�b 
# data segment �ŧi�@�� array ����l��}���� label�A�M���J�Ʀr�i�H�̧Ǧs�U�h�A
# �M��A�ƧǡC
#
	.data
spc:	.asciiz " "
	.text
main:	li	$s0, 0		# $s0 as min
	li	$s1, 0		# $s1 as max
	li	$v0, 5		# get 1st number
	syscall			#
	add	$s0, $v0, $0	# $s0 initial value
	add	$s1, $v0, $0	# $s1 initial value
loop:	li	$v0, 5		# input from console
	syscall			#
	beq 	$v0, $0, out	# leave loop if getting 0
	add	$a0, $s0, $0	# 1st argument $s0 
	add	$a1, $s1, $0	# 2nd argument $s1
	add	$a2, $v0, $0	# 3rd argument $v0
	jal	minmax		# call procedure minmax
	add	$s0, $v0, $0	#
	add	$s1, $v1, $0	#
	j	loop		# loop again
out:	add	$a0, $s0, $0	# print the min
	li	$v0, 1		#
	syscall			#
	la	$a0, spc	# print a space
	li	$v0, 4		#
	syscall			#
	add	$a0, $s1, $0	# print the max
	li	$v0, 1		#
	syscall			#
exit:	li	$v0, 10		# end of program
	syscall			#
minmax:	add	$v0, $a0, $0	# procedure for getting min and max in $v0 and $v1
	add	$v1, $a1, $0	#
	ble	$a0, $a2, max	# 
	add	$v0, $a2, $0	#
max:	bge	$a1, $a2, done	#
	add	$v1, $a2, $0	#
done:	jr	$ra		# return to caller