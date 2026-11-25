const int *address(void)
{
    static const int *object = &(static thread_local int){ 7 };
    return object;
}
