// expect exit 0

static int sum(int first)
{
    int ordinary = first, __attribute__((unused)) *pointer = &ordinary;
    int extra = *pointer, __attribute__((unused)) last = extra + 3;
    return ordinary + extra + last;
}

int main(void)
{
    return sum(4) != 15;
}
