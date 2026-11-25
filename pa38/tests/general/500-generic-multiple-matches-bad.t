int choose(int (*value)[])
{
    return _Generic(value, int (*)[1]: 1, int (*)[2]: 2, default: 0);
}
