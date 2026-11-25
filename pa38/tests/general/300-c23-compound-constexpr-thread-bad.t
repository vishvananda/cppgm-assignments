const int *object(void)
{
    return &(static thread_local constexpr int){ 7 };
}
