struct Cell { int value; };

static int plus_one(register int value)
{
    return value + 1;
}

int main(void)
{
    struct Cell cell = {3};
    register int array[4];
    register struct Cell copy = {6};
    register struct Cell *cursor = &cell;
    int *pointee = &(cursor->value);
    return sizeof array != 4 * sizeof(int) || *pointee != 3 ||
        plus_one(copy.value) != 7;
}
