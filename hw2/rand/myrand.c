#include <stdio.h>
#include "myrand.h"

long int* myrand(int seed, int n, long int* random){
	
	int i, rand;
	
	/* inspired by mid square method */
	for(i = 0; i < n; ++i){
		seed *= seed; //8-digit number
		seed /= 100; //deletes last 2 digits
		seed = seed % 10000; //deletes first 2 digits
		seed += 7654; //to make it more random, 4-digit random number is added
		rand = 1 + seed % 15; //to generate numbers between [1, 15]
		random[i] = rand; 
	}
	
	return random;
}
