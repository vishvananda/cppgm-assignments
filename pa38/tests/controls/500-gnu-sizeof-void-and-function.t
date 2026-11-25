// expect exit 0

static int calls;

static int probe(void)
{
    ++calls;
    return 9;
}

_Static_assert(sizeof(void) == 1, "GNU size of void");
_Static_assert(sizeof(int(void)) == 1, "GNU size of a function type");

int main(void)
{
    unsigned long bytes = sizeof((void)probe()) + sizeof(probe);
    return bytes != 2 || calls != 0;
}
