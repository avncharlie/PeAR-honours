.PHONY: all build disass clean
all: build disass

ifndef target
$(error target binary not set. Usage: make target=<target_name>)
endif

# run docker container manually:
#   build image:
#     $ docker build -t gtirb_rewriting .
#   run container:
#     $ docker run -d --rm --name=gtirb -v /tmp/workspace:/workspace -it gtirb_rewriting
#   run commands:
#     $ docker exec gtirb ddisasm --help
#   stop container:
#     $ docker stop gtirb

null-transform-asm:
	$(eval target_fname := $(shell basename $(target)))
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(target) out/
	docker exec gtirb_container ddisasm /workspace/out/$(target_fname) --ir /workspace/out/$(target_fname).gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(target_fname).gtirb --asm /workspace/out/$(target_fname).identity.S
	rm out/$(target_fname)
	docker stop gtirb_container
null-transform-binary:
	$(eval target_fname := $(shell basename $(target)))
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(target) out/
	docker exec gtirb_container ddisasm /workspace/out/$(target_fname) --ir /workspace/out/$(target_fname).gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(target_fname).gtirb --binary /workspace/out/$(target_fname).identity
	rm out/$(target_fname)
	docker stop gtirb_container
docker-build-asm:
	$(eval target_fname := $(shell basename $(target)))
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(target) out/
	docker exec gtirb_container ddisasm /workspace/out/$(target_fname) --ir /workspace/out/$(target_fname).gtirb
	docker exec gtirb_container python3.9 /workspace/add_afl.py /workspace/out/$(target_fname).gtirb /workspace/out/$(target_fname)-afl.gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(target_fname)-afl.gtirb --asm /workspace/out/$(target_fname).gtirb.afl.S
	rm out/$(target_fname)
	docker stop gtirb_container
docker-build-binary:
	$(eval target_fname := $(shell basename $(target)))
	mkdir -p out
	docker build -t gtirb_rewriting .
	docker run -d --rm --name=gtirb_container -v $(shell pwd):/workspace -it gtirb_rewriting
	cp $(target) out/
	docker exec gtirb_container ddisasm /workspace/out/$(target_fname) --ir /workspace/out/$(target_fname).gtirb
	docker exec gtirb_container python3.9 /workspace/add_afl.py /workspace/out/$(target_fname).gtirb /workspace/out/$(target_fname)-afl.gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/out/$(target_fname)-afl.gtirb --binary /workspace/out/$(target_fname).gtirb.afl
	rm out/$(target_fname)
	docker stop gtirb_container
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
