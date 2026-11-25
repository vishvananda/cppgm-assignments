struct Part { int value; };

void examine(void)
{
    struct Outer { struct Part data; };
    struct Part { int value; };
    struct Outer { struct Part data; };
}
