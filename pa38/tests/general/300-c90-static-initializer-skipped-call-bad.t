int call(void);
static int value = 1 ? 42 : call();

int main(void)
{
    return value != 42;
}
