extern "C" unsigned long add_widened(volatile unsigned* input,
                                    unsigned long canary,
                                    unsigned long* observed_canary) {
    unsigned left = input[0], right = input[1];
    asm volatile ("" ::: "rax", "rbx", "rcx", "rdx", "rsi", "rdi",
        "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15");
    unsigned long result;
    asm ("movq %1, %0; addq %2, %0" : "=&r" (result)
        : "r" (static_cast<unsigned long>(left)), "r" (static_cast<unsigned long>(right)) : "cc");
    *observed_canary = canary;
    return result;
}
