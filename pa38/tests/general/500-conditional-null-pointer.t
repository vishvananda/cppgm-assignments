static void callback(void) {}

_Static_assert(_Generic((1 ? (void *)0 : 0), void *: 1, default: 0), "pointer first");
_Static_assert(_Generic((1 ? 0 : (void *)0), void *: 1, default: 0), "pointer second");
_Static_assert(_Generic((1 ? 0 : (const void *)0), const void *: 1, default: 0), "keep qualifiers");
_Static_assert(_Generic((1 ? callback : (void *)0), void (*)(void): 1, default: 0), "function pointer");

static int check(int flag)
{
    void *p = flag ? (void *)0 : 0;
    void *q = flag ? 0 : (void *)0;
    return !(p == q && p == 0 && (void *)0 == 0);
}

int main(void) { return check(0) || check(1); }
