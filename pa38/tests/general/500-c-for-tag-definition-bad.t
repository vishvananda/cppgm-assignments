void f(void)
{
    for (struct Item { int member; } value = { 0 }; value.member; )
        ;
}
