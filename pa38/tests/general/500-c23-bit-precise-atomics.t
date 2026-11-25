typedef unsigned _BitInt(9) U9;

static _Atomic(U9) value = 511;

int main(void)
{
    if (value++ != 511 || value != 0)
        return 1;
    if ((value += 509) != 509 || (value += 4) != 1)
        return 2;
    if (__atomic_fetch_add(&value, (U9)511, __ATOMIC_SEQ_CST) != 1 || value != 0)
        return 3;
    return __atomic_add_fetch(&value, (U9)511, __ATOMIC_SEQ_CST) != 511;
}
