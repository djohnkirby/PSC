#It's a makefile!

CC= gcc
CFLAGS=		-pedantic -ansi -W -Wall -Wextra -fopenmp -lm

ProcCom: parseFloats.o getline.o
	$(CC) $(CFLAGS) -c DansProcCom.c

parseFloats.o : getline.o 
	$(CC) $(CFLAGS) -c parseFloats.c

getline.o : getline.c getline.h
	$(CC) $(CFLAGS) -c getline.c
