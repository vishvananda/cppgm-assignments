static int row[3] = { 2, 5, 8 };
static int (*unknown)[] = &row;
static int (*complete)[3] = &row;
static const int left = 7;
static volatile int right = 9;

_Static_assert(sizeof *(1 ? unknown : complete) == sizeof row, "right bound");
_Static_assert(sizeof *(1 ? complete : unknown) == sizeof row, "left bound");
_Static_assert(_Generic(1 ? &left : &right, const volatile int*: 1, default: 0),
    "qualifiers from both operands");

static int (*choose(int use_unknown, int* visits, int (*from)[], int (*to)[3]))[3]
{
    return use_unknown ? (++*visits, from) : to;
}

int main(void)
{
    int visits = 0;
    int a = (*choose(1, &visits, unknown, complete))[1];
    int b = (*choose(0, &visits, unknown, complete))[2];
    return !(a == 5 && b == 8 && visits == 1);
}
