.LFB11:
	push	rbp
	mov	rbp, rsp
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
	ret


	.section	.rodata
.LC8:
	.string	"__AFL_SHM_FUZZ_ID"
.LC9:
	.string	"none"
.LC10:
	.string	"DEBUG: fuzzcase shmem %s\n"
.LC11:
	.string	"Could not access fuzzing shared memory"
.LC12:
	.string	"DEBUG: successfully got fuzzing shared memory\n"
.LC13:
	.string	"Error: variable for fuzzing shared memory is not set\n"