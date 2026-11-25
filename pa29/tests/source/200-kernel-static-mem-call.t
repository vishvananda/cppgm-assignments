struct Hooks {
    void (*first)();
    void (*second)();
};
extern "C" Hooks hooks;

extern "C" void dispatch_hooks() {
    asm volatile (
        "1: call *%0\n"
        "2: call *%1\n"
        "3: .pushsection .rodata.hook_call_sizes,\"a\"\n"
        ".byte 2b-1b, 3b-2b\n"
        ".popsection"
        : : "m" (hooks.first), "m" (hooks.second)
        : "rax", "rcx", "rdx", "rsi", "rdi", "r8", "r9", "r10", "r11", "memory", "cc");
}
