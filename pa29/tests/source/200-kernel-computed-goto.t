#ifndef __code_model_kernel__
#error kernel code model macro missing
#endif

extern "C" int external_counter;
extern "C" void external_observer(int);

extern "C" void (*kernel_observer())(int) {
    return external_observer;
}

extern "C" int kernel_counter() {
    return external_counter;
}

extern "C" int dispatch_kernel(unsigned which, int value) {
    static const void *const targets[] __attribute__((section(".data.rel.ro.dispatch_targets"))) = {
        &&add, &&multiply
    };
    goto *targets[which & 1];
add:
    return value + 13;
multiply:
    return value * 7;
}
