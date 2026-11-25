static int component(int input)
{
    return 11 * input;
}

extern "C" int function_operand(int input)
{
    int (*address)(int);
    asm("leaq %c1(%%rip), %0" : "=r"(address) : "i"(component));
    return address(input);
}
