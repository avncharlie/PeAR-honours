.LFB9:
	push	rbp
	mov	rbp, rsp
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
	ret


	.section	.rodata
.LC5:
	.string	"ERROR: malloc to setup dummy map failed\n"
.LC6:
	.string	"AFL_DEBUG"
.LC7:
	.string	"DEBUG: debug enabled\n"