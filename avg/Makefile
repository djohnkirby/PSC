all: avg_h

avg_c: avg.c
	gcc avg.c -lpng -o avg_c

avg_h: avg.cpp
	 g++ avg.cpp -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -ljpeg -ltiff -o avg_h

make_images: make_images.cpp
	g++ make_images.cpp -I  /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -o make_images

clean:
	rm avg make_images	
