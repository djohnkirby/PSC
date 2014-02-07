%.o: %.cpp
	g++ $(input) -I ../include -L ../bin -lHalide `libpng-config --cflags --ldflags` -o $(output)
