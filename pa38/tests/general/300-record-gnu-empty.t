#include <stddef.h>

struct Empty {};
union EmptyUnion {};
struct Pair {
    unsigned char left;
    struct Empty first;
    struct Empty second;
    unsigned char right;
};

static struct Pair pair = { 3, (struct Empty){}, (struct Empty){}, 5 };
_Static_assert(sizeof(struct Empty) == 0 && sizeof(union EmptyUnion) == 0, "empty record size");
_Static_assert(sizeof(struct Empty[17]) == 0, "empty record array size");
_Static_assert(sizeof(struct Pair) == 2 && offsetof(struct Pair, right) == 1, "enclosing record layout");

static int evaluations;

static struct Empty *destination(struct Pair *pair)
{
    ++evaluations;
    return &pair->first;
}

static struct Empty replacement(void)
{
    ++evaluations;
    return (struct Empty){};
}

int main(void)
{
    struct Pair copy = pair;
    *destination(&copy) = replacement();
    copy.second = copy.first;
    return !(copy.left == 3 && copy.right == 5 && evaluations == 2);
}
