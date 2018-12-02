//
//
//

define(fd_r, w19)
define(buf_base_r, x20)
define(nread_r, x21)
define(AT_FDCWD, -100)

err1:	.string	"ERROR: Could not open file: %s \nExiting...\n"
err2:	.string	"ERROR: Invalid arguments, usage ./a6 <Input-File.bin>\n"
err3:	.string	"ERROR: x out of range, x must be in range [0,90]"
head1:	.string "\tx\t|\tx^(1/3)\n"
head2:	.string	" ***************|*****************\n"
test:	.string "%15.10f\t|%15.10f\n"
status:	.string "status: %d\n"

	buf_size = 8
	alloc = -(16 + buf_size) & -16
	dealloc = -alloc
	buf_s = -16

	.balign 4
	.global main
main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp

	mov	w19, w0				// number of args
	mov	x20, x1				// address of args
	cmp	w19, 2				// check number of args	
	b.ne	error				// branch to error if not 2 args

	ldr	x22, [x20, 8]			// get path

	mov	w0, AT_FDCWD			// 1st arg (use cwd)
	mov	x1, x22				// 2nd arg (pathname)
	mov	w2, 0				// 3rd arg (read-only)
	mov	w3, 0				// 4th arg (not used)
	mov	x8, 56				// openat I/O request
	svc	0				// call sys function

	mov	fd_r, w0			// save fd

	cmp	fd_r, 0				// error check
	b.ge	open_ok				// branch to open_ok

// If file didn't open properly then display error mssg and exit
	adrp	x0, err1			// get address of string to be printed
	add	x0, x0, :lo12:err1		// takes two steps to get address
	mov	x1, x22				// improper pathname
	bl	printf				// execute printf
	mov	w0, -1				// set return variable to -1
	b	exit				// branch to exit

open_ok:
	adrp	x0, head1			// print table header
	add	x0, x0, :lo12:head1
	bl	printf
	adrp	x0, head2
	add	x0, x0, :lo12:head2
	bl	printf

	add	buf_base_r, x29, buf_s		// get base of buf
top:	mov	w0, fd_r			// 1st arg (fd)
	mov	x1, buf_base_r			// 2bd arg (ptr to buf)
	mov	x2, buf_size			// 3rd arg (n)
	mov	x8, 63				// read I/I request
	svc	0				// call sys function
	mov	nread_r, x0			// save number bytes read

	cmp	nread_r, buf_size 		// check if read was successful
	b.ne	close				// branch to close if unsuccessful

	ldr	d8, [buf_base_r]	
	fmov	d0, d8
	bl	newton
	fmov	d9, d0


	adrp	x0, test
	add	x0, x0, :lo12:test
	fmov	d0, d8
	fmov	d1, d9
	bl	printf

	b	top

error:	adrp	x0, err2
	add	x0, x0, :lo12:err2
	bl	printf
	b	close

close:	

	mov	w0, fd_r
	mov	x8, 57
	svc	0
	mov	w25, w0

	mov	w0, 0
exit:	ldp	x29, x30, [sp], dealloc
	ret

// Subroutine
define(input_r, d16)
define(x_r, d17)
define(y_r, d18)
define(dy_r, d19)
define(dydx_r, d20)
	.data
tol_m:	.double	0r1.0e-10
	.text
	.balign 4
newton:	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	fmov	input_r, d0
	fmov	d1, 3.0
	fdiv	x_r, input_r, d1

do:	fmul	y_r, x_r, x_r			// y = x * x
	fmul	y_r, y_r, x_r			// y = x * x * x
	fsub	dy_r, y_r, input_r		// dy = y - input
	fmul	dydx_r, x_r, x_r		// y' = x * x
	fmul	dydx_r, dydx_r, d1		// y' = 3 * x^2
	fdiv	d21, dy_r, dydx_r		// d21 = dy / dydx
	fsub	x_r, x_r, d21			// x = x - d21
	fabs	dy_r, dy_r			// dy = abs(dy)
	
	adrp	x9, tol_m
	add	x9, x9, :lo12:tol_m
	ldr	d2, [x9]

	fcmp	dy_r, d2			// check if dy < tol
	b.ge	do				// if not branch to top of do loop

	fmov	d0, x_r				// load return variable

	ldp	x29, x30, [sp], 16		// restores state
	ret					// restores state
















