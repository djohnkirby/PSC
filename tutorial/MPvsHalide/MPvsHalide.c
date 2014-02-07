#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include <sys/time.h>
#include <Halide.h>

using namespace Halide;

int main()
{
  struct timeval start_time, stop_time, elapsed_time; //setup timer
	printf("\nOkay, running the solution from Halide tutorial.\n");
	float c_result[600][800];
	gettimeofday(&start_time,NULL);
//	int y, yo, yi, py, x_base, y_base, x_vec, i, j;
	int x[4];
	float vec[4];
	float producer_storage[2][801];
	float thresh = 0.000001;

 Func producer("producer_mixed"), consumer("consumer_mixed");
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
	gettimeofday(&stop_time, NULL);
  printf("Halide parallel version executed in %f seconds\n",elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);
	gettimeofday(&start_time, NULL);
	// For every strip of 16 scanlines
//	#pragma omp parallel for \
	private(y, i, y_base, x_vec, producer_storage, yi, x, x_base)\
	shared(c_result)
	for (yo = 0; yo < 600/16 + 1; yo++) { // (this loop is parallel in the Halide version)

	// 16 doesn't divide 600, so push the last slice upwards to fit within [0, 599] (see lesson 05).
		y_base = yo * 16;
		if (y_base > 600-16) y_base = 600-16;

		// Allocate a two-scanline circular buffer for the producer
	
		// For every scanline in the strip of 16:
		for (yi = 0; yi < 16; yi++) {
			y = y_base + yi;

			for (py = y; py < y+2; py++) {
			// Skip scanlines already computed *within this task*
				if (yi > 0 && py == y) continue;

			// Compute this scanline of the producer in 4-wide vectors
			for(x_vec = 0; x_vec < 800/4 + 1; x_vec++) {
				x_base = x_vec*4;
				// 4 doesn't divide 801, so push the last vector left (see lesson 05).
				if (x_base > 801 - 4) x_base = 801 - 4;
				// If you're on x86, Halide generates SSE code for this part:
			//	x = {x_base, x_base + 1, x_base + 2, x_base + 3};
				for( i = 0; i < 4; i ++ )
					x[i] = x_base + i;
				for( i = 0; i < 4; i ++ )
					vec[i] = sqrtf(x[i] * py);
			//	vec[4] = {sqrtf(x[0] * py), sqrtf(x[1] * py), sqrtf(x[2] * py), sqrtf(x[3] * py)};
				producer_storage[py & 1][x[0]] = vec[0];
				producer_storage[py & 1][x[1]] = vec[1];
				producer_storage[py & 1][x[2]] = vec[2];
				producer_storage[py & 1][x[3]] = vec[3];
			}		
	}

	// Now compute consumer for this scanline:
		for (x_vec = 0; x_vec < 800/4; x_vec++) {
			int x_base = x_vec * 4;
			// Again, Halide's equivalent here uses SSE.
			int x[] = {x_base, x_base + 1, x_base + 2, x_base + 3};
			float vec[] = {
				(producer_storage[y & 1][x[0]] +
				producer_storage[(y+1) & 1][x[0]] +
				producer_storage[y & 1][x[0]+1] +
				producer_storage[(y+1) & 1][x[0]+1]),
				(producer_storage[y & 1][x[1]] +
				producer_storage[(y+1) & 1][x[1]] +
				producer_storage[y & 1][x[1]+1] +
				producer_storage[(y+1) & 1][x[1]+1]),
				(producer_storage[y & 1][x[2]] +
				producer_storage[(y+1) & 1][x[2]] +
				producer_storage[y & 1][x[2]+1] +
				producer_storage[(y+1) & 1][x[2]+1]),
				(producer_storage[y & 1][x[3]] +
				producer_storage[(y+1) & 1][x[3]] +
				producer_storage[y & 1][x[3]+1] +
				producer_storage[(y+1) & 1][x[3]+1])};
	
				c_result[y][x[0]] = vec[0];
				c_result[y][x[1]] = vec[1];
				c_result[y][x[2]] = vec[2];
				c_result[y][x[3]] = vec[3];
			}

		}
	}
// Look on my code, ye mighty, and despair!
	gettimeofday(&stop_time, NULL);
	timersub(&stop_time, &start_time, &elapsed_time);//subtract time
	printf("Halide tutorial code executed in %f seconds\n",elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);

	printf("Okay, now for Dan's implementation\n");
	float omp_result[800][600];

  gettimeofday(&start_time,NULL);

  #pragma omp parallel for \
  private(y, i, y_base, x_vec, producer_storage, yi, x, x_base)\
  shared(omp_result)
  for (yo = 0; yo < 600/16 + 1; yo++) { // (this loop is parallel in the Halide version)

  // 16 doesn't divide 600, so push the last slice upwards to fit within [0, 599] (see lesson 05).
    y_base = yo * 16;
    if (y_base > 600-16) y_base = 600-16;

    // Allocate a two-scanline circular buffer for the producer

    // For every scanline in the strip of 16:
    for (yi = 0; yi < 16; yi++) {
      y = y_base + yi;

      for (py = y; py < y+2; py++) {
      // Skip scanlines already computed *within this task*
        if (yi > 0 && py == y) continue;

      // Compute this scanline of the producer in 4-wide vectors
      for(x_vec = 0; x_vec < 800/4 + 1; x_vec++) {
        x_base = x_vec*4;
        // 4 doesn't divide 801, so push the last vector left (see lesson 05).
        if (x_base > 801 - 4) x_base = 801 - 4;
        // If you're on x86, Halide generates SSE code for this part:
      //  x = {x_base, x_base + 1, x_base + 2, x_base + 3};
        for( i = 0; i < 4; i ++ )
          x[i] = x_base + i;
        for( i = 0; i < 4; i ++ )
          vec[i] = sqrtf(x[i] * py);
      //  vec[4] = {sqrtf(x[0] * py), sqrtf(x[1] * py), sqrtf(x[2] * py), sqrtf(x[3] * py)};
        producer_storage[py & 1][x[0]] = vec[0];
        producer_storage[py & 1][x[1]] = vec[1];
        producer_storage[py & 1][x[2]] = vec[2];
        producer_storage[py & 1][x[3]] = vec[3];
      } 
  }

  // Now compute consumer for this scanline:
    for (x_vec = 0; x_vec < 800/4; x_vec++) {
      int x_base = x_vec * 4;
      // Again, Halide's equivalent here uses SSE.
			for( i = 0; i < 4; i ++ )
				x[i] = x_base + i;
//      x = {x_base, x_base + 1, x_base + 2, x_base + 3};
			vec[0] = 
        (producer_storage[y & 1][x[0]] +
        producer_storage[(y+1) & 1][x[0]] +
        producer_storage[y & 1][x[0]+1] +
        producer_storage[(y+1) & 1][x[0]+1]);
		   vec[1] = (producer_storage[y & 1][x[1]] +
        producer_storage[(y+1) & 1][x[1]] +
        producer_storage[y & 1][x[1]+1] +
        producer_storage[(y+1) & 1][x[1]+1]);
        vec[2] = (producer_storage[y & 1][x[2]] +
        producer_storage[(y+1) & 1][x[2]] +
        producer_storage[y & 1][x[2]+1] +
        producer_storage[(y+1) & 1][x[2]+1]);
        vec[3] = (producer_storage[y & 1][x[3]] +
        producer_storage[(y+1) & 1][x[3]] +
        producer_storage[y & 1][x[3]+1] +
        producer_storage[(y+1) & 1][x[3]+1]);

        omp_result[y][x[0]] = vec[0];
        omp_result[y][x[1]] = vec[1];
        omp_result[y][x[2]] = vec[2];
        omp_result[y][x[3]] = vec[3];
      }

    }
  }
// Look on my code, ye mighty, and despair!
  gettimeofday(&stop_time, NULL);
  timersub(&stop_time, &start_time, &elapsed_time);//subtract time
  printf("OMP Version executed in %f seconds\n",elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);

	printf("Checking correctness\n");
//	for(i = 0; i < 8; i ++)
	//	for(j = 0; j<6; j ++)
	//		printf("omp_result[%d][%d] = %f\n", i, j, omp_result[i][j]);
	for(i = 0; i < 800; i ++)
		for(j = 0; j < 600;	j++)
		{
			if(abs(omp_result[i][j] - c_result[i][j]) > thresh)
			{
				printf("Cripes! Something bad happened! \nomp_result[%d][%d] was %f\n", i,j, omp_result[i][j]);
				printf("c_result[%d][%d] was %f\n", i, j, c_result[i][j]);
				exit(EXIT_FAILURE);
			}
		}

	printf("Success!\n");
	return 1;
}
