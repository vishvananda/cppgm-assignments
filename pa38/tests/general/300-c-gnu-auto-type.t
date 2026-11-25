static __auto_type global = 11u;
typedef int Index;

static int twice(int value) { return 2 * value; }

int main(void)
{
    int once = 0;
    {
        __auto_type Index = (Index)++once;
        if (Index != 1 || once != 1)
            return 1;
    }
    const int value = 7;
    __auto_type copy = value;
    const __auto_type qualified = value + 2;
    _Static_assert(__builtin_types_compatible_p(__typeof__(&copy), int *), "value conversion");
    _Static_assert(__builtin_types_compatible_p(__typeof__(&qualified), const int *), "declared qualifier");
    _Static_assert(__builtin_types_compatible_p(__typeof__(global), unsigned), "constant has unsigned type");

    int data[] = {2, 3, 5, 7};
    __auto_type element = data;
    __auto_type callback = twice;
    _Static_assert(__builtin_types_compatible_p(__typeof__(element), int *), "array conversion");
    _Static_assert(__builtin_types_compatible_p(__typeof__(callback), int (*)(int)), "function conversion");
    int length = 3;
    __auto_type row = (int (*)[++length])&data;
    if (length != 4 || sizeof *row != sizeof data)
        return 2;
    length = 1;
    int sum = 0;
    for (__auto_type i = 0u; i < sizeof *row / sizeof data[0]; ++i)
        sum += (*row)[i];
    return global != 11u || qualified != 9 || sum != 17 || callback(element[1]) != 6;
}
