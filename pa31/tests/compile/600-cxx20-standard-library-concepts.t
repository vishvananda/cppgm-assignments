#include <concepts>
#if !defined(__cpp_concepts) || __cpp_concepts < 201907L
#error C++20 concepts must be enabled
#endif
struct Base {};
struct Derived : Base {};
static_assert(std::same_as<int, int>);
static_assert(!std::same_as<const int, int>);
static_assert(std::derived_from<Derived, Base>);
static_assert(std::convertible_to<int, long>);
static_assert(std::regular<int>);
template<std::integral T> int select(T) { return 1; }
template<class T> int select(T) { return 2; }
int main() { return select(4) != 1 || select(4.5) != 2; }
