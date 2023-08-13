.LFB6:
	push	rbp
	mov	rbp, rsp
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
	ret

