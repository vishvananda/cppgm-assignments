.set RESULT_BASE, (2 * 5 + 6)
INTEGER_RESULT = RESULT_BASE - 1

.text
.globl symbol_expression_function
.type symbol_expression_function,@function
symbol_expression_function:
    movl $INTEGER_RESULT + 12, %eax
    ret
.globl symbol_expression_end
symbol_expression_end:
.set FUNCTION_SIZE, . - symbol_expression_function
.size symbol_expression_function, FUNCTION_SIZE

.data
.globl byte_before_origin
byte_before_origin:
    .byte 0x27
.org (byte_before_origin + 3), 0x32
    .byte 0x56
.globl measured_size
measured_size:
    .long ((symbol_expression_end - symbol_expression_function) + FUNCTION_SIZE)
.globl measured_pointer
measured_pointer:
    .quad (byte_before_origin + 2)
.section .note.GNU-stack,"",@progbits
