extern _Alignas(32) char item;
extern char item;

static _Alignas(16) char local = 2;

static int check_local(void)
{
    extern _Alignas(16) char local;
    return local == 2 && (__UINTPTR_TYPE__)&local % 16 == 0;
}

int main(void)
{
    return !(item == 7 && (__UINTPTR_TYPE__)&item % 32 == 0 && check_local());
}
