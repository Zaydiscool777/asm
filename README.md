```
nasm -@ r FILE
nasm -f elf64 -g -w+all FILE
```
remove `-g` if not debugging;
`-g` is helpful in gdb

# linking asm and c
```
nasm -f elf64 -o linktest_asm.o linktest_asm.asm
gcc -c -o linktest_c.o linktest_c.c -O0
gcc -no-pie -o linktest linktest_c.o linktest_asm.o -lc
```

this is a deprecated behaviour, but the warning still pops
up for now: `missing .note.GNU-stack section implies executable stack`.
to fix, add to asm:
`section .note.GNU-stack noalloc noexec nowrite progbits`
also, without `-no-pie`, it uses `Scrt1.o`, which is made
for shared libraries.

`nm` and `objdump` are useful!

the c calling convention in convoluted, but here is a summary:
- int inputs are rdi, rsi, rdx, rcx, r8, and r9.
- int outputs are rax and rdx
- int inputs, rax, r9, and r10 are volatile:
  	they are saved by the caller, not callee.
- floating point uses sse: in = xmm0-7, and out = xmm0 and xmm1
- long double is x87: input is the stack, and out = st0 and st1
- all sse and x87 is volatile
- rest of registers are non-volatile: callee saves
- obviously, if all registers are full, use stack

<!-- crt*.o is already included by gcc
`/usr/lib/x86_64-linux-gnu/` can be used for `crt*.o` as well.
the `*` in `crt*.o` should be `1`, `i`, and `n` only. -->

https://brettapitz.github.io/posts/groundup1/
https://nasm.us/
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86_64-64_bit
