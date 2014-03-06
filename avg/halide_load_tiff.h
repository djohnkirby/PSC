#include <Halide.h>
#include <cstdio>
#include <tiffio.h>

Using namespace Halide;

void scan_line(TIFF* tif, Image<T> im);
template <typename T> Image<T> load_tiff(const char* filename);
