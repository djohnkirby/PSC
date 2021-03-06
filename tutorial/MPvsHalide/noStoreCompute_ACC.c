/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/
#include "MPvsHalide.h"

float ** noStoreCompute()
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
	#pragma omp parallel for private(yo, y_in, y_base, x, yi, py, storeMe)
	for( yo = 0; yo < numPasses; yo++ )
	{
		y_base = STRIPE_SIZE * yo;
		if (y_base > CONSUMER_HEIGHT - STRIPE_SIZE)
			y_base = CONSUMER_HEIGHT - STRIPE_SIZE;
		/*Now compute this section of the consumer*/
		for( x = 0; x < CONSUMER_WIDTH; x ++ )
		{
			for( y_in = 0; y_in < STRIPE_SIZE; y_in ++ )
			{
				y = y_base + y_in;
				storeMe = consumer_raw(x,y);
				if (storeMe - (x*y + (x+1)*(y+1) + x*(y+1) + y*(x+1)) > 0.001f)
					printf("HELP HELP I NEED AN ADULT! got producer(%d, %d) = %f\n", x, y, storeMe);
				consumer_arr[x][y] = storeMe;
			}
		}
	}
	/* Just ofr the luls, let's redo the first row*/
	return consumer_arr;
}
