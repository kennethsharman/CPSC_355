#include <stdio.h>

int main()
{
	int x;
	int y;
	int *pointer;
	
	x = 1;

	pointer = &y; // *var. pointer getting the address of y*

	printf("\n pointer = &y \n");	
	printf("x = %d, y = %d, &OfY = %x *pointer = %d \n", x, y, pointer, *pointer);

	*pointer = 9; // Put 9 in the memory location that *pointer points to

	printf("x = %d, y = %d, &OfY = %x *pointer = %d \n", x, y, pointer, *pointer);
	
	pointer = &x;

	printf("\n pointer = &x \n");
	printf("x = %d, y = %d, &OfY = %x *pointer = %d \n", x, y, pointer, *pointer);	
	
	return 0;
}	
