// CPSC 355:	Tutorial T06
// Assignment:	#4
// Date:	Nov 9, 2018
// Description:	Implements and manipulates a box structure and displays results

// define strings for print statements
str1:	.string "Box %s origin = (%d, %d) width = %d height = %d area = %d\n"	// box values
str2:	.string "Initial box values:\n" 	// header 1
str3:	.string "\nChanged box values:\n" 	// header 2
first:	.string "first" 			// first box name
second:	.string "second"			// second box name

	FALSE = 0	// assembler equates
	TRUE = 1

// Define equates used in newBox subroutine
	box_origin = 0	// box struct offsets
	box_size = 8
	box_area = 16

	point_x = 0	// box struct nested Offsets
	point_y = 4
	dim_width = 0
	dim_height = 4

	b_size = 20					// 20 bytes needed for box struct
	alloc_box = -(16 + b_size) & -16		// quadword align stack allocation
	dealloc_box = -alloc_box			// define dealloc
	b_s = 16					// box b stack offset

	.balign 4					// ensures instructions are properly aligned

// newBox subroutine creates new box struct and initializes its values
newBox:	stp	x29, x30, [sp, alloc_box]!		// saves state
	mov	x29, sp					// saves state

	add	x9, x29, b_s				// calculate b struct base address 
	mov	w10, 1					// w10 = 1, used to store value of 1	
	
	// assign values to the fields of box b
	str	wzr, [x9, box_origin + point_x]		// b.origin.x = 0
	str	wzr, [x9, box_origin + point_y]		// b.origin.y = 0
	str	w10, [x9, box_size + dim_width]		// b.size.width = 1
	str	w10, [x9, box_size + dim_height]	// b.size.height = 1

	ldr	w10, [x9, box_size + dim_width]		// w10 = b.size.width
	ldr	w11, [x9, box_size + dim_height]	// w11 = b.size.height
	mul	w10, w10, w11				// w10 = width * height
	str	w10, [x9, box_area]			// b.area = b.size.width * b.size.height

	// set return variables
	ldr	w0, [x9, box_origin + point_x]		// w0 = b.origin.x = 0
	ldr	w1, [x9, box_origin + point_y]		// w1 = b.origin.y = 0
	ldr	w2, [x9, box_size + dim_width]		// w2 = b.size.width = 1
	ldr	w3, [x9, box_size + dim_height]		// w3 = b.size.height = 1
	ldr	w4, [x9, box_area]			// w4 = b.area = 1

	ldp	x29, x30, [sp], dealloc_box		// restores state
	ret						// transfers control to address stored in LR

// move subroutine changes the origin location of box struct
move:	stp	x29, x30, [sp, -16]!			// saves state
	mov	x29, sp					// save state
	// load box origin data into temp registers
	ldr	w9, [x0, box_origin + point_x]		// w9 = b.origin.x
	ldr	w10, [x0, box_origin + point_y]		// w10 = b.origin.y
	// shift box origin values
	add	w9, w9, w1				// w9 += w1 (deltaX)
	add	w10, w10, w2				// w10 += w2 (deltaY)
	// update values on stack
	str	w9, [x0, box_origin + point_x]		// b.origin.x += deltaX
	str	w10, [x0, box_origin + point_y]		// b.origin.y += deltaY

	ldp	x29, x30, [sp], 16			// restores state
	ret						// transfers control to address in LR

// expand subroutine scales the dimensions of box struct
expand:	stp	x29, x30, [sp, -16]!			// saves state
	mov	x29, sp					// saves state
	// load box size data
	ldr	w9, [x0, box_size + dim_width]		// w9 = b.size.width
	ldr	w10, [x0, box_size + dim_height]	// w10 = b.size.height
	// scale box size
	mul	w9, w9, w1				// w9 = b.size.width * factor
	mul	w10, w10, w1				// w10 = b.size.height * factor
	// update values on stack
	str	w9, [x0, box_size + dim_width]		// b.size.width *= factor
	str	w10, [x0, box_size + dim_height]	// b.size.height *= factor
	// multiply width and height and update area
	mul	w9, w9, w10				// w9 = width * height
	str	w9, [x0, box_area]			// b.area = width * height

	ldp	x29, x30, [sp], 16			// restores state
	ret						// transfers control to address in LR

// printBox subroutine prints box values
printBox:
	stp	x29, x30, [sp, -16]!			// saves state
	mov	x29, sp					// saves state

	mov	x9, x1					// x9 = box pointer
	mov	x1, x0					// x0 = box string name

	adrp	x0, str1				// arg 1: address of string to be printed
	add	x0, x0, :lo12:str1			// takes two steps to get address
	ldr	w2, [x9, box_origin + point_x]		// arg 2: b.origin.x
	ldr	w3, [x9, box_origin + point_y]		// arg 3: b.origin.y
	ldr	w4, [x9, box_size + dim_width]		// arg 4: b.size.width
	ldr	w5, [x9, box_size + dim_height]		// arg 5: b.size.height
	ldr	w6, [x9, box_area]			
	bl	printf					// execute printf

	ldp	x29, x30, [sp], 16			// restores state
	ret						// transfers control to address in LR

