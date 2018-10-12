// CPSC 355:	Tutorial T06
// Assignment:	#2a
// Date:	October 11, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	ARMv8 assembly language program, translated from code written in C, that implements integer multiplication

// Define 3 strings for initial, intermediate, and final print statements
str1:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
str2:	.string "product = 0x%08x multiplier = 0x%08x\n"
str3:	.string "64-bit result = 0x%016lx (%ld)\n"

// Define Macros
define(FALSE, 0)
define(TRUE, 1)
define(mcand, W20)	// macros using 32-bit-wide registers
define(mplier, W21)
define(prod, W22)
define(i, W23)
define(neg, w24)
define(result, x25)	// macros using 64-bit-wide
define(tmp1, x26)
define(tmp2, x27)

	.balign 4				// Ensures instructions are properly aligned
	.global main

main:	stp	x20, x30, [sp, -16]!		// Saves state
	mov	x29, sp				// Saves state
	
	// Initialize variables
	mov	mcand, -16843010		// multiplicand = -16843010
	mov	mplier,	70			// multiplier = 70
	mov	prod, 0				// product = 0
	mov	i, 0

	// Print out initial values of variables
	adrp	x0, str1			// Arg 1: Address of initial string to be printed
	add	x0, x0,	:lo12:str1		// Takes two steps to get the address
	mov	w1, mplier			// Arg 2: Multiplier
	mov	w2, mplier			// Arg 3: Multiplier
	mov	w3, mcand			// Arg 4: Multiplicand
	mov	w4, mcand			// Arg 5: Multiplicand
	bl	printf				// Execute printf

	// Determine if the multiplier is negative
	mov	neg, FALSE			// Assume multiplier is not negative
	cmp	mplier, 0			// Compare multiplier and zero
	b.gt	top				// If multiplier > 0 go to top
	mov	neg, TRUE			// Otherwise multiplier is negative

	// Do repeated add and shift
top:	tst	mplier, 0x1			// Test if lsb of multiplier is 0 or 1
	b.eq	shift				// If lsb = 0 skip next step
	add	prod, prod, mcand		// If lsb = 1 then: product += multiplicand

	// Arithmetic shift right the multiplier and combined product
shift:	asr	mplier, mplier, 1		// Arithmetic shift right multiplier by 1
	tst	prod, 0x1			// Test if lsb of multiplier is 0 or 1
	b.eq	stmt1				// If lsb of product = 0 skip to stmt1
	ORR	mplier, mplier, 0x80000000	// If lsb = 1 then msb of multiplier is set to 1
	b	stmt2				// Skip next step

stmt1:	and	mplier, mplier, 0x7FFFFFFF	// If lsb of product = 1 then msb is set to 0
stmt2:	asr	prod, prod, 1			// Arithmetic shift right product by 1
	add	i, i, 1				// i += 1
	cmp	i, 32				// Compare value of i to 32
	b.lt	top				// If i < 32 go to top

	cmp	neg, 1				// Check to see if multiplier was negative
	b.lt	next				// If not skip next step
	sub	prod, prod, mcand		// If it was negative product -= multiplicand

next:	adrp	x0, str2
	add	x0, x0, :lo12:str2
	mov	w1, prod
	mov	w2, mplier
	bl	printf

	sxtw	tmp1, prod
	and tmp1, tmp1, 0xFFFFFFFF
	lsl	tmp1, tmp1, 32
	sxtw	tmp2, mplier
	and	tmp2, tmp2, 0xFFFFFFFF
	add	result, tmp1, tmp2

	adrp	x0, str3
	add	x0, x0, :lo12:str3
	mov	x1, result
	mov	x2, result
	bl	printf

	ldp	x29, x30, [sp], 16		// Restores state
	ret					// Restores state
