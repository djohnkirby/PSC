<<<<<<< HEAD
//This program takes two images and averages them.

// On linux, you can compile and run it like so:
// g++ avg.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -ltiff -o avg
// LD_LIBRARY_PATH=../bin ./avg png1.png png2.png

// On os x:
// g++ avg.cpp -I ../include -L ../bin -lHalide `libpng-config --cflags --ldflags` -o avg
// DYLD_LIBRARY_PATH=../bin ./avg png1.png png2.png

// The only Halide header file you need is Halide.h. It includes all of Halide.
#include <Halide.h>
//#include <halide_load_tiff.h>
// Include some support code for loading pngs. It assumes there's an
// Image type, so we'll pull the one from Halide namespace;
using namespace Halide;
=======
#include <stdio.h>
#include <Halide.h>
>>>>>>> f5be0629648059fdb8a0557afc63f9f2589472ad
using Halide::Image;
#include "../apps/support/image_io.h"
#include <tiffio.h>
//#include "halide_load_tiff.h"
int debug = 0;

template <typename U,typename T>
void scan_line(TIFF* tif, Image<T> im)
{
        uint32 imagelength;
        TIFFGetField(tif, TIFFTAG_IMAGELENGTH, &imagelength);
        tsize_t scanline = TIFFScanlineSize(tif);
        T *ptr = (T*)im.data();
        U* buf = (U*)_TIFFmalloc(scanline);
        for (uint32 row = 0; row < imagelength; row++) {
                TIFFReadScanline(tif, buf, row);
                for (uint32 col = 0; col < scanline / sizeof(U); col++){
                        convert(buf[col], *(ptr++));
                }
        }
        _TIFFfree(buf);
}

