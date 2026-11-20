// expect exit 0
union Inner { int left; int right; };
struct Part { Inner item; };
union Outer { Part one; Part two; };
constexpr Outer value{{{13}}};

template<const int* P> struct Pointer {};
template<class T, class U> struct Same { static constexpr bool value = false; };
template<class T> struct Same<T, T> { static constexpr bool value = true; };

constexpr const int* selected = &value.one.item.left;
static_assert(Same<Pointer<selected>, Pointer<&value.one.item.left>>::value);
static_assert(!Same<Pointer<selected>, Pointer<&value.one.item.right>>::value);
static_assert(!Same<Pointer<selected>, Pointer<&value.two.item.left>>::value);

template<const int* P> constexpr int read() { return *P; }
static_assert(read<selected>() == 13);
int main() { return read<selected>() != 13; }
