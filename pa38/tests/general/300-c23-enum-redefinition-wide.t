__extension__ typedef unsigned __int128 u128;
__extension__ typedef __int128 i128;

enum Wide : u128 { high = (u128)1 << 87, following };
enum Wide : u128 { following = ((u128)1 << 87) + 1, high = (u128)2 << 86 };

enum SignedWide : i128 { lowest = -((i128)1 << 100), positive = (i128)1 << 63 };
enum SignedWide : i128 { positive = (i128)1 << 63, lowest = -((i128)2 << 99) };

static volatile enum Wide value = following;
static volatile enum SignedWide signed_value = lowest;

int main(void)
{
    return value - high != 1 || signed_value != lowest || positive < 0;
}
