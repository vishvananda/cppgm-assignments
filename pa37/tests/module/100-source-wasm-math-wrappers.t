extern "C" double floor(double value) { return __builtin_floor(value); }
extern "C" float floorf(float value) { return __builtin_floorf(value); }
extern "C" double ceil(double value) { return __builtin_ceil(value); }
extern "C" float ceilf(float value) { return __builtin_ceilf(value); }
extern "C" double trunc(double value) { return __builtin_trunc(value); }
extern "C" float truncf(float value) { return __builtin_truncf(value); }
extern "C" double rint(double value) { return __builtin_rint(value); }
extern "C" float rintf(float value) { return __builtin_rintf(value); }
extern "C" double nearbyint(double value) { return __builtin_nearbyint(value); }
extern "C" float nearbyintf(float value) { return __builtin_nearbyintf(value); }
extern "C" double sqrt(double value) { return __builtin_sqrt(value); }
extern "C" float sqrtf(float value) { return __builtin_sqrtf(value); }
extern "C" int observe() {
  volatile double negative = -1.75, even = 2.5, odd = 3.5, square = 2.25;
  volatile float narrow = -1.75f, narrow_square = 2.25f;
  if (floor(negative) != -2 || floorf(narrow) != -2) return 1;
  if (ceil(negative) != -1 || ceilf(narrow) != -1) return 2;
  if (trunc(negative) != -1 || truncf(narrow) != -1) return 3;
  if (rint(even) != 2 || rint(odd) != 4 || rint(-even) != -2 || rintf(narrow) != -2) return 4;
  if (nearbyint(even) != 2 || nearbyintf(narrow) != -2) return 5;
  if (sqrt(square) != 1.5 || sqrtf(narrow_square) != 1.5f) return 6;
  volatile double negative_zero = -0.0, infinity = __builtin_inf();
  if (!__builtin_signbit(floor(negative_zero)) || !__builtin_signbit(trunc(negative_zero))) return 7;
  if (!__builtin_signbit(sqrt(negative_zero)) || floor(infinity) != infinity) return 8;
  if (!__builtin_isnan(sqrt(negative)) || !__builtin_isnan(floor(__builtin_nan("")))) return 9;
  int counter = 0;
  if (__builtin_sqrt(3.0 + ++counter) != 2 || counter != 1) return 10;
  return 0;
}
