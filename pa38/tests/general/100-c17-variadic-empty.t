#include "100-c17-variadic-empty.inc/system.h"
#define FIRST(first, ...) (first)

int main(void)
{
    return FIRST(17,) + SYSTEM_FIRST(25) != 42;
}
