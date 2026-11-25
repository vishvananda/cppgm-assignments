extern "C" unsigned long named_registers(unsigned long base, unsigned long extra) {
    register unsigned long source asm("r12") = base;
    register unsigned long other asm("%rsi") = extra;
    register unsigned long result asm("rdx");
    asm ("leaq 11(%%r12, %%rsi, 2), %%rdx" : "=r" (result) : "r" (source), "r" (other));
    return result;
}

extern "C" unsigned long tied_named_register(unsigned long input) {
    register unsigned long source asm("r12") = input;
    register unsigned long result asm("r12");
    asm ("leaq 7(%%r12), %%r12" : "=r" (result) : "0" (source));
    return result;
}

extern "C" unsigned long named_register_alternatives(unsigned long input) {
    register unsigned long source asm("r12") = input;
    register unsigned long result asm("rax");
    asm ("leaq 3(%%r12), %%rax" : "=a,r" (result) : "c,r" (source));
    return result;
}

extern "C" unsigned long repeated_named_register(unsigned long input) {
    register unsigned long value asm("r11") = input;
    asm ("leaq 5(%[before]), %0" : "+r" (value) : [before] "r" (value));
    return value;
}
