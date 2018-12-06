// CPSC 355:	Tutorial T06
// Assignment:	#6
// Date:	December 2, 2018
// Description:	Computes the cubed root of a list of numbers saved in .bin file
// Author:	Kenneth Sharman

// Macros
define(fd_r, w19)		// stores file descriptor when a file is read
define(buf_base_r, x20)		// base address of buffer used to stored read bytes
define(nread_r, x21)		// number of bytes read when reading input file
define(AT_FDCWD, -100)		// used to indicate input file pathname is relative to CWD

// Print statements
	.text
err1:	.string	"ERROR: Could not open file: %s \nTerminating Program...\n"
err2:	.string	"ERROR: Invalid arguments, usage ./a6 <Input-File.bin>\n"
err3:	.string "ERROR: Close file unsuccessful. Check Code.\n"
head1:	.string "\tx\t|\tx^(1/3)\n"
head2:	.string	" ***************|*****************\n"
disp:	.string "%15.10f\t|%15.10f\n"

	buf_size = 8				// buffer is 8 bytes
	alloc = -(16 + buf_size) & -16	
	dealloc = -alloc
	buf_s = -16				// buffer offset

	.balign 4				// ensures instructions are properly aligned
	.global main
main:	stp	x29, x30, [sp, alloc]!		// saves state
	mov	x29, sp				// saves states

	mov	w19, w0				// number of cmd line args
	mov	x20, x1				// address of cmd line args
	cmp	w19, 2				// check number of args	
	b.ne	error				// branch to error if not 2 args

// Open file for reading
	ldr	x22, [x20, 8]			// get path of input file passed from cmd line
	mov	w0, AT_FDCWD			// 1st arg (use cwd)
	mov	x1, x22				// 2nd arg (pathname)
	mov	w2, 0				// 3rd arg (read-only)
	mov	w3, 0				// 4th arg (not used)
	mov	x8, 56				// openat I/O request
	svc	0				// generate exception
	mov	fd_r, w0			// save fd
// Verify file was opened successfully
	cmp	fd_r, 0				// error check (-1 returned on error)
	b.ge	open_ok				// branch to open_ok if fd >= 0

// If file didn't open properly then display error msg and exit
	adrp	x0, err1			// get address of string to be printed
	add	x0, x0, :lo12:err1		// takes two steps to get address
	mov	x1, x22				// improper pathname
	bl	printf				// execute printf
	mov	w0, -1				// set return variable to -1
	b	exit				// branch to exit

open_ok:
	adrp	x0, head1			// print table header
	add	x0, x0, :lo12:head1		// which consists of two print statements
	bl	printf				// first is column names
	adrp	x0, head2			// second is divider bar
	add	x0, x0, :lo12:head2
	bl	printf

	add	buf_base_r, x29, buf_s		// get buffer base address

// Loop reads a double from input file, calcs cubed root using a call to the
// newton subroutine and then displays both input and cubed root values
top:	// Read double (8 bytes) from input file
	mov	w0, fd_r			// 1st arg (fd)
	mov	x1, buf_base_r			// 2bd arg (pointer to buf)
	mov	x2, buf_size			// 3rd arg (n- # of bytes to read)
	mov	x8, 63				// read I/O request
	svc	0				// call sys function
	mov	nread_r, x0			// save number bytes read
	// error check
	cmp	nread_r, buf_size 		// check if read was successful
	b.ne	close				// branch to close if unsuccessful
	// calc cubed root of double read
	ldr	d8, [buf_base_r]		// save double read to callee-save register
	fmov	d0, d8				// load double read for subroutine FP arg
	bl	newton				// call newton subroutine to calc cubed root
	fmov	d9, d0				// save return value
	// display input and cubed root
	adrp	x0, disp			// arg 1: address of display string
	add	x0, x0, :lo12:disp		// low 12 address
	fmov	d0, d8				// arg 2: input value
	fmov	d1, d9				// arg 3: cubed root of input value
	bl	printf				// execute printf

	b	top				// branch to top of loop
						// (loop is broken when file read is unsuccessful)

// Error message for when prog is called without 2nd (input file) arg
error:	adrp	x0, err2			// address of error string
	add	x0, x0, :lo12:err2		// low 12 address
	bl	printf				// execute printf

// Close file and check that it was successful
close:	mov	w0, fd_r			// load fd as system call arg
	mov	x8, 57				// close service request
	svc	0				// generate exception
	cmp	w0, 0				// 0 is close was successful
	b.eq	exit				// skip error msg if successful

	adrp	x0, err3			// address of close file error string
	add 	x0, x0, :lo12:err3		// low 12 address
	bl	printf				// execute printf

exit:	ldp	x29, x30, [sp], dealloc		// restores state
	ret					// restores state

// Subroutine FP Macros
define(input_r, d16)
define(x_r, d17)
define(y_r, d18)
define(dy_r, d19)
define(dydx_r, d20)
	
	.text
tol_m:	.double	0r1.0e-10			// maximum error in cubed root

	.text
	.balign 4
newton:	stp	x29, x30, [sp, -16]!		// saves state
	mov	x29, sp				// saves state

	fmov	input_r, d0			// save subroutine arg
	fmov	d1, 3.0				// move 3.0 into FP register for arithmetic
	fdiv	x_r, input_r, d1		// x = input / 3.0

// Do while loop executes until abs(dy) < tol
do:	fmul	y_r, x_r, x_r			// y = x * x
	fmul	y_r, y_r, x_r			// y = x * x * x
	fsub	dy_r, y_r, input_r		// dy = y - input
	fmul	dydx_r, x_r, x_r		// y' = x * x
	fmul	dydx_r, dydx_r, d1		// y' = 3 * x^2
	fdiv	d21, dy_r, dydx_r		// d21 = dy / dydx
	fsub	x_r, x_r, d21			// x = x - d21
	fabs	dy_r, dy_r			// dy = abs(dy)
	
	adrp	x9, tol_m			// get address of tol
	add	x9, x9, :lo12:tol_m		// get low 12 address of tol
	ldr	d2, [x9]			// load val of tol into FP register

	fcmp	dy_r, d2			// check if dy < tol
	b.ge	do				// if not branch to top of do loop

	fmov	d0, x_r				// load return variable

	ldp	x29, x30, [sp], 16		// restores state
	ret					// restores state
