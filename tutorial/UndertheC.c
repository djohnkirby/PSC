#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
	printf("Hi this is a program to test the performance characteristics of a couple specific things from lesson 8 of Halide's tutorial.\n");
  float result[4][4];
	float result2[4][4];
   // Allocate some temporary storage for the producer.
   float producer_storage[5][5];
	int y, x;

   // Compute the producer.
   for (y = 0; y < 5; y++) {
   	for (x = 0; x < 5; x++) {
   		producer_storage[y][x] = sqrt(x * y);
			printf("|%f|",producer_storage[y][x]);
   	 }
			printf("\n");
    }

   // Compute the consumer. Skip the prints this time.
   for (y = 0; y < 4; y++) {
   	for (x = 0; x < 4; x++) {
   		result[y][x] = (producer_storage[y][x] +
                      producer_storage[y+1][x] +
                      producer_storage[y][x+1] +
                      producer_storage[y+1][x+1]);
			printf("|%f|",result[y][x]);
     }
		printf("\n");
    }
	//So which is faster? Store in (x,y) or (y,x)
   for (y = 0; y < 4; y++) {
    for (x = 0; x < 4; x++) {
      result2[x][y] = (producer_storage[y][x] +
                      producer_storage[y+1][x] +
                      producer_storage[y][x+1] +
                      producer_storage[y+1][x+1]);
     }
    }

	return 42;// the ultimate answer
}
