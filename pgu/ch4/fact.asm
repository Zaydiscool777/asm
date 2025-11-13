section .text
global _start
_start:
	push 4
	call fact
	add rsp, 8
	mov rdi, rax ; exit
	mov rax, 60
	syscall
	
global fact:function
fact:
	enter 0, 0
	mov rax, 1
	mov rcx, [rbp + 16] ; ... in RET [RBP]
	cmp rcx, 0
	je .end
	mov rbx, rcx
	dec rcx
	push rbx
	push rcx
	call fact ; rax = fact(n-1)
	add rsp, 8
	pop rbx
	imul rax, rbx ; rax = n * fact(n-1)
.end:
	leave
	ret
