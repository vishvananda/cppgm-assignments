struct Block { unsigned low, high; };
extern "C" unsigned long read_block(const Block* block) {
    unsigned long result;
    asm("movq %1, %0" : "=r"(result) : "m"(*block));
    return result;
}
static unsigned& select(unsigned* object, unsigned* calls) {
    ++*calls;
    return *object;
}
extern "C" unsigned memory_update(unsigned input, unsigned* calls) {
    volatile unsigned value = input;
    asm volatile("addl $17, %0" : "+m"(value) : : "cc");
    unsigned result;
    asm("movl %1, %0" : "=r"(result) : "o"(value));
    asm("addl $7, %0" : "+m"(select(&result, calls)) : : "cc");
    return result;
}

extern "C" unsigned memory_array(unsigned input)
{
    unsigned values[2];
    unsigned long both = (97UL << 32) | input;
    asm("movq %1, %0" : "=m"(values) : "r"(both));
    unsigned second;
    asm("movl 4(%1), %0" : "=r"(second) : "r"(values) : "memory");
    return values[0] + second;
}
