/* This is a program that simply averages two images.
 * The output image is guarunteed to be the size of the smaller (in both dimensions)
 * of the two images. So for instance if the inputs are (800 x 600) and (600 x 800)
 * the output image will be (600 x 600)*/

#include <Halide.h>
#include <stdio.h>

using namespace Halide;

#include "/home/dkirby/Halide-current/apps/support/image_io.h"


int main( int argc, char ** argv )
{
	Halide::Func average;
//	Halide::Var x("x"), y("y"), c("c"),c1("c1"), c2("c2");
	Halide:: Var x, y, c, c1, c2;
  Halide::Image<uint8_t> input1 = load<uint8_t>("/home/dkirby/Halide-master/apps/images/gray.png");
	Halide::Image<uint8_t> input2 = load<uint8_t>("/home/dkirby/Halide-master/apps/images/gray.png");
	
//	Halide::Expr av = (input1(x, y, c1) + input2(x, y, c2))/2;
//	average = av;
	Halide::Expr val1 = input1(x, y, c);
	Halide::Expr val2 = input2(x, y, c);
//	average(x, y, c) = Halide::cast<uint8_t>(1.0f*val1+1.0f*val2)/2;
  average(x, y, c)  = val1/2 + val2/2;
//	Halide::Image<uint8_t> output = average.realize(min(input1.width(),input2.width()), min(input1.height(), input2.height()), input1.channels(), input2.channels()); 
//	save(output, "result.png");
	/*int w1 = input1.width();
	int w2 = input2.width();
	int h1 = input1.height();
	int h2 = input2.height();

	int w = min(w1, w2);
	int h = min(h1, h2);*/

	Halide::Image<uint8_t> output = average.realize(input1.width(), input2.height(), input1.channels(), input2.channels());

/*	for( int j = 0; j < output.height(); j ++ )
		for ( int i = 0; i < output.width(); i ++ )
			if ( output(i,j) != (input1(i,j) + input2(i,j))/2 )
				{
		 			printf("Something went wrong!\n"
               "Pixel %d, %d was supposed to be %d, but instead it's %d\n",
                       i, j, (input1(i,j)+input2(i,j))/2, output(i, j));
				}

*/	
	return 0;
}
