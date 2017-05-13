.data
declaredSpace: .space 64
output: .asciiz "\nHere is the output: "
enter: .asciiz "\nPlease enter your string: "
enterChar: .asciiz "\nPlease enter the character to replace: "
thisIs: .asciiz "<--- this is the input"


#Program
.text
la 	$a0, enter
addi 	$v0, $zero, 4 #Print "Please enter your string: "
syscall
li      $v0, 8
la      $a0, declaredSpace
li      $a1, 64
add 	$v0, $zero, 8 #Read user input
li 	$v0,  8
syscall
add 	$t0, $zero, $v0
jal	ReplaceLetterWithHash

ReplaceLetterWithHash:
	la	 $a0, enterChar
	addi  	 $v0, $zero, 4 #Print enterChar
	syscall
	add 	$v0, $zero, 8 #Read user input
	li 	$v0,  8
	syscall
	add 	$t1, $zero, $v0
	li	$v0, 4
	add	$a0, $zero, $v0
	syscall
	
invertCase:

