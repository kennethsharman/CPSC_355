#include <stdio.h>
#include<string.h>
int main()
{
	char str1[8], str2[8];
	int index = 0;

	/*copying the content of the array into str1 */
	strcpy(str1, "Hello");


	printf("\n str1 = %s \n", str1);

	/*printing the content of the array str1*/
	printf("\n Printing the content of the array str1\n");
	for (index; index < sizeof(str1); index++)
	{
		printf("str[%d]=%x \n", index, str1[index]);
	}

	/*printing the strong stored in str1*/
	printf("\n printing the strong stored in str1 \n");
	index = 0;
	while (str1[index] != 0x00)
	{
		printf("str1[%d]=%c\n", index, str1[index]);
		index++;
	}

	return 0;
 }

