#include <constexpr_try.h>

static_assert(header_try(2) == 7, "system-header try");
static_assert(header_function_try() == 12, "system-header function-try-block");

int main() { return 0; }
