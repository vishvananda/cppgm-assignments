// expect exit 0

enum { literal_choice = 7 ?: 42 };
static const int fallback = 0 ?: 17;
static int calls;
static char bytes[4];

static int probe(int value)
{
    ++calls;
    return value;
}

static void *pointer(void *value)
{
    ++calls;
    return value;
}

int main(void)
{
    if (literal_choice != 7 || fallback != 17)
        return 1;
    if ((probe(7) ?: probe(8)) != 7 || calls != 1)
        return 2;
    if ((probe(0) ?: probe(0) ?: probe(9)) != 9 || calls != 4)
        return 3;
    if ((pointer(bytes) ?: pointer(bytes + 1)) != bytes || calls != 5)
        return 4;
    if ((pointer(0) ?: pointer(bytes + 1)) != bytes + 1 || calls != 7)
        return 5;
    volatile double fraction = 0.5;
    if ((fraction ?: 2.0) != 0.5)
        return 6;
    (probe(1) ?: (void)probe(2));
    return calls != 8;
}
