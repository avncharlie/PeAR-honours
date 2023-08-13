	.file	"afl-instrumentation.c"
	.intel_syntax noprefix
	.text
	.globl	__afl_area_ptr_dummy
	.bss
	.align 8
	.type	__afl_area_ptr_dummy, @object
	.size	__afl_area_ptr_dummy, 8
__afl_area_ptr_dummy:
	.zero	8
	.globl	__afl_area_ptr
	.align 8
	.type	__afl_area_ptr, @object
	.size	__afl_area_ptr, 8
__afl_area_ptr:
	.zero	8
	.globl	__afl_debug
	.align 4
	.type	__afl_debug, @object
	.size	__afl_debug, 4
__afl_debug:
	.zero	4
	.globl	__afl_already_initialized_shm
	.align 4
	.type	__afl_already_initialized_shm, @object
	.size	__afl_already_initialized_shm, 4
__afl_already_initialized_shm:
	.zero	4
	.globl	__afl_prev_loc
	.align 4
	.type	__afl_prev_loc, @object
	.size	__afl_prev_loc, 4
__afl_prev_loc:
	.zero	4
	.globl	__afl_already_initialized_forkserver
	.align 4
	.type	__afl_already_initialized_forkserver, @object
	.size	__afl_already_initialized_forkserver, 4
__afl_already_initialized_forkserver:
	.zero	4
	.globl	__afl_map_size
	.data
	.align 4
	.type	__afl_map_size, @object
	.size	__afl_map_size, 4
__afl_map_size:
	.long	65536
	.globl	child_pid
	.bss
	.align 4
	.type	child_pid, @object
	.size	child_pid, 4
child_pid:
	.zero	4
	.globl	old_sigterm_handler
	.align 8
	.type	old_sigterm_handler, @object
	.size	old_sigterm_handler, 8
old_sigterm_handler:
	.zero	8
	.weak	__afl_sharedmem_fuzzing
	.align 4
	.type	__afl_sharedmem_fuzzing, @object
	.size	__afl_sharedmem_fuzzing, 4
__afl_sharedmem_fuzzing:
	.zero	4
	.globl	__afl_connected
	.align 4
	.type	__afl_connected, @object
	.size	__afl_connected, 4
__afl_connected:
	.zero	4
	.globl	is_persistent
	.type	is_persistent, @object
	.size	is_persistent, 1
is_persistent:
	.zero	1
	.globl	first_pass
	.data
	.type	first_pass, @object
	.size	first_pass, 1
first_pass:
	.byte	1
	.globl	cycle_cnt
	.bss
	.align 4
	.type	cycle_cnt, @object
	.size	cycle_cnt, 4
cycle_cnt:
	.zero	4
	.globl	__afl_fuzz_len
	.align 8
	.type	__afl_fuzz_len, @object
	.size	__afl_fuzz_len, 8
__afl_fuzz_len:
	.zero	8
	.globl	__afl_fuzz_ptr
	.align 8
	.type	__afl_fuzz_ptr, @object
	.size	__afl_fuzz_ptr, 8
__afl_fuzz_ptr:
	.zero	8
	.globl	__document_mutation_counter
	.align 4
	.type	__document_mutation_counter, @object
	.size	__document_mutation_counter, 4
__document_mutation_counter:
	.zero	4
	.text
	.globl	__afl_persistent_loop
	.type	__afl_persistent_loop, @function
__afl_persistent_loop:
.LFB6:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR -4[rbp], edi
	movzx	eax, BYTE PTR first_pass[rip]
	test	al, al
	je	.L2
	mov	eax, DWORD PTR __afl_map_size[rip]
	mov	edx, eax
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	mov	esi, 0
	mov	rdi, rax
	call	memset@PLT
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	mov	BYTE PTR [rax], 1
	mov	DWORD PTR __afl_prev_loc[rip], 0
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR cycle_cnt[rip], eax
	mov	BYTE PTR first_pass[rip], 0
	mov	eax, 1
	jmp	.L3
