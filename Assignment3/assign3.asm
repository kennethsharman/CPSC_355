// CPSC 355:	Tutorial T06
// Assignment:	#3
// Date:	October 25, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	Creates an array with random positive integers, then sorts it using insertion sort

// Define 2 strings for print statements
str1:	.string "v[%d] : %d\n"
str2:	.string "\nSorted array:\n"

// Define macros
define(i_r, w19)		// index i register
define(j_r, w20)		// index j register
define(temp_r, w21)		// temp variable register
define(v_base_r, x22)		// array v register
define(FP, x29)			// frame pointer register

define(i_s, 16)			// index i offset
define(j_s, 20)			// index j offset
define(temp_s, 24)		// temp variable offset
define(v_s, 28)			// array v offset
define(SIZE, 50)		// size of array v
define(SHIFT, 2)		// used for logical shift left by 2

	v_size = 50 * 4						// 200 bytes total allocated for the array
	local_var_size = 4					// 4 byte local variables; i, j, and temp
	alloc = -(16 + v_size + 3 * local_var_size) & -16	// forces address to be evenly divisible
	dealloc = -alloc 

	.balign 4						// ensures instructions are properly aligned
	.global main

main:	stp	x29, x30, [sp, alloc]!				// saves state
	mov	x29, sp						// saves state

	add	v_base_r, FP, v_s				// add the FP address plus the array v offset to v register
	str	WZR, [FP, i_s]					// i_s = 0
	ldr	i_r, [FP, i_s]					// load i_r register with value i_s = 0
	b	loop1_check					// check/ enter first loop 

loop1:	// Initialize array to random positive integers, mod 256

	ldr	i_r, [FP, i_s]					// load index into index register
	
	bl	rand						// generate random number
	and	w23, w0, 0xFF					// generate random number in range 0-255
	str	w23, [v_base_r, i_r, SXTW SHIFT]		// store random number in v array register

	adrp	x0, str1					// arg 1: Address of str1
	add	x0, x0, :lo12:str1				// takes 2 steps to get address
	mov	w1, i_r						// arg 2: index
	ldr	w2, [v_base_r, i_r, SXTW SHIFT]			// arg 3: random number assigned to v[index]
	bl	printf						// execute printf

	add	i_r, i_r, 1					// increment index by 1
	str	i_r, [FP, i_s]					// store index value on stack

loop1_check:	
	cmp	i_r, SIZE					// if i < SIZE :
	b.lt	loop1						// go to top of loop1

	mov	i_r, 1						// set index i register to 1
	str	i_r, [FP, i_s]					// store index i value on stack
	b	loop2_outerTest					// check/ enter second loop

loop2: // Sort the array using an insertion sort

	ldr	i_r, [FP, i_s]					// load index i value on stack to index i register
	mov	j_r, i_r					// copy index i to index j
	str	j_r, [FP, j_s]					// store index j on stack
	ldr	temp_r,	[v_base_r, i_r, SXTW SHIFT]		// temp_r = v[index i]

	b	loop2_innerTest					// check/ enter inner loop

loop2_inner:
	ldr	j_r, [FP, j_s]					// load index j from stack into index j register
	add	w23, j_r, -1					// decrement value of index j register by 1
	ldr	w24, [v_base_r, w23, SXTW SHIFT]		// load register w24 with v[-j]
	str	w24, [v_base_r, j_r, SXTW SHIFT]		// store v[-j] from w24 on stack in location v[j]

	add	j_r, j_r, -1					// decrement value of index j register
	str	j_r, [FP, j_s]					// store index j value on stack

loop2_innerTest:
	ldr	j_r, [FP, j_s]					// load index j from stack into register
	cmp	j_r, WZR					// compare index j register to zero
	b.le	break_inner					// if j < 0 then break from inner loop

	add	w23, j_r, -1					// if j !< 0 then place j-1 in w23
	ldr	w24, [v_base_r, w23, SXTW SHIFT]		// load v[j-1] value into w24
	
	cmp	temp_r, w24					// compare temp_r = v[i] and w24 = v[j-1]
	b.ge	break_inner					// if v[i] >= v[j-1]
	b	loop2_inner 					// break inner loop

break_inner:
	str	temp_r, [v_base_r, j_r, SXTW SHIFT]		// update v[j] = temp_r = v[i]
	add	i_r, i_r, 1					// increment index i register by 1
	str	i_r, [FP, i_s]					// store index i value on stack

loop2_outerTest:	
	cmp	i_r, SIZE					// compre index i register with size
	b.lt	loop2						// if i < SIZE then go to top of loop2

// Print "Sorted array:"
	adrp	x0, str2					// arg 1: address of initial string to be printed
	add	x0, x0, :lo12:str2				// takes two steps to get address
	bl	printf						// execute printf

// Print each element of array v
	str	WZR, [FP, i_s]					// reset index i to zero on stack
	ldr	i_r, [FP, i_s]					// update index i register
	b	print_check					

final_loop:
	adrp	x0, str1					// arg 1: address of string to be printed
	add	x0, x0, :lo12:str1				// takes two steps to get address
	mov	w1, i_r						// arg 2: index i
	ldr	w2, [v_base_r, i_r, SXTW SHIFT]			// arg 3: v[index i]
	bl	printf						// execute printf

	add	i_r, i_r, 1					// increment index i register by 1
	str	i_r, [FP, i_s]					// update index i value on stack

print_check:
	cmp	i_r, SIZE					// compare index i register to SIZE
	b.lt	final_loop					// if i_r < SIZE then print next element
								// else done
	ldp	x29, x30, [sp], dealloc				// restores state
	ret
