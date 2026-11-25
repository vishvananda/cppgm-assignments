/* A bound that is only type-checked needs no definition of this function. */
int unavailable(void);
_Static_assert(__builtin_types_compatible_p(int[unavailable()], int[3]), "file-scope type name");
_Static_assert(_Alignof(int[unavailable()]) == _Alignof(int), "file-scope alignment query");
_Static_assert(sizeof(int (*)[unavailable()]) == sizeof(int *), "pointer size is independent of the bound");
_Alignas(int[unavailable()]) static char aligned;

static int probe(int n, int m)
{
    typedef int Row[n];
    _Static_assert(__builtin_types_compatible_p(Row, int[m++]), "two runtime bounds");
    _Static_assert(__builtin_types_compatible_p(int[unavailable()], const int[7]), "top-level array qualifiers");
    _Static_assert(__builtin_types_compatible_p(int (*)[n][2], int (*)[4][2]), "pointer to variable array");
    _Static_assert(!__builtin_types_compatible_p(int (*)[n][2], int (*)[m][3]), "different fixed inner bounds");
    _Static_assert(!__builtin_types_compatible_p(const int (*)[n], int (*)[m]), "pointee qualifiers");
    _Static_assert(__builtin_types_compatible_p(__typeof__((int (*)[n++])0), int (*)[5]), "nested type query");
    _Static_assert(__builtin_types_compatible_p(int[sizeof(int[n++])], int[1]), "nested variable size");
    return !__builtin_types_compatible_p(Row, int[n++]) || n != 7 || m != 9;
}

int main(void) { return probe(7, 9) || __alignof__(aligned) != _Alignof(int); }