<<<<<<< HEAD
template <typename T>
Image<T> load_tiff(const char* filename) {
        Func gray,gray2;
        Var x,y,c;

        TIFF* tif = TIFFOpen(filename,"r");
        if (tif) {
                uint32 w, h, ch, bits;
                printf("Whoo! Entered the if statement\n");

                TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &w);
                TIFFGetField(tif, TIFFTAG_IMAGELENGTH, &h);
                /* THis is a hack fix, but a fix nonetheless, this can now
                 * only do grayscale, maybe one day let's like not do this*/
                //TIFFGetField(tif, TIFFTAG_SAMPLESPERPIXEL, &ch);
                ch = 1;
                TIFFGetField(tif, TIFFTAG_BITSPERSAMPLE, &bits);
                printf("%d x %d x %d, %d bits\n", w, h, ch, bits);
                Image<T> im(w,h,ch);
                printf("%d x %d x %d, %d bits\n",w,h,ch,bits);

                size_t npixels = w * h;


                T *ptr = (T*)im.data();
                int c_stride = im.stride(2);

                _assert((ch == 3 && bits == 8) || (ch == 1 && (bits == 8 || bits == 16)),
                                "Not supported format.\n");

                if(ch == 3 && bits == 8){
                        uint32* raster = (uint32*) _TIFFmalloc(npixels * sizeof (uint32));
                        if (raster != NULL && TIFFReadRGBAImage(tif, w, h, raster, 0)) {
                                for (int y = h - 1; y >= 0; y--) {
                                        uint8_t* srcPtr = (uint8_t*)&(raster[w * y]);
                                        for (int x = 0; x < w; x++) {
                                                for (int c = 0; c < ch; c++) {
                                                        convert(*srcPtr++, ptr[c*c_stride]);
                                                }
                                                srcPtr++;
                                                ptr++;
                                        }
                                }
                                _TIFFfree(raster);
                        }
                } else if (ch == 1){
                        if (bits == 8) {
                                scan_line<uint8_t,T>(tif,im);
                        }else if (bits == 16) {
                                scan_line<uint16_t,T>(tif,im);
                        }
                }else{
                        _assert(false, "Not supported format.\n");
                        return Image<T>(0,0,1);
                }
                TIFFClose(tif);

                im.set_host_dirty();
                return im;

        }else{
                return Image<T>(0,0,1);
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
	  Halide::Image<uint8_t> input = load_tiff(argv[0]);
		Halide::Image<uint8_t> input2 = load_tiff(argv[1]);
    Halide::Func average;
=======

/* Define benchmarking functionality */
typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

double getclockspeed()
{
	ticks micros0, micros1;
	int sec = 2;
	double tdiff;
  micros0 = getticks();
 	sleep(sec);
  micros1 = getticks();
  tdiff = micros1-micros0;
	return tdiff/sec;
}

/* Define min function */
template <class T> const T& min (const T& a, const T& b) {
  return !(b<a)?a:b;     // or: return !comp(b,a)?a:b; for version (2)
}

double min_arr( double * dubs, int n )
{
  int i;
  double mindub = dubs[0];
  for( i = 1; i < n; i ++ )
    if (dubs[i] < mindub)
      mindub = dubs[i];
  return mindub; 
}


double avg(char * im1, char * im2) {
		ticks tick0, tick1;
    // First we'll load the input image we wish to brighten.
    Halide::Image<uint8_t> input = load<uint8_t>(im1);
		Halide::Image<uint8_t> input2 = load<uint8_t>(im2);
    
		Halide::Func average;

>>>>>>> f5be0629648059fdb8a0557afc63f9f2589472ad
    Halide::Var x, y, c;

    Halide::Expr value = input(x, y, c);
		Halide::Expr value2 = input2(x, y, c);
		value = value/2.0f + value2/2.0f;

<<<<<<< HEAD
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
=======
    average(x, y, c) = Halide::cast<uint8_t>(value);

		int w1 = input.width();
		int w2 = input2.width();
		int w = min(w1, w2);
		int h1 = input.height();
		int h2 = input2.height();
		int h = min(h1,h2);
		int c1 = input.channels();
		int c2 = input2.channels();
		int ch = min(c1, c2);
		
		/* Start benchmarking*/

		tick0 = getticks();
    Halide::Image<uint8_t> output = average.realize(w, h, ch);
		tick1 = getticks();
		
//		printf("Executed in %f CPU ticks\n", (double)(tick1 - tick0));
	for( int j = 0; j < output.height(); j ++ )
		for ( int i = 0; i < output.width(); i ++ )
			if ( output(i,j) != (input(i,j) + input2(i,j))/2 )
				{
		 			printf("Something went wrong!\n"
               "Pixel %d, %d was supposed to be %d, but instead it's %d\n",
                       i, j, (input(i,j)+input2(i,j))/2, output(i, j));
					return -1.0;
				}
>>>>>>> f5be0629648059fdb8a0557afc63f9f2589472ad


 //   save(output, "output1.png");

//    printf("Success!\n");
    return (double)(tick1-tick0);
}

int main(int argc, char **argv)
{
	int N = 10;
	int i;
	double ticks[N];
	double clockspeed;

 if( argc < 3 )
   {
     printf("You need to specify at least two images\n");
     return 0.0;
   }
	/*Support two or four*/
	if( argc == 3 )
		for( i = 0; i < N; i ++ )
			ticks[i] = avg(argv[1], argv[2]);
	else if( argc == 5 )
		for( i = 0; i < N; i = i + 2 )
		{
			ticks[i] = avg(argv[1], argv[2]);
			ticks[i+1] = avg(argv[3] , argv[4]);
		}
	else
		{
			printf("Huh? Weird arg count, exiting...\n");
			return 0;
		}

	clockspeed = getclockspeed();

	/* Print total CPU cycles */
	printf("Execution times for each trial in clock cycles:\n");
	for( i = 0; i < N-1; i ++ )
		printf("%f, ", ticks[i]);
	printf("%f\n", ticks[N-1]);
	printf("minimum was: %f\n", min_arr(ticks, N));

	/* Print time for each */
	printf("Execution times for each trial in milliseconds:\n");
	for( i = 0; i < N-1; i ++ )
		printf("%f, ", (ticks[i]/clockspeed)*1000 );
	printf("%f\n", (ticks[N-1]/clockspeed)*1000);
}
