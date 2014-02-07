#include <stdio.h>
#include <Halide.h>

using namespace Halide;

int main()
{
	int i, j;
	FILE * output;

	producer("producer_mixed"), consumer("consumer_mixed");
  	      producer(x, y) = sqrt(x * y);
   	     consumer(x, y) = (producer(x, y) +
   	                       producer(x, y+1) +
   	                       producer(x+1, y) +
   	                       producer(x+1, y+1));
	
        // Split the y coordinate of the consumer into strips of 16 scanlines:
        Var yo, yi;
        consumer.split(y, yo, yi, 16);
        // Compute the strips using a thread pool and a task queue.
        consumer.parallel(yo);
        // Vectorize across x by a factor of four.
        consumer.vectorize(x, 4);

        // Now store the producer per-strip. This will be 17 scanlines
        // of the producer (16+1), but hopefully it will fold down
        // into a circular buffer of two scanlines:
        producer.store_at(consumer, yo);
        // Within each strip, compute the producer per scanline of the
        // consumer, skipping work done on previous scanlines.
        producer.compute_at(consumer, yi);
        // Also vectorize the producer (because sqrt is vectorizable on x86 using SSE).
        producer.vectorize(x, 4);

        // Let's leave tracing off this time, because we're going to
        // evaluate over a larger image.
      // consumer.trace_stores();
        // producer.trace_stores();


  Image<float> halide_result = consumer.realize(800, 600);

	fopen("Halide_result.txt","wt");
	
	for( i = 0; i < 800; i ++ )
	{
		for( j = 0; j < 600; j ++)
		{
			fprintf(output,"%f ",halide_result(i,j));
		}
		fprintf(output, "\n");
	}
	return 42;
}
