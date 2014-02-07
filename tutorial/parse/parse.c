#include <stdlib.h>
#include <stdio.h>

int main()
{
	FILE * input = fopen("123.txt", "rt");
	char line[10];
	char num[11];
	int nums[10];
	int i, j, k;
	char * ptr;

	fgets(line, 80, input);
	printf("%s\n", line);
	ptr = line;
	for( i = 0; i < 10; i ++ )
		nums[i] = 0;
	for( i = 0; i < 10; i ++ )
	{
		j = 0;
		for( k = 0; k < 11; k ++ )
  	  num[k] = '\0';
		while( *ptr != ' ' && j < 10)
		{
			num[j] = *ptr;
			j++;
			ptr++;
			printf("num now: %s\n", num);
			}
		printf("atoi(num) = %d\n", atoi(num));
		nums[i] = atoi(num);
		printf("nums[%d] = %d\n", i, nums[i]);
		if( *ptr != '\n')
			ptr = ptr + 1;
		//printf("%s\n", ptr);
		j = 0;
	}

	for( i = 0; i < 10; i ++ )
		printf("%d, ", nums[i]);
	printf("\n");

	return 0;	
}
