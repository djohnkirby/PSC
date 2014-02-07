//gcc -O -o blur blur.c -ljpeg -ltiff

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <jpeglib.h>
#include <tiffio.h>
#include "myimio.h"

#define THRESH 0.02 

double sum(double * doubles, int size)
{
	int i;
	double returnme;

	for(i = 0; i < size; i ++){
		returnme = returnme + doubles[i];
		printf("doubles[%d]: %f\n",i,doubles[i]);}
	return returnme;
}

/*This is a helper function that turns 2D pixel locations into 1D pixel
	locations*/
int twoDtoOneD(int i, int j, int wid)
{
	return i*wid+j;
}

/*Returns the number of 1s in the first b bits of an int*/
int countbits( int n, int b )
{
	int i;
	int count = 0;
	if ( b >32 )
		return 33;
	for( i = 0; i < b-1; i++ )
		count = count + (n>>i) &1;
}

int factorial(int n)
{
        if (n < 0)
                return 0;
        if (n == 0)
                return 1;
        else
                return n*factorial(n-1);
}

//Computes n choose k.
int choose(int n, int k)
{
				printf("Computing %d choose %d\n",n,k);
				printf("Found it to be %d\n",factorial(n)/(factorial(k)*factorial(n-k)));
        return factorial(n)/(factorial(k)*factorial(n-k));
}

//Returns the left half of the
// normalized nth pascal's triangle row.
double* nthpascal(int n)
{
  int i;
	int odd = n % 2;
	double* returnme;
	int total;
	if(odd)
  	returnme = malloc((n+1)/2*sizeof(double));
	else
		returnme = malloc((n/2)*sizeof(double));
	//Let's be clever here, we only need to compute
	//one half of the pascallian because it is symmetrical
	if(odd)
	{
	//If this is an odd row, we need to go to (n+1)/2
	for( i = 0; i < (n+1)/2; i++ )
		returnme[i] = ((double)choose(n-1,i));
	//divide by the sum of the entire row
					total = 2*sum(returnme,(n+1)/2) - returnme[(n+1)/2-1];
					for( i =0; i < (n+1)/2; i++ )
						returnme[i] = (returnme[i])/total;
				}
				else
				{
		        	for(i = 0; i < n/2; i++)
 			 	      returnme[i] = ((double)choose(n-1,i));
					//divide by the sum of the entire row
					total = 2*sum(returnme,n/2);
					for(i = 0; i< n/2; i++)
						returnme[i] = returnme[i]/total;
        }

				return returnme;
}

/*This is just the gaussian function*/
double gaussian(double x, double variance)
{
//	return (1/sqrt(2*variance*variance*M_PI))*exp(-x*x/(2*variance*variance))
		return exp(-x*x/(2*variance*variance));
}

/*I shouldn't need this gaussian table function
	but whatever*/
double * make_gaussian_table(double radius, double length)
{
	int i;
	double total;
	double * returnme = malloc(length*sizeof(double));
	for( i = 0; i < length; i++ )
		    returnme[i] = gaussian(i,radius);	
	total = sum(returnme, length);
	for( i = 0; i < length; i++ )
		returnme[i] = returnme[i]/total;
	return returnme;
}
/* This one takes both the image that you want to blur and the
	 distance out to which to ride the Gaussian*/
struct image * gaussian_blur(struct image * img, double radius)
{
	int i, j, h, w, k;
	int size;
	unsigned char * pixels;
	unsigned short thispixel;
	double * gaussianvals;
	struct image * new;
	h = img->ht;
	w = img-> wid;
	size = h*w;
/*Local array of pixels*/
	pixels = malloc(size*sizeof(char));
	printf("1. Got into gaussian blur\n");	
	/*Do horizontal blur first*/
	gaussianvals = make_gaussian_table(radius, w);
	printf("2. got gaussian values.\n");	
	/*Now start teh bluring*/
	for( i = 0; i < h; i++ )
		for( j = 0; j < w; j++ ){
			k = 0;
//			printf("3: k = %d\n",k);
			/*blur right*/
			//printf("3.5 img->pp[0]: %d\n",(int)(img->pp[0]));
			thispixel = ((unsigned short)(img->pp[twoDtoOneD(i,j,w)]));
			thispixel= thispixel*gaussianvals[0];
			//printf("4: Grabbed the first thingie\n");
			/*walk right until we hit the edge or get under
				a certain threshold*/
			while( (k+i < w) && (gaussianvals[k] > THRESH) )
			{
				thispixel = thispixel + gaussianvals[k]*(img->pp[twoDtoOneD(i+k,j,w)]);
				k++;
			}
			k=0;
			/*blur left*/
			while( (k+i > 0) && (gaussianvals[k] > THRESH) )
			{
				thispixel = thispixel + gaussianvals[-k]*(img->pp[twoDtoOneD(i+k,j,w)]);
				k--;
			}
			
			pixels[twoDtoOneD(i,j,w)] = (char)thispixel;
	}
	printf("3. Did the horizontal blurring.\n");
	/*Now do vertical blurring*/
	if( h > w )
	{
		gaussianvals = realloc(gaussianvals, h*sizeof(char));
		for( i = w; i < h; i++ )
			gaussianvals[i] = gaussian(i, radius);
	}

