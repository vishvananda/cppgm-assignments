#include <cmath>

constexpr float f = __builtin_sinf(-1.0f);
constexpr double d = __builtin_sin(1.0);
constexpr long double l = __builtin_sinl(-1.0L);
static_assert(f == -0x1.aed548p-1f, "binary32 sine");
static_assert(d == 0x1.aed548f090ceep-1, "binary64 sine");
static_assert(l > -0.8414709848078966L && l < -0.8414709848078964L, "long double sine");
static_assert(__builtin_signbit(__builtin_sin(-0.0)), "preserved zero sign");

#if defined(__GLIBCXX__)
static_assert(std::sin(1.0) == d, "hosted sine declaration");
#endif

int main() { return 0; }
