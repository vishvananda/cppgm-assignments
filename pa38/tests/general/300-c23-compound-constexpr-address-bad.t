const int *address(void)
{
    static const int *object = &(constexpr int){ 7 };
    return object;
}
