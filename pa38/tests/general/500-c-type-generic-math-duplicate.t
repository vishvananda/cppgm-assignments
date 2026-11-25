float a(float);
double b(double);
float c(float);

int main(void)
{
    return __builtin_tgmath(a, b, c, 1.0f);
}
