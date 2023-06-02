import gtirb_rewriting.driver
from gtirb_rewriting import * # pyright: ignore
from gtirb_capstone.instructions import GtirbInstructionDecoder
import gtirb
import gtirb_functions

from gtirb_rewriting.patches import CallPatch
import itertools
import capstone_gt
from functools import partial

import random

#level = logging.DEBUG
#logger = logging.getLogger('add_afl')
#logging.basicConfig(
#    level=level,
#    format='%(name)s:%(levelname)s: %(message)s'
#)

class AFLTrampolinePatch(Patch):
    def __init__(self, block_id: int):
        self.block_id = block_id 
        super().__init__(Constraints(x86_syntax=X86Syntax.INTEL))

    def get_asm(self, insertion_context): # pyright: ignore
        return f'''
            lea    rsp,[rsp-0x98]
            mov    QWORD PTR [rsp],rdx
            mov    QWORD PTR [rsp+0x8],rcx
            mov    QWORD PTR [rsp+0x10],rax
            mov    rcx,{hex(self.block_id)}
            call   __afl_maybe_log
            mov    rax,QWORD PTR [rsp+0x10]
            mov    rcx,QWORD PTR [rsp+0x8]
            mov    rdx,QWORD PTR [rsp]
            lea    rsp,[rsp+0x98]
        '''

