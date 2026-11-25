#define EMPTY
#define SUM(first, ...) (first __VA_OPT__(+ (__VA_ARGS__)))
#define MAYBE_STRING(...) #__VA_OPT__(__VA_ARGS__)
#define SELECT(first, ...) first ## __VA_OPT__(__VA_ARGS__)
#define INITIALIZE(name, ...) int name[] __VA_OPT__(= { __VA_ARGS__ })
#define EMPTY_PASTE(...) __VA_OPT__()/**/__VA_OPT__()
#define JOIN(a, b, c) a ## b ## c
#define FORWARD_JOIN(b) JOIN(to, b, tal)

static const char s[] = MAYBE_STRING();
static const char word[] = MAYBE_STRING(EMPTY);
static const char tokens[] = MAYBE_STRING(1 + 2);
INITIALIZE(values, 17, 25);

int main(void)
{
    int value = 2;
    int value_other = 3;
    int total = 5;
    return SUM(17) != 17 || SUM(25,) != 25 || SUM(42, EMPTY) != 42 ||
           SUM(17, 25) != 42 || sizeof s != 1 || sizeof word != 1 ||
           sizeof tokens != 6 || tokens[1] != ' ' || tokens[4] != '2' ||
           SELECT(value) != 2 || SELECT(value, _other) != 3 ||
           FORWARD_JOIN(EMPTY_PASTE()) != total ||
           sizeof values != 2 * sizeof(int) || values[0] + values[1] != 42;
}
