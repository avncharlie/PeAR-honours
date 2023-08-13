.LFB7:
	push	rbp
	mov	rbp, rsp
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
	ret

