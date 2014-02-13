#It's a makefile!

CC= gcc
CFLAGS= -fopenmp -lm

ProcCom: parseFloats.o getline.o DansProcCom.c
	$(CC) $(CFLAGS) -c DansProcCom.c -o Hai

parseFloats.o : getline.o parseFloats.c
	$(CC) $(CFLAGS) -c parseFloats.c

getline.o : getline.h getline.c
	$(CC) $(CFLAGS) -c getline.c
