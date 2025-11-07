- [x] step 1. doing the main parts of pgu i want to do
- [ ] step 2. doing the main parts of pgu i don't
- [ ] step 3. doing the exercises
- [ ] step 4. try implementing basic x11? or gnome?
  - [ ] research

# assembling
```bash
nasm -@rn FILE
nasm -f elf64 -g -w+all FILE # actually rn
```
remove `-g` if not debugging;
`-g` is helpful in gdb

# linking asm and c
```bash
# this can happen in the ./linktest directory
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
for me, the printed file names were all basically:
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

# optimization
- optimize AFTER the product is clean
  - everything is documented
  - as well as works by the documentation
  - and the code is modular
- try not to in early development
- use a profiler tool, like `gprof` (standard)
- local optimization is about the program specifically
  - e.g. fastest instructions/methods
  - precomputing calculations
  - caching results
  - location of data (where it is -> how fast to access)
  - register usage
  - inline functions (macros)
  - optimized instructions (`mov,0` -> `xor`, `deccx;jz` -> `loop`)
  - addressing modes (`[const]` -> `[reg]` -> `[reg + const * reg]`)
  - data alignment (less variation of data sizes)
- global optimization is about what the program uses
  - e.g. inputs and outputs
  - usually about restructuring rather than solving
  - parallelization
  - statelessness

# further information
## pgu suggestions
### Bottom Up
- Programming from the Ground Up by Jonathan Bartlett
- Introduction to Algorithms by Thomas H. Cormen, Charles E. Leiserson, and
Ronald L. Rivest
- The Art of Computer Programming by Donald Knuth (3 volume set - volume 1
is the most important)
- Programming Languages by Samuel N. Kamin
- Modern Operating Systems by Andrew Tanenbaum
- Linkers and Loaders by John Levine
- Computer Organization and Design: The Hardware/Software Interface by
David Patterson and John Hennessy
### Top Down
- How to Design Programs by Matthias Felleisen, Robert Bruce Findler, Matthew
Flatt, and Shiram Krishnamurthi, available online at http://www.htdp.org/
- Simply Scheme: An Introduction to Computer Science by Brian Harvey and
Matthew Wright
- How to Think Like a Computer Scientist: Learning with Python by Allen
Downey, Jeff Elkner, and Chris Meyers, available online at
http://www.greenteapress.com/thinkpython/
- Structure and Interpretation of Computer Programs by Harold Abelson and
Gerald Jay Sussman with Julie Sussman, available online at
http://mitpress.mit.edu/sicp/
- Design Patterns by Erich Gamma, Richard Helm, Ralph Johnson, and John
Vlissides
- What not How: The Rules Approach to Application Development by Chris Date
- The Algorithm Design Manual by Steve Skiena
- Programming Language Pragmatics by Michael Scott
- Essentials of Programming Languages by Daniel P. Friedman, Mitchell Wand,
and Christopher T. Haynes
### Middle Out (specialized)
- Programming Perl by Larry Wall, Tom Christiansen, and Jon Orwant
- Common LISP: The Language by Guy R. Steele
- ANSI Common LISP by Paul Graham
- The C Programming Language by Brian W. Kernighan and Dennis M. Ritchie
- The Waite Group’s C Primer Plus by Stephen Prata
- The C++ Programming Language by Bjarne Stroustrup
- Thinking in Java by Bruce Eckel, available online at
http://www.mindview.net/Books/TIJ/
- The Scheme Programming Language by Kent Dybvig
- Linux Assembly Language Programming by Bob Neveln

## links
- https://brettapitz.github.io/posts/groundup1/
  - helped with getting started on nasm
- https://nasm.us/
  - docs on nasm
- https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/
  - syscalls
  - https://x64.syscall.sh/
- https://gaultier.github.io/blog/x11_x64
  - X11 (graphics) in assembly... crazy!!! 🤯
- `man` for `nasm:ld:objdump:readelf:patchelf:ldd:nm:ar`
- https://graphics.stanford.edu/~seander/bithacks.html
  - kinda faster alternatives to normal instructions
  - sometimes _very_ c oriented
- http://www.sandpile.org/
  - more on intel and amd and stuff
- https://www.cs.yale.edu/homes/perlis-alan/quotes.html
  - idk
