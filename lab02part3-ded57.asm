.data
str: .asciiz "What is integer A?"
strtwo: .asciiz "Here is the input in binary: "
strthree: .asciiz "\nHere is the input in hexadecimal: "
strfour: .asciiz "\nHere is the output in binary: "
strfive: .asciiz "\nHere is the output in hexadecimal: "

.text
la $a0, str
addi $v0, $zero, 4
syscall
li $v0, 5
syscall

#Input in Binary
add $t0, $zero, $v0
la $a0, strtwo
li $v0, 4
syscall
add $a0, $zero, $t0
li $v0, 35
syscall

#Input in Hexadecimal
la $a0, strthree
li $v0, 4
syscall
add $a0, $zero, $t0
li $v0, 34
syscall

#Shift
srl $t0, $t0, 8
and $t0, 15

#Output in Binary
add $v0, $zero, $t0
la $a0, strfour
li $v0, 4
syscall
add $a0, $zero, $t0
li $v0, 35
syscall

#Input in Hexadecimal
la $a0, strfive
li $v0, 4
syscall
add $a0, $zero, $t0
li $v0, 34
syscall