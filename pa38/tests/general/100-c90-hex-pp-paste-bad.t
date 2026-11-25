#include "c-hex-pp-number.h"

int main(void)
{
    return different(STRING(JOIN(0x1p, +)), "0x1p+");
}
