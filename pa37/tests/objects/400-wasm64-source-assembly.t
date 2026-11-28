static_assert(sizeof(long) == 8 && sizeof(void *) == 8 && sizeof(int) == 4, "wasm64 is LP64");

asm(".globaltype current, i64");

extern "C" {
int image[] = {1, 3, 7, 9};
int *volatile address = image + 1;

long bump(long value) { return value + 2; }
long (*volatile callback)(long) = bump;

long observe(long value)
{
    asm volatile("local.get %0\n\tglobal.set current" : : "r"(value) : "memory");
    long saved;
    asm("global.get current\n\tlocal.set %0" : "=r"(saved));
    asm("" : "=r"(saved) : "0"(saved));
    return callback(saved) + address[1];
}
}
