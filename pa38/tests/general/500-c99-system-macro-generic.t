#include "c-edition-system-macros.h"

#define APPLY(macro, value) macro(value)

int main(void)
{
    return APPLY(C_SYSTEM_PICK, 1) != 7 || C_SYSTEM_PICK(1.0) != 2 ||
        C_SYSTEM_PASTED_PICK(1) != 7;
}
