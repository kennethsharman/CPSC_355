/*
 * CPSC 355 Tutorial 1
 * Sept 17, 2018
 * Author: Ken Sharman
 *
 * Gets degrees celsius from user and prints degree fahrenheit
 */

# include <stdio.h>

int

main()
{
	int degreeC, degreeF;

	printf("Please enter the degrees (in celcius):\n");

	scanf("%d", &degreeC);

	degreeF = (9.0/5.0) * degreeC + 32.0;

	printf("%d degrees in celsius is %d degrees in Fahrenheit \n", degreeC, degreeF);
}	
