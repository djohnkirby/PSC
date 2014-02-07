/* atoi example */
#include <stdio.h>      /* printf, fgets */
#include <stdlib.h>     /* atoi */

int main ()
{
  int i;
  char buffer[256];
	for( i = 0; i < 256; i ++ )
		buffer[i] = '\0';
	buffer[0] = '1';
	buffer[1] = '0';
  i = atoi (buffer);
	printf("string: %s, int: %d\n", buffer, i);
  return 0;
}



