all:
	gcc -c a5aMain.c
	m4 a5a.asm > a5a.s
	as a5a.s -o a5a.o
	gcc a5aMain.o a5a.o -o exec
	./exec
