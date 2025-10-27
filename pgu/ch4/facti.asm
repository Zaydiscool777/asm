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
mov rcx, [rbp + 16]
mov rax, 1
	fact_loop:
imul rax, rcx
loop fact_loop
leave
ret
