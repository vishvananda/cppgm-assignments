extern int never_called(void);
enum { three = (int)(3.5), zero = sizeof(char) - 1 };

_Static_assert(three == 3 && '0' != 0, "enum and character constants");
_Static_assert(1 ? 1 : (0, 0), "unevaluated comma");
_Static_assert(1 || (0, 0), "short circuit");
_Static_assert(sizeof never_called() == sizeof(int), "unevaluated sizeof operand");
_Static_assert(_Generic(three, int: 1, default: never_called()), "selected association");

static int values[three] = { [1 | 0] = 7 };
_Alignas(1 << 3) static unsigned char aligned;

static int is_null(int *p)
{
    return p == sizeof(char) - 1;
}

static int *returns_null(void)
{
    return zero;
}

int main(void)
{
    const int size = three;
    int runtime_array[size];
    int *p = 2 - 2;
    int *q = aligned ? values : (1 & 2);
    runtime_array[2] = values[1];
    switch (runtime_array[2])
    {
    case (1 << three) - 1:
        return !(is_null(1 - 1) && !p && !q && !returns_null());
    default:
        return 1;
    }
}
