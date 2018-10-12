// CPSC 355:	Tutorial T06
// Assignment:	#2c
// Date:	October 11, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	ARMv8 assembly language program, translated from code written in C, that implements integer multiplication

// Define 3 strings for initial, intermediate, and final print statements
str1:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
str2:	.string "product = 0x%08x multiplier = 0x%08x\n"
str3:	.string "64-bit result = 0x%016lx (%ld)\n"

// Define Macros
	// 0 = 0
		// 1 = 1
	// Multiplicand
	// Multiplier
	// Product
		// Iteration index
	// Indicates if multiplier is negative
	// Result of multiplication
	// Temp variable 1 used in x25 concatenation
	// Temp variable 2 used in x25 concatenation

	.balign 4				// Ensures instructions are properly aligned
	.global main

main:	stp	x20, x30, [sp, -16]!		// Saves state
	mov	x29, sp				// Saves state
	
	// Initialize variables
	mov	W20, -252645136		// Multiplicand = -252645136
	mov	W21,	-256			// Multiplier = -256
	mov	W22, 0				// Product = 0
	mov	W23, 0				// Initialize iteration count to zero

	// Print out initial values of variables
	adrp	x0, str1			// Arg 1: Address of initial string to be printed
	add	x0, x0,	:lo12:str1		// Takes two steps to get the address
	mov	w1, W21			// Arg 2: Multiplier
	mov	w2, W21			// Arg 3: Multiplier
	mov	w3, W20			// Arg 4: Multiplicand
	mov	w4, W20			// Arg 5: Multiplicand
	bl	printf				// Execute printf

	// Determine if the multiplier is negative
	mov	w24, 0			// Assume multiplier is not negative
	cmp	W21, 0			// Compare multiplier and zero
	b.gt	top				// If multiplier > 0 go to top
	mov	w24, 1			// Otherwise multiplier is negative

	// Do repeated add and shift
top:	tst	W21, 0x1			// Test if lsb of multiplier is 0 or 1
	b.eq	shift				// If lsb = 0 skip next step
	add	W22, W22, W20		// If lsb = 1 then: product += multiplicand

	// Arithmetic shift right the multiplier and combined product
shift:	asr	W21, W21, 1		// Arithmetic shift right multiplier by 1
	tst	W22, 0x1			// Test if lsb of multiplier is 0 or 1
	b.eq	stmt1				// If lsb of product = 0 skip to stmt1
	ORR	W21, W21, 0x80000000	// If lsb = 1 then msb of multiplier is set to 1
	b	stmt2				// Skip next step

stmt1:	and	W21, W21, 0x7FFFFFFF	// If lsb of product = 1 then msb is set to 0
stmt2:	asr	W22, W22, 1			// Arithmetic shift right product by 1
	add	W23, W23, 1				// W23 += 1
	cmp	W23, 32				// Compare value of W23 to 32
	b.lt	top				// If W23 < 32 go to top

	// Adjust product register if multiplier is negative
	cmp	w24, 1				// Check to see if multiplier was negative
	b.lt	next				// If not skip next step
	sub	W22, W22, W20		// If it was negative product -= multiplicand

	// Print out product and multiplier
next:	adrp	x0, str2			// Arg 1: Address of str2
	add	x0, x0, :lo12:str2		// Takes 2 steps to get address
	mov	w1, W22			// Arg 2: product
	mov	w2, W21			// Arg 3: multiplier
	bl	printf				// Execute printf

	// Combine product and multiplier together
	sxtw	x26, W22			// Signed-Extend Word casts int to long int
	and	x26, x26, 0xFFFFFFFF		// Form a bitmask with 0xFFFFFFF
	lsl	x26, x26, 32			// Shift x26 so it occupies left half of bits
	sxtw	x27, W21			// Cast multiplier to 64-bit
	and	x27, x27, 0xFFFFFFFF		// Bitmask x27 with 0xFFFFFFF
	add	x25, x26, x27		// Add temp variables to obtain 64-bit x25

	// Print out 64-bit x25
	adrp	x0, str3			// Arg 1: Address of str3
	add	x0, x0, :lo12:str3		// Takes 2 steps to get address
	mov	x1, x25			// Arg 2: x25
	mov	x2, x25			// Arg 3: x25
	bl	printf				// Execute printf

	ldp	x29, x30, [sp], 16		// Restores state
	ret					// Restores state
