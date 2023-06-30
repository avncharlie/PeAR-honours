.PHONY: all build disass clean
all: build disass

ifndef target
$(error target binary not set. Usage: make target=<target_name>)
endif

# for docker-build:
#   build image:
#       docker build -t gtirb_rewriting .
#   run container:
#       docker run -d --rm --name=gtirb_container -v /tmp/workspace:/workspace -it gtirb_rewriting

docker-build:
	$(eval target_fname := $(shell basename $(target)))
	# build and start container if not already running
	docker build -t gtirb_rewriting .
	docker ps | grep gtirb_container >/dev/null || docker run -d --rm --name=gtirb_container -v /tmp/workspace:/workspace -it gtirb_rewriting
	mkdir -p out
	cp $(target) /tmp/workspace
	cp add_afl.py /tmp/workspace
	docker exec gtirb_container ddisasm /workspace/$(target_fname) --ir /workspace/$(target_fname).gtirb
	docker exec gtirb_container python3.9 /workspace/add_afl.py /workspace/$(target_fname).gtirb /workspace/$(target_fname)-afl.gtirb
	docker exec gtirb_container gtirb-pprinter /workspace/$(target_fname)-afl.gtirb --binary /workspace/$(target_fname).gtirb.afl
	cp /tmp/workspace/$(target_fname).gtirb out/
	cp /tmp/workspace/$(target_fname)-afl.gtirb out/
	cp /tmp/workspace/$(target_fname).gtirb.afl out/
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