// define equates used in equal subroutine
	return_size = 4					// int result requires 4 bytes memory
	alloc_equal = -(16 + return_size) & -16		// quadword align stack allocation
	dealloc_equal = -alloc_equal			// define dealloc
	return_s = 16

// equal subroutine verifies that the values of two box structs are equal and returns TRUE
// if they are not equal the subroutine returns FALSE
equal:	stp	x29, x30, [sp, alloc_equal]!		// saves state
	mov	x29, sp					// saves state

	mov	x9, x0					// x9 = b1 pointer
	mov	x10, x1					// x10 = b2 pointer
	mov	w11, FALSE				// x11 = FALSE
	str	w11, [x29, return_s]			// result = x11 = FALSE

	// first if construct
	ldr	w12, [x9, box_origin + point_x]		// w12 = b1.origin.x
	ldr	w13, [x10, box_origin + point_x]	// w13 = b2.origin.x
	cmp	w12, w13				// if b1.origin.x != b2.origin.x
	b.ne	break					// break from if construct

	// second if construct
	ldr	w12, [x9, box_origin + point_y]		// w12 = b1.origin.y
	ldr	w13, [x10, box_origin + point_y]	// w13 = b2.origin.y
	cmp	w12, w13				// if b1.origin.y != b2.origin.y
	b.ne	break					// break from if construct

	// third if construct
	ldr	w12, [x9, box_size + dim_width]		// w12 = b1.size.width
	ldr 	w13, [x10, box_size + dim_width]	// w13 = b2.size.width
	cmp	w12, w13				// if b1.size.wdith != b2.size.width
	b.ne	break					// break from if construct

	// fourth if construct
	ldr	w12, [x9, box_size + dim_height]	// w12 = b1.size.height
	ldr	w13, [x10, box_size + dim_height]	// w13 = b2.size.height
	cmp	w12, w13				// if b1.size.height != b2.size.height
	b.eq	break					// break from if construct

	mov	w11, TRUE				// x11 = TRUE
	str	w11, [x29, return_s]			// result = x11 = TRUE

break:	ldr	x0, [x29, return_s]			// Load/ return result value
	ldp	x29, x30, [sp], dealloc_equal		// retores state
	ret						// returns control to address in LP

// define equates used in main
	alloc_main = -(16 + (2*b_size)+ 16) & -16	// allocate memory: 2 box structs, 2 registers
	dealloc_main = -alloc_main			// define dealloc
	first_s = 16					// first box offset
	second_s = first_s + b_size			// second box offset

	.global main
main:	stp	x29, x30, [sp, alloc_main]!		// saves state
	mov	x29, sp					// saves state

	add	x19, x29, first_s			// x19 = first_base_r
	add	x20, x29, second_s			// x20 = second_base_r

	bl	newBox					// execute newBox subroutine
	str	w0, [x19, box_origin + point_x]		// Store b1.origin.x on stack
	str	w1, [x19, box_origin + point_y]		// Store b1.origin.y
	str	w2, [x19, box_size + dim_width]		// Store b1.size.width
	str	w3, [x19, box_size + dim_height]	// Store b1.size.height
	str	w4, [x19, box_area]			// Store b1.area

	bl	newBox					// execute newBox subroutine
	str	w0, [x20, box_origin + point_x]		// Store b2.origin.x on stack
	str	w1, [x20, box_origin + point_y]		// Store b2.origin.y
	str	w2, [x20, box_size + dim_width]		// Store b2.size.width
	str	w3, [x20, box_size + dim_height]	// Store b2.size.height
	str	w4, [x20, box_area]			// Stor b2.area on stack

	// print header 1 string
	adrp	x0, str2				// arg 1: address of str2
	add	x0, x0, :lo12:str2			// takes two steps to get address
	bl printf					// execute printf
	// print values of first box
	ldr	x0, =first				// arg 1: first string
	add	x1, x29, first_s			// arg 2: first pointer
	bl	printBox				// execute printBox
	// print values of second box
	ldr	x0, =second				// arg 1: second string
	add	x1, x29, second_s			// arg 2: second pointer
	bl	printBox				// execute printBox
	// compare values in first and second
	add	x0, x29, first_s			// arg 1: first pointer
	add	x1, x29, second_s			// arg 2: second pointer
	bl	equal					// execute equal subroutine
	cbz	x0, nequal
	// if equal: execute move on first
	add	x0, x29, first_s			// arg 1: first pointer
	mov	w1, -5					// arg 2: deltaX = -5
	mov	w2, 7					// arg 3: deltaY = 7
	bl	move					// execute move subroutine on first
	// execute expand on second
	add	x0, x29, second_s			// x0 = second pointer
	mov	w1, 3					// w1 = factor = 3
	bl	expand					// execute expand subroutine on second

nequal:	// print header 2 string
	adrp	x0, str3				// arg 1: Changed Value string
	add	x0, x0, :lo12:str3			// takes two steps to get address
	bl	printf					// execute printf
	// print values of first box
	ldr	x0, =first				// arg 1: first string
	add	x1, x29, first_s			// arg 2: first pointer
	bl	printBox				// execute printBox
	// print values of second box
	ldr	x0, =second				// arg 1: second string
	add	x1, x29, second_s			// arg 2: second pointer
	bl	printBox				// execute printBox

	ldp	x29, x30, [sp], dealloc_main		// restores state
	ret						// restores state
