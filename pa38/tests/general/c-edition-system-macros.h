#pragma GCC system_header

#define C_SYSTEM_PICK(x) _Generic((x), int: 7, default: 2)
#define C_SYSTEM_PASTED_PICK(x) _Gene ## ric((x), int: 7, default: 2)
#define C_SYSTEM_IDENTITY(x) (x)
