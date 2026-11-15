#include <stdint.h>
static int values[3] = { 3, 5, 7 };
static int add(int value) { return value + 1; }
static uintptr_t object_address = (uintptr_t)&values[1];
static uintptr_t function_address = (uintptr_t)add;
static unsigned long long wide_address = (unsigned long long)&values[2];
int main(void) {
  if (object_address != (uintptr_t)&values[1] || *(int*)object_address != 5) return 1;
  if (function_address != (uintptr_t)add || ((int (*)(int))function_address)(41) != 42) return 2;
  if (wide_address != (unsigned long long)&values[2] || *(int*)(uintptr_t)wide_address != 7) return 3;
  return 0;
}
