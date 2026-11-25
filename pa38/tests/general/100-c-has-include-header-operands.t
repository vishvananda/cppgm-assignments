#define NAME c-include-local.h
#define PROBE __has_include
#define FROM_TOKENS(name) __has_include(name)
#define FROM_BODY __has_include(<NAME>)
#define EMPTY
#define DISCARD(x)

#if !__has_include(<c-header  spaces.h> EMPTY)
#error a direct angle name keeps both spaces
#endif

#if !PROBE(<c-header  spaces.h>)
#error an expanded operator reads its operand from the source
#endif

#if FROM_TOKENS(<c-header  spaces.h>)
#error a tokenized name uses normal macro whitespace
#endif

#if __has_include(<NAME>)
#error a direct header-name token is not macro replaced
#endif

#if 0
#error an inactive branch
#elif !FROM_BODY || !FROM_TOKENS(<NAME>)
#error tokens from a macro expand before lookup
#endif

#if !__has_include("c-include-local.h" DISCARD(0))
#error trailing tokens can expand away
#endif

#include <c-header  spaces.h>
#include <c-include-local.h>

int main(void)
{
    return HEADER_SPACES_VALUE != 43 || LOCAL_VALUE != 19;
}
