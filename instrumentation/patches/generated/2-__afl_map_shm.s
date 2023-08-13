.LFB8:
	push	rbp
	mov	rbp, rsp
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
	ret


	.section	.rodata
.LC0:
	.string	"__AFL_SHM_ID"
.LC1:
	.string	"<null>"
.LC2:
	.string	"DEBUG: (1) id_str %s, __afl_area_ptr %p, __afl_area_ptr_dummy %p, MAP_SIZE %u\n"
.LC3:
	.string	"shmat for map"
.LC4:
	.string	"DEBUG: (2) id_str %s, __afl_area_ptr %p, __afl_area_ptr_dummy %p, MAP_SIZE %u\n"