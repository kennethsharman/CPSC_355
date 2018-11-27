// CPSC 355:	Tutorial 06
// Assignment:	#5b
// Date:	Nov 25, 2018
// Description:	Takes 2 cmd line args as a date in format mm dd and displays season of this date
// Author:	Kenneth Sharman 00300185

// Define Macros
define(argc_r, w19)
define(argv_r, x20)

// Define print statements used in the program
		.text
jan_m:		.string "January"				// define all 12 months of year
feb_m:		.string "February"
mar_m:		.string "March"
apr_m:		.string "April"
may_m:		.string "May"
jun_m:		.string "June"
jul_m:		.string "July"
aug_m:		.string "August"
sep_m:		.string "September"
oct_m:		.string "October"
nov_m:		.string "November"
dec_m:		.string "December"

spr_m:		.string "Spring"				// define all 4 seasons
sum_m:		.string "Summer"
fal_m:		.string "Fall"
win_m:		.string "Winter"

display:	.string "%s %d%s is %s\n"			// eg: December 25th is Winter
error1:		.string "Correct usage form: a5b mm dd\n"	// error string 1
error2:		.string "Incorrect input form.\n"		// error string 2

st_m:		.string "st"					// eg: 1st
nd_m:		.string "nd"					// eg: 2nd
rd_m:		.string "rd"					// eg: 3rd
th_m:		.string "th"					// eg: 4th		

// Define arrays of pointers
		.data
		.balign 8					// doubleword align
month_m:	.dword	jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m
day_m:		.dword	th_m, st_m, nd_m, rd_m
season_m:	.dword	win_m, spr_m, sum_m, fal_m

		.text
		.balign 4					// quadword align
		.global main
main:		stp	x29, x30, [sp, -16]!			// saves state
		mov	x29, sp					// saves state

		mov	argc_r, w0				// argc_r = # of arguements
		mov	argv_r, x1				// argv_r = array of pointers to the arguments

// error checking cmd line input
		cmp	argc_r, 3				// verify cmd line input was of form: a5b mm dd
		b.eq	skip_error				// if proper input then skip error message

		adrp	x0, error1				// 1st arg: address of string to be printed
		add	x0, x0, :lo12:error1			// takes two steps to get full address
		bl	printf					// execute printf
		b	end					// skip to end of main to terminate
// error checking month input
skip_error:	ldr	x0, [argv_r, 8]				// x0 = 1st arg
		bl	atoi					// convert string arg to int
		mov	w21, w0					// w21 = month
		cmp	w21, 1					// check to see if month >= 1
		b.lt	error					// if not, then branch to error
		cmp	w21, 12					// check to see if month <= 12
		b.gt	error					// if not, then branch to error
// error checking day input
		ldr	x0, [argv_r, 16]			// x0 = 2nd arg
		bl	atoi					// convert string arg to int
		mov	w22, w0					// w22 = day
		cmp	w22, 1					// check to see if day >=1
		b.lt	error					// if not, then branch to error
		cmp	w22, 31					// check to see if day <= 31
		b.gt	error					// if not, then branch to error
// determine post fix of day
		mov	w24, 10					// going to divide day by 10
		SDIV	w3, w22, w24				// w3 = day/10
		MSUB	w3, w24, w3, w22			// remainder: day-[int(day/10)*day]	
		cmp	w3, 3					// compare result to 3
		b.le	next1					// if result <= 3 branch to next1
		mov	w3, 0					// set post fix to "th"
		b	next2					// branch to next2
// Verify 11, 12, 13 have postfix "th"
next1:		cmp	w22, 11					// check if day < 11
		b.lt	next2					// if it is, branch to next2
		cmp	w22, 13					// check if day > 13
		b.gt	next2					// if it is, branch to next2
		mov	w3, 0					// 11<=day<=13 so post fix will be "th"
// Shift date so that seasons are easily identified by month
next2:		mov	w25, w21				// "adjusted month"
		cmp	w22, 21					// compare day to 21
		b.lt	next3					// if day < 21 branch to next3
		add	w25, w25, 1				// month += 1
next3:		cmp	w25, 12					// compare month to 12
		b.le	next4					// if month <=12 branch to next4
		mov	w25, 1					// if month=13 change to 1

next4:		cmp	w25, 3					// compare month to 3
		b.gt	next5					// if month > 3 branch to next5
		mov	w25, 0					// 0th season: winter
		b	print					// branch to print

next5:		cmp	w25, 6					// compare month to 6
		b.gt	next6					// if month > 6 branch to next6
		mov	w25, 1					// 1st season: spring
		b	print					// branch to print

next6:		cmp	w25, 9					// compare month to 9
		b.gt	next7					// if month > 9 branch to next7
		mov	w25, 2					// 2nd second: summer
		b	print					// branch to print		

next7:		mov	w25, 3					// 3rd season: fall
// print output
print:		adrp	x0, display				// arg 1: address of the string to be printed
		add	x0, x0, :lo12:display			// takes two steps to get address
		
		adrp	x23, month_m				// get address of month array
		add	x23, x23, :lo12:month_m			// get low 12 address of month array
		sub	w21, w21, 1				// zero indexing
		ldr	x1, [x23, w21, SXTW 3]			// 2nd arg: month 
		
		mov	w2, w22					// 3rd arg: day

		adrp	x26, day_m				// get address of day array
		add	x26, x26, :lo12:day_m			// get low 12 address of day array
		ldr	x3, [x26, w3, SXTW 3]			// 4th arg: postfix of day
		
		adrp	x27, season_m				// get address of season array
		add	x27, x27, :lo12:season_m		// get low 12 address of season array
		ldr	x4, [x27, w25, SXTW 3]			// 5th arg: season

		bl	printf					// execute printf
		b	end					// branch to end

error:		adrp	x0, error2				// 1st arg: address of string to be printed
		add	x0, x0, :lo12:error2			// takes two steps to get address
		bl	printf					// execute printf

end:		ldp	x29, x30, [sp], 16			// restores state
		ret						// restores state
