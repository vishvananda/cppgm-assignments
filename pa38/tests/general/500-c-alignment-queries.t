static _Alignas(32) int self = __alignof__(self);

typedef int Shifted __attribute__((aligned(8)));
static Shifted alias_self = __alignof__(alias_self);

extern int incomplete_array[];

struct __attribute__((packed)) Packed {
    char lead;
    int plain;
    _Alignas(16) int aligned;
};
extern struct Packed packed;

#pragma pack(push, 2)
struct Capped {
    char lead;
    int member;
};
#pragma pack(pop)
extern struct Capped capped;

struct Flags { unsigned bits : 3; };
extern struct Flags flags;

_Static_assert(__alignof__((self)) == 32, "requested object alignment");
_Static_assert(__alignof__(packed.plain) == 1, "packed member");
_Static_assert(__alignof__(packed.aligned) == 16, "explicit alignment in a packed record");
_Static_assert(__alignof__(capped.member) == 2, "pragma pack member alignment");
_Static_assert(__alignof__(incomplete_array) == _Alignof(int), "GNU incomplete array object query");
_Static_assert(__alignof__((flags.bits = 0)) > 0, "alignment of an assignment value");
_Static_assert(sizeof((flags.bits = 0)) > 0, "size of an assignment value");

int main(void)
{
    int count = 2;
    _Alignas(16) int array[count];
    if (__alignof__(array) != 16 || _Alignof(int[count++][2]) != _Alignof(int))
        return 1;
    return count != 2 || self != 32 || alias_self != 8;
}
