all: avg make_images

avg_c: avg.c
	gcc avg.c -acc -ta=nvidia -Minfo=accel -lpng -ljpeg -ltiff -o avg_c

avg: avg.cpp
	 g++ avg.cpp -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -ljpeg -ltiff -o avg

make_images: make_images.cpp
	g++ make_images.cpp -I  /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -o make_images

clean:
	rm avg make_images	
