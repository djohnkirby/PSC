/***************************************************************************
                        Image Processing - Gaussian Blur
                             -------------------
    begin                : Thu Dec 26 13:05:05 PST 2002
    copyright            : (C) 2002 by Kevin Duraj 
    url                  : http://pacific-design.com
    compile              :  cc -o gaussian gaussian.c -lm

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

 ***************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define mx(a,i,j) (i)*(a)->cols+(j)
/*--------------------------------------------------------------------------*/
typedef struct {
    int rows;
    int cols;
    double *val;
} MATRIX;

MATRIX *r[2], *g[2], *b[2], *kernel, *counter;
/*--------------------------------------------------------------------------*/
void clrscr(void)
{
  printf("\033[2J");           /* Clear the entire screen.            
    */
  printf("\033[0;0f");         /* Move cursor to the top left hand
corner  */
}
/*-------------------------------------------------------------------------*/
MATRIX *matrix_new(int nrows, int ncols)
{
    double *temp;
    MATRIX *m = NULL;
    if ((temp = malloc(nrows * ncols * sizeof(double))) == NULL)
    { printf("allocation failed"); return NULL; }
    if ((m = malloc(sizeof(MATRIX))) == NULL)
    {  printf("allocation failed"); free(temp); return NULL; }

    m->rows = nrows;
    m->cols = ncols;
    m->val = temp;
    return m;
}
/*-------------------------------------------------------------------------*/
void matrix_free(MATRIX * m)
{
    if ( m == NULL) return;
    free(m->val);
    free(m);
}
/*--------------------------------------------------------------------------*/
int ask_for_image()
{
  char filename[128], *c;
  int i=0;

  system("ls -l");
  printf("Enter image filename: ");

  i = 0;
  do {
    c = fgetc(stdin);
    filename[i++] = c;
    fputc(c, stdout);
    fflush(stdout);
  } while (c != '\n');

  filename[i] = '\0';
  i = strlen(filename);

  if(i < 5) { printf("No filename selected!\n"); return 1; }
  else { filename[i-1] = '\0'; load_image(filename); return 0; }
}
/*--------------------------------------------------------------------------*/
void load_image(char *filename)
{
  char sType[8], cmd[512], temp[4];
  int ROW, COL, SIZE, c, i, j, pnm=0;
  FILE *fp;

  clrscr(); printf("Loading %s\n", filename);

  i = strlen(filename);
  c = &filename[i-3];

  system("rm -f temp.* ");

  if((strcmp(c, "jpg")) == NULL)
  { sprintf(cmd, "/usr/bin/jpegtopnm %s > temp.pnm", filename); pnm=1;
}
  else if((strcmp(c, "tif")) == NULL)
  { sprintf(cmd, "/usr/bin/tifftopnm %s > temp.pnm", filename); pnm=1;
}
  else if((strcmp(c, "png")) == NULL)
  { sprintf(cmd, "/usr/bin/pngtopnm %s > temp.pnm",  filename); pnm=1;
}
  else if((strcmp(c, "gif")) == NULL)
  { sprintf(cmd, "/usr/bin/giftopnm %s > temp.pnm",  filename); pnm=1;
}
  else if((strcmp(c, "pnm")) == NULL)
  { sprintf(cmd, "cp %s temp.pnm", filename);                   pnm=1;
}
  else if((strcmp(c, "bmp")) == NULL)
  { sprintf(cmd, "/usr/bin/bmptoppm %s > temp.ppm", filename);        
}
  else if((strcmp(c, "tga")) == NULL)
  { sprintf(cmd, "/usr/bin/tgatoppm %s > temp.ppm", filename);        
}
  else
  { printf("%s is no valid filename ext[jpg, tif, png, gif, tga]\n",
c); return; }

  system(cmd);

  if(pnm) { if((fp = fopen("temp.pnm","rb")) == NULL)
  { fprintf(stderr, "Enable to open file"); exit(1); } }
  else    { if((fp = fopen("temp.ppm","rb")) == NULL)
  { fprintf(stderr, "Enable to open file"); exit(1); } }

  fscanf(fp, "%s %d %d %d", sType, &COL, &ROW, &SIZE);
  printf("Image Type: %s\n", sType);
  printf("COL: %d\tROW: %d\tMAX SIZE: %d", COL, ROW, SIZE);

  /* read 1 space */
  c = fgetc(fp); printf("%c", c);

  r[0] = matrix_new( ROW, COL );
  g[0] = matrix_new( ROW, COL );
  b[0] = matrix_new( ROW, COL );

  r[1] = matrix_new( ROW, COL );
  g[1] = matrix_new( ROW, COL );
  b[1] = matrix_new( ROW, COL );

  counter= matrix_new( ROW, COL );

  for(i=0; i<ROW; i++)
  {
    for(j=0; j<COL; j++)
    {
       c = fgetc(fp);  r[0]->val[mx(r[0],i,j)] = c;
       c = fgetc(fp);  g[0]->val[mx(g[0],i,j)] = c;
       c = fgetc(fp);  b[0]->val[mx(b[0],i,j)] = c;
    }
  }

  fclose(fp);

}
/*--------------------------------------------------------------------------*/
void compute_kernel(int radius)
{
  int x, y, i, j, size;
  double tval, coefficient;

  size = (radius*2) + 1;
  kernel = matrix_new(size,size);

  coefficient = -2 / pow(radius,2);

  i=0;
  for(y=-radius; y<=radius; y++)
  {
    j=0;
    for(x=-radius; x<=radius; x++)
    {
      kernel->val[mx(kernel,i,j)] = exp(coefficient * (pow(x,2) +
pow(y,2)));
      j++;
    } i++;
  }
}
/*--------------------------------------------------------------------------*/
void write_new_pnm( int size, MATRIX *r, MATRIX *g, MATRIX *b )
{
  int SIZE, c, i, j;
  FILE *fp;

  if((fp = fopen("new.pnm","wb")) == NULL)
  { fprintf(stderr, "Enable to open file"); exit(1); }

  fprintf(fp, "P6\n%d %d\n%d\n", r->cols, r->rows, size);
  printf("Writting COL: %d\tROW: %d\tMAX SIZE: %d\n", r->cols,
r->rows, size);

  fflush(stdout);

  for (i=0; i < r->rows; i++)
  {
      for (j = 0; j < r->cols; j++)
      {
          c = r->val[mx(r,i,j)]; fputc(c, fp);
          c = g->val[mx(g,i,j)]; fputc(c, fp);
          c = b->val[mx(b,i,j)]; fputc(c, fp);
      }
  }

  fclose(fp);
  fflush(stdout);

  system("gqview new.pnm &");
}
/*-------------------------------------------------------------------------*/
/* Gaussian Blur                                                      
     */
