section .data
	s_read equ 0
	s_write equ 1
	s_open equ 2
	s_close equ 3
	s_exit equ 60
	; /usr/include/asm-generic/fcntl.h for me
	o_rdonly equ 0o0000_0000
	o_creat_wronly_trunc equ 0o0000_1101
	
	f_stdin equ 0
	f_stdout equ 1
	f_stderr equ 2
	eof equ 0

	arg_c equ 0
	arg_0 equ 8
	arg_1 equ 16
	arg_2 equ 24

section .bss
	buffer_size equ 500
	buffer_data resb buffer_size

	file_in resq 1
	file_out resq 1
	
section .text
global _start
_start:
	; if argc is 0, use stdin/stdout
	mov rax, [rsp + arg_c]
	cmp rax, 3
	jge .open_files
	mov qword [rsp + arg_1], f_stdin
	mov qword [rsp + arg_2], f_stdout
	jmp .loop
.open_files:
	mov rax, s_open
	mov rdi, [rsp + arg_1]
	mov rsi, o_rdonly
	mov rdx, 0o444 ; r--r--r--
	syscall ; rax is the file descriptor
	mov [file_in], rax
	mov rax, s_open
	mov rdi, [rsp + arg_2]
	mov rsi, o_creat_wronly_trunc
	mov rdx, 0o666 ; rw-rw-rw-
	syscall
	mov [file_out], rax
.loop:
	mov rax, s_read
	mov rdi, [file_in]
	mov rsi, buffer_data
	mov rdx, buffer_size
	syscall
	cmp rax, eof
	jle .end
	push rax
	mov rdi, rax
	mov rax, buffer_data
	call conv
	pop rax
	add rsp, 8
	mov rdi, [file_out]
	mov rsi, buffer_data
	mov rdx, rax
	mov rax, s_write
	syscall
	jmp .loop
.end:
	mov rax, s_close
	mov rdi, [file_in]
	syscall
	mov rax, s_close
	mov rdi, [file_out]
	syscall
	mov rax, s_exit
	mov rdi, 0
	syscall

	lower_s equ 'a'
	lower_e equ 'z'
	lower_shift equ 'A' - 'a'
global conv:function
conv:
	; conv(char* buffer_addr, size_t length)
	enter 0, 0
	mov rcx, rdi
	mov rsi, rax
	test rcx, rcx
	je .ret
.loop:
	mov dl, [rsi]
	cmp dl, lower_s
	jl .next
	cmp dl, lower_e
	jg .next
	add dl, lower_shift
	; alt: and dl, 0b1101_1111
.next:
	mov [rsi], dl
	inc rsi
	loop .loop
.ret:
	leave
	ret
