// expect exit 0

extern unsigned int invalid_size;

#define CHECKED_SIZE(type) \
    (sizeof(type) == sizeof(type[1]) && sizeof(type) < 64 ? sizeof(type) : invalid_size)

enum { computed = CHECKED_SIZE(char[8]) };
static const int table[16] = { [CHECKED_SIZE(char[8])] = 42 };

static int evaluate(unsigned int value)
{
    switch (value) {
    case 32 | CHECKED_SIZE(char[4]):
        return 7;
    case 32 | CHECKED_SIZE(char[8]):
        return 9;
    default:
        return 0;
    }
}

int main(void)
{
    return computed != 8 || table[8] != 42 || evaluate(36) != 7 || evaluate(40) != 9 || evaluate(33) != 0;
}
