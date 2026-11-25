static int limit = 1;

void f(void)
{
    for (extern int limit; limit; --limit)
        ;
}
