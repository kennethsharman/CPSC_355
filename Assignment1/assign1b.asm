// CPSC 355:	Tutorial T06
// Assignment:	#1b
// Date: 	Sept 27, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	Program finds the maximum of f(x) = -5x^3-31x^2+4x+31 in range -6 <= x <= 5
// 		Assumes the maximum value is greater than or equal to -9999
//		Optimized version of assign1a.s

// Define macros in form: y_val = a_3(x_val)^3 + a_2(x_val)^2 + a_3(x_val) + a_0
define(x_val, x19)				// x19 = x value
define(y_val, x20)				// x20 = y value
define(max, x21)				// x21 = maximum value
define(a_3, x22)				// x22 = a_3
define(a_2, x23)				// x23 = a_2
define(a_1, x24)				// x24 = a_1
define(a_0, x25)				// x25 = a_0

tbl1:	.string "   x\t| f(x)\t|  Max\n"	// Table header
tbl2:	.string "---------------------\n"	// Table Header Divider
vals:	.string "  %d\t| %d\t|  %d\n"		// printf format string

	.balign 4				// Ensures instructions are properly aligned
	.global main

main:	stp	x29, x30, [sp, -16]!		// Saves state
	mov	x29, sp				// Saves state

	adrp	x0, tbl1			// Arg 1: Address of the header string
	add	x0, x0, :lo12:tbl1		// Takes 2 steps to get address
	bl	printf				// Call printf to print table header

	adrp	x0, tbl2			// Arg 1: Address of the table divider
	add	x0, x0, :lo12:tbl2		// Takes 2 steps to get address
	bl	printf

	mov	x_val, -6			// x_val starts at -6
	mov	max, -9999			// Current max initialized to -9999
	mov	a_3, -5				// a_3 = -5
	mov	a_2, -31			// a_2 = -31
	mov	a_1, 4				// a_1 = 4
	mov	a_0, 31				// a_0 = 31

	b	test

eval:	madd	y_val, x_val, a_3, a_2		// y = -5x-31
	madd	y_val, y_val, x_val, a_1	// y = -5x^2 - 31x + 4
	madd	y_val, y_val, x_val, a_0	// y = -5x^3 - 31x^2 + 4x + 31

	cmp	y_val, max			// Compare y value to current max
	b.le	show				// If y <= max, current max holds and skip next line
	mov	max, y_val

show:	adrp	x0, vals			// Arg 1: Address of vals string
	add	x0, x0, :lo12:vals		// Takes 2 steps to get address
	mov	x1, x_val			// Arg 2: x val
	mov	x2, y_val			// Arg 3: y val
	mov	x3, max				// Arg 4: Current Max
	bl	printf				// Execute printf

	add	x19, x_val, 1			// Increment x-val by 1
	
test:	cmp	x19, 5				// Compare x19, 5
	b.le	eval				// If value in x19 > 5 go to 'done' label

	ldp	x29, x30, [sp], 16		// Restores state
	ret					// Restores state
