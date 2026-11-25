typedef short Small;

static auto ((storage)) = 5L;
extern long storage;
static auto address = &storage;
constexpr auto width = 37;
typedef unsigned _BitInt(width) Word;

static double value(unsigned n)
{
    return n + 0.5;
}

#define TYPE_IS(expr, type) _Generic((expr), type: 1, default: 0)

static_assert(TYPE_IS(address, long *));
static_assert(TYPE_IS(&width, const int *));
static_assert(TYPE_IS((Word)0, unsigned _BitInt(37)));

int main(void)
{
    const Small items[2] = {4, 7};
    const auto p = items;
    auto q = &items;
    auto invoke = value;
    volatile Small narrow = 9;
    auto copied = narrow;
    auto restricted = nullptr;
    register auto tally = 0;
    auto Small typed = 2;

    struct Bits { unsigned bits : 3; } box = {3};
    auto bit = box.bits;
    static_assert(TYPE_IS(box.bits, typeof(bit)));
    static_assert(TYPE_IS(&p, const Small *const *));
    static_assert(TYPE_IS(q, const Small (*)[2]));
    static_assert(TYPE_IS(invoke, double (*)(unsigned)));
    static_assert(TYPE_IS(&copied, Small *));
    static_assert(TYPE_IS(restricted, typeof(nullptr)));

    for (auto index = 0; index != 2; ++index)
        tally += p[index];
    return *address != 5L || invoke(2) != 2.5 || tally != 11 ||
        bit != 3 || copied != 9 || typed != 2 || restricted != nullptr;
}
