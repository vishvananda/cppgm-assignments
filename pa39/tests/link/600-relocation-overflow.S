.text
.globl abs_value
abs_value:
	// Checked 16-bit move-wide relocation cannot represent this symbol address.
	movz x0, #:abs_g0:abs_value+0x10000
	ret
