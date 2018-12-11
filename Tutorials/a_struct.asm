// Implements a nested struct and displays contents
// Date December 11, 2018

id:	.string	"\n\nID Number: %d\n"
name:	.string "Alpha Name: %d, %d, %d\n\n"

define(ken_base_r, x19)	// base register for person struct base address

	fn = 0	// nested offset for number corresponding to first initial
	mn = 1	// nested offset for middle initial
	ln = 2	// nest offset for last initial

	person_id = 0				// offset for id # field
	person_name = 4				// offset for name field

	ken_size = 7				// 7 bytes needed for person struct
	alloc = -(16 + ken_size) & -16
	dealloc = -alloc
	ken_s = 16				// stack frame offset

	.balign 4
	.global main
main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp

	add	ken_base_r, x29, ken_s			// calculate base address

	mov	w20, 12345				// ken.id = 12345
	str	w20, [ken_base_r, person_id]

	mov	w20, 11
	strb	w20, [ken_base_r, person_name + fn]	// ken.name.fn = 11

	mov	w20, 2
	strb	w20, [ken_base_r, person_name + mn]	// ken.name.mn = 2

	mov	w20, 19
	strb	w20, [ken_base_r, person_name + ln]	// ken.name.lm = 19

	bl	print					// branch to print subroutine

	mov	x0, 0
ldp	x20, x30, [sp], dealloc
	ret


print:	stp	x29, x30, [sp, -16]!
	mov	x29, sp	

	adrp	x0, id					// print id #
	add	x0, x0, :lo12:id
	ldr	w1, [ken_base_r, person_id]
	bl	printf

	adrp 	x0, name				// print fn, mn, lm
	add	x0, x0, :lo12:name
	ldrb	w1, [ken_base_r, person_name + fn]
	ldrb	w2, [ken_base_r, person_name + mn]
	ldrb	w3, [ken_base_r, person_name + ln]
	bl	printf

	mov	x0, 0
	ldp	x9, x30, [sp], 16			// restores state
	ret
