static int stored = 11;

extern "C" const int* symbol_address()
{
    const int* result;
    asm("leaq %a1, %0" : "=r"(result) : "i"(&stored));
    return result;
}

extern "C" const int* register_address(const int* address)
{
    const int* result;
    asm("leaq %a1, %0" : "=r"(result) : "r"(address));
    return result;
}
