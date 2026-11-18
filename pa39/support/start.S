.text
.global _start
.type _start, %function
_start:
	adrp x19, __init_array_start
	add x19, x19, :lo12:__init_array_start
	adrp x20, __init_array_end
	add x20, x20, :lo12:__init_array_end
.Linit:
	cmp x19, x20
	b.eq .Lmain
	ldr x16, [x19], #8
	blr x16
	b .Linit
.Lmain:
	ldr x0, [sp]
	add x1, sp, #8
	add x2, x1, x0, lsl #3
	add x2, x2, #8
	bl main
	mov x8, #94
	svc #0
.size _start, .-_start
.section .note.GNU-stack,"",%progbits
