extern "C" const char* get_text(bool literal)
{
    static const char text[] = "file";
    const char* address;
    if (literal)
        asm("leaq %c1(%%rip), %0" : "=r"(address) : "i"("line"));
    else
        asm("leaq %c1(%%rip), %0" : "=r"(address) : "i"(text));
    return address;
}
