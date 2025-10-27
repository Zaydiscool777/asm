.section .data
	data_items:
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
.section .text
.globl _start
    _start:
pushl data_items
call max
addl $4, %esp
movl $0, %ebx
movl $1, %eax
int $0x80

.type max,@function
	max: # [ret in ext]
pushl %ebp # [%ebp ret in ext]
movl %esp, %ebp # [%ebp] ret in ext
movl 8(%ebp), %esi
movl $0, %edi
movl (%esi,%edi,4), %eax
movl %eax, %ebx
	start_max:
movl (%esi,%edi,4), %eax
cmpl $0, %eax
je max_exit
incl %edi
cmpl %ebx, %eax
jle start_max
movl %eax, %ebx
jmp start_max
	max_exit:
movl %ebp, %esp # [%ebp] ret in ext
popl %ebp # [ret in ext]
ret 
