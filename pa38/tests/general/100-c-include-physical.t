#define HEADER "c-include-physical.h"
#line 70 "generated/path/input.c"
#if __LINE__ != 70
#error wrong presumed line before include
#endif
#include HEADER
#include "c-include-physical.h"
#if LOCAL_VALUE != 19
#error wrong nested header
#endif

static const char presumed[] = __FILE__;

int main(void) {
    return sizeof presumed != sizeof "generated/path/input.c" ||
           presumed[0] != 'g' || include_count != 1;
}
