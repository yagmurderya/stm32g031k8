#include <stdio.h>
#include "myrand.h"
#include "test_random.h"


int main(){
	
	int x; //for problem 1: loop number to generate final random number - problem 2: number of the tested random numbers
	long int* random = (long int*) malloc (x * sizeof(long int)); //random array to get all random numbers from myrand()
	
	printf("enter how many numbers you generate: "); 
	scanf("%d", &x);
	int seed = 7394; //random seed value which is given by me
	
	random = myrand(seed, x, random);
	printf("random number: %d\n", random[x-1]); // for problem 1, it prints the last element of random array in the myrand()
	test_random(seed, x, random);
	
	free(random);
	
	return 0;
}
