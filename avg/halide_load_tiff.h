#include <Halide.h>
#include <cstdio>
#include <tiffio.h>

using namespace Halide;

using Halide::Image;
template <typename T> 
Halide::Image<uint8_t> load_tiff(const char* filename);
void scan_line(TIFF* tif, Image<T> im);

