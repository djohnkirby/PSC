#ifndef HALIDE_avg_h
#define HALIDE_avg_h
#ifndef BUFFER_T_DEFINED
#define BUFFER_T_DEFINED
#include <stdint.h>
typedef struct buffer_t {
    uint64_t dev;
    uint8_t* host;
    int32_t extent[4];
    int32_t stride[4];
    int32_t min[4];
    int32_t elem_size;
    bool host_dirty;
    bool dev_dirty;
} buffer_t;
#endif
#ifndef HALIDE_FUNCTION_ATTRS
#define HALIDE_FUNCTION_ATTRS
#endif
extern "C" int avg_h(buffer_t *p0, buffer_t *p1, buffer_t *f0) HALIDE_FUNCTION_ATTRS;
#endif
