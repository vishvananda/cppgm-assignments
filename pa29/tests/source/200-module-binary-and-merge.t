/*slice*/
.pushsection .rodata.byte_strings, "aMS", @progbits, 1
.globl module_slice
.type module_slice STT_NOTYPE
module_slice:
.incbin __FILE__, 2, 5
.byte 0
.popsection

.pushsection .discard.test_entries, "M", @progbits, 8
.quad 17, 23
.popsection

.section .note.GNU-stack, "", @progbits
