// CPSC 355:	Tutorial T06
// Assignment:	#3
// Date:	October 24, 2018
// Author:	Kenneth Sharman
// Student ID:	00300185
// Description:	Creates an array with random positive integers, then sorts it using insertion sort

// Define 2 strings for print statements
str1:	.string "v[%d] : %d\n"
str2:	.string "\nSorted array:\n"

define(i_s, 16)
define(i_r, w19)
define(j_s, 20)
define(j_r, w20)
define(min_s, 24)
define(min_r, w21)
define(temp_s, 28)
define(temp_r, w22)
define(v_sr, x25)
define(v_s, 32)
define(SIZE, 50)
define(SCALE, 2)
define(FP, x29)
define(SP, x30)
define(temp1_r, w23)
define(temp2_r, w24)

	alloc = -(

	.balign 4
	.global main
main:	stp	x29, x30, [sp, -240]!
	mov	x29, sp

	mov	v_sr, v_s			// Load the v_sr register with the offset of the v array
	
