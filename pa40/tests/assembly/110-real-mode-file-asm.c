__asm__(".pushsection .rodata\n"
        ".globl real_mode_push, real_mode_pop, real_mode_ret\n"
        "real_mode_push: pushl %eax\n"
        "real_mode_pop: popl %eax\n"
        "real_mode_ret: retl\n"
        ".popsection\n");
