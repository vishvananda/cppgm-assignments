#define RETAIN_TYPE(condition, type) __typeof__(*(0 ? (type *)0 : (void *)!(condition)))
#define SELECT_TYPE(condition, yes, no) \
    __typeof__(*(0 ? (RETAIN_TYPE(condition, yes) *)0 : (RETAIN_TYPE(!(condition), no) *)0))

typedef RETAIN_TYPE(0, int) Empty;
typedef SELECT_TYPE(1, float, double) Selected;
typedef char check_empty[__builtin_types_compatible_p(Empty, void) ? 1 : -1];
typedef char check_selected[__builtin_types_compatible_p(Selected, float) ? 1 : -1];

static void *empty_pointer = &*(void *)0;
static int object;
static int calls;

static volatile void *next(void)
{
    ++calls;
    return &object;
}

typedef __typeof__(*next()) Qualified;
typedef char check_qualified[__builtin_types_compatible_p(Qualified *, volatile void *) ? 1 : -1];

int main(void)
{
    if (empty_pointer != 0 || calls != 0)
        return 1;
    if (&(*next()) != &object || calls != 1)
        return 2;
    (void)*next();
    return calls != 2;
}
