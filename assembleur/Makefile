

CC := GCC

all: asm
	build/asm ../tests_asm/code2.asm code.txt	

clean:
	rm -rf build/*


build/instructions.o: instructions.c
	gcc -c instructions.c -o build/instructions.o
build/main.o: main.c
	gcc -c main.c -o build/main.o
build/parser.o: parser.c
	gcc -c parser.c -o build/parser.o


asm: build/instructions.o build/main.o build/parser.o
	gcc build/instructions.o build/main.o build/parser.o -o build/asm
	