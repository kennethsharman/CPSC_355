/*
 * CPSC 355 Tutorial 1
 * Sept 19, 2018
 * Author: Ken Sharman
 *
 * Program gets users Name and Age and displays on screen.
 */

# include <stdio.h>

int

main()
{
	int age;
	char name[20];

	printf("Hi what is your name?\n");

	scanf("%s", name);

	printf("What is your age?\n");

	scanf("%d", &age);

	printf("Hi %s you are %d years old \n", name, age);
}
