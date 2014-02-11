/* This pulls floats formatted like %f %f %f %f\n %f %f %f %f\n and puts them in a 2D array maximum of 10000 character lines. Not neccessarily the same length each. */
#define LINE_LENGTH 10000
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <getline.h>

int countSpaces(char * line)
{
	int returnMe = 0;
	char * ptr;
	ptr = line;
	while( strlen(ptr) > 0)
	{
		if(*ptr == ' ')
			returnMe++;
		ptr = ptr + 1;
	}
	return returnMe;
}

float ** parseFloats(char * filename)
{
	FILE * myfile;
	int i, j, h, w;
	float myvariable;
	float ** floats;
	char * line;
	myfile = fopen( filename, "r" );

	if ( !myfile )
	{
		printf("No filename detected, exiting!\n");
		exit(EXIT_FAILURE);	
	}
	h = 0;
	w = 0;

	while( fgetline_123(&line, myfile) )
	{ 
		 h ++;
		 i = countSpaces( line ) + 1;
     if( i > w)
			w = i;
	}

	floats = malloc(h*sizeof(float*));
	for( i = 0; i < h; i ++ )
		floats[i] = calloc( w, sizeof(float));
	
	rewind( myfile );

  for(i = 0; i < h; i++)
  {
    for (j = 0 ; j < w; j++)
    {
       fscanf(myfile,"%f",&myvariable);
       floats[i][j] = myvariable;
    }
  }
	return floats; 
}


/*int main()
{
	float ** floats = parseFloats("Halide_solution.txt");
	return 0;
}
*/
