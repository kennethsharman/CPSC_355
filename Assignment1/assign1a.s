// CPSC 355:	Tutorial T06
// Assignment:	#1a
// Date: 	Sept 26, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	Program finds the maximum of f(x) = -5x^3-31x^2+4x+31 in range -6 <= x <= 5
//		Assumes the maximum value is greater than or equal to -9999

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

	mov	x19, -6				// x19 is x-val which starts at -6
	mov	x20, -9999			// x20 is current max, initialized to -9999
	mov	x22, -1				// Move -1 into register x22, used to negate in mul ops

test:	cmp	x19, 5				// Compare x19, 5
	b.gt	done				// If value in x19 > 5 go to 'done' label

eval:	mov	x21, 5				// x21 used to store y, initialized to 5
	mul	x21, x21, x19			// 5x
	add	x21, x21, 31			// 5x + 31
	mul	x21, x21, x22			// -5x - 31
	mul	x21, x21, x19			// -5x^2 - 31x
	add	x21, x21, 4			// -5x^2 - 31x + 4
	mul	x21, x21, x19			// -5x^2 - 31x + 4x
	add	x21, x21, 31			// -5x^2 - 31x + 4x + 31

	cmp	x20, x21			// Compare current max to y val in x21
	b.ge	show				// If current max >= y go to 'show' label
	mov	x20, x21			// Else update current max with y

show:	adrp	x0, vals			// Arg 1: Address of vals string
	add	x0, x0, :lo12:vals		// Takes 2 steps to get address
	mov	x1, x19				// Arg 2: x val
	mov	x2, x21				// Arg 3: y val
	mov	x3, x20				// Arg 4: Current Max
	bl	printf				// Execute printf

	add	x19, x19, 1			// Increment x-val by 1
	
	b	test				// Return to start of the loop

done:	ldp	x29, x30, [sp], 16		// Restores state
	ret					// Restores state
