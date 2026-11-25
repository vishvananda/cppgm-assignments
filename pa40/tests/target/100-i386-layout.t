_Static_assert(sizeof(void *) == 4, "pointer width");
_Static_assert(_Generic(sizeof(0), unsigned int: 1, default: 0), "size_t type");
_Static_assert(sizeof(long) == 4, "long width");
_Static_assert(_Alignof(long long) == 4, "long long alignment");
_Static_assert(_Alignof(double) == 4, "double alignment");
_Static_assert(sizeof(long double) == 12 && _Alignof(long double) == 4, "x87 storage");

unsigned long long timestamp(void)
{
    unsigned long long value;
    __asm__("rdtsc" : "=A"(value));
    return value;
}
