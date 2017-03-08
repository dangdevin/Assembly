.data
	buffer:		.space 6200
	after_buffer:	.space 4
	playerScore:	.asciiz "The game score is: "  #The game score is <bug-hits> : <phaser-firings>.
	colon:		.asciiz	": "
	

	
.text	
	la	$s6, buffer		# load buffer into $s6 - INPUT (write)
	la	$s7, buffer		# load buffer into $s7 - OUTPUT (read)
	li	$t8, 0			# phasers fired
	li	$t6, 0


INIT.get_current_time:
	li	$v0, 30			# set service to get initial time
	add	$a0, $zero, $t0		# time_step = read time;
	syscall				# system calls for the initial time
	move 	$s3, $a0		# timestamp of last update
	move	$t5, $a0		# start time
	
InitializePlayer:
	# InitializePlayer Body
	# player start
	li 	$a2, 2 			# set color to orange
	li	$a0, 32			# set X
	li	$a1, 63			# set Y
	move	$s2, $a0		# move
	jal	_setLED
	


loop:	
	# the main method
	
	jal	pollPrologue			# Check for keypress

get_current_time:
	li	$v0, 30			# set service to get current time
	add	$a0, $zero, $t0
	syscall				# system calls for the current time
	move	$s4, $a0		# current_time = read time
	sub	$s5, $s4, $s3		# current time - time_step
	bge 	$s5, 100, process	# if time elapsed is greater than 600 ms, poll keypad
	blt	$s5, 100, pollPrologue	# if time is less than 600, poll for input
	
	j	loop			# Recursion - jump back to the top of the loop
	



process:
	# adjust $s3
	# process Body
	li	$v0, 30			# set service to get current time
	add	$a0, $zero, $t0
	syscall				# system calls for the current time
	move	$s3, $a0		# overwrite the timestamp of the last update
	jal	GenerateBugPrologue	# generate bug
	jal	MovePhaserPrologue	# check for phasers, move them
	jal	MoveBugPrologue		# move bugs
	
	j	loop
	
	#read loop
	#stack pointer
	#store in array
	
	 	
GenerateBugPrologue:
	#GenerateBug Prologue
	addi 	$sp,$sp,-8 		# push frame: storing 8 bytes
	sw 	$ra,0($sp) 		# save return address
	sw 	$s1,4($sp) 		# save $s1 
	move 	$s1,$a1 		# use $s1 to hold $a1 across call 
				
GenerateBugLoop:
	#GenerateBug Loop
	li  	$v0, 42          	# service 42 is generate random number
    	add 	$a1, $zero, 64		# range of random number from 0-63, should set X-coordinate
    	syscall
    	sb	$a0, 0($s6)		# store x value into queue
    	li	$a2, 3			# set color to green
    	li	$a1, 0			# set bug to appear on top row
    	jal	_setLED
	sb	$a1, 1($s6)		# store y value into queue
	sb	$a2, 2($s6)		# store color value into queue
	addi	$s6, $s6, 3		# advance array to the next cell
    	
GenerateBugEpilogue:
	#GenerateBug Epilogue
	lw 	$ra,0($sp) 		# restore $ra
	lw 	$s1,4($sp) 		# restore $s1
	addi 	$sp,$sp,8 		# pop stack frame
	jr 	$ra 			# return 

MoveBugPrologue:
	#MoveBug Prologue
	addi 	$sp,$sp,-12 		# push frame: storing 12 bytes
	sw 	$ra,0($sp) 		# save return address
	sw 	$s1,4($sp) 		# save $s1 
	move 	$s1,$a1 		# use $s1 to hold $a1 across call

#MoveBug:
	la	$t4, ($s6)		# load $s6 to $t4 for later comparision purposes
