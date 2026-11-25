#define UTILS "c-include\utils.h"
#define ESCAPED "c-include\u00e9.h"
#if !__has_include(UTILS) || !__has_include(ESCAPED)
#error computed header probe lost the written path
#endif
#include UTILS
#include ESCAPED
#include "c-include\u00e9.h"

int main(void) {
    return utils_value != 11 || escape_value != 19;
}
