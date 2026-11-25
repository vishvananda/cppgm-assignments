struct Row { int value; };
typedef struct Row Outer;

int check(void)
{
    struct Row { int value; };
    return _Generic(0,
        char: 1, short: 2, int: 3, unsigned: 4, long: 5, double: 6, float: 7,
        struct Row: 8, Outer: 9, default: 10);
}
