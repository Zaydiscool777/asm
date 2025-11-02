section .data
data_items:
	dq 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 0
section .text
global _start
_start:
	mov rdi, 0
	mov rax, [rdi * 8 + data_items]
	mov rbx, rax
	.loop:
		cmp rax, 0
		je .exit
		mov rax, [rdi * 8 + data_items]
		inc rdi
		cmp rax, rbx
		jge .loop
		mov rbx, rax
		jmp .loop
	.exit:
		mov rax, 60
		mov rdi, rbx
		syscall