	for( i = 0; i < h; i++ )
    for( j = 0; j < w; j++ ){
      k = 0;
      /*blur up*/
      thispixel = gaussianvals[0]*(img->pp[twoDtoOneD(i,j,w)]);
      /*walk right until we hit the edge or get under
        a certain threshold*/
      while( (k+j < w) && (gaussianvals[k] > THRESH) )
      {
        thispixel = thispixel + gaussianvals[k]*(img->pp[twoDtoOneD(i,j+k,w)]);
        k++;
      }
      k=0;
      /*blur down*/
      while( (k+j > 0) && (gaussianvals[k] > THRESH) )
      {
        thispixel = thispixel + gaussianvals[-k]*(img->pp[twoDtoOneD(i,j+k,w)]);
        k--;
      }
			pixels[twoDtoOneD(i,j,w)]=(char)thispixel;
	}
	free(gaussianvals);
	//All done, now make teh new image
	new = newimage(w,h, img->bpp);
	for( i =0; i < size; i ++)
		new->pp[i] = pixels[i];
	free(pixels);
	return new;
}

struct image * box_blur(struct image * img)
{
	int i, j, h, w;
	int size;
	struct image * new;
	unsigned short thispixel, left, right, up, down, dr, dl, ur, ul, thisold;
	unsigned char *pixels; // Local pixels array.
	short bitmap = 0;//This tells me whether this is a left, right, down, up
	/*The way the bitmap works is UDLR for the first 4 bits*/
	short avg = 2;
	h = img->ht;
	w = img->wid;
	size = h*w;
	/* Create a local array for all pixels*/
	pixels = malloc(size*sizeof(char));
	/*Now start teh bluring*/
	for( i = 0; i < h; i++ )
		for( j = 0; j < w; j++ ){
			left = (unsigned short)0;
			right = left; //Oh no! Up is down! Left is right!
			up = right; //Cats and dogs living together!
			down = up; //Mass hysteria!
			dr = dl = ur = ul = down; //Get down!
			/*This might be the hackyest line in this entire code. So I'm just
			gonna thorow in some commmentary here. Basically what this does is
			answer the question "Is there a left/right/up/down pixel?"
			That gets answered by whether i, j is zero or whether i +1 or j+1
			is the width/heigth. the double bangs turn all nonzero numbers into
			1 and all the zeros into...zero*/
			bitmap = !(!(i))<<3 | !(!((i+1) % h))<<2 | !(!(j))<<1 | !(!((j+1) % w));
			//Handles upleft, downright, upright, downleft, hilariously long
			bitmap = bitmap | (i && j) << 7
					| (i && ((j+1) % w)) << 6 
					| ((i+1) % h && j) << 5 
					| ((i+1) % h && (j+1) % w) <<4;
			avg = countbits(bitmap, 8) + 1;
			thisold = img->pp[twoDtoOneD(i,j,w)];
			if (bitmap & 1)
				right = (unsigned short)(img->pp[twoDtoOneD(i,j+1,w)]);
			if (bitmap & 1<<1)
				 left = (unsigned short)(img->pp[twoDtoOneD(i,j-1,w)]);
			if(bitmap & 1<<2)
				down = (unsigned short)(img->pp[twoDtoOneD(i+1,j,w)]);
			if(bitmap & 1<<3)
				 up = (unsigned short)(img->pp[twoDtoOneD(i-1,j,w)]);
			if(bitmap & 1<<4)
				 dr = (unsigned short)(img->pp[twoDtoOneD(i+1,j+1,w)]);
			if(bitmap & 1<<5)
				dl = (unsigned short)(img->pp[twoDtoOneD(i+1,j-1,w)]);
			if(bitmap & 1<<6)
				ur = (unsigned short)(img->pp[twoDtoOneD(i-1,j+1,w)]);
			if(bitmap & 1<<7)
				ul = (unsigned short)(img->pp[twoDtoOneD(i-1,j-1,w)]);
			//All done, compute the average
			thispixel = (left+right+up+down + ul + ur + dl + dr + thisold)/avg;
			pixels[twoDtoOneD(i, j, w)] = (char)thispixel;
		}
	//All done, now make teh new image
	new = newimage(w, h, img->bpp);
	for( i = 0; i < size; i++)
		new->pp[i] = pixels[i];
	free(pixels);
	return new;
}

int main(int argc, char * argv[])
{
	double * gaussian;
	int i;
	printf("Greetings and welcome to Dan's image blurer.\n");
	printf("Let's get ready to rumble! \n");
	//struct image * input = read_img(argv[1]);
	//printf("Okay that went okay.\n");
	//struct image * output = box_blur(input);
	//struct image * output = gaussian_blur(input, atof(argv[2]));
	//write_img("blurredimg.pgm", output);
	gaussian = malloc(20*sizeof(double));
	gaussian = make_gaussian_table(atof(argv[2]), 20);
	for ( i = 0; i < 20; i ++ )
		printf("%f\n",gaussian[i]);
	printf("Sum of those numbers is %f\n",sum(gaussian,i));
	printf("also, just for funzies, 1/sqrt(stuff) is %f\n",1/sqrt(2*atof(argv[2])*atof(argv[2])*M_PI));

	
}
