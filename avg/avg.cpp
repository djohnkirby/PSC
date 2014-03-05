//This program takes two images and averages them.

// On linux, you can compile and run it like so:
// g++ avg.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -o avg
// LD_LIBRARY_PATH=../bin ./avg png1.png png2.png

// On os x:
// g++ avg.cpp -I ../include -L ../bin -lHalide `libpng-config --cflags --ldflags` -o avg
// DYLD_LIBRARY_PATH=../bin ./avg png1.png png2.png

// The only Halide header file you need is Halide.h. It includes all of Halide.
#include <Halide.h>

// Include some support code for loading pngs. It assumes there's an
// Image type, so we'll pull the one from Halide namespace;
using Halide::Image;
#include "../apps/support/image_io.h"
int debug = 0;

int main(int argc, char **argv) 
{
		if( argc < 2 )
		{	
			printf("Usage: ./avg png1.png png2.png\n");
			return 0;
		}
		if( argc > 2 && *(argv[3]) == 'd')
			debug = 1;
		Halide::Image<uint8_t> input = load<uint8_t>(argv[1]);
		Halide::Image<uint8_t> input2 = load<uint8_t>(argv[2]);
    Halide::Func average;
    Halide::Var x, y, c;

    Halide::Expr value = input(x, y, c);
		Halide::Expr value2 = input2(x, y, c);

    value = value/2.0f + value2/2.0f;

    average(x, y, c) = Halide::cast<uint8_t>(value);

    Halide::Image<uint8_t> output = average.realize(input.width(), input.height(), input.channels());


		/*Tester code*/
	if(debug)
	{
		for( int j = 0; j < output.height(); j ++ )
			for ( int i = 0; i < output.width(); i ++ )
				if ( output(i,j) != (input(i,j) + input2(i,j))/2 )
					{
			 			printf("Something went wrong!\n"
   	            "Pixel %d, %d was supposed to be %d, but instead it's %d\n",
   	                    i, j, (input(i,j)+input2(i,j))/2, output(i, j));
					}
	}


    // Save the output for inspection. It should look like a bright parrot.
    save(output, "output.png");

    printf("Success!\n");
    return 1;
}
