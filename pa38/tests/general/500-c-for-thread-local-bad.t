void f(void)
{
    for (static _Thread_local int index = 1; index < 2; ++index)
        ;
}
