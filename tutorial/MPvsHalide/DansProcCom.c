/* This is a function that I am writing to compare to lesson_08 of the Halide
	 tutorial.

	Written by Daniel John Kirby.*/
float producer_arr[PRODUCER_WIDTH][CONSUMER_HEIGHT];
float consumer_arr[CONSUMER_WIDTH][CONSUMER_HEIGHT];
float halide_result[CONSUMER_WIDTH][CONSUMER_HEIGHT];
float producer_buffer[PRODUCER_WIDTH][STRIPE_SIZE + 1];

int storeAllCompute()
{
	int x, y, i, j;
	int yo, y_base, y_in, yi, py;
	float ** halide_result;
	int numPasses = CONSUMER_HEIGHT/STRIPE_SIZE;

	int correctness = 0;

	if( CONSUMER_HEIGHT % STRIPE_SIZE )
		numPasses ++; 

	gettimeofday(&start_time, NULL);
	printf("Good morning\n");

	
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
				consumer_arr[x][y] = consumer_from_buffer(x, y);
				//printf("(x, y) = (%d, %d)\n", x, y);
			}
		}
		printConsumer();
	}
//	printf("Phew, made it out of the parallel loop\n");

	gettimeofday(&stop_time,NULL);
  timersub(&stop_time, &start_time, &elapsed_time);//subtract time
	/* Check Correctness */
	/*Load Halide result*/
/*	printf("Let's check whether the producer actually worked, why not?\n");
	for( x = 0; x < PRODUCER_WIDTH; x ++ )
	{
		for( y = 0; y < PRODUCER_HEIGHT; y ++ )
		{
	//		printf("|%f|", producer_arr[x][y]);
			if( producer_arr[x][y] - sqrt(x*y) > 0.001f )
				printf("producer[%d][%d] = %f instead of %f WTF?\n", x, y, producer_arr[x][y], sqrt(x*y));
		}
//		printf("\n");
	}
*/

	halide_result = parseFloats( "Halide_solution.txt" );
//	printf("Printing consumer array\n");
   for (x = 0; x < CONSUMER_WIDTH; x++) {
            for (y = 0; y < CONSUMER_HEIGHT; y++) {
                float error = halide_result[x][y] - consumer_arr[x][y];
                // It's floating-point math, so we'll allow some slop:

               if (error < -0.001f || error > 0.001f) {
                    printf("halide_result(%d, %d) = %f instead of %f\n",
                        x, y, halide_result[x][y], consumer_arr[x][y]);
                    return 0;
                }
            }
        }



  printf("This code executed in %f seconds\n",elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);
	return 1;

}
