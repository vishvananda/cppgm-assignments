extern int (*buffer)[];

void use(void)
{
    extern int (*buffer)[3];
    (void)buffer;
}

extern int (*buffer)[4];
