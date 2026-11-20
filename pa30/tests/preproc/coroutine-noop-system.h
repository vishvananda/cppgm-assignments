#pragma GCC system_header
#if __has_builtin(__builtin_coro_noop)
system_builtin
#else
system_fallback
#endif
