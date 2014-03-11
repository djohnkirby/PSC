all: avg make_images

avg: avg.cpp
	 g++ avg.cpp halide_load_tiff.o -I /home/dkirby/Halide-master/include -L /home/dkirby/Halide-master/bin -lHalide -lpthread -ldl -lpng -o avg

make_images: make_images.cpp
	g++ make_images.cpp -I  /home/dkirby/Halide-master/include -L /home/dkirby/Halide-master/bin -lHalide -lpthread -ldl -lpng -o make_images

halide_load_tiff: halide_load_tiff.cpp
	 g++  `libpng-config --cflags --ldflags` -ltiff halide_load_tiff.cpp -I /home/dkirby/Halide-master/include -L /home/dkirby/Halide-master/bin -lHalide -o halide_load_tiff 

clean:
	rm avg make_images halide_load_tiff	
