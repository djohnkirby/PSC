#include <stdio.h>
//#include <Halide.h>
#include <png.h>
#include <math.h>
#include <ctype.h>
#include <jpeglib.h>
#include <tiffio.h>
#include "../apps/support/static_image.h"
//#include "myimio.h"
//using Halide::Image;
#include "../apps/support/image_io.h"
#include "average.h"

typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

/*This routine loads kB kilobytes of junk into cache to try to force
	everything else to be evicted*/
void clearCache(int kB)
{
	int i;
	int * comicallyLargeArray = (int *)malloc((kB*1000) * sizeof(int));
	comicallyLargeArray[0] = -1;
	for( i = 1; i < kB*1000; i ++ )
		comicallyLargeArray[i] = comicallyLargeArray[i-1] + 1;
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

double avg_arr( double * dubs, int n )
{
	int i;
	double total = 0.0;
	for( i = 0; i < n; i ++ )
		total = total + dubs[i];
	return total/n;
}

double avg_h( char * im1, char * im2 )
{
	ticks tick0, tick1;
  Image<uint8_t> input = load<uint8_t>(im1);
  Image<uint8_t> input2 = load<uint8_t>(im2);
	Image<uint8_t> output(min(input.width(), input2.width()), min(input.width(), input2.width()));
	tick0 = getticks();
	average( input, input2, output );
	tick1 = getticks();
	save(output, "output2.png");
	return (double)(tick1 - tick0);
}

int main(int argc, char **argv)
{
  int N = 100;
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
		{
			avg_h(argv[1], argv[2]); //Run once to initialize stuff This doesn't seem to do anything
      ticks[i] = avg_h(argv[1], argv[2]);
			clearCache(6144);
		}
  else if( argc == 5 )
    for( i = 0; i < N; i = i + 2 )
    {
      ticks[i] = avg_h(argv[1], argv[2]);
      ticks[i+1] = avg_h(argv[3] , argv[4]);
    }
  else
    {
      printf("Huh? Weird arg count, exiting...\n");
      return 0;
    }

  clockspeed = getclockspeed();

  /* Print total CPU cycles */
//  printf("Execution times for each trial in clock cycles:\n");
  //for( i = 0; i < N-1; i ++ )
  //  printf("%f, ", ticks[i]);
  //printf("%f\n", ticks[N-1]);
  printf("minimum number of clock cycles was: %f\n", min_arr(ticks, N));
	printf("Average was: %f\n", avg_arr(ticks, N));
	printf("First run performance was %f\n", ticks[0]);
  /* Print time for each */
//  printf("Execution times for each trial in milliseconds:\n");
 // for( i = 0; i < N-1; i ++ )
  //  printf("%f, ", (ticks[i]/clockspeed)*1000 );
  //printf("%f\n", (ticks[N-1]/clockspeed)*1000);
	printf("Minimum time was: %f milliseconds\n", (min_arr(ticks, N)/clockspeed)*1000);
	printf("Average milliseconds: %f\n", (avg_arr(ticks, N)/clockspeed)*1000);
	printf("First time milliseconds was %f\n", (ticks[0]/clockspeed)*1000);
}

