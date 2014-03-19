#include <stdio.h>
#include <png.h>
#include <ctype.h>
#include <stdlib.h>
#include "myimio.h"

void abort_(const char * s, ...)
{
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
        fprintf(stderr, "\n");
        va_end(args);
        abort();
}

/* Define benchmarking functionality */
typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

struct image * read_png(char * file_name)
{
  int x, y, width, height, thisindex;
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
			//	printf("%d\n", (int)color_type);
				returnMe = newimage( width, height, 3);

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
//            printf("Pixel at position [ %d - %d ] has RGBA values: %d - %d - %d - %d\n",
//                    x, y, ptr[0], ptr[1], ptr[2], ptr[3]);
						/*ptr[0] = r, ptr[1] = g, ptr[2] = b, ptr[3] = alpha*/
						thisindex = x + y* width;
						returnMe->pp[thisindex] = (unsigned char)(ptr[0]/3.0 + ptr[1]/3.0 + ptr[2]/3.0);					
           }
        }

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


double min_arr( double * dubs, int n )
{
  int i;
  double mindub = dubs[0];
  for( i = 1; i < n; i ++ )
    if (dubs[i] < mindub)
      mindub = dubs[i];
  return mindub;
}

double min( double dub1, double dub2 )
{
	if ( dub1 < dub2 )
		return dub1;
	else
		return dub2;
}

double avg_c( char * im1, char * im2 )
{
	ticks tick0, tick1; 
	int i, j, h, w, thisindex;
	struct image * input = read_png( im1 );
	struct image * input2 = read_png( im2 );
	struct image * output;
	w = min( input->wid, input2->wid );
	h = min( input->ht, input2->ht );
	//Assuming that we have a grayscale image for now. In the future learn something more about
	//png_byte.
	output = newimage(w, h, 1);
	tick0 = getticks();
	#pragma omp parallel for private(i,j, thisindex)
	for( j = 0; j < h; j ++ )
		for( i = 0; i < w; i ++ )
		{
			thisindex = i + j*w;
			output->pp[thisindex] = 0.5f*(input->pp[thisindex])  + 0.5f*(input2->pp[thisindex]);
		}

	tick1 = getticks();
	for( j = 0; j < h; j ++ )
		for( i = 0; i < w; i ++ )
		{
 			thisindex = i + j*w;
			if( output->pp[thisindex] !=  (unsigned char)(0.5f*(input->pp[thisindex])  + 0.5f*(input2->pp[thisindex]) ))
			{
				printf("Something went wrong!\n"
               "Pixel %d, %d was supposed to be %d, but instead it's %d\n",
                       i, j, (input->pp[thisindex] + input2->pp[thisindex])/2, output->pp[thisindex]);
          return -1.0;

			}
	  } 
	return (double)(tick1-tick0);

}


int main( int argc,  char ** argv )
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
      ticks[i] = avg_c(argv[1], argv[2]);
  else if( argc == 5 )
    for( i = 0; i < N; i = i + 2 )
    {
      ticks[i] = avg_c(argv[1], argv[2]);
      ticks[i+1] = avg_c(argv[3] , argv[4]);
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
