// Halide tutorial lesson 2.

// This lesson demonstrates how to pass in input images.

// On linux, you can compile and run it like so:
// g++ lesson_02*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -o lesson_02
// LD_LIBRARY_PATH=../bin ./lesson_02

// On os x:
// g++ lesson_02*.cpp -I ../include -L ../bin -lHalide `libpng-config --cflags --ldflags` -o lesson_02
// DYLD_LIBRARY_PATH=../bin ./lesson_02

// The only Halide header file you need is Halide.h. It includes all of Halide.
#include <Halide.h>

// Include some support code for loading pngs. It assumes there's an
// Image type, so we'll pull the one from Halide namespace;
using Halide::Image;
#include "/home/dkirby/Halide-current/apps/support/image_io.h"

int main(int argc, char **argv) {
		int i, j;
		Halide::Func black;
		Halide::Func white;
    Halide::Var x, y;
		
    black(x, y) = 0;
		white(x, y) = 254;
    
		Halide::Image<int32_t> output1 = black.realize(800, 600);
		Halide::Image<int32_t> output2 = white.realize(800, 600);

    // Save the output for inspection. It should look like a bright parrot.
    save(output1, "input1.png");
		save(output2, "input2.png");
		//Check to see everything is copacetic
		for( i = 0; i < 800; i ++ )
		{
			for( j = 0; j < 600; j ++ )
				if (output2(i, j) != 254 || output1(i, j) != 0)
				{
					printf("Failure! Failed at (%d, %d)\n", i, j);
					return 1;
				}	
		}
    printf("Success!\n");
    return 0;
}
