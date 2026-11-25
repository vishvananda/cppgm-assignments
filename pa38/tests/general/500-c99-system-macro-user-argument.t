#include "c-edition-system-macros.h"

int main(void)
{
    return C_SYSTEM_IDENTITY(_Generic(1, int: 0, default: 1));
}
