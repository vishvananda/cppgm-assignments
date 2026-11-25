enum Byte : const volatile unsigned char;
enum Byte : unsigned char { start = 254, end, typed = sizeof(start) };
enum Flag : bool { clear, set };

static_assert(sizeof(enum Byte) == sizeof(unsigned char));
static_assert(typed == sizeof(unsigned char) && end == 255);
static_assert(_Generic(start, enum Byte: 1, default: 0));

static volatile enum Flag flag;
static int object;

int main(void)
{
    volatile double real = 42.75;
    enum Byte converted = real;
    if (converted != 42)
        return 1;
    flag = &object;
    if (flag++ != set || flag-- != set || flag != clear)
        return 2;
    if (--flag != set || flag != set)
        return 3;
    flag = 8;
    if (flag != set)
        return 4;
    flag = nullptr;
    return flag != clear;
}
