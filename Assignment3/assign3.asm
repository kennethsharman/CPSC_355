// CPSC 355:	Tutorial T06
// Assignment:	#3
// Date:	October 24, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	Creates an array with random positive integers, then sorts it using insertion sort

// Define 2 strings for print statements
str1:	.string "v[%d] : %d\n"
str2:	.string "\nSorted array:\n"

define(i_r, w19)
define(j_r, w20)
define(temp_r, w21)
define(v_base_r, x22)

	v_size = 50 * 4						// 200 bytes total allocated for the array
	local_var_size = 4					// 4 byte local variables; i, j, and temp
	alloc = -(16 + v_size + 3 * local_var_size) & -16	// Forces address to be evenly divisible
	dealloc = -alloc 
	
	i_s = 16
	j_s = 20
	temp_s = 24

	.balign 4
	.global main
main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp








	ldp	x29, x30, [sp], dealloc
	ret	
