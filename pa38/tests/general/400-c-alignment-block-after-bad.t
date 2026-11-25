static _Alignas(16) char item = 1;

void declare_item(void)
{
    extern _Alignas(32) char item;
}
