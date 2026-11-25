asm(".cfi_sections .eh_frame, .debug_frame\n"
    ".text\n.globl debug_frame_probe\n.type debug_frame_probe,@function\n"
    "debug_frame_probe:\n.cfi_startproc\n.cfi_signal_frame\n"
    ".cfi_personality 0x1b, debug_frame_personality\n"
    "pushq %rbp\n.cfi_adjust_cfa_offset 8\n.cfi_offset %rbp,-16\n"
    "popq %rbp\n.cfi_adjust_cfa_offset -8\n.cfi_restore %rbp\n"
    "ret\n.cfi_endproc\n.size debug_frame_probe, .-debug_frame_probe\n");
