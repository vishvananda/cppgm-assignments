enum Counter
{
    start = 3UL,
    next = _Generic(start, int: start + 1, default: 99)
};

enum Delta
{
    below = -5LL,
    above = _Generic(below, int: 8, default: 99)
};

_Static_assert(_Generic(start, int: 1, default: 0), "enumeration constant type");
_Static_assert(_Generic(below, int: 1, default: 0), "negative constant type");
_Static_assert(next == 4 && above == 8, "earlier constants in an enum body");

static unsigned int read_counter(const unsigned int *p) { return *p; }
static int read_delta(const int *p) { return *p; }

int main(void)
{
    enum Counter counter = next;
    enum Delta delta = below;
    const void *data = (const void *)(__UINTPTR_TYPE__)next;
    if ((enum Counter)data != next)
        return 1;
    return read_counter(&counter) != 4 || read_delta(&delta) != -5;
}
