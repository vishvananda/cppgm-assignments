#include <float.h>

static double largest = DBL_MAX;
static double smallest = DBL_MIN;

int main(void)
{
    return !(largest > 1e300 && smallest > 0.0 && smallest < 1e-300);
}
