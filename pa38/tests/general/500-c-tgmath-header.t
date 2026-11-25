#include <tgmath.h>

int main(void)
{
    float variable = 4.0f;
    float complex number = 3.0f + 4.0f * I;
    int effects = 0;
    typedef char square_root[__builtin_types_compatible_p(__typeof__(sqrt(variable)), float) ? 1 : -1];
    typedef char magnitude[__builtin_types_compatible_p(__typeof__(fabs(number)), float) ? 1 : -1];
    return sizeof(sqrt((++effects, variable))) != sizeof(float) || effects != 0;
}
