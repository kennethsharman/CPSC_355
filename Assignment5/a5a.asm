// CPSC 355:	Tutorial T06
// Assignment:	#5a
// Date:	Nov 25, 2018
// Description:	Implements the functions required for a queue
// Author:	Kenneth Sharman 00300185

// Macros
define(QUEUESIZE, 8)	// maximum number of items in queue
define(MODMASK, 0x7)	// wrap-around indexing
define(TRUE, 1)
define(FALSE, 0)

// External variables
		.data
queue_m:	.skip	QUEUESIZE * 4		// int queue[QUEUESIZE]
head_m:		.word	-1			// int head = -1
tail_m:		.word	-1			// int tail = -1

// Print statements
		.text									// subroutine where used:
queueOverFlow:	.string "\nQueue overflow. Cannot enqueue into a full queue.\n";	// enqueue
queueUnderFlow:	.string "\nQueue underflow. Cannot dequeue from an emtpy queue.\n";	// dequeue
queueEmpt:	.string "\nEmpty queue\n"						// display
queueContents:	.string "\nCurrent queue contents:\n"					// display
queueElement:	.string "  %d"								// display
queueHead:	.string " <-- head of queue"						// display
queueTail:	.string " <-- tail of queue"						// display
carriageReturn:	.string	"\n"								// display

		.balign 4
// enqueue subroutine (label branches with 1)
define(head_r, w9)	// w9 = head
define(tail_r, w10)	// w10 = tail

		.global enqueue					// make available to other compilation units
enqueue:	stp	x29, x30, [sp, -16]!			// saves state
		mov	x29, sp					// saves state

		mov	w15, w0					// store arg (enqueue value) in w15

		bl	queueFull				// execute queueFull subroutine
		cmp	w0, WZR					// check if  queueFull() returned TRUE or FALSE
		b.eq	next1					// if FALSE branch to next1

		adrp	x0, queueOverFlow			// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueOverFlow		// takes two steps to get address
		bl	printf					// execute printf
		b	done1					// since queue is full, skip to end

next1:		bl	queueEmpty				// execute queueEmpty subroutine
		cmp	w0, WZR					// check if queueEmpty() returned TRUE or FALSE
		b.eq	else1					// if FALSE branch to else
		
		adrp	x12, head_m				// get address of head
		add	x12, x12, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x12]				// w9 = head

		adrp	x13, tail_m				// get address of tail
		add	x13, x13, :lo12:tail_m			// get low 2 address of tail
		ldr	tail_r, [x13]				// w10 = tail

		mov	head_r, WZR				// set head to 0
		str	head_r, [x12]				// update global variable
		mov	tail_r, WZR				// set tail to 0
		str	tail_r, [x13]				// update global variable

		b	skip_else1				// skip over else block

else1:		adrp	x13, tail_m				// get address of tail
		add	x13, x13, :lo12:tail_m			// get low 12 address of tail
		ldr	tail_r, [x13]				// w10 = tail

		add	tail_r, tail_r, 1			// tail += 1
		and	tail_r, tail_r, MODMASK			// tail  = tail & MODMASK
		str	tail_r, [x13]				// update global variable

skip_else1:	adrp	x13, tail_m				// get address of tail
		add	x13, x13, :lo12:tail_m			// get low 12 address of tail
		ldr	tail_r, [x13]				// w10 = tail

		adrp	x14, queue_m				// get address of queue
		add	x14, x14, :lo12:queue_m			// get low 12 address of queue
		str	w15, [x14, tail_r, SXTW 2]		// queue[tail] = x0 = value

done1:		ldp	x29, x30, [sp], 16			// restores state
		ret						// restores state

// dequeue subroutine (label branches with 2)
define(value_r, w11)	// w11 = value

		.global	dequeue					// make available to other compilation units
dequeue:	stp	x29, x30, [sp, -16]!			// saves state
		mov	x29, sp					// saves state

		bl	queueEmpty				// execute queueEmpty subroutine
		cmp	w0, WZR					// check is queueEmpty() returned TRUE or FALSE
		b.eq	next2					// if queue is not empty branch to next2

		adrp	x0, queueUnderFlow			// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueUnderFlow		// takes two steps to get address
		bl	printf					// execute printf

		mov	w0, -1					// return (-1)
		b	done2					// since queue is empty, skip to end

next2:		adrp	x12, head_m				// get address of head
		add	x12, x12, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x12]				// w9 = head

		adrp 	x13, tail_m				// get address of tail
		add	x13, x13, :lo12:tail_m			// get low 12 address of tail
		ldr	tail_r, [x13]				// w10 = tail

		adrp	x14, queue_m				// get address of queue
		add	x14, x14, :lo12:queue_m			// get low 12 address of queue
		ldr	value_r, [x14, head_r, SXTW 2]		// w11 = queue[head]

		cmp	head_r, tail_r				// compare head and tail
		b.ne	else2					// if they are not equal branch to else2

		mov	head_r, -1				// head = -1
		mov	tail_r, -1				// tail = -1
		str	head_r, [x12]				// update global variable
		str	tail_r, [x13]				// update global variable

		b	skip_else2				// branch to skip_else2

else2:		adrp	x13, head_m				// get address of head
		add	x13, x13, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x13]				// w9 = head

		add	head_r, head_r, 1			// head += 1
		and	head_r, head_r, MODMASK			// head = (++head & MODMASK)
		str	head_r, [x12]				// update global variable

skip_else2:	mov	w0, value_r				// return w0 = value

done2:		ldp	x29, x30, [sp], 16			// restores state
		ret						// restores state

//queueFull subroutine (label branches with 3)
		.global queueFull				// make available to other compilation units
