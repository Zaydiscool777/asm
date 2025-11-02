section .data
	s_read equ 0
	s_write equ 1
	s_open equ 2
	s_close equ 3
	s_exit equ 60
	o_rdonly equ 0o0000_0000
	o_creat_wronly_trunc equ 0o0000_1101
	f_stdin equ 0
	f_stdout equ 1
	f_stderr equ 2
	eof equ 0
	fname db "heynow.txt", 0
	msg db "Hey diddle diddle!", 0
	msglen equ 18 ; $ - msg
section .text
global _start
_start:
	mov rax, s_open
	mov rdi, fname
	mov rsi, o_creat_wronly_trunc
	mov rdx, 0o666
	syscall
	mov rdi, rax
	mov rax, s_write
	mov rsi, msg
	mov rdx, msglen
	syscall
	mov rdi, rax
	mov rax, 60
	syscall
