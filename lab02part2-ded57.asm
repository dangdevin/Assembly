.data
str: .asciiz "What is the first value?"
.text
la $a0, str
addi $v0, $zero, 4
syscall
li $v0, 5
syscall
add $t0, $zero, $v0


.data
strtwo: .asciiz "\nWhat is the second value?"
.text
la $a0, strtwo
addi $v0, $zero, 4
syscall
li $v0, 5
syscall
add $t1, $zero, $v0

.data
strthree: .asciiz "\nThe sum is "
.text
la $a0, strthree
addi $v0, $zero, 4
syscall
add $a0, $t1, $t0
li $v0, 1
syscall
