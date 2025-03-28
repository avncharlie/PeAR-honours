.PHONY: all build disass clean
all: build

#ifndef TARGET
#	$(error target binary not set. Usage: make TARGET=<target_name>)
#else
#    TARGET_FNAME := $(shell basename $(TARGET))
#endif

COLOR_RESET = \033[0m
COLOR_RED = \033[31m
COLOR_GREEN = \033[32m
COLOR_YELLOW = \033[33m
COLOR_BLUE = \033[34m
COLOR_CYAN = \033[36m

ifndef TARGET
$(error TARGET not specified. Please provide the target as follows: make TARGET=<target_name>)
endif

TARGET_FNAME := $(shell basename $(TARGET))

ifeq ($(FORKSERVER_INIT_ADDR),)
    FORKSERVER_INIT_ADDR_ARG :=
else
    FORKSERVER_INIT_ADDR_ARG := --forkserver-init-address $(FORKSERVER_INIT_ADDR)
endif

ifeq ($(FORKSERVER_INIT_FUNC),)
    FORKSERVER_INIT_FUNC_ARG :=
else
    FORKSERVER_INIT_FUNC_ARG := --forkserver-init-func $(FORKSERVER_INIT_FUNC)
endif

ifeq ($(PERSISTENT_MODE_FUNC),)
    PERSISTENT_MODE_INIT_FUNC_ARG :=
else
    PERSISTENT_MODE_INIT_FUNC_ARG := --persistent-mode-func $(PERSISTENT_MODE_FUNC)
endif

ifeq ($(PERSISTENT_MODE_ADDR),)
    PERSISTENT_MODE_INIT_ADDR_ARG :=
else
    PERSISTENT_MODE_INIT_ADDR_ARG := --persistent-mode-address $(PERSISTENT_MODE_ADDR)
endif

ifeq ($(PERSISTENT_MODE_COUNT),)
    PERSISTENT_MODE_COUNT_ARG :=
else
    PERSISTENT_MODE_COUNT_ARG := --persistent-mode-count $(PERSISTENT_MODE_COUNT)
endif

ifeq ($(SHAREDMEM_HOOK_LOC),)
    SHAREDMEM_HOOK_LOC_ARG :=
else
    SHAREDMEM_HOOK_LOC_ARG := --sharedmem-hook-location $(SHAREDMEM_HOOK_LOC)
endif

ifeq ($(SHAREDMEM_HOOK_FUNC_NAME),)
    SHAREDMEM_HOOK_FUNC_ARG :=
else
    SHAREDMEM_HOOK_FUNC_ARG := --sharedmem-hook-func-name $(SHAREDMEM_HOOK_FUNC_NAME)
endif

ifneq ($(GEN_BINARY),)
    GEN_TEST_BINARY_CMD := docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME)-test.gtirb --binary /workspace/out/$(TARGET_FNAME).test
    GEN_NULL_BINARY_CMD := docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME).gtirb --binary /workspace/out/$(TARGET_FNAME).identity
    GEN_BINARY_CMD := docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME)-afl.gtirb --binary /workspace/out/$(TARGET_FNAME).gtirb.afl
    DISASS_CMD := objdump out/$(TARGET_FNAME).gtirb.afl -D -M intel > out/afl-disass
else
    GEN_TEST_BINARY_CMD :=
    GEN_NULL_BINARY_CMD := 
    GEN_BINARY_CMD := 
    DISASS_CMD := 
endif

null-transform:
	docker stop gtirb_container || true
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(TARGET) out/
	docker exec gtirb_container ddisasm /workspace/out/$(TARGET_FNAME) --ir /workspace/out/$(TARGET_FNAME).gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME).gtirb --asm /workspace/out/$(TARGET_FNAME).identity.S
	$(GEN_NULL_BINARY_CMD)
	rm out/$(TARGET_FNAME)
	docker stop gtirb_container

build-no-docker:
	mkdir -p out
	cp $(TARGET) out/
	ddisasm out/$(TARGET_FNAME) --ir out/$(TARGET_FNAME).gtirb
	python3.9 add_afl.py out/$(TARGET_FNAME).gtirb out/$(TARGET_FNAME)-afl.gtirb --patch-dir instrumentation/patches/generated/ $(FORKSERVER_INIT_ADDR_ARG) $(FORKSERVER_INIT_FUNC_ARG) $(PERSISTENT_MODE_INIT_ADDR_ARG) $(PERSISTENT_MODE_INIT_FUNC_ARG) $(PERSISTENT_MODE_COUNT_ARG) $(SHAREDMEM_HOOK_LOC_ARG) $(SHAREDMEM_HOOK_FUNC_ARG)
	@echo "$(COLOR_GREEN)Instrumented GTIRB IR saved to $(shell pwd)/out/$(TARGET_FNAME)-afl.gtirb$(COLOR_RESET)"
	gtirb-pprinter out/$(TARGET_FNAME)-afl.gtirb --asm out/$(TARGET_FNAME).S

fuzzbench:
	mkdir -p out
	cp $(TARGET) out/
	ddisasm out/$(TARGET_FNAME) --ir out/$(TARGET_FNAME).gtirb
	python3.9 add_afl.py out/$(TARGET_FNAME).gtirb out/$(TARGET_FNAME)-afl.gtirb --patch-dir instrumentation/patches/generated/ $(FORKSERVER_INIT_ADDR_ARG) $(FORKSERVER_INIT_FUNC_ARG) $(PERSISTENT_MODE_INIT_ADDR_ARG) $(PERSISTENT_MODE_INIT_FUNC_ARG) $(PERSISTENT_MODE_COUNT_ARG) $(SHAREDMEM_HOOK_LOC_ARG) $(SHAREDMEM_HOOK_FUNC_ARG)
	@echo "$(COLOR_GREEN)Instrumented GTIRB IR saved to $(shell pwd)/out/$(TARGET_FNAME)-afl.gtirb$(COLOR_RESET)"

build:
	docker stop gtirb_container || true
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(TARGET) out/
	docker exec gtirb_container ddisasm /workspace/out/$(TARGET_FNAME) --ir /workspace/out/$(TARGET_FNAME).gtirb
	docker exec gtirb_container python3.9 /workspace/add_afl.py /workspace/out/$(TARGET_FNAME).gtirb /workspace/out/$(TARGET_FNAME)-afl.gtirb --patch-dir /workspace/instrumentation/patches/generated/ $(FORKSERVER_INIT_ADDR_ARG) $(FORKSERVER_INIT_FUNC_ARG) $(PERSISTENT_MODE_INIT_ADDR_ARG) $(PERSISTENT_MODE_INIT_FUNC_ARG) $(PERSISTENT_MODE_COUNT_ARG) $(SHAREDMEM_HOOK_LOC_ARG) $(SHAREDMEM_HOOK_FUNC_ARG)
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME)-afl.gtirb --asm /workspace/out/$(TARGET_FNAME).gtirb.afl.S
	$(GEN_BINARY_CMD)
	rm out/$(TARGET_FNAME)
	docker stop gtirb_container
	@echo "$(COLOR_GREEN)Instrumented assembly saved to $(shell pwd)/out/$(TARGET_FNAME).gtirb.afl.S$(COLOR_RESET)"
	$(DISASS_CMD)

test:
	docker stop gtirb_container || true
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(TARGET) out/
	docker exec gtirb_container ddisasm /workspace/out/$(TARGET_FNAME) --ir /workspace/out/$(TARGET_FNAME).gtirb
	docker exec gtirb_container python3.9 /workspace/test.py /workspace/out/$(TARGET_FNAME).gtirb /workspace/out/$(TARGET_FNAME)-test.gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(TARGET_FNAME)-test.gtirb --asm /workspace/out/$(TARGET_FNAME).test.S
	$(GEN_TEST_BINARY_CMD)
	rm out/$(TARGET_FNAME)
	docker stop gtirb_container
