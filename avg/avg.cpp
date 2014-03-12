#include <stdio.h>
#include <Halide.h>
using Halide::Image;
#include "../apps/support/image_io.h"


/* Define benchmarking functionality */
typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

/* Define min function */
template <class T> const T& min (const T& a, const T& b) {
  return !(b<a)?a:b;     // or: return !comp(b,a)?a:b; for version (2)
}

int main(int argc, char **argv) {
		ticks tick0, tick1;
		if( argc < 2 )
		{
			printf("You need to specify two images\n");
			return 0;
		}
    // First we'll load the input image we wish to brighten.
    Halide::Image<uint8_t> input = load<uint8_t>(argv[1]);
		Halide::Image<uint8_t> input2 = load<uint8_t>(argv[2]);
    
		Halide::Func average;

    Halide::Var x, y, c;

    Halide::Expr value = input(x, y, c);
		Halide::Expr value2 = input2(x, y, c);
		value = value/2.0f + value2/2.0f;

    average(x, y, c) = Halide::cast<uint8_t>(value);

		int w1 = input.width();
		int w2 = input2.width();
		int w = min(w1, w2);
		int h1 = input.height();
		int h2 = input2.height();
		int h = min(h1,h2);
		int c1 = input.channels();
		int c2 = input2.channels();
		int ch = min(c1, c2);
		
		/* Start benchmarking*/

		tick0 = getticks();
    Halide::Image<uint8_t> output = average.realize(w, h, ch);
		tick1 = getticks();
		
		printf("Executed in %f CPU ticks\n", (double)(tick1 - tick0));
	for( int j = 0; j < output.height(); j ++ )
		for ( int i = 0; i < output.width(); i ++ )
			if ( output(i,j) != (input(i,j) + input2(i,j))/2 )
				{
		 			printf("Something went wrong!\n"
               "Pixel %d, %d was supposed to be %d, but instead it's %d\n",
                       i, j, (input(i,j)+input2(i,j))/2, output(i, j));
				}


    save(output, "output1.png");

    printf("Success!\n");
    return 1;
}
