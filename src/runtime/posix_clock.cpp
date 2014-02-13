#include "mini_stdint.h"

#ifndef _STRUCT_TIMEVAL
#define _STRUCT_TIMEVAL

#ifdef BITS_64
struct timeval {
    int64_t tv_sec, tv_usec;
};
#else
struct timeval {
    int32_t tv_sec, tv_usec;
};
#endif

#endif

extern "C" {

extern int gettimeofday(timeval *tv, void *);

WEAK bool halide_reference_clock_inited = false;
WEAK timeval halide_reference_clock;

WEAK int halide_start_clock(void *user_context) {
    // Guard against multiple calls
    if (!halide_reference_clock_inited) {
      gettimeofday(&halide_reference_clock, NULL);
      halide_reference_clock_inited = true;
    }
    return 0;
}

// clock_gettime() is preferred over gettimeofday(), but OSX
// doesn't provide the former. (Use linux_clock.cpp to use clock_gettime(),
// which will provide actual nanosecond accuracy.)
WEAK int64_t halide_current_time_ns(void *user_context) {
    timeval now;
    gettimeofday(&now, NULL);
    int64_t d = int64_t(now.tv_sec - halide_reference_clock.tv_sec)*1000000;
    int64_t ud = int64_t(now.tv_usec) - int64_t(halide_reference_clock.tv_usec);
    return (d + ud) * 1000;
}

}