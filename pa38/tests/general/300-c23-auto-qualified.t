int main(void)
{
    _Atomic auto storage = 6;
    auto copy = storage;
    int value = 4;
    restrict auto pointer = &value;
    static_assert(_Generic(&storage, _Atomic int *: 1, default: 0));
    static_assert(_Generic(&copy, int *: 1, default: 0));
    static_assert(_Generic(&pointer, int *restrict *: 1, default: 0));
    storage += *pointer;
    return copy != 6 || storage != 10;
}
