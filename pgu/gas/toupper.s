# steps:
# open input file
# open output file
# until eof:
# read an amount to buffer
# if letter is lowercase, make it uppercase for each letter in the buffer
# write buffer to output file
# close files once eof
	.section .data
# use for system calls
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ LINUX_SYSCALL, 0x80
# file options
.equ O_RNN, 0
.equ O_RWN, 03101
.equ CHMOD, 0666
.equ STDIN, 0
.equ STDOUT, 1
.equ EOF, 0
	.section .bss
# never exceed 16000
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE
	.section .text
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
# 0 is ARGC
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12
.globl _start
	_start:
movl %esp, %ebp
subl $ST_SIZE_RESERVE, %esp
# open files
movl $SYS_OPEN, %eax
movl ST_ARGV_1(%ebp), %ebx
movl $O_RNN, %ecx
movl $CHMOD, %edx
int $LINUX_SYSCALL
movl %eax, ST_FD_IN(%ebp)
movl $SYS_OPEN, %eax
movl ST_ARGV_2(%ebp), %ebx
movl $O_RWN, %ecx
movl $CHMOD, %edx
int $LINUX_SYSCALL
movl %eax, ST_FD_OUT(%ebp)
	loop_read:
movl $SYS_READ, %eax
movl ST_FD_IN(%ebp), %ebx
movl $BUFFER_DATA, %ecx
movl $BUFFER_SIZE, %edx
int $LINUX_SYSCALL
cmpl $EOF, %eax
jle loop_end
	loop_write:
pushl $BUFFER_DATA
pushl %eax
call convert
popl %eax
addl $4, %esp
movl %eax, %edx
movl $SYS_WRITE, %eax
movl ST_FD_OUT(%ebp), %ebx
movl $BUFFER_DATA, %ecx
int $LINUX_SYSCALL
jmp loop_read
	loop_end:
movl $SYS_CLOSE, %eax
movl ST_FD_OUT(%ebp), %ebx
int $LINUX_SYSCALL
movl $SYS_CLOSE, %eax
movl ST_FD_IN(%ebp), %ebx
int $LINUX_SYSCALL
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12
.type convert, @function
	convert:
pushl %ebp
movl %esp, %ebp
movl ST_BUFFER(%ebp), %eax
movl ST_BUFFER_LEN(%ebp), %ebx
movl $0, %edi
cmpl $0, %ebx
je end_convert_loop
	convert_loop:
movb (%eax,%edi,1), %cl
cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASE_Z, %cl
jg next_byte
addb $UPPER_CONVERSION, %cl
movb %cl, (%eax,%edi,1)
	next_byte:
incl %edi
cmpl %edi, %ebx
jne convert_loop
	end_convert_loop:
movl %ebp, %esp
popl %ebp
ret



