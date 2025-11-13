section .data
data_items:
	dq 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11 ; no sentinel
section .text
global _start
_start:
	mov rsi, data_items
	add rsi, 96 ; 12 * 8
	mov rdi, data_items
	mov rax, [rdi]
	mov rbx, rax
.loop:
	cmp rdi, rsi
	je .exit
	add rdi, 8
	mov rax, [rdi]
	cmp rax, rbx
	jle .loop
	mov rbx, rax
	jmp .loop
.exit:
	mov rax, 60
	mov rdi, rbx
	syscall
