%include "record_def.asm"
%include "linux.asm"
extern read_record
extern write_record
section .data
	filename db "records.dat", 0
	filename2 db "mod_records.dat", 0
section .bss
	record_buff resb rec_size
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
	mov rax, s_open
	mov rdi, filename2
	mov rsi, o_creat_wronly_trunc
	mov rdx, 0o666
	syscall
	%define fdout qword [rbp - 16]
	mov fdout, rax ; output file descriptor
mod_loop:
	push fdin
	push record_buff
	call read_record
	add rsp, 16
	cmp rax, rec_size
	jne done_reading
	mov rsi, [record_buff + rec_age]
	inc rsi
	mov [record_buff + rec_age], rsi
	push fdout
	push record_buff
	call write_record
	add rsp, 16
	jmp mod_loop
done_reading:
	mov rax, s_close
	mov rdi, fdin
	syscall
	mov rax, s_exit
	mov rdi, 0
	syscall
