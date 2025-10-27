%include "record_def.asm"
%include "linux.asm"
extern write_record; %include "write_record.asm"
%macro new_record 5
	%1:
db %2
db (%1 + 40 - $) dup 0
db %3
db (%1 + 80 - $) dup 0
db %4
db (%1 + 320 - $) dup 0
dd %5
%endmacro
section .data
new_record record1, "Fredrick", "Barlett", \
`4242 S Prairie\nTulsa, OK 55555`, 45
new_record record2, "Marilyn", "Taylor", \
`2224 S Johannan St\nChicago, IL 12345`, 29
new_record record3, "Derrick", "McIntire", \
`500 W Oakland\nSan Diego, CA 54321`, 36
	file_name:
db "records.dat", 0

section .text
global _start
	_start:
enter 0, 0
mov rax, s_open
mov rdi, file_name
mov rsi, o_creat_wronly_trunc
mov rdx, 0o666
syscall
push rax
push record1
call write_record
add rsp, 8 ; fd still on stack
push record2
call write_record
add rsp, 8
push record3
call write_record
add rsp, 8
pop rax ; get fd
mov rdi, rax
mov rax, s_close
syscall
mov rax, s_exit
mov rdi, 0 ; xor rdi, rdi
syscall
