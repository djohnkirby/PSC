/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/

#include "MPvsHalide.h"

float ** storeBuffCompute()
{
	int x, y, i, j;
	int yo, y_base, y_in, yi, py;
	int numPasses = CONSUMER_HEIGHT/STRIPE_SIZE;
	float producer_buffer[PRODUCER_WIDTH][STRIPE_SIZE + 1];
	float ** consumer_arr;
	int correctness = 0;

	if( CONSUMER_HEIGHT % STRIPE_SIZE )
		numPasses ++; 

	printf("Good morning\n");
	consumer_arr = malloc(CONSUMER_HEIGHT*sizeof(float*));
        for( i = 0; i < CONSUMER_HEIGHT; i ++ )
                consumer_arr[i] = calloc(CONSUMER_WIDTH, sizeof(float));

	
	/*This loop executes the producer and consumer function in parallel strips
		of 16*/
	#pragma omp parallel for private(yo, y_in, y_base, x, yi, py, producer_buffer)
	for( yo = 0; yo < numPasses; yo++ )
	{
		y_base = STRIPE_SIZE * yo;
		if (y_base > CONSUMER_HEIGHT - STRIPE_SIZE)
			y_base = CONSUMER_HEIGHT - STRIPE_SIZE;
		/*Precompute the entire section of the producer we need*/
		for( y_in = 0; y_in <= STRIPE_SIZE; y_in ++ )
		{
			/*This goes up to STRIPE_SIZE + 1 because the stripe size describes how
				big the consumer function's stripes are, which are one smaller than the
				producer function */
			y = y_base + y_in;
			for( x = 0; x < PRODUCER_WIDTH; x ++)
			{
				/*Store this locally in producer buffer*/
				producer_buffer[x][y_in] = producer(x,y); //Now say that five times fast
			}
		}
		//printProducerBuffer();
//		printf("Phew, made it out of the producer section\n");
		/*Now compute this section of the consumer*/
		for( x = 0; x < CONSUMER_WIDTH; x ++ )
		{
			for( y_in = 0; y_in < STRIPE_SIZE; y_in ++ )
			{
				y = y_base + y_in;
//				consumer_arr[x][y] = consumer(x, y);
				consumer_arr[x][y] = consumer_from_buffer(x, y, (float**)producer_buffer);
				//printf("(x, y) = (%d, %d)\n", x, y);
			}
		}
	}

	return consumer_arr;
}
