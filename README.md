# assembling
```bash
nasm -@rn FILE
nasm -f elf64 -g -w+all FILE # actually rn
```
remove `-g` if not debugging;
`-g` is helpful in gdb

# linking asm and c
```bash
nasm -f elf64 -o linktest_asm.o linktest_asm.asm
gcc -c -o linktest_c.o linktest_c.c -O0
gcc -no-pie -o linktest linktest_c.o linktest_asm.o -lc
```

this is a deprecated behaviour, but the warning still pops
up for now: `missing .note.GNU-stack section implies executable stack`.
to fix, add to asm:
```bash
section .note.GNU-stack noalloc noexec nowrite progbits
```
also, without `-no-pie`, it uses `Scrt1.o`, which is made
for shared libraries.

## using ld instead of gcc
**note: gcc is more portable than ld!**

`gcc -print-file-name` can be used for finding the actual files
gcc talks about:

```bash
# after compiling FILE.asm w/ nasm

CRT1=$(gcc -print-file-name=crt1.o)
CRTI=$(gcc -print-file-name=crti.o)
CRTN=$(gcc -print-file-name=crtn.o)
LDD=$(gcc -print-file-name=ld-linux-x86-64.so.2)

ld "$CRT1" "$CRTI" \
	FILE.o -lc \
	"$CRTN" \
	-dynamic-linker "$LDD" \
	-L . \
	-o EXEC
```
### me
For me, the printed file names were all basically:
```
/usr/lib/gcc/x86_64-linux-gnu/13/../../../x86_64-linux-gnu/FILE
# which becomes
/usr/lib/x86_64-linux-gnu/FILE
```
where `FILE` was the argument passed to `gcc`.
I can also use `/lib64/ld-linux-x86-64.so.2`

# on ld
use `ld -shared` to make a `.so` instead of a normal `.o`.
`libNAME.so` allows you to use the flag `-lNAME` to link it.
although, you should use `-L .` if it is local only.

use `-rpath` to add a _directory_ to search for libraries,
or set `$LD_LIBRARY_PATH` to them colon-seperated. it is
usually empty by default, and it will be checked if not empty.

`nm` and `objdump` are useful! so is `readelf` and `ldd`.
`ld -r` _combines_ objects.
`ar` archives static objects?

## calling with c
the c calling convention in convoluted, but here is a summary:
- word inputs are rdi, rsi, rdx, rcx, r8, and r9.
- word outputs are rax and rdx
- word inputs, rax, r9, and r10 are volatile:
  	they are saved by the caller, not callee.
- floating point uses sse: in = xmm0-7, and out = xmm0 and xmm1
- al has the amount of floats used?
- long double is x87: input is the stack, and out = st0 and st1
- all sse and x87 is volatile
- rest of registers are non-volatile: callee saves
- obviously, if all registers are full, use stack
  
## other c stuff
because of `crt1.o`, you use `main` instead of `_start`.

# links
- https://brettapitz.github.io/posts/groundup1/
- https://nasm.us/
- https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/
- https://gaultier.github.io/blog/x11_x64
- `man` for `nasm:ld:objdump:readelf:patchelf:ldd:nm:ar`
