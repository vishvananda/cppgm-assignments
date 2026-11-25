extern initial;
static marker = 3;

product(x, y)
int x;
{
    return x * y;
}

main()
{
    int inline = initial;
    int restrict = marker;
    int result = sum((unsigned char)inline, (float)restrict);
    return result != 7 || product(2, 3) != 6;
}

int sum(int value, double extra)
{
    return value + (int)extra;
}

int initial = 4;