.L2:
	mov	eax, DWORD PTR cycle_cnt[rip]
	sub	eax, 1
	mov	DWORD PTR cycle_cnt[rip], eax
	mov	eax, DWORD PTR cycle_cnt[rip]
	test	eax, eax
	je	.L4
	mov	edi, 19
	call	raise@PLT
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	mov	BYTE PTR [rax], 1
	mov	DWORD PTR __afl_prev_loc[rip], 0
	mov	eax, 1
	jmp	.L3
.L4:
	mov	rax, QWORD PTR __afl_area_ptr_dummy[rip]
	mov	QWORD PTR __afl_area_ptr[rip], rax
	mov	eax, 0
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	__afl_persistent_loop, .-__afl_persistent_loop
	.type	send_forkserver_error, @function
send_forkserver_error:
.LFB7:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	cmp	DWORD PTR -20[rbp], 0
	je	.L11
	cmp	DWORD PTR -20[rbp], 65535
	jg	.L11
	mov	eax, DWORD PTR -20[rbp]
	sal	eax, 8
	and	eax, 16776960
	or	eax, -134217585
	mov	DWORD PTR -4[rbp], eax
	lea	rax, -4[rbp]
	mov	edx, 4
	mov	rsi, rax
	mov	edi, 199
	call	write@PLT
	cmp	rax, 4
	jmp	.L5
.L11:
	nop
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	send_forkserver_error, .-send_forkserver_error
	.section	.rodata
.LC0:
	.string	"__AFL_SHM_ID"
.LC1:
	.string	"<null>"
	.align 8
.LC2:
	.string	"DEBUG: (1) id_str %s, __afl_area_ptr %p, __afl_area_ptr_dummy %p, MAP_SIZE %u\n"
.LC3:
	.string	"shmat for map"
	.align 8
.LC4:
	.string	"DEBUG: (2) id_str %s, __afl_area_ptr %p, __afl_area_ptr_dummy %p, MAP_SIZE %u\n"
	.text
	.type	__afl_map_shm, @function
__afl_map_shm:
.LFB8:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	eax, DWORD PTR __afl_already_initialized_shm[rip]
	test	eax, eax
	jne	.L24
	mov	DWORD PTR __afl_already_initialized_shm[rip], 1
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	getenv@PLT
	mov	QWORD PTR -8[rbp], rax
	mov	eax, DWORD PTR __afl_debug[rip]
	test	eax, eax
	je	.L15
	mov	rcx, QWORD PTR __afl_area_ptr_dummy[rip]
	mov	rdx, QWORD PTR __afl_area_ptr[rip]
	cmp	QWORD PTR -8[rbp], 0
	je	.L16
	mov	rax, QWORD PTR -8[rbp]
	jmp	.L17
.L16:
	lea	rax, .LC1[rip]
.L17:
	mov	rdi, QWORD PTR stderr[rip]
	mov	r9d, 65536
	mov	r8, rcx
	mov	rcx, rdx
	mov	rdx, rax
	lea	rax, .LC2[rip]
	mov	rsi, rax
	mov	eax, 0
	call	fprintf@PLT
.L15:
	cmp	QWORD PTR -8[rbp], 0
	je	.L25
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	edx, 0
	mov	esi, 0
	mov	edi, eax
	call	shmat@PLT
	mov	QWORD PTR __afl_area_ptr[rip], rax
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	test	rax, rax
	je	.L19
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	cmp	rax, -1
	jne	.L20
.L19:
	mov	edi, 8
	call	send_forkserver_error
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	perror@PLT
	mov	edi, 1
	call	_exit@PLT
.L20:
	mov	rax, QWORD PTR __afl_area_ptr[rip]
	mov	BYTE PTR [rax], 1
	mov	eax, DWORD PTR __afl_debug[rip]
	test	eax, eax
	je	.L12
	mov	rcx, QWORD PTR __afl_area_ptr_dummy[rip]
	mov	rdx, QWORD PTR __afl_area_ptr[rip]
	cmp	QWORD PTR -8[rbp], 0
	je	.L22
	mov	rax, QWORD PTR -8[rbp]
	jmp	.L23
.L22:
	lea	rax, .LC1[rip]
