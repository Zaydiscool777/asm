; this will be very hard...
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

section .bss
buffer_size equ 500
	buffer_data:
resb buffer_size

section .text
st_size_reserve equ 16
st_fd_in equ -8
st_fd_out equ -16
; seperated by 16 because of simd and some stuff
; it's obviously easier to sep. by a constant 16 than by varying amounts
st_argc equ 0
st_argv_0 equ 16
st_argv_1 equ 24
st_argv_2 equ 32

global _start
	_start:
enter st_size_reserve, 0
; open input file
mov rax, s_open
mov rdi, [rbp + st_argv_1]
mov rsi, o_rdonly
mov rdx, 0o444 ; r--r--r--
syscall ; rax is the file descriptor
mov [rbp + st_fd_in], rax
; open output file
mov rax, s_open
mov rdi, [rbp + st_argv_2]
mov rsi, o_creat_wronly_trunc
mov rdx, 0o666 ; rw-rw-rw-
syscall
mov [rbp + st_fd_out], rax

	read_loop:
mov rax, s_read
mov rdi, [rbp + st_fd_in]
mov rsi, buffer_data
mov rdx, buffer_size
syscall
cmp rax, eof
jle read_end
push buffer_data
push rax
call conv
pop rax
add rsp, 8
mov rdx, rax ; write
mov rax, s_write
mov rdi, [rbp + st_fd_out]
mov rsi, buffer_data
syscall
jmp read_loop
	read_end:
mov rax, s_close
mov rdi, [rbp + st_fd_in]
syscall
mov rax, s_close
mov rdi, [rbp + st_fd_out]
syscall
mov rax, s_exit
mov rdi, 0
syscall

lower_s equ 'a'
lower_e equ 'z'
lower_shift equ 'A' - 'a'
st_buffer_len equ 16
st_buffer equ 24
global conv:function
	conv:
enter 0, 0
mov rax, [rbp + st_buffer]
mov rbx, [rbp + st_buffer_len]
mov rcx, 0
cmp rbx, 0
je conv_end
	conv_loop:
mov dl, [rax + rcx]
cmp dl, lower_s
jl conv_next
cmp dl, lower_e
jg conv_next
add dl, lower_shift
mov [rax + rcx], dl
	conv_next:
inc rcx
cmp rcx, rbx
jl conv_loop
	conv_end:
leave
ret
