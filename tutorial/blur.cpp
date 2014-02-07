//This is my first attempt at writing some blur functions in Halide
//Please don't laugh at me.

#include <Halide.h>

using namespace Halide;
using Halide::Image;
#include "../apps/support/image_io.h"

  // The schedule - defines order, locality; implies storage

	//This program will define at least one blurring algorithm
Func blur_3x3(Halide::Image<uint8_t> input) {
  Func blur_x, blur_y;
  Var x, y, c, xi, yi;

	//Clamp the edges	
	Expr clamped_x = clamp(x, 0, input.width()-1);
	Expr clamped_y = clamp(y, 0, input.height()-1);
  Func clamped("clamped");
	clamped(x,y,c) = input(clamped_x,clamped_y, c);

  //The algorithm - no storage or order
  Func input_16("input_16");
	input_16(x,y,c) = cast<uint16_t>(clamped(x,y,c));
  blur_x(x, y) = (input_16(x-1, y) + input_16(x, y) + input_16(x+1, y))/3;
  blur_y(x, y) = (blur_x(x, y-1) + blur_x(x, y) + blur_x(x, y+1))/3;

 // The schedule - defines order, locality; implies storage
  blur_y.tile(x, y, xi, yi, 256, 32)
        .vectorize(xi, 8).parallel(y);
  blur_x.compute_at(blur_y, x).vectorize(x, 8);
   return blur_y.realize(input.width(),input.height());
}
int main(int argc, char ** argv)
{
  Halide::Image<uint8_t> input = load<uint8_t>("../apps/images/rgb.png");
	Func blur_x, blur_y;
  	Var x, y, c, xi, yi;



  // The algorithm - no storage or order
	//Need to figure out how to make it not go off the end
  blur_x(x, y) = input(x-1, y) + input(x, y) + input(x+1, y);
  blur_y(x, y) =blur_x(x, y-1) + blur_x(x, y) + blur_x(x, y+1);

 // The schedule - defines order, locality; implies storage
//  blur_y.tile(x, y, xi, yi, 256, 32)
 //       .vectorize(xi, 8).parallel(y);
//  blur_x.compute_at(blur_y, x).vectorize(x, 8);

//	Halide::Image<uint8_t> output = blur_y.realize(input.width(), input.height(), input.channels());
//	Halide::Image<uint8_t> output = blur_3x3(input(x,y,c));
//	save(output,"blurred.png");
	printf("Success!\n");
	return 2;
}
