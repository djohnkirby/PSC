#include        <stdio.h>
typedef unsigned long long ticks;       // the full CPU cycle counter is 64 bits
static  __inline__ ticks getticks(void) {       // read the CPU cycle counter
        unsigned a, d;
        asm volatile("rdtsc" : "=a" (a), "=d" (d));
        return ((ticks)a) | (((ticks)d) << 32);
}

#define SEC 10
ticks micros0, micros1;
main(int argc, char *argv[]) {
        int sec = SEC;
        double tdiff;
        if(argc > 1)
                sec = atoi(argv[1]);
        micros0 = getticks();
        sleep(sec);
        micros1 = getticks();
        tdiff = micros1-micros0;
        printf("%g\n", tdiff/sec);
}