class AddAFLPass(Pass):
    """
    Add AFL instrumentation to binary
    """

    def get_basic_blocks(self, function: gtirb_functions.Function) -> list[list[gtirb.CodeBlock]]:
        blocks: list[list[gtirb.CodeBlock]] = []
        for block in sorted(function.get_all_blocks(), key=lambda e: e.address):
            incoming = list(block.incoming_edges)
            outgoing = list(block.outgoing_edges)

            # Ignore 'detached' blocks that have  no path to or from them.
            if len(incoming) == 0 and len(outgoing) == 0 and not block in function.get_entry_blocks():
                continue

            # Gtirb builds basic blocks across an entire program and not just
            # functions. This means that calls are considered to end a basic
            # block. However, in the context of AFL instrumentation, we do not
            # consider a call to end a basic block. 
            # As such, we group blocks that satisfy all these conditions:
            #   - Do not have an incoming edge from a jump instruction 
            #   - Have a incoming edge that is a fallthrough and ...
            #       - The source block of the fallthrough edge has two outgoing 
            #         edges, being: {Call, Fallthrough}.
            # 
            # i.e consider this block:
            #   <ASM1>
            #   call <func>
            #   <ASM2>
            #   call <another_func>
            # Gtirb would turn this into two basic blocks:
            #   block 1 (outgoing edges = [CALL, Fallthrough to block 2]:
            #     <ASM1>
            #     call <func>
            #   block 2 (incoming edges = [Fallthrough from block 1]:
            #     <ASM2>
            #     call <another_func>
            # We consider this one block. As such, we store blocks as lists, and
            # the above block would be stored as [block1, block2] in the
            # `blocks` array.
            # Blocks that don't have calls in them would be stored as singleton
            # lists in the `blocks` array.

            # Check block is fallthrough and doesn't come from branch.
            incoming_edge_types = [x.label.type for x in incoming]
            if gtirb.Edge.Type.Fallthrough in incoming_edge_types and not gtirb.Edge.Type.Branch in incoming_edge_types:
                skip = False
                for incoming_edge in incoming:

                    # Retrieve source block that falls through to current block.
                    if incoming_edge.label.type == gtirb.Edge.Type.Fallthrough:
                        outgoing_source_edge_types = [x.label.type for x in list(incoming_edge.source.outgoing_edges)]

                        # Check source block has {Call, Fallthrough} as its
                        # outoing edges.
                        if set(outgoing_source_edge_types) == set([gtirb.Edge.Type.Call, gtirb.Edge.Type.Fallthrough]):

                            # Find parent block in blocklist and append self.
                            for blocklist in blocks:
                                for b in blocklist:
                                    if b.address == incoming_edge.source.address:
                                        blocklist.append(block)
                                        break

                            skip = True
                            break
                if skip:
                    continue

            blocks.append([block])

        return blocks

    def add_afl(self,
                function: gtirb_functions.Function,
                context: RewritingContext,
                decoder: GtirbInstructionDecoder):

        blocks = self.get_basic_blocks(function)

        print(f"function {function.get_name()} has {len(blocks)} blocks")

        for blocklist in blocks:

            # Retrieve all instructions from block
            insns = ''
            for b in blocklist:
                for ins in decoder.get_instructions(b):
                    insns += f"\t{ins.insn_name()} {ins.op_str}\n"

            # insert AFL Trampoline at start of block
            context.register_insert(
                SingleBlockScope(blocklist[0], BlockPosition.ENTRY),
                AFLTrampolinePatch(block_id=random.getrandbits(16))
            )

    def begin_module(self,
                     module: gtirb.module.Module,
                     functions: list[gtirb_functions.function.Function],
                     context: RewritingContext):

        print('----------------------------------------')

        # make these functions accessible form patches
        context.get_or_insert_extern_symbol('printf', 'libc.so.6')
        context.get_or_insert_extern_symbol('getenv', 'libc.so.6')
        context.get_or_insert_extern_symbol('atoi', 'libc.so.6')
        context.get_or_insert_extern_symbol('shmat', 'libc.so.6')
        context.get_or_insert_extern_symbol('write', 'libc.so.6')
        context.get_or_insert_extern_symbol('read', 'libc.so.6')
        context.get_or_insert_extern_symbol('close', 'libc.so.6')
        context.get_or_insert_extern_symbol('fork', 'libc.so.6')
        context.get_or_insert_extern_symbol('waitpid', 'libc.so.6')
        context.get_or_insert_extern_symbol('exit', 'libc.so.6')

        # create logging + forkserver function
        context.register_insert_function(
            '__afl_maybe_log',
            Patch.from_function(lambda _: '''

                # Store flags on stack (apparently faster than pushf)
                lahf
                seto al

                # Store afl shared memory area in rdx
                # If not initialised, this will the first call to this function
                # in that case, set up shared memory area and start forkserver
                mov rdx,[rip + __afl_area_ptr]
                test rdx,rdx
                je __afl_setup

                __afl_store:
                # Calculate and store block coverage
                xor rcx,QWORD PTR [rip + __afl_prev_loc]
                xor QWORD PTR [rip + __afl_prev_loc],rcx
                shr QWORD PTR [rip + __afl_prev_loc],1
                inc BYTE PTR [rdx+rcx*1]
                adc BYTE PTR [rdx+rcx*1],0x0

                __afl_return:
                # Restore flags and return
                add al,0x7f
                sahf
                ret

                __afl_setup:
                # Do not attempt setup again if previously tried and failed
                cmp BYTE PTR [rip + __afl_setup_failure],0
                jne __afl_return

                # Use shared memory address in global pointer if not NULL
                lea rdx,[rip + __afl_global_area_ptr]
                mov rdx,QWORD PTR [rdx]
                test rdx,rdx
                je __afl_setup_first
                mov QWORD PTR [rip+__afl_area_ptr],rdx
                jmp __afl_store

                __afl_setup_first:
                # We will now setup and soon start forkserver
                # Save registers on stack
                lea    rsp,[rsp-0x160]
                mov    QWORD PTR [rsp],rax
                mov    QWORD PTR [rsp+0x8],rcx
                mov    QWORD PTR [rsp+0x10],rdi
                mov    QWORD PTR [rsp+0x20],rsi
                mov    QWORD PTR [rsp+0x28],r8
                mov    QWORD PTR [rsp+0x30],r9
                mov    QWORD PTR [rsp+0x38],r10
                mov    QWORD PTR [rsp+0x40],r11
                movq   QWORD PTR [rsp+0x60],xmm0
                movq   QWORD PTR [rsp+0x70],xmm1
                movq   QWORD PTR [rsp+0x80],xmm2
                movq   QWORD PTR [rsp+0x90],xmm3
                movq   QWORD PTR [rsp+0xa0],xmm4
                movq   QWORD PTR [rsp+0xb0],xmm5
                movq   QWORD PTR [rsp+0xc0],xmm6
                movq   QWORD PTR [rsp+0xd0],xmm7
                movq   QWORD PTR [rsp+0xe0],xmm8
                movq   QWORD PTR [rsp+0xf0],xmm9
                movq   QWORD PTR [rsp+0x100],xmm10
                movq   QWORD PTR [rsp+0x110],xmm11
                movq   QWORD PTR [rsp+0x120],xmm12
                movq   QWORD PTR [rsp+0x130],xmm13
                movq   QWORD PTR [rsp+0x140],xmm14
                movq   QWORD PTR [rsp+0x150],xmm15

                # Save rsp
                push   r12
                mov    r12,rsp

                # 16-byte align rsp 
                sub    rsp,0x10
                and    rsp,0xfffffffffffffff0

                # Get shared memory id from environment variable
                lea rdi,[rip + .AFL_SHM_ENV]
                call getenv
                test rax,rax
                je __afl_setup_abort  # no env variable, probably not running
                                      # under afl-fuzz

                # Map shared memory into address space
                mov rdi,rax
                call atoi
                xor rdx,rdx     # no flags
                xor rsi,rsi     # no requested address
                mov rdi,rax     # shared memory id
                call shmat
                cmp    rax,0xffffffffffffffff # shmat error
                je __afl_setup_abort

                # Save shared memory address
                mov rdx,rax
                # Set area pointer
                mov QWORD PTR [rip + __afl_area_ptr],rax
                # Set global area pointer (TODO: should be actually global)
                lea rdx,[rip + __afl_global_area_ptr]
                mov QWORD PTR [rdx],rax
                mov rdx,rax

                __afl_forkserver:
                push rdx
                push rdx
                # Communicate with afl-fuzz. fd 199 is used to communicate with
                # afl-fuzz. Stop forkserver if write failed. Buffer contents do
                # not matter.
                mov rdx, 4                  # bytes to write
                lea rsi,[rip + __afl_temp]  # buffer
                mov rdi, 199                # file descriptor
                call write
                cmp rax, 0x4
                jne __afl_fork_resume # write failed

                __afl_fork_wait_loop:
                # Read from afl-fuzz. fd 198 is used by afl-fuzz to communicate
                # with us. Value recieved does not mean anythinig.
                mov rdx, 4                   # bytes to read
                lea rsi, [rip + __afl_temp]  # buffer
                mov rdi, 198                 # file descriptor
                call read
                cmp rax,4
                jne __afl_die # read error

                # fork child for fuzzing
                call fork
                cmp rax,0
                jl __afl_die  # fork error
                je __afl_fork_resume # jump to __afl_fork_resume if child

                # Store child pid and send to afl-fuzz
                mov DWORD PTR [rip + __afl_fork_pid],eax
                mov rdx, 4                      # bytes
                lea rsi,[rip + __afl_fork_pid]  # buffer to read from
                mov rdi,199                     # file descriptor
                call write

                # Wait for child process
                mov rdx,0                                   # options
                lea rsi,[rip + __afl_temp]                  # status
                mov rdi, QWORD PTR [rip + __afl_fork_pid]   # pid
                call waitpid
                cmp rax, 0
                jle __afl_die # waitpid error

                # Send status of process to afl-fuzz
                mov rdx, 4                  # bytes to send
                lea rsi,[rip + __afl_temp]    # buffer
                mov rdi,199                 # file descriptor
                call write

                # Start loop again
                jmp __afl_fork_wait_loop

                __afl_fork_resume:
                # Is child process.
                # Close afl-fuzz file descriptors (only parent needs them)
                mov rdi,198
                call close
                mov rdi,199
                call close
                # Restore registers and stack
                pop    rdx
                pop    rdx
                mov    rsp,r12
                pop    r12
                mov    rax,QWORD PTR [rsp]
                mov    rcx,QWORD PTR [rsp+0x8]
                mov    rdi,QWORD PTR [rsp+0x10]
                mov    rsi,QWORD PTR [rsp+0x20]
                mov    r8,QWORD PTR [rsp+0x28]
                mov    r9,QWORD PTR [rsp+0x30]
                mov    r10,QWORD PTR [rsp+0x38]
                mov    r11,QWORD PTR [rsp+0x40]
                movq   xmm0,QWORD PTR [rsp+0x60]
                movq   xmm1,QWORD PTR [rsp+0x70]
                movq   xmm2,QWORD PTR [rsp+0x80]
                movq   xmm3,QWORD PTR [rsp+0x90]
                movq   xmm4,QWORD PTR [rsp+0xa0]
                movq   xmm5,QWORD PTR [rsp+0xb0]
                movq   xmm6,QWORD PTR [rsp+0xc0]
                movq   xmm7,QWORD PTR [rsp+0xd0]
                movq   xmm8,QWORD PTR [rsp+0xe0]
                movq   xmm9,QWORD PTR [rsp+0xf0]
                movq   xmm10,QWORD PTR [rsp+0x100]
                movq   xmm11,QWORD PTR [rsp+0x110]
                movq   xmm12,QWORD PTR [rsp+0x120]
                movq   xmm13,QWORD PTR [rsp+0x130]
                movq   xmm14,QWORD PTR [rsp+0x140]
                movq   xmm15,QWORD PTR [rsp+0x150]
                lea    rsp,[rsp+0x160]
                # Store block trace then continue execution
                jmp __afl_store

                __afl_die:
                xor rax,rax
                call exit

                __afl_setup_abort:
                # Record setup failure
                inc BYTE PTR [rip + __afl_setup_failure]
                # Restore registers and stack
                mov    rsp,r12
                pop    r12
                mov    rax,QWORD PTR [rsp]
                mov    rcx,QWORD PTR [rsp+0x8]
                mov    rdi,QWORD PTR [rsp+0x10]
                mov    rsi,QWORD PTR [rsp+0x20]
                mov    r8,QWORD PTR [rsp+0x28]
                mov    r9,QWORD PTR [rsp+0x30]
                mov    r10,QWORD PTR [rsp+0x38]
                mov    r11,QWORD PTR [rsp+0x40]
                movq   xmm0,QWORD PTR [rsp+0x60]
                movq   xmm1,QWORD PTR [rsp+0x70]
                movq   xmm2,QWORD PTR [rsp+0x80]
                movq   xmm3,QWORD PTR [rsp+0x90]
                movq   xmm4,QWORD PTR [rsp+0xa0]
                movq   xmm5,QWORD PTR [rsp+0xb0]
                movq   xmm6,QWORD PTR [rsp+0xc0]
                movq   xmm7,QWORD PTR [rsp+0xd0]
                movq   xmm8,QWORD PTR [rsp+0xe0]
                movq   xmm9,QWORD PTR [rsp+0xf0]
                movq   xmm10,QWORD PTR [rsp+0x100]
                movq   xmm11,QWORD PTR [rsp+0x110]
                movq   xmm12,QWORD PTR [rsp+0x120]
                movq   xmm13,QWORD PTR [rsp+0x130]
                movq   xmm14,QWORD PTR [rsp+0x140]
                movq   xmm15,QWORD PTR [rsp+0x150]
                lea    rsp,[rsp+0x160]
                # Return and continue execution
                jmp __afl_return

                .rodata
                .AFL_SHM_ENV:
                    .string "__AFL_SHM_ID"

                .data
                __afl_global_area_ptr:   .quad   0            # TODO: should be stored as global
                __afl_area_ptr:   .quad   0
                __afl_prev_loc:   .quad   0
                __afl_setup_failure:   .byte   0
                __afl_temp:   .long   0
                __afl_fork_pid:   .long   0

            ''', Constraints(x86_syntax=X86Syntax.INTEL))
        )

        # add instrumentation to basic blocks
        decoder = GtirbInstructionDecoder(module.isa)
        for function in functions:
            # make sure we do not modify _start function

            #if module.entry_point not in function.get_all_blocks() and function.get_name() == 'fib':
            #if module.entry_point not in function.get_all_blocks() and function.get_name() == 'main':
            if module.entry_point not in function.get_all_blocks():
                self.add_afl(function, context, decoder)

        print('----------------------------------------')

if __name__ == "__main__":
    # Allow gtirb-rewriting to provide us a command line driver. See
    # docs/Drivers.md for details.
    gtirb_rewriting.driver.main(AddAFLPass)
