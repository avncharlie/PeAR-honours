.PHONY: hook clean
all: hook

hook:
	gcc -c -fno-stack-protector -fcf-protection=none hook.c
	ar rcs libhook.a hook.o

clean:
	rm *.a *.o