InnerBugLoop:
	lb	$a0, 0($s7)		# get x value from $s7
	lb	$a1, 1($s7)		# get y value from $s7
	lb	$a2, 2($s7)		# get LED from $s7
	bne	$a2, 3, MoveBugEpilogue	# if it is red, don't move it
	beq	$a1, 62, BugReachedEnd  # when bug reaches the end, go somewhere else
	jal	_setLED
	li	$a2, 0			# clear LED
	jal	_setLED
	addi	$a1, $a1, 1		# bug moves down
	jal	_getLED			
	beq	$v0, 1, DestroyEvent	# if that location is red, go to DestroyEvent
	li	$a2, 3			# set LED to green
	sb	$a0, 0($s6)		# store x value into queue
	sb	$a1, 1($s6)		# store y value into queue
	sb	$a2, 2($s6)		# store color value into queue	
	addi	$s7, $s7, 3		# add 3 to $s7
	addi	$s6, $s6, 3		# add 3 to $s6
	jal	_setLED
	bge	$s7, $t4, MoveBugEpilogue # if $s7 is greater than $t4, move back to MoveBugEpilogue (here to help with lag)
	j	InnerBugLoop		# if $s7 is less than $t4, go back to the top of the loop
	
MoveBugEpilogue: 
	#MoveBug Epilogue
	lw 	$ra,0($sp) 		# restore $ra
	lw 	$s1,4($sp) 		# restore $s1
	addi 	$sp,$sp,12 		# pop stack frame
	jr 	$ra 			# return
	
DestroyEvent:
	addi	$t6, $t6, 1		# count bugs hit
	li	$a2, 0			# set LED to clear
	addi	$s7, $s7, 3		# add 3 to $s7
	addi	$s6, $s6, 3		# add 3 to $s6
	jal	_setLED			# destroys bug
	addi	$a0, $a0, -1		
	li	$a2, 1
	jal	_setLED			# burst at (x - 1, y)
	addi	$a1, $a1, 1
	jal	_setLED			# burst at (x - 1, y + 1)
	addi	$a1, $a1, -2
	jal	_setLED			# burst at (x - 1, y - 1)
	addi	$a0, $a0, 2		
	jal	_setLED			# burst at (x + 1, y - 1)
	addi	$a1, $a1, 1
	jal	_setLED			# burst at (x + 1, y)
	addi	$a1, $a1, 1
	jal	_setLED			# burst at (x + 1, y + 1)
	j	InnerBugLoop


BugReachedEnd:
#BugReachedEnd:
	li	$a2, 0			# clear LED
	jal	_setLED
	addi	$s6, $s6, 3
	addi	$s7, $s7, 3
	jal	InnerBugLoop

	
	

MovePhaserPrologue:
	#MovePhaser Prologue
	addi 	$sp,$sp,-12 		# push frame: storing 8 bytes
	sw 	$ra,0($sp) 		# save return address
	sw 	$s1,4($sp) 		# save $s1 
	move 	$s1,$a1 		# use $s1 to hold $a1 across call

#MovePhaser:
	beq	$s6, 268500992, MovePhaserEpilogue
	la	$t4, ($s6)		# load $s6 to $t4 for later comparision purposes
InnerPhaserLoop:
	lb	$a0, 0($s7)		# get x value from $s6
	lb	$a1, 1($s7)		# get y value from $s6
	lb	$a2, 2($s7)		# get LED from $s6
	bne	$a2, 1, MovePhaserEpilogue	# if it isn't red, don't try to move it
	jal	_getLED
#	beq	$v0, 3, DestroyEvent	
	li	$a2, 0			# clear LED
	beq	$a1, $zero, PhaserReachedEnd
	jal	_setLED
	addi	$a1, $a1, -1		# phaser shoots up
	li	$a2, 1			# set LED to red
	sb	$a0, 0($s6)		# store x value into queue
	sb	$a1, 1($s6)		# store y value into queue
	sb	$a2, 2($s6)		# store color value into queue	
	addi	$s7, $s7, 3
	addi	$s6, $s6, 3
	jal	_setLED
	bge	$s7, $t4, MovePhaserEpilogue	# if $s7 is greater than $t4, move back to MoveBugEpilogue (here to help with lag)
	j	InnerPhaserLoop
	
	
MovePhaserEpilogue: 
	#MovePhaer Epilogue
	lw 	$ra,0($sp) 		# restore $ra
	lw 	$s1,4($sp) 		# restore $s1
	addi 	$sp,$sp,12 		# pop stack frame
	jr 	$ra 			# return
	

	
