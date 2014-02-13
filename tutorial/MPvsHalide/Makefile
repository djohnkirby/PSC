#It's a makefile!

CC= gcc
CFLAGS= -fopenmp -lm

ProcCom: parseFloats.o getline.o
	$(CC) $(CFLAGS) -c DansProcCom.c

parseFloats.o : getline.o 
	$(CC) $(CFLAGS) -c parseFloats.c

getline.o : getline.h getline.c
	$(CC) $(CFLAGS) -c getline.c
