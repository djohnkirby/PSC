#It's a makefile!

CC= gcc
CFLAGS= -fopenmp -lm -g2

MPvsHalide: getline.h MPvsHalide.h parseFloats.h 
	$(CC) getline.c parseFloats.c driver.c noStoreComputeNoChunk.c noStoreComputeChunked.c storeBuffCompute.c storeAllCompute.c -o MPvsHalide $(CFLAGS)

ProcCom: parseFloats.o getline.o DansProcCom.c
	$(CC) $(CFLAGS) -c DansProcCom.c -o Hai

parseFloats.o : getline.o parseFloats.c
	$(CC) $(CFLAGS) -c parseFloats.c

getline.o : getline.h getline.c
	$(CC) $(CFLAGS) -c getline.c

clean: MPvsHalide
	rm MPvsHalide
