#include "c-hex-pp-number.h"

int main(void)
{
    return different(EXPONENTS, "0x1p+suffix 0x1P-suffix 1e+suffix 1E-suffix") ||
           different(STRING(JOIN(0x1p, +)), "0x1p+");
}
