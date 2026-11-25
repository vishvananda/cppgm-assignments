float a(float, float);
double b(double, long double);

int main(void)
{
    return __builtin_tgmath(a, b, 1.0f, 2.0f);
}
