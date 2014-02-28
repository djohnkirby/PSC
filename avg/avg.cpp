#include <Halide.h>
#include <stdio.h>
#include "/home/dkirby/Halide-master/apps/support/image_io.h"

using namespace Halide;

int main( int argc, char ** argv )
{
  Halide::Image<uint8_t> input1 = load<uint8_t>("input1.png");
	Halide::Image<uint8_t> input2 = load<uint8_t>("input2.png");
	
}
