// Same: one T must fit both arguments, so deduction fails for two types.
template<class T> struct Tag {};
template<class T> void same(Tag<T>, Tag<T>);
template<class T, class U> concept Same = requires(Tag<T> a, Tag<U> b) { same(a, b); };
template<class T> concept Modular = requires(T value) { value % value; };
template<class T> concept Void = Same<T, void>;
template<class T> concept Returning = requires(T value) {
  { value.field } -> Same<int&>;
  { value.run() } noexcept -> Modular;
};
struct Good { int field; int run() noexcept; };
struct WrongField { long field; int run() noexcept; };
struct Throwing { int field; int run(); };
struct WrongResult { int field; void* run() noexcept; };

template<class T> concept FixedOperand = requires { { 0 } -> Same<T>; };

void nothing();

int main() {
  return !Returning<Good> || Returning<WrongField> || Returning<Throwing> || Returning<WrongResult>
      || Returning<int> || !FixedOperand<int> || FixedOperand<long>
      || !requires { { nothing() } -> Void; }
      || !requires(const int value) { { value } -> Same<const int&>; }
      || !requires(int&& value) { { static_cast<int&&>(value) } -> Same<int&&>; };
}
