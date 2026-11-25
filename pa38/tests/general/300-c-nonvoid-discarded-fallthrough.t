static volatile int effects;

struct Result {
    int values[8];
};

static int scalar(int returns_value)
{
    effects += 1;
    if (returns_value)
        return 7;
    effects += 2;
}

static struct Result aggregate(int returns_value)
{
    struct Result result = {{2, 3, 5, 7, 11, 13, 17, 19}};
    effects += 4;
    if (returns_value)
        return result;
    effects += 8;
}

int main(void)
{
    volatile int discard = 0;
    int number;
    struct Result record;
    effects = 0;
    scalar(discard);
    (void)aggregate(discard);
    if (effects != 15)
        return 1;
    number = scalar(1);
    record = aggregate(1);
    return number != 7 || record.values[7] != 19 || effects != 20;
}
