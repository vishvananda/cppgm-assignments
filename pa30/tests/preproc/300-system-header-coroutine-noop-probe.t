#ifndef __GNUC__
#define __GNUC__ 15
#endif
#ifdef __clang__
#undef __clang__
#endif

#include "coroutine-noop-system.h"

#if __has_builtin(__builtin_coro_noop)
ordinary_builtin
#else
ordinary_fallback
#endif
