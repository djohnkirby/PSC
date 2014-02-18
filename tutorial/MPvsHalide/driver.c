#include "MPVsHalide.h"

float producer(int x, int y)
{
  return sqrt(x*y);
}

float consumer_raw(int x, int y)
{
  return producer(x, y) + producer(x+1, y+1) +
        producer(x+1, y) + producer(x, y+1);
}

float consumer(int x, int y)
{
  return producer_arr[x][y]+producer_arr[x+1][y+1] +
         producer_arr[x+1][y] + producer_arr[x][y+1];
}

void printProducerBuffer()
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

void printConsumer()
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

int main()
{
	/* I will use this timer sev'ral times. */
	struct timeval start_time, stop_time, elapsed_time;
	
}
