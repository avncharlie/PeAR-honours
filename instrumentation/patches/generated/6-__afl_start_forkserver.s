.LFB12:
	push	rbp
	mov	rbp, rsp
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
	ret


	.section	.rodata
.LC14:
	.string	"target forkserver recv: %08x\n"
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