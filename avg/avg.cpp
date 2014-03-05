//This program takes two images and averages them.

// On linux, you can compile and run it like so:
// g++ avg.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -ltiff -o avg
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
#include <tiffio.h>
int debug = 0;

readTiff(TIFF * input)
{
	uint32 imagelength;
	tdata_t buf;
	uint32 row;
	TIFFGetField(input, TIFFTAG_IMAGELENGTH, &imagelength);
	buf = _TIFFmalloc(TIFFScanlineSize(input));
  
	for (row = 0; row < imagelength; row++)
	{
   tiffreadscanline(input, buf, row);
	 /* This is where we have the buf, load into Halide here? */
	_tifffree(buf);
	}

}

int main(int argc, char **argv) 
{
		if( argc < 2 )
		{	
			printf("Usage: ./avg png1.png png2.png\n");
			return 0;
		}
		printf("About to check the thing.\n");
		if( argc > 2 && strcmp(argv[2],"d") == 0)	
			debug = 1;
		/*Halide::Image<uint8_t> input = load<uint8_t>(argv[1]);
		Halide::Image<uint8_t> input2 = load<uint8_t>(argv[2]);
		*/
		TIFF *tiff1 = TIFFOpen(argv[1], "r");
		TIFF *tiff2 = TIFFOpen(argv[2], "r");
		
		Halide<uint8_t> input = readTiff(tiff1);
		Halide<uint8_t> input2 = readTiff(tiff2);		

		TIFFClose(tiff1);
		TIFFClose(tiff2);

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
