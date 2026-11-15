extern "C" int implementation(int left, int right) { return left + right; }
// GNU/LLVM aliases preserve the body's ABI even with another declared prototype.
extern "C" int other_prototype(int) __attribute__((alias("implementation")));
static int internal_implementation(int left, int right) { return left + right; }
static int internal_prototype(int) __attribute__((alias("_ZL23internal_implementationii")));
extern "C" int observe() {
  using Actual = int (*)(int, int);
  Actual volatile function = reinterpret_cast<Actual>(other_prototype);
  Actual volatile internal = reinterpret_cast<Actual>(internal_prototype);
  return function(19, 23) + internal(19, 23);
}
