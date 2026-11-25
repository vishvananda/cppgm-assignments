#define REGISTER(name) % name

.text
.globl load_array_element
.type load_array_element,@function
load_array_element:
    movl (example_array + 4)(REGISTER(RIP)), REGISTER(eax)
    ret

.globl system_instructions
.type system_instructions,@function
system_instructions:
    movq REGISTER(gs):(example_array + 8)(REGISTER(rip)), REGISTER(rax)
    pushfq
    popfq
    rdmsr
    wrmsr
    clac
    stac
    swapgs
    cli
    sti
    hlt
    leaveq
    lgdt (%rax)
    lidt (%r8)
    sgdt (%eax)
    sidt %gs:(%rax)
    invlpg (%rdx)
    movq %cr3,%rax
    movq %rdi,%cr3
    movq %cr8,%r9
    movq %r8,%cr8
    movq %dr6,%r12
    movq %r13,%dr7
    movq %ds,%rax
    movl %fs,%ecx
    movw %gs,(%rax)
    movw %ax,%ds
    movl %ecx,%fs
    movw (%rbx),%gs
    inb %dx,%al
    inw $42,%ax
    inl %dx,%eax
    outb %al,$42
    outw %ax,%dx
    outl %eax,%dx
    movntiq %rax,(%rbx)
    movntil %ecx,12(%rdx)
    verw %ax
    verw 2(%rax)
    sldt %ax
    sldt %r8d
    sldt %r9
    sldt 12(%rax)
    prefetcht0 8(%rax)
    prefetcht1 16(%rax)
    prefetcht2 24(%rax)
    prefetchnta 32(%rax)
    prefetchw 40(%rax)
    lar %ax,%cx
    lar %eax,%ecx
    lar %rax,%rcx
    larq (%rax),%r8
    movntdqa 16(%rdi),%xmm0
    punpcklqdq %xmm5,%xmm8
    pinsrd $3,%r8d,%xmm0
    pinsrq $1,%r8,%xmm11
    xsaves64 (%rdi)
    xsaves (%rdi)
    xrstors64 (%rdi)
    xrstors (%rdi)
    xsave64 (%rdi)
    xsave (%rdi)
    xrstor64 (%rdi)
    xrstor (%rdi)
    xsaveopt (%rdi)
    xsaveopt64 (%rdi)
    xsavec (%rdi)
    xsavec64 (%rdi)
    wbinvd
    monitorx
    mwaitx
    monitor
    mwait
    fninit
    movq %db0,%rax
    movq %r9,%db7
    ud1 (%edx),%rdi
    ud1 %esp,%ecx
    sysretq
    sysretl
    rdpid %rax
    rdpid %r9
    rdgsbase %r9
    rdgsbase %eax
    wrfsbase %r10
    fxsave (%rdi)
    fxsave64 (%r9)
    fxrstor (%rax)
    fxrstor64 (%rax)
    clflush (%rax)
    clflushopt (%rax)
    clwb (%rax)
    fnclex
    crc32b (%rax),%eax
    crc32b (%rax),%r8
    crc32w (%rax),%eax
    crc32l (%rax),%eax
    crc32q (%rax),%r8
    iretq

.data
example_array:
    .long 23, 47, 0, 0
.section .note.GNU-stack,"",@progbits
