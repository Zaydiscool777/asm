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
	start_loop:
cmp rdi, rsi
je loop_exit
add rdi, 8
mov rax, [rdi]
cmp rax, rbx
jle start_loop
mov rbx, rax
jmp start_loop
	loop_exit:
mov rax, 60
mov rdi, rbx
syscall
