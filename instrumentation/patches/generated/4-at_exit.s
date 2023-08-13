.LFB10:
	push	rbp
	mov	rbp, rsp
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

