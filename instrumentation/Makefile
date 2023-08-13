.PHONY: all build disass clean
all: build
build:
	mkdir -p patches/generated
	rm -rf patches/generated/*
	gcc -c -fno-stack-protector -fcf-protection=none -masm=intel -S -o afl-instrumentation.s afl-instrumentation.c
	python3 parse_assembly.py afl-instrumentation.s patches/generated
disass:
	gcc -c -fno-stack-protector -fcf-protection=none -o afl-instrumentation.o afl-instrumentation.c
	objdump afl-instrumentation.o -D -M intel > afl-instrumentation-disass
clean:
	rm -f afl-instrumentation.s afl-instrumentation.o afl-instrumentation-disass
