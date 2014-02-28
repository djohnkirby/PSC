// Halide tutorial lesson 2.

// This lesson demonstrates how to pass in input images.

// On linux, you can compile and run it like so:
// g++ lesson_02*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -o lesson_02
// LD_LIBRARY_PATH=../bin ./lesson_02

// On os x:
// g++ lesson_02*.cpp -I ../include -L ../bin -lHalide `libpng-config --cflags --ldflags` -o lesson_02
// DYLD_LIBRARY_PATH=../bin ./lesson_02

// The only Halide header file you need is Halide.h. It includes all of Halide.
#include <Halide.h>

// Include some support code for loading pngs. It assumes there's an
// Image type, so we'll pull the one from Halide namespace;
using Halide::Image;
#include "/home/dkirby/Halide-current/apps/support/image_io.h"

int main(int argc, char **argv) {

		Halide::Func black;
		Halide::Func white;
    Halide::Var x, y, c;
		
    // Normally we'd probably write the whole function definition on
    // one line. Here we'll break it apart so we can explain what
    // we're doing at every step.

    // Clamp it to be less than 255, so we don't get overflow when we
    // cast it back to an 8-bit unsigned int.
    //value = Halide::min(value, 255.0f);

    // Cast it back to an 8-bit unsigned integer.
//    value = Halide::cast<uint8_t>(value);

    // Define the function.
    black(x, y) = 0;
		white(x, y) = 255;
    // The equivalent one-liner to all of the above is:
    //
    // brighter(x, y, c) = Halide::cast<uint8_t>(min(input(x, y, c) * 1.5f, 255));
    //
    // In the shorter version:
    // - I skipped the cast to float, because multiplying by 1.5f does
    //   that automatically.
    // - I also used integer constants in clamp, because they get cast
    //   to match the type of the first argument.
    // - I left the Halide:: off clamp. It's unnecessary due to Koenig
    //   lookup.

    // Remember. All we've done so far is build a representation of a
    // Halide program in memory. We haven't actually processed any
    // pixels yet. We haven't even compiled that Halide program yet.

    // So now we'll realize the Func. The size of the output image
    // should match the size of the input image. If we just wanted to
    // brighten a portion of the input image we could request a
    // smaller size. If we request a larger size Halide will throw an
    // error at runtime telling us we're trying to read out of bounds
    // on the input image.
    Halide::Image<uint8_t> output1 = black.realize(800, 600);
		Halide::Image<uint8_t> output2 = white.realize(800, 600);

    // Save the output for inspection. It should look like a bright parrot.
    save(output1, "input1.png");
		save(output1, "input2.png");
		

    printf("Success!\n");
    return 0;
}
