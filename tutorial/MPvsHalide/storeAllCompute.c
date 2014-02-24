/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/

#include "MPvsHalide.h"

float ** storeAllCompute()
{
	int x, y, i, j;
	float producer_arr[PRODUCER_WIDTH][PRODUCER_HEIGHT];
	float ** consumer_arr;
	int correctness = 0;

	consumer_arr = malloc(CONSUMER_WIDTH*sizeof(float*));
        for( i = 0; i < CONSUMER_WIDTH; i ++ )
                consumer_arr[i] = malloc(CONSUMER_HEIGHT*sizeof(float));
	printf("CONSUMER_HEIGHT is %d, PRODUCER_HEIGHT IS %d, PRODUCER_WIDTH\
				  is %d\n", i, PRODUCER_HEIGHT, PRODUCER_WIDTH);
	for( x = 0; x < PRODUCER_WIDTH; x ++ )
		for( y = 0; y < PRODUCER_HEIGHT; y ++ )
			producer_arr[x][y] = producer(x, y);


	for( x = 0; x < CONSUMER_WIDTH; x ++ )
		for( y = 0; y < CONSUMER_HEIGHT; y ++ )
			consumer_arr[x][y] = producer_arr[x][y] + producer_arr[x+1][y + 1] + producer_arr[x+1][y] + producer_arr[x][y + 1];


	return consumer_arr;
}
