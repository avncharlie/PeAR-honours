# Moved to: https://github.com/avncharlie/PeAR
## This is an archived version of PeAR, kept as it was when I submitted my honours thesis.  

# PeAR

Add AFL instrumentation to x86_64 binaries using GTIRB. Supports persistent
mode, deferred initialisation and shared memory fuzzing.

Check out the tutorial in example/README.md

## Quick start
`TARGET=/path/to/binary make`

## Options

Deferred initialisation options:
 - Set `FORKSERVER_INIT_FUNC` to function in which AFL initialisation should
   occur. AFL will be initialised at the start of given function.
 - Set `FORKSERVER_INIT_ADDR` to address where AFL should be initalised.

Persistent mode options:
 - Set `PERSISTENT_MODE_FUNC` to function that persistent mode should be
   applied to.
 - Set `PERSISTENT_MODE_ADDR` to address that persistent mode should be applied
   to.
 - Set `PERSISTENT_MODE_COUNT` to number of times persistent mode loop should run.
   Default is 10000.

Shared memory fuzzing options:
 - Set `SHAREDMEM_HOOK_LOC` to one of:
    - `PERSISTENT_LOOP` to call the shared memory hook immediately prior to the
      start of the persistent loop
    - `FORKSERVER_INIT` to call the hook immediately after the AFL initialises
    - `<address>` to call the hook at specific address.
 - Set `SHAREDMEM_HOOK_FUNC_ARG` to name of sharedmem hook. Default is
   "__afl_rewrite_sharedmem_hook"








