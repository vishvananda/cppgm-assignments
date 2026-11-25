enum Count { minus_one = -1, plus_one = 1 };

int choose(void)
{
    return _Generic(0,
        int (*)(enum Count): 1, char: 2, short: 3, int: 4, long: 5,
        float: 6, double: 7, int (*)(void): 8, int (*)(int): 9);
}
