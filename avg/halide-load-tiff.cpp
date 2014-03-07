// To compile this, you need to link libpng and libtiff:
// clang++ `libpng-config --cflags --ldflags` -lHalide -ltiff halide-load-tiff.cpp
 
#include <Halide.h>
#include <cstdio>
 
using namespace Halide;
#include "../apps/support/image_io.h"
 
#include "tiffio.h"
 
// For tiff format and libtiff, read the following pages.
// http://www.underworldproject.org/documentation/LibTiffDownload.html
// http://www.awaresystems.be/imaging/tiff/tifftags.html
// http://www.remotesensing.org/libtiff/libtiff.html
// http://www.remotesensing.org/libtiff/man/TIFFReadRGBAImage.3tiff.html
 
 
// Adapted from http://stackoverflow.com/a/5484594/1461206
 
//Only for single channel images. (SamplesPerPixel == 1)
template <typename U,typename T>
void scan_line(TIFF* tif, Image<T> im)
{
uint32 imagelength;
TIFFGetField(tif, TIFFTAG_IMAGELENGTH, &imagelength);
tsize_t scanline = TIFFScanlineSize(tif);
T *ptr = (T*)im.data();
U* buf = (U*)_TIFFmalloc(scanline);
for (uint32 row = 0; row < imagelength; row++) {
TIFFReadScanline(tif, buf, row);
for (uint32 col = 0; col < scanline / sizeof(U); col++){
convert(buf[col], *(ptr++));
}
}
_TIFFfree(buf);
}
 
template <typename T>
Image<T> load_tiff(const char* filename) {
Func gray,gray2;
Var x,y,c;
 
TIFF* tif = TIFFOpen(filename,"r");
 
if (tif) {
uint32 w, h, ch, bits;
 
TIFFGetField(tif, TIFFTAG_IMAGEWIDTH, &w);
TIFFGetField(tif, TIFFTAG_IMAGELENGTH, &h);
TIFFGetField(tif, TIFFTAG_SAMPLESPERPIXEL, &ch);
TIFFGetField(tif, TIFFTAG_BITSPERSAMPLE, &bits);
 
Image<T> im(w,h,ch);
printf("%d x %d x %d, %d bits\n",w,h,ch,bits);
 
size_t npixels = w * h;
 
T *ptr = (T*)im.data();
int c_stride = im.stride(2);
 
_assert((ch == 3 && bits == 8) || (ch == 1 && (bits == 8 || bits == 16)),
"Not supported format.\n");
 
if(ch == 3 && bits == 8){
uint32* raster = (uint32*) _TIFFmalloc(npixels * sizeof (uint32));
if (raster != NULL && TIFFReadRGBAImage(tif, w, h, raster, 0)) {
for (int y = h - 1; y >= 0; y--) {
uint8_t* srcPtr = (uint8_t*)&(raster[w * y]);
for (int x = 0; x < w; x++) {
for (int c = 0; c < ch; c++) {
convert(*srcPtr++, ptr[c*c_stride]);
}
srcPtr++;
ptr++;
}
}
_TIFFfree(raster);
}
} else if (ch == 1){
if (bits == 8) {
scan_line<uint8_t,T>(tif,im);
}else if (bits == 16) {
scan_line<uint16_t,T>(tif,im);
}
}else{
_assert(false, "Not supported format.\n");
return Image<T>(0,0,1);
}
TIFFClose(tif);
 
im.set_host_dirty();
return im;
 
}else{
return Image<T>(0,0,1);
}
}
 
int main(int argc, char **argv) {
Image<uint16_t> im = load_tiff<uint16_t>(argv[1]);
printf("%d x %d x %d\n",im.width(),im.height(),im.channels());
save(im,"out_tiffread.png");
return 0;
}
