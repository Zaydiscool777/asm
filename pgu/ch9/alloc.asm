section .data
	heap_start dq 0 ; constant amount of storage
	heap_now dq 0 ; here too
	navail equ 0
	avail equ 1
	s_brk equ 12
	
	struc header
	    .avail resq 1 ; really resb, but alignment
		.rsize resq 1 ; size of the region
	endstruc
	
section .text
global alloc_init:function
alloc_init:
	enter 0, 0
	mov rax, s_brk
	mov rdi, 0
	syscall
	inc rax
	mov [heap_now], rax
	mov [heap_start], rax
	leave
	ret
	
global alloc:function
	; rcx holds input: number of bytes to allocate
	; rax is examined region
	; rbx is break position
	; rdx is region size
alloc:
	enter 0, 0
	mov rcx, rdi ; in
	mov rax, [heap_start]
	mov rbx, [heap_now]
.loop: ; loop start
	cmp rax, rbx
	je .brk ; if the heap "begins" where it is, it's full
	mov rdx, [rax + header.rsize]
	cmp qword [rax + header.avail], navail
	je .next ; obvoiously, it should be available
	cmp rcx, rdx
	jle .do_here ; if req < size, then yeah!
.next: ; lookup fail
	; block = header + memory, so add to cur pos
	add rax, header_size
	add rax, rdx
	jmp .loop
.do_here: ; lookup sucsess!
	mov qword [rax + header.avail], navail ; occupy
	add rax, header_size
	leave
	ret
.brk: ; super lookup fail
	add rbx, header_size
	add rbx, rcx
	push rax ; save registers for caller
	push rcx
	push rbx
	mov rax, s_brk ; syscall
	syscall
	cmp rax, 0 ; if error
	je .err
	pop rbx
	pop rcx
	pop rax
	mov qword [rax + header.avail], navail ; occupy
	mov [rax + header.rsize], rcx ; size
	add rax, header_size ; account for header
	mov [heap_now], rbx ; update heap_now
	leave
	ret
.err:
	add rsp, 24 ; pop 3
	mov rax, 0 ; NULL on error
	leave
	ret
	
global dealloc:function
	enter 0, 0
	mov rax, rdi
	sub rax, header_size ; although heap goes up, still little-endian
	mov qword [rax + header.avail], avail
	leave
	ret
