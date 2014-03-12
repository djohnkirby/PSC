#include <Halide.h>
#include <tiffio.h>
using Halide::Image;

readTiff(TIFF * input)
{
  uint32 imagelength;
  tdata_t buf;
  uint32 row;
  TIFFGetField(input, TIFFTAG_IMAGELENGTH, &imagelength);
  buf = _TIFFmalloc(TIFFScanlineSize(input));

  for (row = 0; row < imagelength; row++)
  {
   tiffreadscanline(input, buf, row);
   /* This is where we have the buf, load into Halide here? */
		
  _tifffree(buf);
  }

}
