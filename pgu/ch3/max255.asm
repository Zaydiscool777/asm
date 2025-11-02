section .data
data_items:
	dq 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 255
section .text
global _start
_start:
	mov rdi, 0
	mov rax, [rdi * 8 + data_items]
	mov rbx, rax
	.loop:
		cmp rax, 0
		je .exit
		inc rdi
		mov rax, [rdi * 8 + data_items]
		cmp rax, rbx
		jle .loop
		mov rbx, rax
		jmp .loop
	.exit:
		mov rax, 60
		mov rdi, rbx
		syscall
