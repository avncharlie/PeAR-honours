.PHONY: build-binary add-afl-simple
all: build-binary add-afl-simple

COLOR_RESET = \033[0m
COLOR_RED = \033[31m
COLOR_GREEN = \033[32m
COLOR_YELLOW = \033[33m
COLOR_BLUE = \033[34m
COLOR_CYAN = \033[36m

build-binary:
	gcc -o simple simple.c

add-afl-simple:
	make -C .. TARGET=$$(pwd)/simple
	gcc -o simple.afl ../out/simple.gtirb.afl.S -pie -nostartfiles
	@echo "$(COLOR_GREEN)AFL binary built (simple.afl).$(COLOR_RESET)"
	@echo "$(COLOR_CYAN)Fuzz with:$(COLOR_RESET) afl-fuzz -i corpus/ -o afl-out -- ./simple.afl @@"

add-afl-deferred-initialisation:
	FORKSERVER_INIT_FUNC=read_and_test_file make -C .. TARGET=$$(pwd)/simple
	gcc -o simple.afl.deferred ../out/simple.gtirb.afl.S -pie -nostartfiles
	@echo "$(COLOR_GREEN)AFL binary built with deferred initialisation (simple.afl.deferred).$(COLOR_RESET)"
	@echo "$(COLOR_CYAN)Fuzz with:$(COLOR_RESET) afl-fuzz -i corpus/ -o afl-out -- ./simple.afl.deferred @@"

add-afl-persistent-mode:
	PERSISTENT_MODE_FUNC=read_and_test_file FORKSERVER_INIT_FUNC=read_and_test_file make -C .. TARGET=$$(pwd)/simple
	gcc -o simple.afl.deferred.persistent ../out/simple.gtirb.afl.S -pie -nostartfiles
	@echo "$(COLOR_GREEN)AFL binary built with deferred initialisation and persistent mode (simple.afl.deferred.persistent).$(COLOR_RESET)"
	@echo "$(COLOR_CYAN)Fuzz with:$(COLOR_RESET) afl-fuzz -i corpus/ -o afl-out -- ./simple.afl.deferred.persistent @@"

add-afl-sharedmem:
	SHAREDMEM_HOOK_LOC=PERSISTENT_LOOP PERSISTENT_MODE_FUNC=test FORKSERVER_INIT_FUNC=test make -C .. TARGET=$$(pwd)/simple
	make -C sharedmem_hook
	gcc -o simple.afl.deferred.persistent.sharedmem ../out/simple.gtirb.afl.S -pie -nostartfiles -Lsharedmem_hook -lhook
	@echo "$(COLOR_GREEN)AFL binary built with deferred initialisation, persistent mode and sharedmem fuzzing (simple.afl.deferred.persistent.sharedmem).$(COLOR_RESET)"
	@echo "$(COLOR_CYAN)Fuzz with:$(COLOR_RESET) afl-fuzz -i corpus/ -o afl-out -- ./simple.afl.deferred.persistent.sharedmem corpus/testcase"
	@echo "(set environment variable AFL_DEBUG=1 to verify that testcases are successfully being passed through the binary)"

clean:
	rm simple simple.afl simple.afl.deferred simple.afl.deferred.persistent simple.afl.deferred.persistent.sharedmem
