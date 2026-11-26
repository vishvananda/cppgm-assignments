#define STEP 3
#define SAVE_LR(unused) stp x29, x30, [sp, #-16]!

.macro increment, reg, uaccess
  add \reg, \reg, #\uaccess
.endm

.text
padding_start:
.word 0
padding_end:
.space padding_end - padding_start
repeat_begin:
nop
repeat_end:
.rept (repeat_end - repeat_begin) / 4
  nop
.endr
.if (. - repeat_begin) != 8
  .error "incorrect label distance"
.endif
.globl from_assembly
.type from_assembly, %function
from_assembly:
  argument .req w0
  hint #34
  yield
  SAVE_LR(0)
  prfm pldl1keep, [sp, #(repeat_end - repeat_begin + 4)]
  cbz argument, 1f
  increment argument, STEP
1:
  .unreq argument
  adrp x1, value
  ldr w1, [x1, :lo12:value]
  and w1, w1, #7
  lsl w1, w1, #1
  eor w1, w1, #0xf
  orr w1, w1, #2
  movz w2, #1, lsl #16
  movk w2, #0x1234
  lsr w2, w2, #16
  add w1, w1, w2, uxtb
  sub w1, w1, #1
  movz x2, :abs_g1_s:value
  movk x2, :abs_g0_nc:value
  ldr w2, [x2]
  add w1, w1, w2
  sub w1, w1, #11
  add w0, w0, w1
  bl from_cpp
  add x2, sp, xzr
  ldp x29, x30, [x2], #16
  mov sp, x2
  ret
.size from_assembly, .-from_assembly

.globl from_neon
.type from_neon, %function
from_neon:
  p4d .req x1
  ldr p4d, =value
  ld1 { v0.2s }, [p4d]
  .unreq p4d
  movi v1.2s, #1
  add v0.2s, v0.2s, v1.2s
  sub sp, sp, #16
  st1 { v0.2s }, [sp]
  ldar w0, [sp]
  add sp, sp, #16
  ret
.size from_neon, .-from_neon
.ltorg

.section .rodata
.balign 4
.word 255
.subsection 1
value:
.word 11
.word 0
.previous
.word 0xfefefefe
