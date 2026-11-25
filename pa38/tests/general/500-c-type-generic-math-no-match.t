float a(float);
long double b(long double);

int main(void)
{
    return __builtin_tgmath(a, b, 1);
}
