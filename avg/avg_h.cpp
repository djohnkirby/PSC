#include <Halide.h>
using namespace Halide;

int main( int argc, char ** argv )
{
	ImageParam input(UInt(8), 2);
	ImageParam input2(UInt(8), 2);
	Halide::Func average;

  Halide::Var x("x"), y("y"), xi("xi"), yi("yi"), c("c");
	
	//The algorithm
  Halide::Expr value = input(x, y);
  Halide::Expr value2 = input2(x, y);
  value = value/2.0f + value2/2.0f;

  average(x, y) = Halide::cast<uint8_t>(value);
	
	//The Schedule
	//This schedule's performance : 2x10^6 pixels/ms <- I'm skeptical of this
	//average.split(y,y,yi,8).parallel(y).vectorize(x,8);

	//This schedule's performance: 
	average.tile(x, y, xi, yi, 100, 100).parallel(y).vectorize(x, 8);
	
	//A schedule that runs on GPU and is comically slow
//	average.cuda_tile(x, y, 100, 100);

	//Split y into sections of 8 scanlines
	//Compute scanlines in parallel in vectors of size 8
	
	average.compile_to_file("average", input, input2);
	return 0;
}
