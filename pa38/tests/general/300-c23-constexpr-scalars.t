extern int observe(const int *, const int *);

constexpr int width = 34;
constexpr int negative = -9;
constexpr float exact = 0x1.8p0;
constexpr int truncated = (int)exact;
constexpr int *nothing = nullptr;
constexpr int *other = nothing;
constexpr typeof(nullptr) zero = nullptr;
constexpr unsigned char octet = u8'\xff';
constexpr unsigned char text[] = u8"\xff";

static_assert(width == 34);
static_assert(negative == -9);
static_assert(truncated == 1);
static_assert(_Generic(&width, const int *: 1, default: 0));
static_assert(_Generic(u8"", unsigned char *: 1, default: 0));
static_assert(octet == 255);

static const int *previous;

int observe(const int *first, const int *second)
{
    return first != second && *first == *second;
}

static int check_addresses(int depth)
{
    constexpr int local = width + truncated;
    if (depth == 0) {
        previous = &local;
        return check_addresses(1);
    }
    return observe(previous, &local);
}

int main(void)
{
    constexpr int extra = 3;
    typedef unsigned _BitInt(width + extra) Number;
    static_assert(_Generic((Number)0, unsigned _BitInt(37): 1, default: 0));
    return !check_addresses(0) || nothing != nullptr || other != nullptr ||
        zero != nullptr || text[0] != octet;
}
