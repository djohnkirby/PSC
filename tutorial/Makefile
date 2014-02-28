all: lesson_01 lesson_02 lesson_03 lesson_04 lesson_05 lesson_06 lesson_07 lesson_08 lesson_09

lesson_01: lesson_01_basics.cpp
	 g++ lesson_01*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_01

lesson_02: lesson_02_input_image.cpp
	 g++ lesson_02*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -lpng -o lesson_02

lesson_03: lesson_03_debugging_1.cpp
	g++ lesson_03*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_03

lesson_04: lesson_04_debugging_2.cpp
	g++ lesson_04*.cpp -I ../include -L ../bin -rdynamic -lHalide -lpthread -ldl -o lesson_04

lesson_05: lesson_05_scheduling_1.cpp
	g++ lesson_05*.cpp -I ../include -L ../bin -rdynamic -lHalide -lpthread -ldl -o lesson_05

lesson_06: lesson_06_realizing_over_shifted_domains.cpp 
	g++ lesson_06*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_06

lesson_07: lesson_07_multi_stage_pipelines.cpp
	g++ lesson_07*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_07

lesson_08: lesson_08_scheduling_2.cpp 
	g++ lesson_08*.cpp -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_08

lesson_09: lesson_09_update_definitions.cpp
	g++ lesson_09*.cpp -I /home/dkirby/Halide-current/include -L /home/dkirby/Halide-current/bin -lHalide -lpthread -ldl -fopenmp -o lesson_09

clean:
	rm lesson_01 lesson_02 lesson_03 lesson_04 lesson_05 lesson_06 lesson_07 lesson_08 lesson_09
