.data
str: .asciiz "Please enter element type ('w'-word, 'h'-half, 'b'-byte): \n"
str2: .asciiz "\nHere is the output (address, value in hexadecimal, value in decimal): \n"
break: .asciiz ", "
Array_A: .word 0xa1a2a3a4, 0xa5a6a7a8, 0xacabaaa9
addressword: .asciiz "0x10010008"
addressbyte: .asciiz "0x10010002"
addresshalf: .asciiz "0x10010004"

#Enter Element Type
.text
la $a0, str
addi $v0, $zero, 4
syscall
li $v0, 12
syscall
add $t0, $zero, $v0

la $t1, 0x77
la $t2, 0x68
la $t3, 0x62

beq $t0, $t1, Word
beq $t0, $t2, Half
beq $t0, $t3, Byte

Word:
	la $a0, str2
	addi $v0, $zero, 4
	syscall
	la $t4, Array_A
	lw $t5, 8($t4)
	
	#Print Address
	la $a0, addressword
	addi $v0, $zero, 4
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Hexadecimal
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 34
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Decimal Value
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 1
	syscall
	
	b Exit

	
Byte:
	la $a0, str2
	addi $v0, $zero, 4
	syscall
	la $t4, Array_A
	lbu $t5, 12($t4)
	
	#Print Address
	la $a0, addressbyte
	addi $v0, $zero, 4
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Hexadecimal
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 34
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Decimal Value
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 1
	syscall
	
	b Exit

Half:
	la $a0, str2
	addi $v0, $zero, 4
	syscall
	la $t4, Array_A
	lhu $t5, 4($t4)
	
	#Print Address
	la $a0, addresshalf
	addi $v0, $zero, 4
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Hexadecimal
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 34
	syscall
	
	#Print Comma and Space
	add $t0, $zero, $v0
	la $a0, break
	li $v0, 4
	syscall
	
	#Print Decimal Value
	add $t0, $zero, $v0
	la $a0, ($t5)
	li $v0, 1
	syscall
	
	b Exit
	
Exit:
	