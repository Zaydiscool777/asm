these were written in x86, not x86-64. best in https://vfsync.org/vm.html

`as FILE`

```movl %eax, 8(%ebx,%edi,4)```

In Intel syntax, this would be written as:

```mov [8 + %ebx + 1 * edi], eax```
