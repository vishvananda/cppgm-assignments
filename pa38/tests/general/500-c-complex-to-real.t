typedef _Complex float Complex;

static double folded_real = __extension__ (2.5f + 6.0fi);
static int folded_integer = __extension__ (int)(-3.5f + 6.0fi);

static Complex make_value(float real, int *effects)
{
    ++*effects;
    return __extension__ (real + 4.0fi);
}

static double scalar_argument(double value)
{
    return value;
}

static float scalar_return(Complex value)
{
    return value;
}

int main(void)
{
    int effects = 0;
    Complex value = make_value(3.5f, &effects);
    double widened = value;
    int integer = (int)make_value(-3.5f, &effects);
    _Bool truth = make_value(0.0f, &effects);
    return folded_real != 2.5 || folded_integer != -3 ||
        widened != 3.5 || integer != -3 || !truth || effects != 3 ||
        (float)value != 3.5f || scalar_argument(value) != 3.5 ||
        scalar_return(value) != 3.5f;
}
