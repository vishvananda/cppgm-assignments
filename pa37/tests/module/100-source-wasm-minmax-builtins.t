#if !__has_builtin(__builtin_wasm_min_f32) || !__has_builtin(__builtin_wasm_max_f64)
#error missing target builtins
#endif
extern "C" double fmax(double x, double y) {
  if (__builtin_isnan(x)) return y;
  if (__builtin_isnan(y)) return x;
  return __builtin_wasm_max_f64(x, y);
}
extern "C" double fmin(double x, double y) {
  if (__builtin_isnan(x)) return y;
  if (__builtin_isnan(y)) return x;
  return __builtin_wasm_min_f64(x, y);
}
extern "C" int observe() {
  volatile double a = 3.5, b = -4.5, positive = 0.0, negative = -0.0;
  volatile float x = 3.5f, y = -4.5f, p = 0.0f, n = -0.0f;
  if (__builtin_wasm_min_f64(a, b) != b || __builtin_wasm_max_f64(a, b) != a) return 1;
  if (__builtin_wasm_min_f32(x, y) != y || __builtin_wasm_max_f32(x, y) != x) return 2;
  if (!__builtin_signbit(__builtin_wasm_min_f64(positive, negative))) return 3;
  if (!__builtin_signbit(__builtin_wasm_min_f64(negative, positive))) return 4;
  if (__builtin_signbit(__builtin_wasm_max_f64(positive, negative))) return 5;
  if (__builtin_signbit(__builtin_wasm_max_f64(negative, positive))) return 6;
  if (!__builtin_signbit(__builtin_wasm_min_f32(p, n)) || !__builtin_signbit(__builtin_wasm_min_f32(n, p))) return 7;
  if (__builtin_signbit(__builtin_wasm_max_f32(p, n)) || __builtin_signbit(__builtin_wasm_max_f32(n, p))) return 8;
  volatile double nan = __builtin_nan(""), inf = __builtin_inf();
  volatile float fnan = __builtin_nanf(""), finf = __builtin_inff();
  if (!__builtin_isnan(__builtin_wasm_min_f64(nan, a)) || !__builtin_isnan(__builtin_wasm_max_f64(a, nan))) return 9;
  if (!__builtin_isnan(__builtin_wasm_max_f32(fnan, x)) || !__builtin_isnan(__builtin_wasm_min_f32(x, fnan))) return 10;
  if (__builtin_wasm_min_f64(inf, -inf) != -inf || __builtin_wasm_max_f32(-finf, finf) != finf) return 11;
  if (fmax(nan, a) != a || fmin(b, nan) != b || !__builtin_signbit(fmin(positive, negative))) return 12;
  int first = 0, second = 0;
  if (__builtin_wasm_max_f32(++first, ++second + 1) != 2 || first != 1 || second != 1) return 13;
  return 0;
}
