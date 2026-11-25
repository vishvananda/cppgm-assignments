extern unsigned adjust(unsigned value);

unsigned combine(unsigned a, unsigned b, unsigned c, unsigned d)
{
    unsigned sum = a + b + c + d;
    if (sum > 10)
        return adjust(sum) + b;
    return sum;
}
