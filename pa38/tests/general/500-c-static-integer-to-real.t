static const float floats[] = {1, -1};
static const double doubles[] = {1, -2L, -0.5f};
static const long double extended[] = {-3LL, 0xffffffffffffffffULL};

int main(void)
{
    volatile unsigned i = 1;
    return !(floats[i] == -1.0f && doubles[i] == -2.0 &&
        doubles[i + 1] == -0.5 && extended[i - 1] == -3.0L &&
        extended[i] == 0x1.fffffffffffffffep63L);
}
