README
---------

This Bugs game was developed by Devin Dang, a first year student at the University of Pittsburgh.
The game is a project that will be a grade for the Computer Organization and Assembly Language course (CS 0447) offered at the University of Pittsburgh.

WHAT THE GAME DOES
---------------------
-game uses a queue to hold phasers and bugs
-game loops through the queue to move phasers and bugs using a circular buffer
-game loops through the queue every 600 ms
-bugs are placed on the game board at random x coordinates in Row 1
-a bug does move down one LED every time step
-the bug-buster is orange
-bugs are green
-phasers are red
-bug-buster is able to move left and right
-bug-buster is able to shoot phasers using the red buton
-the scoring system is able to count the amount of phasers shot BEFORE the frozen error occurs (see ERRORS)
-no bugs in the bug-buster's row (63)
-game ends early by pressing the down key or the center (b) key
-when bugs and phaser collide, burst occurs
-when burst occurs and there is a bug nearby, that nearby bug is destroyed too

ALGORITHM
------------
-Set off with a player.
-Has two main loops, a fast one and a slow one.
-Fast Loop will check for keypad presses
-Slow Loop will Generate Bugs, Move Bugs and Phasers (if any exist)

ERRORS
-------
-game does not terminate in two minutes
-game does not start by pressing b
-bugs aren't placed in the first row, Row 0
-when bugs and phaser collide, burst occurs but missing a red LED at the center bottom
-when bugs and phaser collide, burst will freeze the game
-sometimes when the bug and phaser collide, they just go through each other
-game does not cascade
-bugs and phasers freeze in place once a bug reaches row 62
	DUE TO THE ABOVE ERROR, THESE ERRORS OCCUR:
	-unable to print "The game score is <bug-hits> : <phaser-firings>." once the bugs and phasers freeze