/**
 * Simple program that prints Hellow World
 * Date: Sept 24, 2018
 * Author: Ken Sharman
 */

.global main
main:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	ldr	x0, =greeting
	bl	printf

	ldp	x29, x30, [sp], 16
	ret

greeting:	.ascii "Hello World!\n"
