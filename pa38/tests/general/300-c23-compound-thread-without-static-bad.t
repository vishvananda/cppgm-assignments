int *object(void)
{
    return &(thread_local int){ 7 };
}
