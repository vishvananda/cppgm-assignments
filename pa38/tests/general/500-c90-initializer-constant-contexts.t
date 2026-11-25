struct Location { int *address; };
static int values[] = { 5, 37 };
static int incomplete(void);
static int answer = sizeof(incomplete());

static int late(void);

static int value_from_late(void)
{
    extern int late(void);
    return late();
}

static int late(void)
{
    return 5;
}

int main(void)
{
    struct Location value = { values + 1 };
    int seen = 0;
    int widths[] = { sizeof(seen = 7), sizeof(int) };
    return *value.address + value_from_late() != 42 || seen != 0 ||
           widths[0] != widths[1] || widths[0] != answer;
}
