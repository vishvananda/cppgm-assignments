#include "600-system-header-optional-variadic.h"

int one[] = { VALUES(1,) };
int two[] = { VALUES(2, 3) };
static_assert(sizeof(one) == sizeof(int), "empty optional replacement");
static_assert(sizeof(two) == 2 * sizeof(int), "nonempty optional replacement");
