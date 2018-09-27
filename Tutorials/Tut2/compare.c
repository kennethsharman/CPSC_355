#include <stdio.h>
#include <string.h>
int main()
{
	char str1[8], str2[8];

	// Copying Hello into str1
	strcpy(str1, "Hello");

	// Printing str1 on the screen
	printf("str1= %s \n", str1);


	// Copying str1 into str2
	strcpy(str2, str1);
	printf("str2 = %s \n", str2);

	// Compare str1 and str2
	if(str1 == str2) // Wrong way
		printf("str1 is the same as str2\n");
	else
		printf("str1 is differrent than str2\n");

	if(strcmp(str1,str2)==0)

		printf("str1 is the same as str2\n");
	else
		printf("str1 is different than str2\n");
}
