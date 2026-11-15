// A static data member of a class template specialization deduces a type that fails; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
template <class T> struct Holder { static constexpr Integral auto value = T(); };
int main() { return Holder<double>::value; }
