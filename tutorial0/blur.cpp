//This is my first attempt at writing some blur functions in Halide
//Please don't laugh at me.

#include <Halide.h>

using Halide::Image;

int main(int argc, char ** argv)
{

Func convolution(Func f, Func kernel, Expr kernel_width, Expr kernel_height){
	Var x,y;
	Func convolved;
	RVar kx(0,kernel_width), ky(0,kernel_height);
	convolved(x,y) += kernel(kx,ky)*f(x+kx-(kernel_width/2),y+ky-(kernel_height/2));
	return convolved;
}
 
Func gaussianBlur(Func f, const float sigma){
	Var x,y;
	Func gaussian, kernelHor, kernelVer, hor, out;
	gaussian(x) = exp(-x*x/(2*sigma*sigma));
	float norm = 1.0/sqrt(2*PI*sigma*sigma);
	int radius = ceil(3*sigma);
	RVar i(-radius, 2*radius+1);
	kernelHor(x,y) = (norm*gaussian(x-radius))/sum(norm*gaussian(i));
	hor = convolution(f, kernelHor, 2*radius+1, 1);
	kernelVer(x,y) = (norm*gaussian(y-radius))/sum(norm*gaussian(i));
	out = convolution(hor, kernelVer, 1, 2*radius+1);
	return out;
}

//int main(int argc, char ** argv)
//{
  Halide::Image<uint8_t> input = load<uint8_t>(argv[0]);
	Halide::Image<uint8_t> output;
	output = gaussianBlur(input, argv[1]);
	save(output,"dansfirsthalidegausian.png");
}
