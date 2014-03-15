#include <Halide.h>
using namespace Halide;
#include "../apps/support/image_io.h"

int main( int argc, char ** argv )
{
	ImageParam input(UInt(8), 3);
	ImageParam input2(UInt(8), 3);
	Halide::Func average;

  Halide::Var x, y, c;

  Halide::Expr value = input(x, y, c);
  Halide::Expr value2 = input2(x, y, c);
  value = value/2.0f + value2/2.0f;

  average(x, y, c) = Halide::cast<uint8_t>(value);

	average.compile_to_file("average", input, input2);
	return 0;
}
