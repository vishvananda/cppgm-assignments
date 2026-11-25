#pragma STDC FP_CONTRACT OFF

static volatile double x = 0x1.0000002p0;
static volatile double y = 0x1.ffffffcp-1;
static volatile double z = -1.0;
static volatile float xf = 0x1.0008p0f;
static volatile float yf = 0x1.fffp-1f;
static volatile float zf = -1.0f;

static double file_off(double a, double b, double c)
{
    return a * b + c;
}

static int allowed(double result, double fused)
{
#ifdef EXPECT_FUSED
    return result == fused;
#else
    return result == 0.0 || result == fused;
#endif
}

static int block_scope(double a, double b, double c)
{
    {
        _Pragma("STDC FP_CONTRACT ON")
        #pragma STDC FENV_ACCESS OFF
        if (!allowed(c + (a * b), -0x1p-54))
            return 1;
        {
            #pragma STDC FP_CONTRACT OFF
            if (a * b + c != 0.0)
                return 2;
        }
        if (!allowed((a * b) + c, -0x1p-54))
            return 3;
        double product = a * b;
        if (product + c != 0.0 || (double)(a * b) + c != 0.0)
            return 4;
    }
    return a * b + c != 0.0 ? 5 : 0;
}

#pragma STDC FP_CONTRACT ON
static float file_on(float a, float b, float c)
{
    return a * b + c;
}

#pragma STDC FP_CONTRACT DEFAULT
static double file_default(double a, double b, double c)
{
    return a * b + c;
}

int main(void)
{
    double a = x, b = y, c = z;
    if (file_off(a, b, c) != 0.0)
        return 6;
    int scope = block_scope(a, b, c);
    if (scope)
        return scope;
    if (!allowed(file_on(xf, yf, zf), -0x1p-26))
        return 7;
    return file_default(a, b, c) != 0.0 ? 8 : 0;
}
