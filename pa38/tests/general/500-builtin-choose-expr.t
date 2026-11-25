#if !__has_builtin(__builtin_choose_expr)
#error missing __builtin_choose_expr
#endif

#define CHOOSE __builtin_choose_expr
#define IS_TYPE(expr, type) __builtin_types_compatible_p(__typeof__(expr), type)

extern int missing(void);
extern long alternate(long);

static int effect;
static short items[2] = {2, 3};
static short *last_item = &CHOOSE(1, items, (short *)0)[1];
enum { count = CHOOSE(1, sizeof(items) / sizeof(items[0]), missing()) };

struct pair { int x, y; };

static struct pair make_pair(void)
{
    struct pair value = {4, 7};
    return value;
}

static int increment(int value)
{
    return value + 1;
}

int main(void)
{
    int left = 2, right = 7;
    struct pair other = {1, 2};
    struct pair result = CHOOSE(0, other, make_pair());
    struct { unsigned a:3; unsigned b:3; } bits = {1, 2};

    CHOOSE(-2, left, right) = 9;
    if (left != 9 || right != 7 || &CHOOSE(0, left, right) != &right) return 1;
    if (!IS_TYPE(CHOOSE(1, (short)1, (long)2), short)) return 2;
    if (sizeof(CHOOSE(1, items, (short *)0)) != sizeof(items) || last_item != &items[1]) return 3;
    if (CHOOSE(1, increment, alternate)(2) != 3 || CHOOSE(0, missing(), count) != 2) return 4;
    if (CHOOSE(1, ++effect, effect += 50) != 1 || effect != 1) return 5;
    if (result.y != 7) return 6;
    CHOOSE(0, bits.a, bits.b) = 5;
    return bits.a != 1 || bits.b != 5;
}
