#if __has_include(<cppgm-quote-only.h>) || !__has_include("cppgm-quote-only.h")
#error -iquote must be visible only to quoted lookups
#endif

#include "cppgm-quote-chain.h"
#ifndef CPPGM_FROM_SECOND_QUOTE
#error include_next must continue through the quote chain
#endif

#undef CPPGM_FROM_FIRST_QUOTE
#undef CPPGM_FROM_SECOND_QUOTE
#undef CPPGM_FROM_ANGLE

#include <cppgm-quote-chain.h>
#if defined(CPPGM_FROM_FIRST_QUOTE) || defined(CPPGM_FROM_SECOND_QUOTE)
#error angle-bracket lookup must bypass the quote directories
#endif

int main() { return CPPGM_FROM_ANGLE != 37; }
