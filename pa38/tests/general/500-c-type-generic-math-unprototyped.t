float a();
double b(double);

int main(void)
{
    return __builtin_tgmath(a, b, 1.0f);
}
