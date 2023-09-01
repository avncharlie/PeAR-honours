# afl-rewrite tutorial

## Acknowledgements
The file `simple.c` is a modified version of [AFLplusplus' persistent mode demo](https://github.com/AFLplusplus/AFLplusplus/blob/stable/utils/persistent_mode/persistent_demo.c).

The format of this tutorial is inspired from [Airbus security lab's tutorial AFL++ QEMU mode fuzzing](https://airbus-seclab.github.io/AFLplusplus-blogpost/).

## Step 1 - applying AFL instrumentation
We will fuzz `simple.c`. It simply crashes when given 'foo!!!' as input.

To simply apply AFL instrumentation, run `make`.

This will build `simple` and instrument it. Use `afl-fuzz -i corpus/ -o afl-out
-- ./simple.afl @@` to fuzz the instrumented program. It should be pretty slow,
with 15-17 execs/s. This is because of the slow `init` function that is called.

## Step 2 - deferred initialisation
We can initialise the AFL later in the program to avoid having to run the
`init` function every fuzzing attempt.

A good place to initialise would be at the start of the `read_and_test_file`,
to skip the slow call to `init`.

We do this by setting the environment variable `FORKSERVER_INIT_FUNC` to the
function we want to add initalisation to when building. Of course, the program
you want to fuzz may not have symbols, or maybe you want to add afl
initalisation at a specific address. In this case, set the variable
`FORKSERVER_INIT_ADDR` to the address you want to add initialsation to.

To test deferred initalisation on `simple`, run `make
add-afl-deferred-initialisation`. This will add AFL instrumentation with
deferred initialisation (at `read_and_test_file`) to the program.

To fuzz: `afl-fuzz -i corpus/ -o afl-out -- ./simple.afl.deferred @@`

You should see a much higher exec speed.

## Step 3 - persistent mode
AFL runs testcases by forking a parent binary every fuzzing attempt. It would
be a lot faster if we could run multiple fuzz attempts per forked child.
We can, using persistent mode! afl-rewrite implements persistent mode in a
very similar way to AFL++ QEMU mode.  afl-rewite only supports adding
persistent mode over whole functions.

Persistent mode runs an area of code over and over again with new testcases in
the one forked child. A function is a good candidate for applying persistent
mode if:
 - It reads the testcase (i.e opens the input file) 
 - It doesn't cause changes in external state that prevents it from being run
   again correctly

For our test program `simple`, a good function to apply persistent mode to
would be `read_and_test_file`

We can also specify a count for how many times the persistent loop should run
before the child exits and a new one is spawned (controlled through the
`PERSISTENT_MODE_COUNT` environment variable, set by default to 10000).  The
more confidence we have in our code not degrading program stability with
successive runs the higher we can set this number.

In afl-rewrite, we can specify applying persistent mode through the environment
variable `PERSISTENT_MODE_FUNC` to apply persistent mode to a function given its
name, or `PERSISTENT_MODE_ADDR` to specify an address instead.

To test persistent mode on `simple`, run `make add-afl-persistent-mode`. This
build an instrumented binary with persistent mode and deferred initalisation
applied to `read_and_test_file`.

To fuzz: `afl-fuzz -i corpus/ -o afl-out -- ./simple.afl.deferred.persistent @@`

You should see a higher exec speed again.

## Step 4 - shared memory fuzzing
AFL supports giving out testcases through shared memory. We can use this
feature to avoid the overhead of reading a file every fuzz attempt. afl-rewrite
implements shared memory fuzzing very similarly to AFL++ QEMU mode, through
using a shared memory hook. An example of this hook is given in the
`sharedmem_hook` folder in `hook.c`.

The hook is passed three arguments:
 - A struct containing saved values of registers at the point it was called
 - A pointer to the current testcase
 - The length of this testcase

Register values can be modified in the register struct.  Registers will be set
to these modified values after the hook has been called.

We have three options to specify where the hook is called:
 - Immediately before the each run of the persistent mode loop. To do this, set
   environment variable `SHAREDMEM_HOOK_LOC` to `PERSISTENT_LOOP`.
 - Immediately after AFL initialisation. This can be paired with deferred
   initalisation to provide precise control as to where the hook will be called
   This is useful when persistent mode cannot be applied but we still want the
   speed savings of sharedmem testcases. To do this, set `SHAREDMEM_HOOK_LOC`
   to `FORKSERVER_INIT`.
 - At a specific address. This can be used when the other two options don't
   suit your case.  To do this, set environment variable `SHAREDMEM_HOOK_LOC`
   to the address you want the hook to be called.

In the `simple` program we can use shared memory fuzzing to enable using
persistent mode on the `test` function. As this function operates directly on a
memory buffer, can use a sharedmem hook to write testcases on this buffer
before every persistent mode loop of this function.  See
`sharedmem_hook/hook.c` for an example of this.

A few things to watch out for when using sharedmem hooks:
 - Reset the buffer at the start of the hook. Otherwise remnants from previous
   testcases may remain in the buffer.
 - Cap the length of the testcase you copy in to the length of the buffer. 

To test using shared memory fuzzing on `simple`, run `make add-afl-sharedmem`. 
This will compile the shared memory hook and create an instrumented binary with
persistent mode and a sharedmem hook call applied to the function `test`. To
enable the sharedmem hook, the compiled hook is linked while assembling the
instrumented program.

To fuzz: `afl-fuzz -i corpus/ -o afl-out --
./simple.afl.deferred.persistent.sharedmem corpus/testcase`

You should see a significantly higher exec speed.

To ensure that testcases are being sent properly, add `AFL_DEBUG=1` to the command,
i.e run `AFL_DEBUG=1 afl-fuzz -i corpus/ -o afl-out --
./simple.afl.deferred.persistent.sharedmem corpus/testcase`. The program prints
the contents of the buffer at the start of the `test` function, and we can see
this while running under AFL debug mode.
