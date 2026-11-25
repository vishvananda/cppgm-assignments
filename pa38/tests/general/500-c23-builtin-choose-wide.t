typedef unsigned _BitInt(128) Wide;

enum {
    high_word = __builtin_choose_expr((Wide)1 << 100, 3, 5),
    zero = __builtin_choose_expr((Wide)0, 3, 5),
    nested = __builtin_choose_expr(__builtin_choose_expr(1, (Wide)1 << 100, (Wide)0), 7, 9)
};

int main(void)
{
    return high_word != 3 || zero != 5 || nested != 7;
}