PhaserReachedEnd:
	li	$a2, 0			# clear LED
	jal	_setLED
	sb	$a0, 0($s6)		# store x value into queue
	sb	$a1, 1($s6)		# store y value into queue
	sb	$a2, 2($s6)		# store color value into queue	
	addi	$s7, $s7, 3
	addi	$s6, $s6, 3
	j	MovePhaserEpilogue

	
pollPrologue:
	#poll Prologue	
	addi 	$sp,$sp,-12 		# push frame: storing 12 bytes
	sw 	$ra,0($sp) 		# save return address
	sw 	$s1,4($sp) 		# save $s1 
	move 	$s1,$a1 		# use $s1 to hold $a1 across call 
	
poll:	
	#poll Body
	la	$v0,0xffff0000		# address for reading key press status
	lw	$t0,0($v0)		# read the key press status
	andi	$t0,$t0,1
	beq	$t0,$0,pollEpilogue	# no key pressed
	lw	$t0,4($v0)		# read key value

lkey:	
	move	$a0, $s2
	addi	$v0,$t0,-226		# check for left key press
	bne	$v0,$0,rkey		# wasn't left key, so try right key
	li	$a1, 63			# set Y back to bottom row
	li	$a2, 2			# set color back to orange
	li	$a2, 0			# turn off LED
	jal	_setLED
	addi	$a0,$a0,-1		# decrement current color
	li	$a2, 2			# orange
	jal	_setLED		        # move bug-buster to the left
	move	$s2, $a0
	j	pollEpilogue

rkey:	
	move	$a0, $s2
	addi	$v0,$t0,-227		# check for right key press
	bne	$v0,$0, ukey		# wasn't right key, so check for up key
	li	$a1, 63			# set Y back to bottom row
	li	$a2, 2			# set color back to orange
	li	$a2, 0			# turn off LED
	jal	_setLED
	addi	$a0,$a0, 1		# move to the right
	li	$a2, 2			# orange
	jal	_setLED			# move bug-buster to the right
	move	$s2, $a0
	j	pollEpilogue

ukey:
	# Phaser fires here   
	move	$a0, $s2
	addi	$v0, $t0, -224		# check for up key press
	bne	$v0, $0, dkey
	add	$t8, $t8, 1
	li	$a1, 62			# phaser shot up
	li	$a2, 1			# set color to red
	jal	_setLED
	sb	$a0, 0($s6)		# store x value into queue
	sb	$a1, 1($s6)		# store y value into queue
	sb	$a2, 2($s6)		# store color value into queue
	move	$s2, $a0
	addi	$s6, $s6, 3		# advance array to the next cell
	j	pollEpilogue
	

dkey:	
	move	$a0, $s2
	addi	$v0, $t0, -225		# check for down key press
	# print out The game score is <bug-hits> : <phaser-firings>.
terminate:
	# quit the game
	li  	$v0, 4           	# service 4 is print string
    	la 	$a0, playerScore  	# 
    	syscall
    	add 	$a0, $zero, $t6
	li 	$v0, 1			
	syscall				# print bugs hit
	li  	$v0, 4           	# service 4 is print string
    	la 	$a0, colon	  	# print " : "
    	syscall
    	add 	$a0, $zero, $t8
	li 	$v0, 1
	syscall				# print phasers fired
	li	$v0, 10			# terminate program
	syscall

pollEpilogue:
	# poll Epilogue
	lw 	$ra,0($sp) 		# restore $ra
	lw 	$s1,4($sp) 		# restore $s1
	addi 	$sp,$sp,12 		# pop stack frame
	jr 	$ra 			# return 
	
	# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=yellow, 3=green
	#
	# arguments: $a0 is x, $a1 is y, $a2 is color
	# trashes:   $t0-$t3
	# returns:   none
_setLED:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll	$t0,$a1,4      # y * 16 bytes
	srl	$t1,$a0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008 # base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$a0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
	
	# int _getLED(int x, int y)
	#   returns the value of the LED at position (x,y)
	#
	#  arguments: $a0 holds x, $a1 holds y
	#  trashes:   $t0-$t2
	#  returns:   $v0 holds the value of the LED (0, 1, 2 or 3)
	#

_getLED:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll  $t0,$a1,4      # y * 16 bytes
	srl  $t1,$a0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$a0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	jr   $ra
