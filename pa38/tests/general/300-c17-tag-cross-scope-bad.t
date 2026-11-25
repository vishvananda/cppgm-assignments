struct Row { int value; };
static struct Row outer;

void check(void)
{
    struct Row { int value; };
    struct Row *local = &outer;
    (void)local;
}
