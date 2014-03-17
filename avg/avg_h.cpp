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
	average.split(y,y,yi,8).parallel(y).vectorize(x,8);
	//Split y into sections of 8 scanlines
	//Compute scanlines in parallel in vectors of size 8
	
	average.compile_to_file("average", input, input2);
	return 0;
}
