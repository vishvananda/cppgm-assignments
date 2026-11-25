.text
.globl entry_target
.type entry_target,@function
entry_target:
    ret

.data
.globl entry_delta
entry_delta:
    .long entry_target - .
.globl delta_size
delta_size:
    .short . - entry_delta
.globl supplied_delta
supplied_delta:
    .long supplied_target - entry_delta + 16

.section .note.GNU-stack, "", @progbits
