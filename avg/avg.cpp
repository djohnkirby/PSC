#include <stdio.h>
#include <Halide.h>
#include <png.h>
#include <math.h>
#include <ctype.h>
#include <jpeglib.h>
#include <tiffio.h>
#include "myimio.h"
using Halide::Image;
#include "../apps/support/image_io.h"


/* Define benchmarking functionality */
typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

void abort_(const char * s, ...)
{
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
        fprintf(stderr, "\n");
        va_end(args);
        abort();
}

struct image * read_png(char * file_name)
{
	int x, y, width, height;
	png_byte color_type;
	png_byte bit_depth;

	png_structp png_ptr;
	png_infop info_ptr;
	int number_of_passes;
	png_bytep * row_pointers;

	struct image * returnMe;
	char header[8];
	FILE *fp = fopen(file_name, "rb");
	if(!fp)
		exit(EXIT_FAILURE);
	fread(header, 1, 8, fp);
        if (png_sig_cmp(header, 0, 8))
                abort_("[read_png_file] File %s is not recognized as a PNG file", file_name);

	/* initialize stuff */
        png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (!png_ptr)
                abort_("[read_png_file] png_create_read_struct failed");

        info_ptr = png_create_info_struct(png_ptr);
        if (!info_ptr)
                abort_("[read_png_file] png_create_info_struct failed");

        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[read_png_file] Error during init_io");

        png_init_io(png_ptr, fp);
        png_set_sig_bytes(png_ptr, 8);

        png_read_info(png_ptr, info_ptr);

        width = png_get_image_width(png_ptr, info_ptr);
        height = png_get_image_height(png_ptr, info_ptr);
        color_type = png_get_color_type(png_ptr, info_ptr);
        bit_depth = png_get_bit_depth(png_ptr, info_ptr);

        number_of_passes = png_set_interlace_handling(png_ptr);
        png_read_update_info(png_ptr, info_ptr);
	
	/* read file */
        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[read_png_file] Error during read_image");

        row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
        for (y=0; y<height; y++)
                row_pointers[y] = (png_byte*) malloc(png_get_rowbytes(png_ptr,info_ptr));

        png_read_image(png_ptr, row_pointers);
	fclose(fp);

	 for (y=0; y<height; y++) {
                png_byte* row = row_pointers[y];
                for (x=0; x<width; x++) {
                        png_byte* ptr = &(row[x*4]);
                        printf("Pixel at position [ %d - %d ] has RGBA values: %d - %d - %d - %d\n",
                               x, y, ptr[0], ptr[1], ptr[2], ptr[3]);

                        /* set red value to 0 and green value to the blue one */
                        ptr[0] = 0;
                        ptr[1] = ptr[2];
                }
        }


	/* Write stuff here*/	
	return(returnMe);
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

double avg_c( char * im1, char * im2 )
{
	struct image *input, *input2;
	int i, j, h, w;
	unsigned char * result;
	input = read_image(im1);
	input2 = read_image(im2);
	h = min(input->ht, input2->ht);
	w = min(input->wid, input2->wid);
	result = malloc(h*w*sizeof(unsigned char));
	
	for( j = 0; j < h; j ++ )
		for( i = 0; i < w; i ++ )
			result[j*w + i] = (unsigned char)(0.5f*input->pp[j*w + i] +	0.5f*input2->pp[j*w + i]);
		
	
}

double avg(char * im1, char * im2) {
		ticks tick0, tick1;
    // First we'll load the input image we wish to brighten.
    Halide::Image<uint8_t> input = load<uint8_t>(im1);
		Halide::Image<uint8_t> input2 = load<uint8_t>(im2);
    
		Halide::Func average;

    Halide::Var x, y, c;

    Halide::Expr value = input(x, y, c);
		Halide::Expr value2 = input2(x, y, c);
		value = value/2.0f + value2/2.0f;

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
