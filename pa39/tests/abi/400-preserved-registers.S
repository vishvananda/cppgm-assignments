#ifdef __APPLE__
#define WITNESS _check_registers
#define COLD_SAMPLE _sample_cold
#else
#define WITNESS check_registers
#define COLD_SAMPLE sample_cold
#endif
.text
.p2align 2
.globl WITNESS
// int check_registers(unsigned long seed, Callback fn, unsigned long expected)
WITNESS:
	sub sp, sp, #176
	stp x19, x20, [sp]
	stp x21, x22, [sp, #16]
	stp x23, x24, [sp, #32]
	stp x25, x26, [sp, #48]
	stp x27, x28, [sp, #64]
	stp d8, d9, [sp, #80]
	stp d10, d11, [sp, #96]
	stp d12, d13, [sp, #112]
	stp d14, d15, [sp, #128]
	stp x29, x30, [sp, #144]
	add x29, sp, #144
	str x2, [sp, #160]
	.irp n,19,20,21,22,23,24,25,26,27,28
	mov x\n, #\n
	.endr
	.irp n,8,9,10,11,12,13,14,15
	mov x9, #\n
	fmov d\n, x9
	.endr
	blr x1
	ldr x9, [sp, #160]
	cmp x0, x9
	b.ne 1f
	.irp n,19,20,21,22,23,24,25,26,27,28
	cmp x\n, #\n
	b.ne 1f
	.endr
	.irp n,8,9,10,11,12,13,14,15
	fmov x9, d\n
	cmp x9, #\n
	b.ne 1f
	.endr
	add x9, sp, #144
	cmp x29, x9
	cset w0, eq
	b 2f
1:	mov w0, #0
2:	ldp x19, x20, [sp]
	ldp x21, x22, [sp, #16]
	ldp x23, x24, [sp, #32]
	ldp x25, x26, [sp, #48]
	ldp x27, x28, [sp, #64]
	ldp d8, d9, [sp, #80]
	ldp d10, d11, [sp, #96]
	ldp d12, d13, [sp, #112]
	ldp d14, d15, [sp, #128]
	ldp x29, x30, [sp, #144]
	add sp, sp, #176
	ret

.p2align 2
.globl COLD_SAMPLE
COLD_SAMPLE:
	.irp n,0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	movi v\n\().16b, #0
	.endr
	add x0, x0, #3
	ret
#ifndef __APPLE__
.section .note.GNU-stack,"",%progbits
#endif
