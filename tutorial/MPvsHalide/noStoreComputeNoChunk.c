/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/
#include "MPvsHalide.h"

float ** noStoreComputeNoChunk()
{
	int x, y, i, j;
	int yo, y_base, y_in, yi, py;
	float ** consumer_arr;
	float storeMe;
	int numPasses = CONSUMER_HEIGHT/STRIPE_SIZE;
	//int correctness = 0;

	if( CONSUMER_HEIGHT % STRIPE_SIZE )
		numPasses ++; 

	/* Allocate conusmer_arr*/
	consumer_arr = calloc(CONSUMER_WIDTH, sizeof(float*));
	for( i = 0; i < CONSUMER_WIDTH; i ++ )
		consumer_arr[i] = calloc(CONSUMER_HEIGHT, sizeof(float));	
	/*This loop executes the producer and consumer function in parallel strips
		of 16*/
	#pragma omp parallel for private(x, y) shared(consumer_arr)
	for( x = 0; x < CONSUMER_WIDTH; x ++ ){
		for( y = 0; y < CONSUMER_HEIGHT; y ++ )
			consumer_arr[x][y] = consumer_raw(x,y);
	}
	return consumer_arr;
}
