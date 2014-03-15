all: avg_h

avg_c: avg.c
	gcc avg.c -lpng -ljpeg -ltiff -o avg_c

avg_hs_driver: avg_hs_driver.cpp avg_hs.o
	g++ avg_hs_driver.cpp avg_h.o -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -o avg_h_static

avg_hs.o: avg_hs
	./avg_hs

avg_hs: ../../  avg_h.cpp
	$(MAKE) -C ../../ $(LIB_HALIDE)
	g++ avg_h.cpp -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin/ -lHalide -lpthread -ldl -lpng -o avg_hs

avg_h: avg.cpp
	 g++ avg.cpp -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -ljpeg -ltiff -o avg_h

make_images: make_images.cpp
	g++ make_images.cpp -I  /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -lpng -o make_images

clean:
	rm avg make_images	
