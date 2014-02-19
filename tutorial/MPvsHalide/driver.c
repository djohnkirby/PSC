#include "MPvsHalide.h"

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
    for (y = 0; y < CONSUMER_HEIGHT; y++)
    {
      printf("|%f|",consumer_arr[x][y]);
    }
  printf("\n");
  }
}

int checkCorrectness( float ** halide_result, float ** c_result )
{
   int x, y;
   float error = 0.0f;
   for (x = 0; x < CONSUMER_WIDTH; x++) {
            for (y = 0; y < CONSUMER_HEIGHT; y++) {
                error = halide_result[x][y] - c_result[x][y];
                // It's floating-point math, so we'll allow some slop:

               if (error < -0.001f || error > 0.001f) {
                    printf("halide_result(%d, %d) = %f instead of %f\n",
                        x, y, halide_result[x][y], c_result[x][y]);
                    return 0;
                }
            }
        }
  return 1;
}

float consumer_from_buffer(int x, int y, float ** producer_buffer)
{
  int locY = y % STRIPE_SIZE;
  float returnMe = producer_buffer[x][locY] + producer_buffer[x+1][locY + 1]
        + producer_buffer[x+1][locY] + producer_buffer[x][locY + 1];
  return returnMe;
}

int main()
{
	/* I will use this timer sev'ral times. */
	struct timeval start_time, stop_time, elapsed_time;
	float ** halide_result;
	halide_result = parseFloats( "Halide_solution.txt" );		
}
