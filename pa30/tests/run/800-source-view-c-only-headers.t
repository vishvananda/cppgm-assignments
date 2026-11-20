#if !__has_include(<stdio.h>) || !__has_include(<math.h>)
#error the C standard headers must remain on the search path
#endif
#if __has_include(<vector>)
#error the system C++ library must be absent
#endif
#include <float.h>
#include <math.h>
#include <cppgm_pa30_explicit_header.h>
#if defined(__GNUC__) && __GNUG__ != __GNUC__
#error the GNU C++ major version must match the GNU major version
#endif
#if __cpp_lambdas < 200907L || __cpp_rvalue_references < 200610L || __cpp_variadic_templates < 200704L
#error missing C++11 language macros
#endif
#if __EXCEPTIONS != 1 || __cpp_exceptions < 199711L || __GXX_RTTI != 1 || __cpp_rtti < 199711L
#error missing exception or RTTI macros
#endif
int main() { return FLT_EVAL_METHOD != 0 || header_value != 7; }
