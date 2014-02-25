#include "MPvsHalide.h"

void printLine()
{
	int i;
	for ( i = 0; i < 80; i ++ )
		printf("-");
	printf("\n");
}

int main()
{
  /* I will use this timer sev'ral times. */
  struct timeval start_time, stop_time, elapsed_time;
  float ** halide_result;
	float ** c_result;
	short correctness = 0; //guilty until proven innocent
	float time;
  halide_result = parseFloats( "Halide_solution.txt" );
	int i;

	/*Run inline C solution in series. Store everything, two parter*/
	printf("Running inline C solution in series\n");
	
	gettimeofday(&start_time,NULL);
  c_result = storeAllCompute();
  gettimeofday(&stop_time, NULL);

	timersub(&stop_time, &start_time, &elapsed_time);
  time = elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0;
  correctness = checkCorrectness( halide_result, c_result );
  free(c_result);
  if( correctness )
    printf("C result was correct and completed in %f seconds.\n", time);
  else
    printf("C result was incorrect, so you actually shouldn't care how fast it ran, I can\
            give you the wrong answer instantly, but it was %f seconds.\n", time);
	
	printLine();

	printf("Running inline C solution in parallel\n");
	
	gettimeofday(&start_time,NULL);
	c_result = noStoreCompute();
	gettimeofday(&stop_time, NULL);
	timersub(&stop_time, &start_time, &elapsed_time);
	time = elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0;
	correctness = checkCorrectness( halide_result, c_result );

//	printConsumer( c_result );
	
	free(c_result);
	if( correctness )
		printf("C result was correct and completed in %f seconds.\n", time);
	else
		printf("C result was incorrect, so you actually shouldn't care how fast it ran, I can\
						give you the wrong answer instantly, but it was %f seconds.\n", time);

	printLine();
	return 1;
	printf("Running split, vectorized, parallel solution in C\n");

	gettimeofday(&start_time,NULL);
  c_result = storeBuffCompute();
  gettimeofday(&stop_time, NULL);

  timersub(&stop_time, &start_time, &elapsed_time);
  time = elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0;
  correctness = checkCorrectness( halide_result, c_result );
  if( correctness )
    printf("C result was correct and completed in %f seconds.\n", time);
  else
    printf("C result was incorrect, so you actually shouldn't care how fast it ran, I can\
            give you the wrong answer instantly, but it was %f seconds.\n", time);

	free(c_result);

	free(halide_result);
}

float producer(int x, int y)
{
  return sqrt(x*y);
}

float consumer_raw(int x, int y)
{
  return producer(x, y) + producer(x+1, y+1) +
        producer(x+1, y) + producer(x, y+1);
}

float consumer(int x, int y, float ** producer_arr)
{
  return producer_arr[x][y]+producer_arr[x+1][y+1] +
         producer_arr[x+1][y] + producer_arr[x][y+1];
}

void printProducerBuffer(float ** producer_buffer)
{
  int x, y;
  for( x = 0; x < PRODUCER_WIDTH; x ++ )
  {
    for( y = 0; y < STRIPE_SIZE + 1; y ++ )
    {
      printf("|%f|", producer_buffer[x][y]);
    }
    printf("\n");
  }
}

void printConsumer(float ** consumer_arr)
{
  int x, y;
  for (x = 0; x < CONSUMER_WIDTH; x++)
  {
    printf("|");
    for (y = 0; y < CONSUMER_HEIGHT; y++)
    {
      printf("%f|",consumer_arr[x][y]);
    }
  printf("\n");
  }
}

int checkCorrectness( float ** halide_result, float ** c_result )
{
   int x, y;
   float error = 0.0f;
   int correctness = 1; //innocent until proven guilty
   for (x = 0; x < CONSUMER_WIDTH; x++) {
            for (y = 0; y < CONSUMER_HEIGHT; y++) {
                error = halide_result[x][y] - c_result[x][y];
                // It's floating-point math, so we'll allow some slop:

               if (error < -0.001f || error > 0.001f) {
                    printf("c_result(%d, %d) = %f instead of %f\n",
                        x, y, c_result[x][y], halide_result[x][y]);
                    correctness = 0;
                }
            }
        }
  return correctness;
}

float consumer_from_buffer(int x, int y, float ** producer_buffer)
{
  int locY = y % STRIPE_SIZE;
  float returnMe = producer_buffer[x][locY] + producer_buffer[x+1][locY + 1]
        + producer_buffer[x+1][locY] + producer_buffer[x][locY + 1];
  return returnMe;
}
