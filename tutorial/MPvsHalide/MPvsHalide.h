#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>
#include "parseFloats.h"
#include "getline.h"

#define STRIPE_SIZE 2

#define CONSUMER_WIDTH 2
#define CONSUMER_HEIGHT 4


#define PRODUCER_WIDTH CONSUMER_WIDTH + 1
#define PRODUCER_HEIGHT CONSUMER_HEIGHT + 1

float producer(int x, int y);
float consumer_raw(int x, int y);
float consumer(int x, int y, float ** producer_arr);
float consumer_from_buffer(int x, int y, float ** producer_buffer);
void printProducerBuffer( float ** producer_buffer);
void printConsumer( float ** consumer_arr);
float consumer_from_buffer( int x, int y, float ** producer_buffer );
float ** noStoreCompute();
float ** storeAllCompute();
int checkCorrectness( float ** halide_result, float ** c_result);
