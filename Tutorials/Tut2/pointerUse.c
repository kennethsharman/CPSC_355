#include <stdio.h>

int main()
{
	int x;
	int y;
	int *pointer;

	x = 1;
	
	pointer = &y;

	*pointer = 9;

	printf("\n x = %d, y = %d, @0fY = %x *pointer = %d \n", x, y, pointer, *pointer);

	pointer = &x;

	printf("\n x = %d, y = %d, @0fY = %x *pointer = %d \n", x, y, pointer, *pointer);


	return 0;

}
