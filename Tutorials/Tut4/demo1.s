// Date: Sept 26, 2018
// Desc: Example Showing the use variables and macros
// The following code prints the number entered by you
	
	outputStr: .asciz "you have entered %d\n"
	inputStr: .asciz "%d"

	

	.balign 4

	.global main
main:

	stp	x29,	x30,	[sp, -16]!	// Save fp register and link register current values on stack
	mov	x29,	sp			// update fp register
	
	// Getting user inout using C function scanf
	ldr	x0,	=inputStr		// Load rgister x0 with the address of string input Str
	ldr	x1,	=varX			// Load register x1 with the address of variable varX
	bl	scanf				// Call function scanf

	ldr	x1,	=varX			// Load rgister x1 with the address of variable
	ldr	x19,[x1]

printY:
	ldr	x0,	=outputStr
	mov	x1,	x19
	bl	printf

	ldp	x29,	x30,	[sp], 16
	ret


	// data section
	.data
	varX:	.int	//scanf will store number entered by user in this memory location
