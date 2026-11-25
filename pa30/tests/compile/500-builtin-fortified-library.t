// VALIDATION: compile-pass

#if !__has_builtin(__builtin___memcpy_chk) || !__has_builtin(__builtin___vsnprintf_chk)
#error missing fortified library builtins
#endif

int checked_format(const char* format, ...)
{
  char output[32], copy[32];
  __builtin_va_list arguments;
  __builtin_va_start(arguments, format);
  int count = __builtin___vsnprintf_chk(output, sizeof(output), 0, sizeof(output), format, arguments);
  __builtin_va_end(arguments);
  __builtin___memcpy_chk(copy, output, sizeof(copy), sizeof(copy));
  return count + __builtin___snprintf_chk(output, sizeof(output), 0, sizeof(output), "%s", copy);
}
