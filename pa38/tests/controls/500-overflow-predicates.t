// expect exit 0
_Static_assert(__builtin_add_overflow_p(255, 1, (unsigned char)0), "narrow addition");
_Static_assert(!__builtin_sub_overflow_p(0, 1, (signed char)0), "signed difference");
_Static_assert(__builtin_mul_overflow_p(64, 2, (signed char)0), "narrow multiplication");

struct Field { unsigned int small : 3; };
int main(void)
{
  struct Field field = { 1 };
  volatile int n = 4;
  int effects = 0;
  if (!__builtin_mul_overflow_p(n, 2, (effects++, (unsigned char)0)) && effects == 1 &&
      __builtin_mul_overflow_p(n, 2, field.small) &&
      !__builtin_mul_overflow_p(n, 1, field.small))
    return 0;
  return 1;
}
