.section .data
.section .text
.globl _start
	_start:
pushl $3
call square
addl $4, %esp
movl %eax, %ebx
movl $1, %eax
int $0x80
.type square,@function
	square:
pushl %ebp
movl %esp, %ebp
movl 8(%ebp), %eax # 4(%ebp) is the return address that call puts automatically. 
imull %eax, %eax
movl %ebp, %esp
popl %ebp
ret
