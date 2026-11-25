struct Small { int first; int last; };
struct Large { int parts[8]; };

static const struct Small smaller = { 7, 11 };
static struct Large larger = { { 13, 17, 19, 23, 29, 31, 37, 41 } };

static struct Small small(void) { return smaller; }
static struct Large large(void) { return larger; }

int main(void)
{
    struct Small a = small();
    struct Large b = large();
    return !(a.first == 7 && a.last == 11 && b.parts[0] == 13 && b.parts[7] == 41);
}
