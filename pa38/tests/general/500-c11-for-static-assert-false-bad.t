void f(void)
{
    for (_Static_assert(0, "failed assertion"); 0; )
        ;
}
