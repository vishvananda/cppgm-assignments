#include "c-imaginary-system.h"

#define IMAGINARY_UNIT (__extension__ 1.0iF)

__extension__ static _Complex double stored = 4.0i;

int main(void)
{
    _Complex double unit = IMAGINARY_UNIT;
    __extension__ _Complex double local = 2.0i;
    _Complex double pair = __extension__ (1.0 + 3.0i);
    _Complex double from_header = HEADER_IMAGINARY;
    return __real__ unit != 0.0 || __imag__ unit != 1.0 ||
        __imag__ stored != 4.0 || __imag__ local != 2.0 ||
        __real__ pair != 1.0 || __imag__ pair != 3.0 || __imag__ from_header != 5.0;
}
