# goal: factorial of a number.
.section .data
.section .text
.globl _start
	_start:
pushl $4
call factorial
addl $4, %esp # this is called scrubbing.
movl %eax, %ebx
movl $1, %eax
int $0x80
.type factorial,@function # since this is a standalone file, it's optional, but good practice.
	factorial: # [ a x]
# if a = 1, return 1.
# otherwise, return a*(a-1)!
pushl %ebp # [ %ebp a x]
movl %esp, %ebp # ~[] %ebp a x
subl $4, %esp # [ @] %ebp a x
movl 8(%ebp), %eax # 8 is a pointer. @](0+) %ebp(4+) a(8+)

cmpl $1, %eax
je fact_end

decl %eax
pushl %eax
call factorial # %eax = (a-1)!
movl 8(%ebp), %ebx # %ebx = a
imull %ebx, %eax # the return value %eax = a*(a-1)!
	fact_end:
movl %ebp, %esp # i thought that we forgot about pushing %eax, but that's okay, since we will move %esp back, and %eax will be scrubbed.
popl %ebp
ret