.L23:
	mov	rdi, QWORD PTR stderr[rip]
	mov	r9d, 65536
	mov	r8, rcx
	mov	rcx, rdx
	mov	rdx, rax
	lea	rax, .LC4[rip]
	mov	rsi, rax
	mov	eax, 0
	call	fprintf@PLT
	jmp	.L12
.L24:
	nop
	jmp	.L12
.L25:
	nop
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	__afl_map_shm, .-__afl_map_shm
	.section	.rodata
	.align 8
.LC5:
	.string	"ERROR: malloc to setup dummy map failed\n"
.LC6:
	.string	"AFL_DEBUG"
.LC7:
	.string	"DEBUG: debug enabled\n"
	.text
	.type	__afl_setup, @function
__afl_setup:
.LFB9:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edi, 65536
	call	malloc@PLT
	mov	QWORD PTR __afl_area_ptr_dummy[rip], rax
	mov	rax, QWORD PTR __afl_area_ptr_dummy[rip]
	test	rax, rax
	jne	.L27
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 40
	mov	esi, 1
	lea	rax, .LC5[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L27:
	mov	rax, QWORD PTR __afl_area_ptr_dummy[rip]
	mov	QWORD PTR __afl_area_ptr[rip], rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	call	getenv@PLT
	test	rax, rax
	je	.L28
	mov	DWORD PTR __afl_debug[rip], 1
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 21
	mov	esi, 1
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	fwrite@PLT
.L28:
	call	__afl_map_shm
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	__afl_setup, .-__afl_setup
	.type	at_exit, @function
at_exit:
.LFB10:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR -4[rbp], edi
	mov	eax, DWORD PTR child_pid[rip]
	test	eax, eax
	jle	.L30
	mov	eax, DWORD PTR child_pid[rip]
	mov	esi, 9
	mov	edi, eax
	call	kill@PLT
	mov	eax, DWORD PTR child_pid[rip]
	mov	edx, 0
	mov	esi, 0
	mov	edi, eax
	call	waitpid@PLT
	mov	DWORD PTR child_pid[rip], -1
.L30:
	mov	edi, 0
	call	_exit@PLT
	.cfi_endproc
.LFE10:
	.size	at_exit, .-at_exit
	.section	.rodata
.LC8:
	.string	"__AFL_SHM_FUZZ_ID"
.LC9:
	.string	"none"
.LC10:
	.string	"DEBUG: fuzzcase shmem %s\n"
	.align 8
.LC11:
	.string	"Could not access fuzzing shared memory"
	.align 8
.LC12:
	.string	"DEBUG: successfully got fuzzing shared memory\n"
	.align 8
.LC13:
	.string	"Error: variable for fuzzing shared memory is not set\n"
	.text
	.type	__afl_map_shm_fuzz, @function
__afl_map_shm_fuzz:
.LFB11:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	lea	rax, .LC8[rip]
	mov	rdi, rax
	call	getenv@PLT
	mov	QWORD PTR -8[rbp], rax
	mov	eax, DWORD PTR __afl_debug[rip]
	test	eax, eax
	je	.L32
	cmp	QWORD PTR -8[rbp], 0
	je	.L33
	mov	rax, QWORD PTR -8[rbp]
	jmp	.L34
.L33:
	lea	rax, .LC9[rip]
.L34:
	mov	rcx, QWORD PTR stderr[rip]
	mov	rdx, rax
	lea	rax, .LC10[rip]
	mov	rsi, rax
	mov	rdi, rcx
	mov	eax, 0
	call	fprintf@PLT
.L32:
	cmp	QWORD PTR -8[rbp], 0
	je	.L35
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR -20[rbp]
	mov	edx, 0
	mov	esi, 0
	mov	edi, eax
	call	shmat@PLT
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	je	.L36
	cmp	QWORD PTR -16[rbp], -1
	jne	.L37
.L36:
	lea	rax, .LC11[rip]
	mov	rdi, rax
	call	perror@PLT
	mov	edi, 4
	call	send_forkserver_error
	mov	edi, 1
	call	exit@PLT
.L37:
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR __afl_fuzz_len[rip], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 4
	mov	QWORD PTR __afl_fuzz_ptr[rip], rax
	mov	eax, DWORD PTR __afl_debug[rip]
	test	eax, eax
	je	.L39
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 46
	mov	esi, 1
	lea	rax, .LC12[rip]
	mov	rdi, rax
	call	fwrite@PLT
	jmp	.L39
.L35:
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 53
	mov	esi, 1
	lea	rax, .LC13[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 4
	call	send_forkserver_error
	mov	edi, 1
	call	exit@PLT
.L39:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	__afl_map_shm_fuzz, .-__afl_map_shm_fuzz
	.section	.rodata
.LC14:
	.string	"target forkserver recv: %08x\n"
	.align 8
.LC15:
	.string	"ERROR: child_stopped && was_killed\n"
.LC16:
	.string	"ERROR: fork\n"
.LC17:
	.string	"ERROR: write to afl-fuzz\n"
.LC18:
	.string	"ERROR: waitpid\n"
.LC19:
	.string	"ERROR: writing to afl-fuzz\n"
	.text
	.type	__afl_start_forkserver, @function
__afl_start_forkserver:
.LFB12:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 192
	mov	eax, DWORD PTR __afl_already_initialized_forkserver[rip]
	test	eax, eax
	jne	.L67
	mov	DWORD PTR __afl_already_initialized_forkserver[rip], 1
	lea	rax, -176[rbp]
	mov	rdx, rax
	mov	esi, 0
	mov	edi, 15
	call	sigaction@PLT
	mov	rax, QWORD PTR -176[rbp]
	mov	QWORD PTR old_sigterm_handler[rip], rax
	lea	rax, at_exit[rip]
	mov	rsi, rax
	mov	edi, 15
	call	signal@PLT
	mov	DWORD PTR -180[rbp], 0
	mov	DWORD PTR -184[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	BYTE PTR -5[rbp], 0
	mov	esi, 0
	mov	edi, 17
	call	signal@PLT
	mov	QWORD PTR -16[rbp], rax
	mov	eax, DWORD PTR __afl_map_size[rip]
	cmp	eax, 8388608
	ja	.L43
	mov	eax, DWORD PTR __afl_map_size[rip]
	cmp	eax, 1
	jbe	.L44
	mov	eax, DWORD PTR __afl_map_size[rip]
	cmp	eax, 8388608
	ja	.L44
	mov	eax, DWORD PTR __afl_map_size[rip]
	sub	eax, 1
	add	eax, eax
	or	eax, 1073741824
	mov	edx, eax
	jmp	.L45
.L44:
	mov	edx, 1073741824
.L45:
	mov	eax, DWORD PTR -184[rbp]
	or	eax, edx
	mov	DWORD PTR -184[rbp], eax
.L43:
	mov	eax, DWORD PTR __afl_sharedmem_fuzzing[rip]
	test	eax, eax
	je	.L46
	mov	eax, DWORD PTR -184[rbp]
	or	eax, 16777216
	mov	DWORD PTR -184[rbp], eax
.L46:
	mov	eax, DWORD PTR -184[rbp]
	test	eax, eax
	je	.L47
	mov	eax, DWORD PTR -184[rbp]
	or	eax, -2113929215
	mov	DWORD PTR -184[rbp], eax
.L47:
	mov	eax, DWORD PTR -184[rbp]
	mov	DWORD PTR -180[rbp], eax
	lea	rax, -180[rbp]
	mov	edx, 4
	mov	rsi, rax
	mov	edi, 199
	call	write@PLT
	cmp	rax, 4
	jne	.L68
	mov	DWORD PTR __afl_connected[rip], 1
	mov	eax, DWORD PTR __afl_sharedmem_fuzzing[rip]
	test	eax, eax
	je	.L65
	lea	rax, -188[rbp]
	mov	edx, 4
	mov	rsi, rax
	mov	edi, 198
	call	read@PLT
	cmp	rax, 4
	je	.L50
	mov	edi, 1
	call	_exit@PLT
.L50:
	mov	eax, DWORD PTR __afl_debug[rip]
	test	eax, eax
	je	.L51
	mov	edx, DWORD PTR -188[rbp]
	mov	rax, QWORD PTR stderr[rip]
	lea	rcx, .LC14[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
.L51:
	mov	eax, DWORD PTR -188[rbp]
	and	eax, -2130706431
	cmp	eax, -2130706431
	jne	.L52
	mov	eax, 0
	call	__afl_map_shm_fuzz
.L52:
	movzx	eax, BYTE PTR is_persistent[rip]
	test	al, al
	je	.L65
	mov	DWORD PTR -4[rbp], 1
.L65:
	cmp	DWORD PTR -4[rbp], 0
	je	.L53
	mov	DWORD PTR -4[rbp], 0
	jmp	.L54
.L53:
	lea	rax, -188[rbp]
	mov	edx, 4
	mov	rsi, rax
	mov	edi, 198
	call	read@PLT
	cmp	rax, 4
	je	.L54
	mov	edi, 1
	call	_exit@PLT
.L54:
	cmp	BYTE PTR -5[rbp], 0
	je	.L55
	mov	eax, DWORD PTR -188[rbp]
	test	eax, eax
	je	.L55
	mov	BYTE PTR -5[rbp], 0
	mov	eax, DWORD PTR child_pid[rip]
	lea	rcx, -192[rbp]
	mov	edx, 0
	mov	rsi, rcx
	mov	edi, eax
	call	waitpid@PLT
	test	eax, eax
	jns	.L55
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 35
	mov	esi, 1
	lea	rax, .LC15[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L55:
	cmp	BYTE PTR -5[rbp], 0
	jne	.L56
	call	fork@PLT
	mov	DWORD PTR child_pid[rip], eax
	mov	eax, DWORD PTR child_pid[rip]
	test	eax, eax
	jns	.L57
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 12
	mov	esi, 1
	lea	rax, .LC16[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L57:
	mov	eax, DWORD PTR child_pid[rip]
	test	eax, eax
	jne	.L58
	mov	rax, QWORD PTR -16[rbp]
	mov	rsi, rax
	mov	edi, 17
	call	signal@PLT
	mov	rax, QWORD PTR old_sigterm_handler[rip]
	mov	rsi, rax
	mov	edi, 15
	call	signal@PLT
	mov	edi, 198
	call	close@PLT
	mov	edi, 199
	call	close@PLT
	jmp	.L40
.L56:
	mov	eax, DWORD PTR child_pid[rip]
	mov	esi, 18
	mov	edi, eax
	call	kill@PLT
	mov	BYTE PTR -5[rbp], 0
.L58:
	mov	edx, 4
	lea	rax, child_pid[rip]
	mov	rsi, rax
	mov	edi, 199
	call	write@PLT
	cmp	rax, 4
	je	.L59
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 25
	mov	esi, 1
	lea	rax, .LC17[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L59:
	movzx	eax, BYTE PTR is_persistent[rip]
	test	al, al
	je	.L60
	mov	edx, 2
	jmp	.L61
.L60:
	mov	edx, 0
.L61:
	mov	eax, DWORD PTR child_pid[rip]
	lea	rcx, -192[rbp]
	mov	rsi, rcx
	mov	edi, eax
	call	waitpid@PLT
	test	eax, eax
	jns	.L62
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 15
	mov	esi, 1
	lea	rax, .LC18[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L62:
	mov	eax, DWORD PTR -192[rbp]
	movzx	eax, al
	cmp	eax, 127
	jne	.L63
	mov	BYTE PTR -5[rbp], 1
.L63:
	lea	rax, -192[rbp]
	mov	edx, 4
	mov	rsi, rax
	mov	edi, 199
	call	write@PLT
	cmp	rax, 4
	je	.L65
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 27
	mov	esi, 1
	lea	rax, .LC19[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	edi, 1
	call	_exit@PLT
.L67:
	nop
	jmp	.L40
.L68:
	nop
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	__afl_start_forkserver, .-__afl_start_forkserver
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
