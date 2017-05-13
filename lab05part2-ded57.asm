.data

enterX: .asciiz "\nPlease enter the x coordinate of the position: \n"
enterY: .asciiz "Please enter the y corordinate of the position: \n"
enterSize: .asciiz "Please enter the size: \n"
enterColor: .asciiz "Please enter the color: ('g' -green, 'y' -yellow and 'r' - red): \n"
input: .asciiz "<--- this is the input"

.text

#Ask for X    
    li $v0, 4
    la $a0, enterX
    syscall
   
    li $v0, 5
    syscall
    add $t4, $v0, $0
   
#Ask for Y   
    li $v0, 4
    la $a0, enterY
    syscall
   
    li $v0, 5
    syscall
    add $t5, $v0, $0
   
#Ask for Size   
    li $v0, 4
    la $a0, enterSize
    syscall
   
    li $v0, 5
    syscall
    add $t6, $v0, $0
 
#Ask for Color 
    li $v0, 4
    la $a0, enterColor
    syscall
   
    li $v0, 12
    syscall
    add $t8, $v0, $0
   
    beq $t8, 0x67, green
    beq $t8, 0x79, yellow
    beq $t8, 0x72, red

green:  
	li $t7, 3
	jal next
		
yellow: 
	li $t7, 2
	jal next
	
red:    
	li $t7, 1
	jal next
	
next:
    	add $a0, $t4, $0
    	add $a1, $t5, $0
    	add $a2, $t6, $0
    	add $a3, $t7, $0
    	jal drawTriangle
   
    	li $v0, 10
    	syscall
    	

setLED:
	#arguments: $a0 is x, $a1 is y, $a2 is color
	# byte offset into display = y * 16 bytes + (x / 4)
	sll $t0,$a1,4 # y * 16 bytes
	srl $t1,$a0,2 # x / 4
	add $t0,$t0,$t1 # byte offset into display
	li $t2,0xffff0008 # base address of LED display
	add $t0,$t2,$t0 # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi $t1,$a0,0x3 # remainder is led position in byte
	neg $t1,$t1 # negate position for subtraction
	addi $t1,$t1,3 # bit positions in reverse order
	sll $t1,$t1,1 # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li $t2,3
	sllv $t2,$t2,$t1
	not $t2,$t2 # bit mask for clearing current color
	sllv $t1,$a2,$t1 # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu $t3,0($t0) # read current LED value
	and $t3,$t3,$t2 # clear the field for the color
	or $t3,$t3,$t1 # set color field
	sb $t3,0($t0) # update display
	jr $ra
	
drawHorizontalLine:
   
    	jal setLED
    	addi $a0, $a0, 1
    	jal drawHorizontalLine
    	
drawObliqueLine:
	
	jal setLED
	jal drawObliqueLine
    	
drawTriangle:

