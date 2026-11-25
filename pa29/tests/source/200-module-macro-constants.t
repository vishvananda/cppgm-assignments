.data
.globl macro_constants
macro_constants:
.macro emit_word field:req index:req
    .set iteration, 0
    .irp n,0,1,2,3
        .if \n == \index
            .long \field + iteration
        .endif
        .set iteration, iteration + 1
    .endr
    .if iteration != 4
        .error "iteration count changed"
    .endif
.endm
emit_word index=2, field=(3 << 5) | (1 << 2)
emit_word index=0, field=(2 << 5) | (1 << 4)
.section .note.GNU-stack,"",@progbits
