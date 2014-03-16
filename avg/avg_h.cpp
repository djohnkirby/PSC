#include <Halide.h>
using namespace Halide;
#include "../apps/support/image_io.h"

int main( int argc, char ** argv )
{
	ImageParam input(UInt(8), 3);
	ImageParam input2(UInt(8), 3);
	Halide::Func average("average");

  Halide::Var x, y, xi, yi, c;

  Halide::Expr value = input(x, y);
  Halide::Expr value2 = input2(x, y);
  value = value/2.0f + value2/2.0f;

  average(x, y) = Halide::cast<uint8_t>(value);
	
	average.split(y,y,yi,8).parallel(y).vectorize(x,8);
	
	average.compile_to_file("average", input, input2);
	return 0;
}
