#include <stdio.h>

#define HEIGHT 2
#define WIDTH  3

int main(void)
{
  FILE *myfile;
  double myvariable;
  int i;
  int j;

  myfile=fopen("myfile.txt", "r");

  for(i = 0; i < HEIGHT; i++)
  {
    for (j = 0 ; j < WIDTH; j++)
    {
      fscanf(myfile,"%lf",&myvariable);
      printf("%.15f ",myvariable);
    }
    printf("\n");
  }

  fclose(myfile);
}
