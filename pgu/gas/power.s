.section .data
.section .text
.globl _start

# goal: calculate and return 2^3 + 5^2
	_start:
pushl $3
pushl $2 # [ 2 3] ...
call power
addl $8, %esp # move stack pointer back by 4 * 2 = 8
pushl %eax # [ 2^3] ...
pushl $2
pushl $5 # [ 5 2 2^3] ...
call power # [ 5 2 2^3] ...
addl $8, %esp # ~ ~[ 2^3] -> [ 2^3]
popl %ebx # [ ]
addl %eax, %ebx # %ebx += %eax
movl $1, %eax # %ebx has return value
int $0x80

# %ebx: base
# %ecx: power
# -4(%ebp): current result
# %eax: temporary storage

.type power, @function
	power:
pushl %ebp # eg. ~[ %ebp 5 2 2^3]
movl %esp, %ebp # eg. ~[] %ebp 5 2 2^3
subl $4, %esp # eg. [ @] %ebp 5 2 2^3
movl 8(%ebp), %ebx 
movl 12(%ebp), %ecx
movl %ebx, -4(%ebp)
	power_loop_start:
cmpl $1, %ecx
je end_power # x^1 = x
movl -4(%ebp), %eax
imull %ebx, %eax
movl %eax, -4(%ebp)
decl %ecx
jmp power_loop_start
	end_power:
movl -4(%ebp), %eax
movl %ebp, %esp # @[] %ebp 5 2 2^3
popl %ebp # @[] %ebp 5 2 2^3 -> @ [] 5 2 2^3 -> ~ [ 5 2 2^3]
ret
