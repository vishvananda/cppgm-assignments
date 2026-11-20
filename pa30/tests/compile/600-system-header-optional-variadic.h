#ifndef ORDINARY_HEADER
#pragma GCC system_header
#endif

#define VALUES(value, ...) value __VA_OPT__(,) __VA_ARGS__