/*-------------------------------------------------------------------------*/
static GaussianBlur(MATRIX *a, MATRIX *b, int radius)
{
  int crow, ccol, i, j, ki, kj;
  unsigned long index=0;
  double convolution, coefficient=0.0;

  compute_kernel(radius);

  /*--- adding all the value of kernel ---*/
  for(i=0; i<5; i++)
    for(j=0; j<5; j++)
      coefficient += kernel->val[mx(kernel,i,j)];

  /* initialize counter matrix to 0.0 */
  index=0;
  for (i=0; i < counter->rows; i++)
  {
    for (j=0; j < counter->cols; j++)
    {
      counter->val[index] = 0.0;
      index++;
    }
  }

  index=0;
  /******************* Source Matrix Loop **************************/
  for(crow=0; crow < a->rows; crow++)
  {
    for(ccol=0; ccol < a->cols; ccol++)
    {
      /*=================== Kernel Matrix Loop =====================*/
      ki=0;
      for (i=crow-radius; i<crow+radius+1; i++)
      {
        kj=0;
        for (j=ccol-radius; j<ccol+radius+1; j++)
        {
          index++;

          if((i >= 0) && (j >=0) && (i < a->rows) && (j < a->cols))
          {
            if(a->val[mx(a,i,j)] != 0)
            {
              index++;
              b->val[mx(b,crow,ccol)] += a->val[mx(a,i,j)] * kernel->val[mx(kernel,ki,kj)];
              counter->val[mx(counter,crow,ccol)] += kernel->val[mx(kernel,ki,kj)];
              fflush(stdout);
            }
          }
          kj++;
        }
        ki++;
      }
      /*================= End of Kernel Loop ===================*/
      if(counter->val[mx(counter,crow,ccol)] == 0) b->val[mx(b,crow,ccol)] = 0;
      else 
b->val[mx(b,crow,ccol)] = b->val[mx(b,crow,ccol)] / counter->val[mx(counter,crow,ccol)];
    }
  }
  /********************** End of Source Loop ********************/
  
  printf("Coefficient : %3.0f\n", coefficient);
  printf("Total calculations: %d\n", index);

}
/*-------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
  char str[80];
  
  if(ask_for_image()) { printf("Exiting\n"); return EXIT_FAILURE;}
  printf("Input Radius: ");
  fgets(str, 80, stdin);
  printf("Computing Radius is: %s ", str);

  GaussianBlur(r[0], r[1], atoi(str));
  GaussianBlur(g[0], g[1], atoi(str));
  GaussianBlur(b[0], b[1], atoi(str));
  write_new_pnm( 255, r[1], g[1], b[1] );

  matrix_free(r[0]);  matrix_free(b[0]);  matrix_free(g[0]);
  matrix_free(r[1]);  matrix_free(b[1]);  matrix_free(g[1]);
  matrix_free(kernel);
  matrix_free(counter);

  return EXIT_SUCCESS;
}
/*-------------------------------------------------------------------------*/


