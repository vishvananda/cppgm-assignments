#define EXPECT_C11_FEATURES 0
#define EXPECT_C11_EXTENSIONS 1
#include "c11-feature-probes.h"

#define u
#define U
#define u8

static char text[] = u"a" U"b" u8"c";

int main(void)
{
    return sizeof text != 4 || text[0] != 'a' || text[2] != 'c' ||
           sizeof(u'a') != sizeof(int) || U'b' != 'b' || L'd' != 'd';
}
