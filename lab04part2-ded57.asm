.data
types: .asciiz "bit", "nybble", "byte", "half", "word"
bits: .asciiz "one", "four", "eight", "sixteen", "thirty-two"
please: .asciiz "Please enter a datatype: \n"
thisIs: .asciiz "<--- this is the input\n"
numOfBits: .asciiz "Number of bits: "

.text
la $a0, please
addi $v0, $zero, 4
syscall
li $v0, 5
syscall

add $t0, $zero, $v0 #store datatype
#la $t1, 
beq $t0, $t1, Word

Word: