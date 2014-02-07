#include <iostream>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>

extern "C" void *halide_malloc(size_t);
extern "C" void halide_free(void *);
extern "C" int halide_debug_to_file(const char *filename, void *data, int, int, int, int, int, int);
extern "C" int halide_start_clock();
extern "C" int64_t halide_current_time_ns();
extern "C" uint64_t halide_profiling_timer();
extern "C" int halide_printf(const char *fmt, ...);

#ifdef _WIN32
extern "C" float roundf(float);
extern "C" double round(double);
#else
inline float asinh_f32(float x) {return asinhf(x);}
inline float acosh_f32(float x) {return acoshf(x);}
inline float atanh_f32(float x) {return atanhf(x);}
inline double asinh_f64(double x) {return asinh(x);}
inline double acosh_f64(double x) {return acosh(x);}
inline double atanh_f64(double x) {return atanh(x);}
#endif
inline float sqrt_f32(float x) {return sqrtf(x);}
inline float sin_f32(float x) {return sinf(x);}
inline float asin_f32(float x) {return asinf(x);}
inline float cos_f32(float x) {return cosf(x);}
inline float acos_f32(float x) {return acosf(x);}
inline float tan_f32(float x) {return tanf(x);}
inline float atan_f32(float x) {return atanf(x);}
inline float sinh_f32(float x) {return sinhf(x);}
inline float cosh_f32(float x) {return coshf(x);}
inline float tanh_f32(float x) {return tanhf(x);}
inline float hypot_f32(float x, float y) {return hypotf(x, y);}
inline float exp_f32(float x) {return expf(x);}
inline float log_f32(float x) {return logf(x);}
inline float pow_f32(float x, float y) {return powf(x, y);}
inline float floor_f32(float x) {return floorf(x);}
inline float ceil_f32(float x) {return ceilf(x);}
inline float round_f32(float x) {return roundf(x);}

inline double sqrt_f64(double x) {return sqrt(x);}
inline double sin_f64(double x) {return sin(x);}
inline double asin_f64(double x) {return asin(x);}
inline double cos_f64(double x) {return cos(x);}
inline double acos_f64(double x) {return acos(x);}
inline double tan_f64(double x) {return tan(x);}
inline double atan_f64(double x) {return atan(x);}
inline double sinh_f64(double x) {return sinh(x);}
inline double cosh_f64(double x) {return cosh(x);}
inline double tanh_f64(double x) {return tanh(x);}
inline double hypot_f64(double x, double y) {return hypot(x, y);}
inline double exp_f64(double x) {return exp(x);}
inline double log_f64(double x) {return log(x);}
inline double pow_f64(double x, double y) {return pow(x, y);}
inline double floor_f64(double x) {return floor(x);}
inline double ceil_f64(double x) {return ceil(x);}
inline double round_f64(double x) {return round(x);}

inline float maxval_f32() {return FLT_MAX;}
inline float minval_f32() {return -FLT_MAX;}
inline double maxval_f64() {return DBL_MAX;}
inline double minval_f64() {return -DBL_MAX;}
inline uint8_t maxval_u8() {return 0xff;}
inline uint8_t minval_u8() {return 0;}
inline uint16_t maxval_u16() {return 0xffff;}
inline uint16_t minval_u16() {return 0;}
inline uint32_t maxval_u32() {return 0xffffffff;}
inline uint32_t minval_u32() {return 0;}
inline uint64_t maxval_u64() {return 0xffffffffffffffff;}
inline uint64_t minval_u64() {return 0;}
inline int8_t maxval_s8() {return 0x7f;}
inline int8_t minval_s8() {return 0x80;}
inline int16_t maxval_s16() {return 0x7fff;}
inline int16_t minval_s16() {return 0x8000;}
inline int32_t maxval_s32() {return 0x7fffffff;}
inline int32_t minval_s32() {return 0x80000000;}
inline int64_t maxval_s64() {return 0x7fffffffffffffff;}
inline int64_t minval_s64() {return 0x8000000000000000;}

inline int8_t abs_i8(int8_t a) {return a >= 0 ? a : -a;}
inline int16_t abs_i16(int16_t a) {return a >= 0 ? a : -a;}
inline int32_t abs_i32(int32_t a) {return a >= 0 ? a : -a;}
inline int64_t abs_i64(int64_t a) {return a >= 0 ? a : -a;}
inline float abs_f32(float a) {return fabsf(a);}
inline double abs_f64(double a) {return fabs(a);}

inline float nan_f32() {return NAN;}
inline float neg_inf_f32() {return -INFINITY;}
inline float inf_f32() {return INFINITY;}

template<typename T> T max(T a, T b) {if (a > b) return a; return b;}
template<typename T> T min(T a, T b) {if (a < b) return a; return b;}
template<typename T> T mod(T a, T b) {T result = a % b; if (result < 0) result += b; return result;}
template<typename T> T sdiv(T a, T b) {return (a - mod(a, b))/b;}
template<typename A, typename B> A reinterpret(B b) {A a; memcpy(&a, &b, sizeof(a)); return a;}

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
bool halide_rewrite_buffer(buffer_t *b, int32_t elem_size,
                           int32_t min0, int32_t extent0, int32_t stride0,
                           int32_t min1, int32_t extent1, int32_t stride1,
                           int32_t min2, int32_t extent2, int32_t stride2,
                           int32_t min3, int32_t extent3, int32_t stride3) {
 b->min[0] = min0;
 b->min[1] = min1;
 b->min[2] = min2;
 b->min[3] = min3;
 b->extent[0] = extent0;
 b->extent[1] = extent1;
 b->extent[2] = extent2;
 b->extent[3] = extent3;
 b->stride[0] = stride0;
 b->stride[1] = stride1;
 b->stride[2] = stride2;
 b->stride[3] = stride3;
 return true;
}
extern "C" int gradient(buffer_t *_gradient) {
int32_t *gradient = (int32_t *)(_gradient->host);
const bool gradient_host_and_dev_are_null = (_gradient->host == NULL) && (_gradient->dev == 0);
(void)gradient_host_and_dev_are_null;
const int32_t gradient_min_0 = _gradient->min[0];
(void)gradient_min_0;
const int32_t gradient_min_1 = _gradient->min[1];
(void)gradient_min_1;
const int32_t gradient_min_2 = _gradient->min[2];
(void)gradient_min_2;
const int32_t gradient_min_3 = _gradient->min[3];
(void)gradient_min_3;
const int32_t gradient_extent_0 = _gradient->extent[0];
(void)gradient_extent_0;
const int32_t gradient_extent_1 = _gradient->extent[1];
(void)gradient_extent_1;
const int32_t gradient_extent_2 = _gradient->extent[2];
(void)gradient_extent_2;
const int32_t gradient_extent_3 = _gradient->extent[3];
(void)gradient_extent_3;
const int32_t gradient_stride_0 = _gradient->stride[0];
(void)gradient_stride_0;
const int32_t gradient_stride_1 = _gradient->stride[1];
(void)gradient_stride_1;
const int32_t gradient_stride_2 = _gradient->stride[2];
(void)gradient_stride_2;
const int32_t gradient_stride_3 = _gradient->stride[3];
(void)gradient_stride_3;
const int32_t gradient_elem_size = _gradient->elem_size;
if (gradient_host_and_dev_are_null)
{
 bool V0 = halide_rewrite_buffer(_gradient, 4, gradient_min_0, gradient_extent_0, 1, gradient_min_1, gradient_extent_1, gradient_extent_0, 0, 0, 0, 0, 0, 0);
 (void)V0;
} // if gradient_host_and_dev_are_null
bool V1 = !(gradient_host_and_dev_are_null);
if (V1)
{
 bool V2 = gradient_elem_size == 4;
 if (!V2) {
  halide_printf("Output buffer gradient has type int32, but elem_size of the buffer_t passed in is not 4\n");
  return -1;
 }
 bool V3 = gradient_stride_0 == 1;
 if (!V3) {
  halide_printf("Static constraint violated: gradient.stride.0 == 1\n");
  return -1;
 }
 for (int gradient_y = gradient_min_1; gradient_y < gradient_min_1 + gradient_extent_1; gradient_y++)
 {
  for (int gradient_x = gradient_min_0; gradient_x < gradient_min_0 + gradient_extent_0; gradient_x++)
  {
   int32_t V4 = gradient_y - gradient_min_1;
   int32_t V5 = V4 * gradient_stride_1;
   int32_t V6 = gradient_x - gradient_min_0;
   int32_t V7 = V6 + V5;
   int32_t V8 = gradient_x + gradient_y;
   gradient[V7] = V8;
  } // for gradient_x
 } // for gradient_y
} // if V1
return 0;
}