queueFull:	stp	x29, x30, [sp, -16]!			// saves state
		mov	x29, sp					// saves state

		adrp	x11, head_m				// get address of head
		add	x11, x11, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x11]				// w9 = head

		adrp	x12, tail_m				// get address of tail
		add	x12, x12, :lo12:tail_m			// get low 12 address of tail
		ldr	tail_r, [x12]				// w10 = tail
		
		add	w13, tail_r, 1				// w13 = tail + 1
		and	w13, w13, MODMASK			// w12 = (tail + 1) & MODMASK
	
		cmp	w13, head_r				// compare (tail+1) & MODMask to head
		b.ne	else3					// if they aren't equal branch to else3

		mov	w0, TRUE				// if queue is full return TRUE
		b	done3					// branch to done3

else3:		mov	w0, FALSE				// if queue is not full return FALSE

done3:		ldp	x29, x30, [sp], 16			// restores state
		ret						// restores state

// queueEmpty subroutine (label branches with 4)
		.global queueEmpty				// make available to other compilation units
queueEmpty:	stp	x29, x30, [sp, -16]!			// saves state
		mov	x29, sp					// save state

		adrp	x11, head_m				// get address of head
		add	x11, x11, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x11]				// x9 = head

		cmp	head_r, -1				// compare head to -1					
		b.ne	else4					// if they are not equal branch to else4
		mov	w0, TRUE				// set w0 = TRUE for return
		b	done4					// skip else3

else4:		mov	w0, FALSE				// set w0 = FALSE

done4:		ldp	x29, x30, [sp], 16			// restores state
		ret						// restores state

// display subroutine (label branches with 5)
define(head_r, w19)	// w19 = head
define(tail_r, w20)	// w20 = tail
define(i_r, w21)	// w21 = i
define(j_r, w22)	// w22 = j
define(count_r, w23)	// w23 = count

		alloc = -(16 + 5*4) & -16			// allocate enough memory to save state of registers
		dealloc	 = -alloc				// dealloc equate
		w19_save = 16					// stack offset of w19 save
		w20_save = 20					// stack offset of w20 save
		w21_save = 24					// stack offset of w21 save
		w22_save = 28					// stack offest of w22 save
		w23_save = 32					// stack offset of w23 save

		.global display					// make available to other compilation units
display:	stp	x29, x30, [sp, -alloc]!			// saves state
		mov	x29, sp					// saves state
		str	w19, [x29, w19_save]			// save w19
		str	w20, [x29, w20_save] 			// save w20
		str	w21, [x29, w21_save]			// save w21
		str	w22, [x29, w22_save]			// save w22
		str	w23, [x29, w23_save]			// save w23

		bl	queueEmpty				// execute queueEmpty()
		cmp	w0, WZR					// if queueEmpty retured FALSE:
		b.eq	next5_1					// branch to next5_1

		adrp	x0, queueEmpt				// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueEmpt			// takes two steps to get address
		bl	printf					// execute printf

		b	done5					// branch to done5

next5_1:	adrp	x14, head_m				// get address of head
		add	x14, x14, :lo12:head_m			// get low 12 address of head
		ldr	head_r, [x14]				// w19 = head

		adrp	x15, tail_m				// get address of tail
		add	x15, x15, :lo12:tail_m			// get low 12 address of tail
		ldr	tail_r, [x15]				// w20 = tail

		mov	count_r, tail_r				// count = tail
		sub	count_r, count_r, head_r		// count = tail - head
		add	count_r, count_r, 1			// count = tail - head + 1	

		cmp	count_r, WZR				// compare count and zero
		b.gt	next5_2					// if c>0 branch to next5_2

		add	count_r, count_r, QUEUESIZE		// count += QUEUESIZE

next5_2:	adrp	x0, queueContents			// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueContents		// takes two steps to get address
		bl	printf					// execute printf

		mov	i_r, head_r				// i = head
		mov	j_r, 0					// j = 0	

		b	test
top:		adrp	x14, queue_m				// get address of queue
		add	x14, x14, :lo12:queue_m			// get low 12 address of queue
		ldr	w15, [x14, i_r, SXTW 2]			// w15 = queue[i]

		adrp	x0, queueElement			// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueElement		// takes two steps to get address
		mov	w1, w15					// arg 2: w1 = queue[i]
		bl	printf					// execute printf

		cmp	i_r, head_r				// compare i and head
		b.ne	next5_3					// if they are not equal branch to next5_3

		adrp	x0, queueHead				// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueHead			// takes two steps to get address
		bl	printf					// execute printf

next5_3:	cmp	i_r, tail_r				// compare i and tail
		b.ne	next5_4					// if they are not equal branch to next5_4

		adrp	x0, queueTail				// arg 1: address of string to be printed
		add	x0, x0, :lo12:queueTail			// takes two steps to get address
		bl	printf					// execute printf

next5_4:	adrp	x0, carriageReturn			// arg1: address of string to be printed
		add	x0, x0, :lo12:carriageReturn		// takes two steps to get address
		bl	printf					// execute printf

		add	i_r, i_r, 1				// i += 1
		and	i_r, i_r, MODMASK			// i = ++i & MODMASK

		add	j_r, j_r, 1				// j += 1
test:		cmp	j_r, count_r				// compare j to count
		b.lt	top					// if j < count branch to top

done5:		ldr	w19, [x29, w19_save]			// restore w19
		ldr	w20, [x29, w20_save]			// restore w20
		ldr	w21, [x29, w21_save]			// restore w21
		ldr	w22, [x29, w22_save]			// restore w22
		ldr	w23, [x29, w23_save]			// restore w23
		ldp	x29, x30, [sp], dealloc			// restores state
		ret						// restores state
