#if true
#error true is an ordinary identifier before C23
#endif

static int bool = 1, true = 2, false = 3, static_assert = 4;
static int typeof = 5, typeof_unqual = 6;

typedef const int Qualified;
__typeof_unqual(Qualified) a;
__typeof_unqual__(Qualified) b;

static void *void_pointer;
static int no_args(__typeof__(*void_pointer)) { return 1; }

int main(void)
{
    a = 40;
    b = 2;
    return a + b + bool + true + false + static_assert + typeof + typeof_unqual + no_args() != 64;
}
