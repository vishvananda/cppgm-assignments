extern int values[];

static int increment(int x) { return x + 1; }
static int (*handler)(int) = increment;
static int *position = &values[1] + (int)2.0;
static unsigned char *next_byte = (unsigned char *)&values[1] + 1;
static const char *word = "abc" + 1;
static int folded = 2 || 1 / 0;
static double fraction = (1.5 + 0.25) * 2;

struct Pair { int first; int second; };
static int *element = &(struct Pair){ 5, 8 }.second;
static struct Entry { int amount; int *pointer; } table[] = {
    { 1 << 3, values + 2 },
    { .pointer = &values[4], .amount = 6 - 3 }
};

static int test_local(int n)
{
    static int local = (3 + 4) * 2;
    static int *p = &local;
    static int (*row)[5] = (int (*)[n])values;
    return *p == 14 && row == (int (*)[5])values && (*row)[0] == 3;
}

int main(void)
{
    return !(handler(41) == 42 && *position == 13 &&
        next_byte == (unsigned char *)&values[1] + 1 && *word == 'b' &&
        folded == 1 && fraction == 3.5 && *element == 8 &&
        table[0].amount == 8 && *table[0].pointer == 11 &&
        table[1].amount == 3 && *table[1].pointer == 17 && test_local(5));
}
