#include <stddef.h>
#include <stdint.h>

extern _Alignas(32) char global;
char _Alignas(32) global = 1;
extern char global;

static const _Alignas(16) char constant = 2;

struct Record {
    char lead;
    char _Alignas(16) field;
};

struct AnonymousMember {
    char lead;
    _Alignas(16) struct { char field; };
};

_Static_assert(_Alignof(char) == 1, "object alignment leaves its type alone");
_Static_assert(_Alignof(struct Record) == 16, "named member alignment");
_Static_assert(offsetof(struct Record, field) == 16, "named member offset");
_Static_assert(_Alignof(struct AnonymousMember) == 16, "anonymous member alignment");
_Static_assert(offsetof(struct AnonymousMember, field) == 16, "anonymous member offset");

int main(void)
{
    int count = 2;
    _Alignas(short[count++]) char local = 3;
    _Alignas(0) _Alignas(1) _Alignas(32) int strongest = 4;
    if (++global != 2 || constant != 2 || local != 3 || strongest != 4)
        return 1;
    if ((uintptr_t)&global % 32 || (uintptr_t)&constant % 16)
        return 2;
    if (count != 2 || (uintptr_t)&local % _Alignof(short) || (uintptr_t)&strongest % 32)
        return 3;
    for (_Alignas(16) char index = 0; index < 1; ++index)
        if ((uintptr_t)&index % 16)
            return 4;
    return 0;
}
