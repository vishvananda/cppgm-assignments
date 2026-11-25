__extension__ typedef unsigned __int128 u128;

enum Status : u128 { ready = ((u128)1 << 89) + 2 };
static enum Status value;

void check(void)
{
    enum Status : u128 { ready = ((u128)1 << 90) + 2 };
    enum Status *local = &value;
    (void)local;
}
