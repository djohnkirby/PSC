#include <Halide.h>
#include <stdio.h>

using namespace Halide;

#include "/home/dkirby/Halide-current/apps/support/image_io.h"


int main( int argc, char ** argv )
{
	Halide::Func average;
	Halide::Var x, y, c1, c2;
        Halide::Image<uint8_t> input1 = load<uint8_t>("input1.png");
	Halide::Image<uint8_t> input2 = load<uint8_t>("input2.png");
	
	average(x, y, c) = Halide::cast<uint8_t>((input1(x,y,c1)*1.0f + input2(x,y,c2)*1.0f)*0.5f);

	Halide::Image<uint8_t> output = average.realize(min(input1.width(),input2.width()), min(input1.height(), input2.height()), 
	
	return 0;
}
