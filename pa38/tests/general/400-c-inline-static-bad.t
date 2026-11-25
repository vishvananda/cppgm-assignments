inline int count(void)
{
    static int counts[2];
    return ++counts[1];
}
