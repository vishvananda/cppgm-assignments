#ifdef __CHAR8_TYPE__
#error The UTF-8 character type macro starts in C23
#endif

#define EXPECT_C11_FEATURES 1
#define EXPECT_C11_EXTENSIONS 1
#include "c11-feature-probes.h"

#define u expands_only_as_an_identifier
#define U expands_only_as_an_identifier
#define u8 expands_only_as_an_identifier
#define UTF8(text) u8 ## text

static const char text[] = UTF8("value");

int main(void)
{
    return sizeof text != 6 || text[0] != 'v' || text[4] != 'e' ||
           sizeof(u"a") != 2 * sizeof(u'a') ||
           sizeof(U"b") != 2 * sizeof(U'b') || sizeof(u8"c") != 2;
}
