/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <math.h>
#include <sys/time.h>
#include "parseFloats.h"
#define CONSUMER_WIDTH 800
#define CONSUMER_HEIGHT 600

#define PRODUCER_WIDTH CONSUMER_WIDTH + 1
#define PRODUCER_HEIGHT CONSUMER_HEIGHT + 1

float producer_arr[PRODUCER_HEIGHT][PRODUCER_WIDTH];
float consumer_arr[CONSUMER_HEIGHT][CONSUMER_WIDTH];
float halide_result[CONSUMER_HEIGHT][CONSUMER_WIDTH];
float producer_buffer[2][PRODUCER_WIDTH];

float producer(int x, int y)
{
	return sqrt(x*y);
}

float consumer_raw(int x, int y)
{
	return producer(x, y) + producer(x+1, y+1) +
			  producer(x+1, y) + producer(x, y+1);
}

/*Yo man, yo, look, you better not call this mother unless you have populated
	the appropriate array. Don't say I didn't warn you*/
float consumer(int x, int y)
{
	return producer_arr[x][y]+producer_arr[x+1][y+1] +
				 producer_arr[x+1][y] + producer_arr[x][y+1];
}

/* This function will parse out a floating point number and return
	 a that char* This advances the pointer for you. */
/*char * parseFloat(char * input)
{
	int i = 0;
	char this;
	char *ReturnMe = malloc(12*sizeof(char));
	while(input[i] != ' ' && i < 9)
	{
		this = *input;
		ReturnMe[i] = this;
		i++;
	}
	return ReturnMe;
}
*/
int main()
{
  struct timeval start_time, stop_time, elapsed_time; /*setup timer*/
	int x, y, i, j;
	int yo, y_base, y_in, yi, py;
	float ** halide_result;
	//int correctness = 0;
  
	gettimeofday(&start_time, NULL);
	printf("Good morning\n");
	/*This loop executes the producer and consumer function in parallel strips
		of 16*/
 	#pragma omp parallel for private(yo, y_in, y_base, x, yi, py)\
													 shared(producer_arr, consumer_arr)
	for( yo = 0; yo < 600/16 +1; yo++ )
	{
		//printf("Hi I'm Mr. Meecees LOOK AT ME!\n");
		y_base = 16 * yo;
		if (y_base > 600- 16)
			y_base = 600 - 16;
		/*Precompute the entire section of the producer we need*/
		for( y_in = 0; y_in < 17; y_in ++ )
		{
			for( x = 0; x < PRODUCER_WIDTH; x ++)
			{
				y = y_base + y_in;
				producer_arr[y][x] = producer(x,y); //Now say that five times fast.
				//printf("(x, y) = (%d, %d)\n", x, y); 
			}
		}
//		printf("Phew, made it out of the producer section\n");
		/*Now compute this section of the consumer*/
		for( x = 0; x < CONSUMER_WIDTH; x ++ )
		{
			for( y_in = 0; y_in < 16; y_in ++ )
			{
				y = y_base + y_in;
				consumer_arr[y][x] = consumer(x, y);
				//printf("(x, y) = (%d, %d)\n", x, y);
			}
		}
//		printf("Phew made it out of the consumer loop\n");
//		printf("Made it to the %dth episode\n", yo);
	}
	printf("Phew, made it out of the parallel loop\n");

	gettimeofday(&stop_time,NULL);
  timersub(&stop_time, &start_time, &elapsed_time);//subtract time
	/* Check Correctness */
	/*Load Halide result*/
	halide_result = parseFloats( "Halide_result.txt" );
   for (y = 0; y < 600; y++) {
            for (x = 0; x < 800; x++) {
                float error = halide_result[x][y] - consumer_arr[x][y];
                // It's floating-point math, so we'll allow some slop:
                if (error < -0.001f || error > 0.001f) {
                    printf("halide_result(%d, %d) = %f instead of %f\n",
                           x, y, halide_result[x][y], consumer_arr[y][x]);
                    return -1;
                }
            }
        }



  printf("This code executed in %f seconds\n",elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);


}
