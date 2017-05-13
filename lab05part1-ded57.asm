.data
 
enter:   .asciiz "Please enter a number n:\n"
enterAnother:   .asciiz "Please enter another number k:\n"
input: .asciiz "<--- this is the input\n"
result:   .asciiz "The resulting value is "

.text
#Print enter
li      $v0, 4 
la      $a0, enter
syscall

#Enter a number
li      $v0, 5          
syscall
move    $t0, $v0

#Print this is the input
la	$a0, input
li	$v0, 4
syscall


#Print enter another number
li      $v0, 4           
la      $a0, enterAnother
syscall

#Enter another number
li      $v0, 5          
syscall
move    $a0, $t0
move    $a1, $v0


#Print this is the input
la	$a0, input
li	$v0, 4
syscall
 
jal exit

#Print result 
move    $t0, $v0
li      $v0, 4        
la      $a0, result
syscall

move    $a0, $t0
li      $v0, 1          
syscall
 
 
li      $v0, 10        
syscall
 
recur:
         slt     $t0, $a0, $a1
         beq     $a0, $zero, recurEnd2   
         beq     $a0, $a1, recurEnd2       
         bne     $t0, $zero, recurEnd 
 
 
 
         sw      $fp, 4($sp)
         addi    $fp, $sp, 0
         addi    $sp, $sp, -12
         sw      $ra, 4($sp)
         sw      $a0, ($sp)
         addi    $sp, $sp, -4
         sw      $t1, ($sp)
         addi    $a0, $a0, -1
         jal     recur
 
         move    $t1, $v0
         addi    $sp, $sp, -4
         sw      $a1, ($sp)
         addi    $sp, $sp, -4
         sw      $ra, ($sp)
 
         addi    $a1, $a1, -1
         jal     recur
 
         add     $v0, $t1, $v0
 
         lw      $ra, ($sp)
         addi    $sp, $sp, 4
 
         lw      $a1, ($sp)
         addi    $sp, $sp, 4
 
         lw      $t1, ($sp)
         addi    $sp, $sp, 4
 
         lw      $a0, ($sp)
         addi    $sp, $sp, 4
         lw      $ra, ($sp)
         addi    $sp, $sp, 4
         lw      $fp, ($sp)
         addi    $sp, $sp, 4
         j       exit
 
recurEnd:   
	add    $v0, $v0, $0
        j       exit
 
recurEnd2:   
	addi    $v0, $zero, 1

exit:    
	jr      $ra