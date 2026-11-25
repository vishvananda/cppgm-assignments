struct Row { int length; char data[]; };
static struct Row outer;

void check(void)
{
    struct Row { int length; char data[3]; };
    struct Row *local = &outer;
    (void)local;
}
