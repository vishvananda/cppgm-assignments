typedef int Counter;

static int after_do(void)
{
    do { } while (sizeof(enum { Counter }) == 0);
    Counter value = 17;
    return value;
}

static int other_branch(int condition)
{
    if (condition)
        (void)sizeof(enum { Counter });
    else
    {
        Counter value = 25;
        return value;
    }
    return 0;
}

int main(void)
{
    return after_do() + other_branch(0) != 42 || other_branch(1) != 0;
}
