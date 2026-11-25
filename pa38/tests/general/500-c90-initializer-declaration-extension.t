struct Number { int value; };
int fallback(void);
__extension__ static int answer = 1 ? 42 : fallback();

static int check(int argument)
{
    __extension__ struct Number initialized = { argument };
    return initialized.value == answer;
}

int main(void)
{
    return !check(42);
}
