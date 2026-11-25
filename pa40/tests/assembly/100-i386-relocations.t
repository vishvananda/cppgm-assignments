#if !defined(__i386__) || defined(__x86_64__) || __SIZEOF_POINTER__ != 4
#error expected i386 target macros
#endif

.text
.globl _start
.type _start,@function
_start:
    call helper
    movl $1, %eax
    int $0x80
.size _start, .-_start
