// expect exit 0
enum class E : unsigned { low = 2, high = 4 };
struct Bits { static constexpr E low=E::low, high=E::high; };
constexpr E join(E e) { return e; }
template<class... Es> constexpr E join(E first, Es... rest) {
  return E(unsigned(first) | unsigned(join(rest...)));
}
template<E> struct Tag { int result; };
using Return = Tag<join(Bits::low, Bits::high)>;
template<class T> struct Wrapper;
template<class U> Return inspect(const Wrapper<U>& w) { return {w.value}; }
template<class T> struct Wrapper {
  Wrapper(T value) : value(value) {}
private:
  T value;
  template<class S>
  friend Tag<join(Bits::low, Bits::high)> inspect(const Wrapper<S>&);
};
int main() { return inspect(Wrapper<int>(42)).result != 42; }
