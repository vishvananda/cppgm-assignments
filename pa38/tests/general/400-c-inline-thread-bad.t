inline int count(void)
{
    static _Thread_local int count;
    return ++count;
}
