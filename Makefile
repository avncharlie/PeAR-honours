.PHONY: all build disass clean
all: build disass

ifndef target
$(error target binary not set. Usage: make target=<target_name>)
endif

build:
	$(eval target_fname := $(shell basename $(target)))
	mkdir -p out
	ddisasm $(target) --ir out/$(target_fname).gtirb
	python3 add_afl.py out/$(target_fname).gtirb out/$(target_fname)-afl.gtirb
	gtirb-pprinter out/$(target_fname)-afl.gtirb --binary out/$(target_fname).gtirb.afl
disass:
	$(eval target_fname := $(shell basename $(target)))
	objdump -dj .text $(target) -M intel > out/$(target_fname)-disass
	objdump -dj .text out/$(target_fname).gtirb.afl -M intel > out/$(target_fname)-gtirb-afl-disass
	[ -f $(target).afl ] && objdump -dj .text $(target).afl -M intel > out/befunge-afl-disass
clean:
	$(eval target_fname := $(shell basename $(target)))
	rm -f out/$(target_fname)*
