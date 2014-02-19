#It's a makefile!

CC= gcc
CFLAGS= -fopenmp -lm

MPvsHalide: getline.h MPvsHalide.h parseFloats.h 
	$(CC) parseFloats.c driver.c noStoreCompute.c storeBuffCompute.c -o MPvsHalide $(CFLAGS)

ProcCom: parseFloats.o getline.o DansProcCom.c
	$(CC) $(CFLAGS) -c DansProcCom.c -o Hai

parseFloats.o : getline.o parseFloats.c
	$(CC) $(CFLAGS) -c parseFloats.c

getline.o : getline.h getline.c
	$(CC) $(CFLAGS) -c getline.c
