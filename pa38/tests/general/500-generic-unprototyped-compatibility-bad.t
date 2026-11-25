typedef int Function();

int choose(void)
{
    return _Generic(0,
        char: 1, short: 2, int: 3, long: 4, float: 5, double: 6,
        int (*)(float): 7, int (*)(int): 8, Function*: 9);
}
