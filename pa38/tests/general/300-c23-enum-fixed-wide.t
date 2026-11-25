__extension__ typedef unsigned __int128 u128;

enum Wide : u128 {
    zero,
    high = (u128)1 << 87,
    following,
    during = high >> 87
};

static_assert((high >> 87) == 1 && during == 1);
static_assert(following == ((u128)1 << 87) + 1);
static volatile enum Wide stored = high;
static volatile unsigned index = 1;

enum Wide read_value(void) { return index ? stored : following; }

int main(void)
{
    switch (read_value()) {
    case zero:
        return 1;
    case high:
        return 0;
    default:
        return 2;
    }
}
