#!/bin/bash

# usage: $0 NUM_FUZZERS

NUM_FUZZERS=$1

if [ $NUM_FUZZERS -gt 1 ]
then
    # create master fuzzer
    ( docker run --rm -d --name=afl_master --user $(id -u):$(id -g) -ti -v $(pwd):/src aflplusplus/aflplusplus afl-fuzz -M master -i /src/befunge-files/examples/ -o /src/afl-out -m none /src/out/befunge.gtirb.afl @@ )>/dev/null &

    for i in `seq 2 $NUM_FUZZERS`; do
        # create slave fuzzers
        SLAVE_NAME="afl_slave_$((${i}-1))"
        ( docker run --rm -d -e AFL_AUTORESUME=1 --name=${SLAVE_NAME} --user $(id -u):$(id -g) -ti -v $(pwd):/src aflplusplus/aflplusplus afl-fuzz -S ${SLAVE_NAME} -b $((${i}-1)) -i /src/befunge-files/examples/ -o /src/afl-out -m none /src/out/befunge.gtirb.afl @@ )>/dev/null &
    done

    echo "Created 1 master fuzzer and $((${NUM_FUZZERS}-1)) slave fuzzers."
else
    echo "need >1 fuzzer for parallel fuzzing"
fi
