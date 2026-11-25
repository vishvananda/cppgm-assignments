enum Values {
    COUNT = sizeof(int) * __CHAR_BIT__ - 2,
    NEGATIVE = -2 << 1,
    WRAPPED = 10 << COUNT
};

static int negative = -1 << 0;
static int wrapped = 10 << COUNT;
static volatile int operand = 10;

int main(void)
{
    switch (operand << COUNT) {
    case WRAPPED:
        return NEGATIVE != -4 || negative != -1 || wrapped != -__INT_MAX__ - 1;
    default:
        return 1;
    }
}
