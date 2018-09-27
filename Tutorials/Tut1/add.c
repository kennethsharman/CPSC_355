/*
 * CPSC 355 Tutorial 1
 * Sept 17, 2018
 * Author: Ken Sharman
 *
 * Program gets two integers from user and displays their sum
 */

# include <stdio.h>

int main()
{
	int num1, num2, result;
	char name[20];

	printf("Enter number 1:\n");

	scanf("%d", &num1);

	printf("Enter number 2:\n");

	scanf("%d", &num2);

	result = num1 + num2;

	printf("%d + %d = %d \n", num1, num2, result);

}

