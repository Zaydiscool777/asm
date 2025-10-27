%include "record_def.asm"
%include "linux.asm"
extern read_record
extern strlen
extern writenl

section .data
	filename:
db "records.dat", 0

section .bss
	record_buff:
resb rec_size

section .text
global _start
	_start:
enter 16, 0
mov rax, s_open
mov rdi, filename
mov rsi, o_rdonly
mov rdx, 0o666
syscall
%define fdin qword [rbp - 8]
mov fdin, rax ; input file descriptor
%define fdout qword [rbp - 16]
mov fdout, 0 ; output file descriptor
	read_loop:
push fdin
push record_buff
call read_record
add rsp, 16

cmp rax, rec_size
jne done_reading

mov byte [record_buff + rec_firstname + 39], 0 ; Null-terminate the first name
push record_buff + rec_firstname
call strlen
add rsp, 8

mov rdx, rax
mov rax, s_write
mov rdi, fdout
mov rsi, record_buff + rec_firstname
syscall

push fdout
call writenl
add rsp, 8

jmp read_loop
	done_reading:
mov rax, s_close
mov rdi, fdin
syscall
mov rax, s_exit
mov rdi, 0
syscall
