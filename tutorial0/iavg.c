// gcc -O -o iavg iavg.c -ljpeg -ltiff 
// gcc -o iavg -O3 -m64 -msse3 iavg.c -ltiff -lfftw3f
// icc -o iavg -O3 -ip -xSSE4.2 -no-prec-div -unroll-agressive -m64 -Wl,-z-ffast-math iavg.c -ltiff -lfftw3f
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <jpeglib.h>
#include <tiffio.h>
#include "myimio.h"

struct image *im0, *im1;

int mode = -1;
int pcount = 4;
unsigned int *intimg;
unsigned char *cntimg; // make it an int later for bigger stacks XXX
unsigned char *minimg, *maximg;
int reversevid;

char *modest[] = {
	"avg", // 0
	"max-min", // 1
	"min", // 2
	"max", // 3
	"hdiffs", // 4
	"stack", // 5 = output volume with no headers between layers
	"integral", // 6 = output integral volume with no headers between layers
	"pixelavg" // average only non 0 pixels - uses big counter array
};

int quiet;
unsigned int hist[256], min = 4000000000, max = 0;
int main(int argc, char* argv[]) {
	int n = 1, i, x, y, size;

	while(argv[1][0] == '-') {
		if(argv[1][1] == 'r')
			reversevid = 1;
		else if(argv[1][1] == 'q')
			quiet++;
		else if(argv[1][1] == 's')
			mode = 5;
		else if(argv[1][1] == 'i')
			mode = 6;
		else if(argv[1][1] == 'a')
			mode = 0;
		else if(argv[1][1] == 'p') {
			mode = 7;
			if(argv[1][2])
				pcount = atoi(argv[1]+2);
if(!quiet)
fprintf(stderr, "pcount thresh %d\n", pcount);
		} else
			mode = atoi(argv[1]+1);
if(!quiet)
fprintf(stderr, "mode %d = %s\n", mode, modest[mode]);
		argv++;
		argc--;
	}
	im0 = read_img(argv[1]);
if(!quiet)
fprintf(stderr, "%d: %s  %d %d %d\n", n, argv[1], im0->wid, im0->ht, im0->bpp);
	size = im0->ht * im0->wid * im0->bpp;
	intimg = malloc(size*sizeof(unsigned int));
	minimg = malloc(size*sizeof(unsigned char));
	maximg = malloc(size*sizeof(unsigned char));
	cntimg = malloc(size*sizeof(unsigned char)); // non 0 pixel counter

	for(i = 0; i < size; i++) {
		int v = im0->pp[i];
		if(reversevid) {
			v = 0xFF & (255-v);
			im0->pp[i] = v;
		}
		hist[v]++;
		if(mode == 4) {
			v = im0->pp[i-1] - im0->pp[i+1];
			if(v < 0)
				v = -v;
		}
		intimg[i] = v;
		minimg[i] = v;
		maximg[i] = v;
	}
	if(mode == 5)
		write(1, im0->pp, size);
	else if(mode == 6)
		write(1, intimg, size*sizeof(int));
	argc -= 2;
	argv += 2;
	while(argc > 0) {
		free(im0->pp);
		free(im0);
		im0 = read_img(argv[0]);
if(!quiet)
fprintf(stderr, "%d: %s  %d %d %d\n", n, argv[0], im0->wid, im0->ht, im0->bpp);
		if(size != im0->ht*im0->wid*im0->bpp) {
			fprintf(stderr, "old size %d -- break\n", size);
			break;
			//exit(1);
		}
		n++;
		for(i = 0; i < size; i++) {
			int v = im0->pp[i];
			if(reversevid) {
				v = 0xFF&(255-v);
				im0->pp[i] = v;
			}
			hist[v]++;
			if(mode == 4) {
				v = im0->pp[i-1] - im0->pp[i+1];
				if(v < 0)
					v = -v;
			}
			intimg[i] += v;
			if(v < minimg[i])
				minimg[i] = v;
			if(v > maximg[i])
				maximg[i] = v;
			if(v)
				cntimg[i]++;
		}
		if(mode == 5)
			write(1, im0->pp, size);
		else if(mode == 6)
			write(1, intimg, size*sizeof(unsigned int));
		else if(mode == 7) {
			char hdr[100];
			int fd = creat("pixcnt.pgm", 0666);
			sprintf(hdr, "P5\n%d %d\n255\n", im0->wid, im0->ht);
			write(fd, hdr, strlen(hdr));
			write(fd, cntimg, size*sizeof(unsigned char));
		}
		argc--;
		argv++;
	}
if(quiet <= 1)
fprintf(stderr, "%d source images\n", n);
	switch(mode) {
	case 0:
/*
		for(i = 0; i < 256; i++)
			if(hist[i])
				break;
		min  = i;
		for( ; i < 256; i++)
			if(hist[i])
				max = i;
		fprintf(stderr, "minmax %d %d\n", min, max);
		for(i = 0; i < size; i++)
			im0->pp[i] = 255.0*(im0->pp[i]-min)/(max-min);
*/
		// XXXX not fixed for RGB color
//fprintf(stderr, "starting minmax %d %d\n", min, max);
		for(i = 0; i < size; i++)
			if(intimg[i] > max)
				max = intimg[i];
			else if(intimg[i] < min)
				min = intimg[i];
//fprintf(stderr, "minmax %d %d\n", min, max);
		for(i = 0; i < size; i++)
			im0->pp[i] = 255.99*(intimg[i]-min)/(max-min);
		break;
	case 1:		// max - min
		for(i = 0; i < size; i++)
	       		im0->pp[i] = maximg[i] - minimg[i];
		break;
	case 2:		// min
		for(i = 0; i < size; i++)
	       		im0->pp[i] = minimg[i];
		break;
	case 3:		// max
		for(i = 0; i < size; i++)
	       		im0->pp[i] = maximg[i];
		break;
	case 5:
		break;
	case 7:		// pixel count average // "apodize edge to mid gray
		for(i = 0; i < size; i++)
			if(cntimg[i] >= 4) // get arg from cmd line
	       			im0->pp[i] = intimg[i] / cntimg[i];
			else
				im0->pp[i] = 150;  /// XXX compute this!!!
		break;
	default:	// else use avg mode
		for(i = 0; i < size; i++)
			im0->pp[i] = intimg[i] / n;
		break;
	}
	if(mode == 5 || mode == 6)
		return(0);
	if(im0->bpp == 3)
		printf("P6\n%d %d\n255\n", im0->wid, im0->ht);
	else
		printf("P5\n%d %d\n255\n", im0->wid, im0->ht);
	fflush(stdout);
	write(1, im0->pp, size);
	return(0);
}
