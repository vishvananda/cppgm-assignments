static int left_values[3] = { 1, 2, 3 };
static int right_values[4] = { 4, 5, 6, 7 };

struct Table {
    int (*left)[3];
    int (*right)[];
    struct Table *next;
    struct { union { int note; unsigned encoded; }; };
};

static struct Table outer = { &left_values, &right_values, &outer, { { 11 } } };
static volatile int choose;

int main(void)
{
    struct Table {
        int (*left)[];
        int (*right)[4];
        struct Table *next;
        struct { union { signed int note; unsigned int encoded; }; };
    } inner = { &left_values, &right_values, &inner, { { 13 } } };

    typeof(choose ? &outer : &inner) merged = choose ? &outer : &inner;
    static_assert(sizeof(*merged->left) == 3 * sizeof(int));
    static_assert(sizeof(*merged->right) == 4 * sizeof(int));
    static_assert(sizeof(*merged->next->left) == 3 * sizeof(int));
    static_assert(sizeof(*merged->next->right) == 4 * sizeof(int));

    typeof(choose ? inner : outer) copy = choose ? inner : outer;
    static_assert(sizeof(*copy.left) == 3 * sizeof(int));
    static_assert(sizeof(*copy.right) == 4 * sizeof(int));

    return (*merged->left)[2] != 3 || (*merged->next->right)[3] != 7 ||
        merged->next->note != 13 || copy.note != 11;
}
