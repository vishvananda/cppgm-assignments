union Value { int count; float reading; };
static union Value value;

void check(void)
{
    union Value { float reading; int count; };
    union Value *local = &value;
    (void)local;
}
