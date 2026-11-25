.text
.globl sse_low_lanes
.type sse_low_lanes,@function
sse_low_lanes:
    movq %rdi, %xmm0
    pslld $4, %xmm0
    pshufd $0x01, %xmm0, %xmm1
    psrld $1, %xmm1
    movq %xmm1, %xmm2
    movq %xmm2, %rax
    ret
.size sse_low_lanes, . - sse_low_lanes
.section .note.GNU-stack,"",@progbits
