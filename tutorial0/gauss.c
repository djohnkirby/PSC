//gcc -O -o gauss gauss.c -ljpeg -ltiff

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <jpeglib.h>
#include <tiffio.h>
#include "myimio.h"

struct image *image;//well...what it sounds like.
int h, w;//image heigth and width
double** gausstable;//stores the blur constants
int i, j; //general iterato
double * gsh;//stores the gauss numbers for each row
double * gsw;//stores the gauss numbers for each column

int factorial(int n)
{
	if (n<= 0)
		return 0;
	if (n == 1)
		return n;
	else
		return n*factorial(n-1);
}

int choose(int n, int i)
{
	return factorial(n)/(factorial(k)*factorial(n-k));
}

//Returns the normalized nth pascal's triangle row.
double* nthpascal(int n)
{
	int i;
	double* returnme = malloc(n*sizeof(double));
	for(i = 0; i <n; i++)
		returnme[i] = ((double)choose(n,i))/n;
	return returnme;
}

int main(int argc, char* argv[])
{
	image = read_img("sample.tiff");
	//Create the table from which we will set the filter weights
	h = image->ht;
	w = image->wid;
	
	//pull the tables of what each weight ought to be
	gausstable = malloc(h*sizeof(int*));
	gsh = nthpascal(h);
	gsw = nthpascal(w);
	
}
